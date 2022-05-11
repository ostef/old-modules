#scope_module

#import "Runtime";
#if OS == .WINDOWS
	win32 :: #import "Win32";
mem   :: #import "Memory";
arena :: #import "Memory/Arena";
array :: #import "Containers/Array";
fmt   :: #import "Fmt";
log   :: #import "Log";
io    :: #import "IO";
str   :: #import "String";
math  :: #import "Math";
time  :: #import "Apollo_Time";
path  :: #import "Path";

#scope_export

#if OS == .WINDOWS
{
	#load "win32/error.jai";
	#load "win32/file.jai";
	#load "win32/directory.jai";
	#load "win32/search.jai";
}

Error :: enum
{
	OK :: 0;

	INVALID_PARAMETERS;
	ALLOCATION_FAILURE;

	ACCESS_DENIED;
	FILE_NOT_FOUND;
	TOO_MANY_OPEN_FILES;
	OPEN_FAILED;

	UNKNOWN;
}

File_Attributes :: enum_flags
{
	NORMAL    :: 0x00;
	DIRECTORY :: 0x01;
	HIDDEN    :: 0x02;
	READ_ONLY :: 0x04;
	SYMLINK   :: 0x08;
	TEMPORARY :: 0x10;
}

File_Open_Flags :: enum_flags
{
	NONE :: 0x00;

	ACCESS_READ  :: 0x01;
	ACCESS_WRITE :: 0x02;
	ACCESS_READ_WRITE :: ACCESS_READ | ACCESS_WRITE;

	APPEND   :: 0x04;
	TRUNCATE :: 0x08;
	CREATE   :: 0x10;
	FAIL_IF_EXISTS :: 0x20;

	OPEN_IF_EXISTS :: 0x00;
	CREATE_NEW     :: CREATE | FAIL_IF_EXISTS;
	ALWAYS_CREATE  :: CREATE | TRUNCATE;
	OPEN_OR_CREATE :: CREATE;
}

File_Search :: struct
{
	// @Note (stefan): It is a bad idea to set RECURSIVE without setting the
	// VISIT_DIRECTORIES flag, because you won't be able to prevent recursion
	// on specific directories (maybe we should disallow it)!
	Flags :: enum_flags
	{
		VISIT_FILES :: 0x01;
		VISIT_DIRECTORIES :: 0x02;
		RECURSIVE :: 0x04;

		NON_RECURSIVE :: VISIT_FILES | VISIT_DIRECTORIES;
		ALL :: VISIT_FILES | VISIT_DIRECTORIES | RECURSIVE;
	}

	dirname : string;
	flags : Flags;
	filename_arena : arena.Memory_Arena;
	// Set this to true if you use the file search in a for_expansion.
	// If this is set to true, the filename_arena will be freed at the end of the loop.
	// Othersiwe, call reset_search to free the memory.
	in_loop : bool;
	error : Error;
}

File_Info :: struct
{
	name : string;
	full_name : string;
	attributes : File_Attributes;
	size : s64;
	creation_time    : time.Apollo_Time;
	last_access_time : time.Apollo_Time;
	last_write_time  : time.Apollo_Time;
}

file_search :: inline (dirname : string, allocator : Allocator, flags := File_Search.Flags.ALL, filename_capacity := 100) -> File_Search #must
{
	result : File_Search;
	result.flags = flags;
	// Allocate for about filename_capacity files of about 100 characters in name and full_name combined
	arena.init (*result.filename_arena, filename_capacity * 100, allocator, allocator);
	result.dirname =  str.clone (dirname, arena.to_allocator (*result.filename_arena));
	path.standardize (*result.dirname);

	return result;
}

// This is supposed to be called in the for statement directly. Don't call this to assign to a variable.
file_search :: inline (dirname : string, flags := File_Search.Flags.ALL, filename_capacity := 100) -> File_Search #must
{
	result : File_Search;
	// Allocate for about filename_capacity files of about 100 characters in name and full_name combined
	arena.init (*result.filename_arena, filename_capacity * 100, mem.HEAP_ALLOC, mem.HEAP_ALLOC);
	result.flags = flags;
	result.dirname = str.clone (dirname, arena.to_allocator (*result.filename_arena));
	path.standardize (*result.dirname);
	result.in_loop = true;

	return result;
}

reset_search :: inline (search : *File_Search)
{
	arena.reset (*search.filename_arena, search.filename_arena.overflow_allocator);
}

File_Node :: struct
{
	using info : File_Info;
	parent : *~s32 File_Node;
	first_child : *~s32 File_Node;
	prev_sibling : *~s32 File_Node;
	next_sibling : *~s32 File_Node;
}

filter_hidden_files :: (info : File_Info) -> bool #must
{
	return !flagged (info.attributes, .HIDDEN);
}

