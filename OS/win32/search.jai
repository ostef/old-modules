// @Note (stefan): The for expansion below does not recurse directly down in directories,
// but rather, it queues them and searches them after it finished searching the current one.
// For a 'direct recurse' approach, see the direct_recurse for expansion below.
// Normal iteration:	|	Direct recurse:
//  ./.					|	 ./.
//  ./dir1/				|	 ./dir1/
//  ./dir2/				|	 ./dir1/dir1/
//  ./file1				|	 ./dir1/dir1/file1
//  ./file2				|	 ./dir1/dir1/file2
//  ./file3				|	 ./dir1/file1
//  ./dir1/dir1/		|	 ./dir1/file2
//  ./dir1/file1		|	 ./dir2/
//  ./dir1/file2		|	 ./dir2/file1
//  ./dir2/file1		|	 ./dir2/file2
//  ./dir2/file2		|	 ./file1
//  ./dir1/dir1/file1	|	 ./file2
//  ./dir1/dir1/file2	|	 ./file3
// Direct recurse, however, is more expensive because it has more data to care about,
// and more things to do when encountering a directory and recursing/when reching the end
// of a file search. This is why it is not the default for_expansion for File_Search.

for_expansion :: (search : *File_Search, body : Code, flags : For_Flags) #expand
{
	#assert (flags & .REVERSE) != .REVERSE "Can't search files in reverse.";
	#assert (flags & .POINTER) != .POINTER "Searching files by pointer does not make sense.";

	defer if search.in_loop
		reset_search (search);

	`it : File_Info;
	`it_index := 0;
	if !flagged (search.flags, .VISIT_FILES) && !flagged (search.flags, .VISIT_DIRECTORIES)
	{
		log.warning ("Trying to do a file search without visiting files nor directories. This does not make sense.");
		return;
	}
	allocator := arena.to_allocator (*search.filename_arena);
	directories : [..]string;
	array.init (*directories, 10, mem.TEMP_ALLOC);
	array.push (*directories, search.dirname);
	should_break := false;
	cursor := 0;
	while !should_break && cursor < directories.count
	{
		dirname := directories[cursor];
		cursor += 1;
		find_data : win32.WIN32_FIND_DATAW;
		ts := mem.get_temporary_storage_state ();
		wildcard := win32.utf8_to_wide (str.join (mem.TEMP_ALLOC, dirname, "/*"), mem.TEMP_ALLOC);
		find_handle := win32.FindFirstFileW (wildcard, *find_data);
		mem.set_temporary_storage_state (ts);
		if find_handle == win32.INVALID_HANDLE_VALUE
		{
			log.error ("Unable to open directory {:'} for searching: %", dirname, get_last_error_string ());
			if cursor > 0
				continue;
			search.error = get_last_error ();
			break;
		}

		while true
		{
			defer {
				it_index += 1;
				if !win32.FindNextFileW (find_handle, *find_data)
					break;
			}

			filename := win32.wide_to_utf8 (find_data.cFileName.data, allocator);
			if filename == "." || filename == ".."
				continue;
			mem.init (*it);
			it.name = filename;
			it.full_name = str.join (allocator, dirname, "/", it.name);
			it.attributes = win32_to_file_attributes (find_data.dwFileAttributes);
			it.size = cast (s64) (find_data.nFileSizeHigh << 32) + find_data.nFileSizeLow;
			it.creation_time    = time.to_apollo (find_data.ftCreationTime);
			it.last_access_time = time.to_apollo (find_data.ftLastAccessTime);
			it.last_write_time  = time.to_apollo (find_data.ftLastWriteTime);
			if flagged (it.attributes, .DIRECTORY)
			{
				if flagged (search.flags, .VISIT_DIRECTORIES)
					#insert (break={ should_break = true; break; }) body;
				if flagged (search.flags, .RECURSIVE)
					array.push (*directories, it.full_name);
			}
			else if flagged (search.flags, .VISIT_FILES)
				#insert (break={ should_break = true; break; }) body;
		}
		win32.FindClose (find_handle);
	}
}

