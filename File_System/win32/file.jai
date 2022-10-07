File :: win32.HANDLE;

open :: (filename : string, flags : File_Open_Flags) -> File #must, Error
{
	access : win32.DWORD;
	if flagged (flags, .ACCESS_READ)
		access |= win32.FILE_GENERIC_READ;
	if flagged (flags, .ACCESS_WRITE)
		access |= win32.FILE_GENERIC_WRITE;
	if flagged (flags, .APPEND)
	{
		access = remove_flag (access, win32.FILE_GENERIC_WRITE);
		access = add_flag (access, win32.FILE_APPEND_DATA);
	}
	if flagged (flags, .CREATE)
		access = add_flag (access, win32.FILE_GENERIC_WRITE);
	share_mode : win32.DWORD = win32.FILE_SHARE_READ | win32.FILE_SHARE_WRITE;
	
	open_mode : win32.DWORD = win32.OPEN_EXISTING;
	if flagged (flags, .CREATE) && flagged (flags, .FAIL_IF_EXISTS)
		open_mode = win32.CREATE_NEW;
	else if flagged (flags, .CREATE) && flagged (flags, .TRUNCATE)
		open_mode = win32.CREATE_ALWAYS;
	else if flagged (flags, .CREATE)
		open_mode = win32.OPEN_ALWAYS;
	else if flagged (flags, .TRUNCATE)
		open_mode = win32.TRUNCATE_EXISTING;

	file := win32.CreateFileW (
		win32.utf8_to_wide (filename, mem.TEMP_ALLOC),
		access,
		share_mode,
		null,
		open_mode,
		win32.FILE_ATTRIBUTE_NORMAL | win32.FILE_FLAG_BACKUP_SEMANTICS,
		null
	);
	if file == win32.INVALID_HANDLE_VALUE
		return null, get_last_error ();
	return cast (File) file, .OK;
}

close :: inline (file : File) -> Error
{
	if !win32.CloseHandle (file)
		return get_last_error ();
	return .OK;
}

write :: (file : File, data : *void, size : s64) -> written : s64, Error
{
	total : s64;
	while total < size
	{
		remaining := size - total;
		to_write := cast (u32) math.min (remaining, math.U32_MAX);
		written : u32;
		if !win32.WriteFile (file, data + total, to_write, *written, null) || written <= 0
			return total, get_last_error ();
		total += cast (s64) written;
	}

	return total, .OK;
}

read :: (file : File, data : *void, size : s64) -> read : s64, Error
{
	total : s64;
	while total < size
	{
		remaining := size - total;
		to_read := cast (u32) math.min (remaining, math.U32_MAX);
		bytes_read : u32;
		if !win32.ReadFile (file, data + total, to_read, *bytes_read, null) || bytes_read <= 0
			return total, get_last_error ();
		total += cast (s64) bytes_read;
	}

	return total, .OK;
}

flush :: inline (file : File) -> Error
{
	if !win32.FlushFileBuffers (file)
		return get_last_error ();
	return .OK;
}

seek :: inline (file : File, offset : s64, from : Seek_From) -> moved : s64, Error
{
	cursor : win32.DWORD;
	if #complete from ==
	{
	case .BEGIN;   cursor = win32.FILE_BEGIN;
	case .CURRENT; cursor = win32.FILE_CURRENT;
	case .END;     cursor = win32.FILE_END;
	}
	hi := cast (s32) (offset >> 32);
	lo := cast (s32) offset;
	lo_moved := win32.SetFilePointer (file, lo, *hi, cursor);
	if lo_moved == win32.INVALID_SET_FILE_POINTER
		return 0, get_last_error ();
	
	return (cast (s64) hi) << 32 + cast (s64) lo_moved, .OK;
}

copy_file :: inline (src : string, dst : string, overwrite := false) -> bool
{
	wide_src := win32.utf8_to_wide (src, mem.TEMP_ALLOC);
	assert (wide_src != null);
	wide_dst := win32.utf8_to_wide (dst, mem.TEMP_ALLOC);
	assert (wide_dst != null);
	return win32.CopyFileW (wide_src, wide_dst, xx (!overwrite)) != 0;
}

get_file_size :: inline (file : File) -> s64 #must, Error
{
	len : win32.LARGE_INTEGER;
	if !win32.GetFileSizeEx (file, *len)
		return len.QuadPart, get_last_error ();
	return len.QuadPart, .OK;
}