// You can ignore the all_files array and only care about the first file when freeing
// the memory allocated for all the files, since first is the same as all_files.data.
// Note however that the memory used for the filenames is allocated using the
// File_Search's filename_arena.
list_files :: (search : *File_Search, allocator : Allocator, filter := filter_hidden_files) -> first : *File_Node #must, all_files : []File_Node
{
	if flagged (search.flags, .RECURSIVE)
		search.flags |= .VISIT_DIRECTORIES;
	parent_index  := -1;
	sibling_index := -1;
	all_files : [..]File_Node;
	all_files.allocator = allocator;
	for :direct_recurse info : search
	{
		if filter && !filter (info)
			continue;
		// Find the parent directory
		while parent_index != -1 && !str.starts_with (info.full_name, all_files[parent_index].full_name)
		{
			sibling_index = parent_index;
			if all_files[parent_index].parent
				parent_index = array.get_index (all_files, all_files[parent_index].parent);
			else
				parent_index = -1;
		}
		current_index := all_files.count;
		current := array.push (*all_files);
		current.info = info;
		if parent_index != -1
		{
			current.parent = *all_files[parent_index];
			if !current.parent.first_child
				current.parent.first_child = current;
		}
		if sibling_index != -1
		{
			current.prev_sibling = *all_files[sibling_index];
			all_files[sibling_index].next_sibling = current;
		}
		if flagged (info.attributes, .DIRECTORY)
		{
			parent_index = current_index;
			sibling_index = -1;
		}
		else
			sibling_index = current_index;
	}

	if all_files.count == 0
	{
		array.reset (*all_files);
		return null, .[];
	}
	return *all_files[0], all_files;
}

list_files :: inline (dirname : string, allocator : Allocator, flags := File_Search.Flags.ALL, filter := filter_hidden_files) -> first : *File_Node #must, search : File_Search #must, all_files : []File_Node
{
	search := file_search (dirname, allocator, flags = flags);
	root, all_files := list_files (*search, allocator, filter);
	return root, search, all_files;
}

Seek_From :: io.Seek_From;

read_entire_file :: (filename : string, allocator : Allocator) -> string #must, Error
{
	file, err := open (filename, File_Open_Flags.ACCESS_READ | .OPEN_IF_EXISTS);
	if !file
		return "", err;
	defer close (file);
	s : string;
	s, err = read_entire_file (file, allocator);

	return s, err;
}

read_entire_file :: (file : File, allocator : Allocator) -> string #must, Error
{
	size := get_file_size (file);
	data := cast (*u8) mem.alloc (size, allocator);
	if !data
		return "", .ALLOCATION_FAILURE;
	err : Error;
	size, err = read (file, data, size);
	if err != .OK
	{
		mem.free (data, allocator);
		return "", err;
	}

	return str.make (data, size), .OK;
}

write_to_file :: inline (filename : string, data : []u8) -> written : s64, Error
{
	written, err := write_to_file (filename, data.data, data.count);
	return written, err;
}

write_to_file :: inline (filename : string, str : string) -> written : s64, Error
{
	written, err := write_to_file (filename, str.data, str.count);
	return written, err;
}

write_to_file :: inline (filename : string, data : *void, size : s64) -> written : s64, Error
{
	file, err := open (filename, File_Open_Flags.ACCESS_READ | .OPEN_OR_CREATE);
	if !file
		return 0, err;
	defer close (file);
	written : s64;
	written, err = write (file, data, size);

	return written, err;
}

create_directory_tree :: (tree : string) -> Error
{
	dirname := tree;
	while dirname.count != 0 && dirname[dirname.count - 1] == #char "/"
		dirname.count -= 1;
	if dirname == ""
		return .OK;
	parent := path.get_parent_dir (dirname);
	create_directory_tree (parent);

	return create_directory (dirname);
}

purge_directory :: (dir : string)
{
	for info : file_search (dir, File_Search.Flags.VISIT_FILES | .VISIT_DIRECTORIES)
	{
		if flagged (info.attributes, .DIRECTORY)
			delete_directory (info.full_name);
		else
			delete_file (info.full_name);
	}
}

delete_directory :: inline (dir : string) -> Error
{
	purge_directory (dir);
	return delete_empty_directory (dir);
}

copy_directory :: (source : string, dest : string)
{
	create_directory_tree (dest);
	for info : file_search (source)
	{
		relative_path := str.advance (info.full_name, source.count);
		dest_path := path.join (mem.HEAP_ALLOC, dest, relative_path);
		if flagged (info.attributes, .DIRECTORY)
			create_directory_tree (dest_path);
		else
			copy_file (info.full_name, dest_path);
	}
}
