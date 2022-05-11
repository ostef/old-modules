get_working_directory :: inline (allocator : Allocator) -> string #must
{
	len := win32.GetCurrentDirectoryW (0, null);
	buff := mem.alloc (2 * (len + 1), mem.TEMP_ALLOC);
	win32.GetCurrentDirectoryW (len + 1, buff);
	result := win32.wide_to_utf8 (buff, allocator);
	path.standardize (*result);

	return result;
}

set_working_directory :: inline (dir : string) -> Error
{
	if !win32.SetCurrentDirectoryW (win32.utf8_to_wide (dir, mem.TEMP_ALLOC))
		return get_last_error ();
	return .OK;
}

create_directory :: inline (dir : string) -> Error
{
	if !win32.CreateDirectoryW (win32.utf8_to_wide (dir, mem.TEMP_ALLOC), null)
		return get_last_error ();
	return .OK;
}

delete_empty_directory :: inline (dir : string) -> Error
{
	if !win32.RemoveDirectoryW (win32.utf8_to_wide (dir, mem.TEMP_ALLOC))
		return get_last_error ();
	return .OK;
}