get_file_cursor :: inline (file : File) -> s64 #must, Error
{
	cursor, err := seek (file, 0, .CURRENT);
	return cursor, err;
}

set_eof_to_cursor :: inline (file : File) -> Error
{
	if !win32.SetEndOfFile (file)
		return get_last_error ();
	return .OK;
}

file_exists :: inline (filename : string) -> bool #must
{
	return win32.GetFileAttributesW (win32.utf8_to_wide (filename, mem.TEMP_ALLOC)) != win32.INVALID_FILE_ATTRIBUTES;
}

delete_file :: inline (filename : string) -> Error
{
	if !win32.DeleteFileW (win32.utf8_to_wide (filename, mem.TEMP_ALLOC))
		return get_last_error ();
	return .OK;
}

move_file :: inline (src : string, dst : string) -> Error
{
	if !win32.MoveFileW (win32.utf8_to_wide (src, mem.TEMP_ALLOC),
		win32.utf8_to_wide (dst, mem.TEMP_ALLOC))
		return get_last_error ();
	return .OK;
}

win32_to_file_attributes :: inline (win32_attrs : win32.DWORD) -> File_Attributes #must
{
	result : File_Attributes;
	if flagged (win32_attrs, win32.FILE_ATTRIBUTE_DIRECTORY)
		result |= .DIRECTORY;
	if flagged (win32_attrs, win32.FILE_ATTRIBUTE_HIDDEN)
		result |= .HIDDEN;
	if flagged (win32_attrs, win32.FILE_ATTRIBUTE_READONLY)
		result |= .READ_ONLY;
	if flagged (win32_attrs, win32.FILE_ATTRIBUTE_REPARSE_POINT)
		result |= .SYMLINK;
	if flagged (win32_attrs, win32.FILE_ATTRIBUTE_TEMPORARY)
		result |= .TEMPORARY;

	return result;
}

file_attributes_to_win32 :: inline (attributes : File_Attributes) -> win32.DWORD #must
{
	win32_attrs : win32.DWORD;
	if flagged (attributes, .DIRECTORY)
		win32_attrs |= win32.FILE_ATTRIBUTE_DIRECTORY;
	if flagged (attributes, .HIDDEN)
		win32_attrs |= win32.FILE_ATTRIBUTE_HIDDEN;
	if flagged (attributes, .READ_ONLY)
		win32_attrs |= win32.FILE_ATTRIBUTE_READONLY;
	if flagged (attributes, .SYMLINK)
		win32_attrs |= win32.FILE_ATTRIBUTE_REPARSE_POINT;
	if flagged (attributes, .TEMPORARY)
		win32_attrs |= win32.FILE_ATTRIBUTE_TEMPORARY;
		
	return win32_attrs;
}

get_file_attributes :: inline (filename : string) -> File_Attributes #must, Error
{
	attrs := win32.GetFileAttributesW (win32.utf8_to_wide (filename, mem.TEMP_ALLOC));
	if attrs == win32.INVALID_FILE_ATTRIBUTES
		return 0, get_last_error ();
	return win32_to_file_attributes (attrs), .OK;
}

set_file_attributes :: inline (filename : string, attrs : File_Attributes) -> Error
{
	remove_flag (*attrs, .DIRECTORY);
	remove_flag (*attrs, .SYMLINK);
	if !win32.SetFileAttributesW (win32.utf8_to_wide (filename, mem.TEMP_ALLOC), file_attributes_to_win32 (attrs))
		return get_last_error ();

	return .OK;
}

get_full_filename :: inline (filename : string, allocator := context.allocator) -> string #must, Error
{
	wstr_filename := win32.utf8_to_wide (filename, mem.TEMP_ALLOC);
	length := win32.GetFullPathNameW (wstr_filename, 0, null, null);
	if length == 0
		return "", get_last_error ();
	buffer := mem.alloc (2 * (length + 1), mem.TEMP_ALLOC);
	win32.GetFullPathNameW (wstr_filename, length, buffer, null);
	result := win32.wide_to_utf8 (buffer, allocator);
	for i : 0..result.count - 1
		if result[i] == #char "\\"
			result[i] = #char "/";

	return result, .OK;
}
