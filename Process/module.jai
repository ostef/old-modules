#scope_module

#import "Runtime";
#if OS == .WINDOWS
	win32 :: #import "Win32";
str :: #import "String";
mem :: #import "Memory";
fs  :: #import "File_System";

#scope_export

#if OS == .WINDOWS
	#load "win32.jai";

Error :: enum
{
	OK :: 0;

	INVALID_PARAMETERS;
	TIMEOUT;

	UNKNOWN :: 1000;
}

Output_Type :: enum
{
	NONE    :: 0;
	CAPTURE :: 1;
	PRINT   :: 2;
}

run_command :: (
	args : ..string,
	working_directory := "",
	timeout_ms : u32 = 0,
	output := Output_Type.NONE
) ->
	exit_code : s32,
	out_str : string,
	err_str : string,
	err : Error
{
	if args.count == 0
		return 1, "", "", .INVALID_PARAMETERS;
	cmd_args := str.join_sep (mem.TEMP_ALLOC, " ", ..mem.advance (args));
	cmd_line := str.join (mem.TEMP_ALLOC, "\"", args[0], "\" ", cmd_args);
	output_pipe : Pipe;
	error_pipe  : Pipe;
	if output != .PRINT
	{
		output_pipe = create_pipe ();
		error_pipe  = create_pipe ();
	}
	defer close_pipe (*output_pipe);
	defer close_pipe (*error_pipe);
	input_pipe : Pipe;
	process := create_process (cmd_line, *input_pipe, *output_pipe, *error_pipe, working_directory);
	exit_code, err := wait_for_process (process, timeout_ms);
	if err != .OK
		exit_code = terminate_process (process, 1);
	out_str := "";
	err_str := "";
	if output == .CAPTURE
	{
		out_str = fs.read_entire_file (output_pipe.read_end);
		err_str = fs.read_entire_file (error_pipe.read_end);
	}

	return exit_code, out_str, err_str, err;
}