direct_recurse :: (search : *File_Search, body : Code, flags : For_Flags) #expand
{
	#assert (flags & .REVERSE) != .REVERSE "Can't search files in reverse.";
	#assert (flags & .POINTER) != .POINTER "Searching files by pointer does not make sense.";

	Search_Entry :: struct
	{
		initialized : bool;
		has_errors  : bool;
		dirname : string;
		find_data : win32.WIN32_FIND_DATAW;
		find_handle : win32.HANDLE;
		parent : *~s32 Search_Entry;
	}

	defer if search.in_loop
		reset_search (search);

	mem.temporary_block ();
	`it : File_Info;
	`it_index := 0;
	if !flagged (search.flags, .VISIT_FILES) && !flagged (search.flags, .VISIT_DIRECTORIES)
	{
		log.warning ("Trying to do a file search without visiting files nor directories. This does not make sense.");
		return;
	}
	allocator := arena.to_allocator (*search.filename_arena);
	entries : [..]Search_Entry;
	array.init (*entries, 10, mem.TEMP_ALLOC);
	current := array.push (*entries);
	current.dirname = search.dirname;
	while current
	{
		dirname := current.dirname;
		if !current.initialized
		{
			mem.temporary_block ();
			wildcard := win32.utf8_to_wide (str.join (mem.TEMP_ALLOC, dirname, "/*"), mem.TEMP_ALLOC);
			current.find_handle = win32.FindFirstFileW (wildcard, *current.find_data);
			current.initialized = true;
			if current.find_handle == win32.INVALID_HANDLE_VALUE
			{
				current.has_errors = true;
				log.error ("Unable to open directory {:'} for searching: %", dirname, get_last_error_string ());
				if dirname != search.dirname
				{
					current = current.parent;
					continue;
				}
				search.error = get_last_error ();
				break;	// If we can't open the first directory then just bail out
			}
		}
		if current.has_errors || !current.find_handle
		{
			current = current.parent;
			continue;
		}
		while true
		{
			defer {
				it_index += 1;
				if current && current.initialized && !win32.FindNextFileW (current.find_handle, *current.find_data)
				{
					win32.FindClose (current.find_handle);
					current.find_handle = null;
					current = current.parent;
					break;
				}
			}

			filename := win32.wide_to_utf8 (current.find_data.cFileName.data, allocator);
			if filename == "." || filename == ".."
				continue;
			// Fill File_Info data
			mem.init (*it);
			it.name = filename;
			it.full_name = str.join (allocator, dirname, "/", it.name);
			it.attributes = win32_to_file_attributes (current.find_data.dwFileAttributes);
			it.size = cast (s64) (current.find_data.nFileSizeHigh << 32) + current.find_data.nFileSizeLow;
			it.creation_time    = time.to_apollo (current.find_data.ftCreationTime);
			it.last_access_time = time.to_apollo (current.find_data.ftLastAccessTime);
			it.last_write_time  = time.to_apollo (current.find_data.ftLastWriteTime);
			if flagged (it.attributes, .DIRECTORY)
			{
				if flagged (search.flags, .VISIT_DIRECTORIES)
					#insert (break={ current = null; break; }) body;
				if flagged (search.flags, .RECURSIVE)
				{
					// Find next file, so we continue where we left off next time
					if !win32.FindNextFileW (current.find_handle, *current.find_data)
					{
						win32.FindClose (current.find_handle);
						current.find_handle = null;
					}
					parent_index := current - entries.data;
					current = array.push (*entries);
					current.parent = *entries[parent_index];
					current.dirname = it.full_name;
					break;
				}
			}
			else if flagged (search.flags, .VISIT_FILES)
				#insert (break={ current = null; break; }) body;
		}
	}
	// Close file search handles that we didn't close yet
	for * entries
		if it.find_handle && it.find_handle != win32.INVALID_HANDLE_VALUE
			win32.FindClose (it.find_handle);
}
