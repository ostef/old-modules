Process :: win32.HANDLE;

Pipe :: struct
{
	read_end  : fs.File;
	write_end : fs.File;
}

get_last_error :: inline () -> Error #must
{
	if win32.GetLastError () ==
	{
	case win32.ERROR_SUCCESS;
		return .OK;
	}
	return .UNKNOWN;
}

create_pipe :: () -> Pipe #must, Error
{
	result : Pipe;
	attr : win32.SECURITY_ATTRIBUTES;
	attr.nLength = size_of (win32.SECURITY_ATTRIBUTES);
	attr.bInheritHandle = 1;
	attr.lpSecurityDescriptor = null;
	if !win32.CreatePipe (*result.read_end, *result.write_end, *attr, 0)
		return result, get_last_error ();
	if !win32.SetHandleInformation (result.read_end, win32.HANDLE_FLAG_INHERIT, 0)
	{
		close_pipe (*result);
		return result, get_last_error ();
	}
	return result, .OK;
}

close_read_end :: inline (using pipe : *Pipe)
{
	if read_end then fs.close (read_end);
	read_end = null;
}

close_write_end :: inline (using pipe : *Pipe)
{
	if write_end then fs.close (write_end);
	write_end = null;
}

close_pipe :: inline (using pipe : *Pipe)
{
	close_read_end (pipe);
	close_write_end (pipe);
}

get_current :: inline () -> Process #must
{
	return win32.GetCurrentProcess ();
}

get_environment_variable :: inline (name : string, allocator : Allocator) -> string #must, Error
{
	wstr_name := win32.utf8_to_wide (name, mem.TEMP_ALLOC);
	size := win32.GetEnvironmentVariableW (wstr_name, null, 0);
	if size == 0
		return "", get_last_error ();
	wstr_result := cast (*u16) mem.alloc (size_of (u16) * (size + 1), mem.TEMP_ALLOC);
	size = win32.GetEnvironmentVariableW (wstr_name, wstr_result, size + 1);

	return win32.wide_to_utf8 (wstr_result, allocator), .OK;
}

create_process :: (cmd_line : string, in : *Pipe, out : *Pipe, err : *Pipe, working_directory := "") -> Process #must, Error
{
	pinfo : win32.PROCESS_INFORMATION;
	sinfo : win32.STARTUPINFOW;
	sinfo.cb = size_of (win32.STARTUPINFOW);
	if err.write_end != null
		sinfo.hStdError = err.write_end;
	else
		sinfo.hStdError = win32.GetStdHandle (win32.STD_ERROR_HANDLE);
	if out.write_end != null
		sinfo.hStdOutput = out.write_end;
	else
		sinfo.hStdOutput = win32.GetStdHandle (win32.STD_OUTPUT_HANDLE);
	if in.read_end != null
		sinfo.hStdInput = in.read_end;
	else
		sinfo.hStdInput = win32.GetStdHandle (win32.STD_INPUT_HANDLE);
	sinfo.dwFlags = win32.STARTF_USESTDHANDLES;

	cwd := working_directory;
	if !cwd
		cwd = fs.get_working_directory (mem.TEMP_ALLOC);
	ok := win32.CreateProcessW (
		null,
		win32.utf8_to_wide (cmd_line, mem.TEMP_ALLOC),
		null,
		null,
		1,
		0,
		null,
		win32.utf8_to_wide (cwd, mem.TEMP_ALLOC),
		*sinfo,
		*pinfo
	);
	if !ok
		return null, get_last_error ();
	// We don't care about the thread
	win32.CloseHandle (pinfo.hThread);
	// We don't need these files anymore, since they are there
	// only to be used by the child.
	close_write_end (err);
	close_write_end (out);
	close_read_end (in);

	return pinfo.hProcess, .OK;
}

wait_for_process :: inline (process : Process, timeout_ms : u32) -> s32, Error
{
	if timeout_ms == 0 then timeout_ms = win32.INFINITE;
	res := win32.WaitForSingleObject (process, timeout_ms);
	if res == win32.WAIT_OBJECT_0
	{
		exit_code : u32;
		win32.GetExitCodeProcess (process, *exit_code);
		win32.CloseHandle (process);
		return cast, no_check (s32) exit_code, .OK;
	}
	if res == win32.WAIT_TIMEOUT
		return 1, .TIMEOUT;
	return 1, .UNKNOWN;
}

terminate_process :: inline (process : Process, exit_code : s32) -> exit_code : s32, Error
{
	ok := win32.TerminateProcess (process, cast, no_check (u32) exit_code);
	if !ok
		return 1, get_last_error ();
	uexit_code : u32;
	win32.GetExitCodeProcess (process, *uexit_code);
	win32.CloseHandle (process);
	return cast, no_check (s32) uexit_code, .OK;
}

sleep :: inline (ms : u32)
#deprecated "Use sleep_milliseconds."
{
	win32.Sleep (ms);
}

sleep_milliseconds :: inline (ms : u32)
{
	win32.Sleep (ms);
}

exit :: inline (code : s32)
{
	win32.ExitProcess (cast, no_check (u32) code);
}
