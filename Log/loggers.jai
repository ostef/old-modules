Default_Logger :: struct
{
	Flags :: enum_flags
	{
		PRINT_TIME_STAMP :: 0x01;
		PRINT_LOCATION   :: 0x02;
		PRINT_LOG_LEVEL  :: 0x04;
		PRINT_COLORS     :: 0x08;
	}

	flags : Flags;
	location : Source_Code_Location;
	stream : io.Stream;
}

default_logger_proc :: (message : string, data : *void, info : Log_Info)
{
	using logger := cast (*Default_Logger) data;
	// @Todo
}

Multi_Logger :: struct
{
	Entry :: struct
	{
		proc : Logger;
		data : *void;
	}

	loggers : [..]Entry;
}

add_logger :: inline (using multi : *Multi_Logger, proc : Logger, data : *void)
{
	entry := array.push (*loggers, initialize = false);
	entry.proc = proc;
	entry.data = data;
}

remove_logger :: inline (using multi : *Multi_Logger, at : s64)
{
	array.remove_at (*loggers, at);
}

multi_logger_proc :: (message : string, data : *void, info : Log_Info)
{
	multi := cast (*Multi_Logger) data;
	for multi.loggers
		it.proc (message, it.data, info);
}
