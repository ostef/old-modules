error_from_win32 :: inline (err : win32.DWORD) -> Error #must
{
	if err ==
	{
	case win32.ERROR_SUCCESS;
		return .OK;
	case win32.ERROR_FILE_NOT_FOUND;
		return .FILE_NOT_FOUND;
	case win32.ERROR_TOO_MANY_OPEN_FILES;
		return .TOO_MANY_OPEN_FILES;
	case win32.ERROR_ACCESS_DENIED;
		return .ACCESS_DENIED;
	}
	return .UNKNOWN;
}

get_last_error :: inline () -> Error #must
{
	return error_from_win32 (win32.GetLastError ());
}

get_last_error_string :: win32.get_last_error_string;
