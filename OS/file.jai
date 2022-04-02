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

file_search :: inline (dirname : string, allocator : Allocator, filename_capacity := 100, flags := File_Search.Flags.ALL, in_loop := true) -> File_Search #must
{
	result : File_Search;
	result.dirname = dirname;
	result.flags = flags;
	// Allocate for about filename_capacity files of about 100 characters in name and full_name combined
	arena.init (*result.filename_arena, filename_capacity * 100, allocator, allocator);
	result.in_loop = in_loop;

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

// You can ignore the all_files array and only care about the first file when freeing
// the memory allocated for all the files, since first is the same as all_files.data.
// Note however that the memory used for the filenames is allocated using the
// File_Search's filename_arena.
list_files :: (search : *File_Search, allocator : Allocator, ignore_files : []string = .[]) -> first : *File_Node #must, all_files : []File_Node
{
	if flagged (search.flags, .RECURSIVE)
		search.flags |= .VISIT_DIRECTORIES;
	parent_index  := -1;
	sibling_index := -1;
	all_files : [..]File_Node;
	all_files.allocator = allocator;
	for :direct_recurse info : search
	{
		if array.find_first (ignore_files, info.name) != -1
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

list_files :: inline (dirname : string, allocator : Allocator, flags := File_Search.Flags.ALL, ignore_files : []string = .[]) -> first : *File_Node #must, search : File_Search #must, all_files : []File_Node
{
	search := file_search (dirname, allocator, flags = flags, in_loop = false);
	root, all_files := list_files (*search, allocator, ignore_files);
	return root, search, all_files;
}

Seek_From :: io.Seek_From;

read_entire_file :: (filename : string, allocator : Allocator) -> string #must, Error
{
	file, err := open (filename, File_Open_Flags.ACCESS_READ | .OPEN_IF_EXISTS);
	if !file
		return "", err;
	defer close (file);
	size := get_file_size (file);
	data := cast (*u8) mem.alloc (size, allocator);
	if !data
		return "", .ALLOCATION_FAILURE;
	size, err = read (file, data, size);
	if err != .OK
	{
		mem.free (data, allocator);
		return "", err;
	}

	return str.make (data, size), .OK;
}
