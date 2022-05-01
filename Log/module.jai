// @Todo (stefan): Find a way to have module identifiers that
// get inserted by a metaprogram for logging.

#scope_module

#import "Runtime";
fmt   :: #import "Fmt";
mem   :: #import "Memory";
array :: #import "Containers/Array";
io    :: #import "IO";

#scope_export

message :: inline (
	fmt_str : string,
	args : ..Any,
	flags := Log_Flags.NONE,
	user_flags : u32 = 0,
	location := #caller_location
)
{
	if !context.logger
		return;
	s := fmt.format (mem.HEAP_ALLOC, fmt_str, ..args);
	defer mem.free (s, mem.HEAP_ALLOC);
	info : Log_Info;
	info.location = location;
	info.common_flags = flags;
	info.user_flags = user_flags;
	context.logger (s, context.logger_data, info);
}

warning :: inline (
	fmt_str : string,
	args : ..Any,
	flags := Log_Flags.NONE,
	user_flags : u32 = 0,
	location := #caller_location
)
{
	message (fmt_str, ..args, (flags & ~.ERROR) | .WARNING, user_flags, location);
}

// We often log an error then return false, so error returns false so you can
// have if statements with only one expression in the body, and no braces. i.e:
//
// if error_case
//     return log_error ("Error case true.");
//
// instead of:
//
// if error_case
// {
//     log_error ("Error case true.");
//     return false;
// }
error :: inline (
	fmt_str : string,
	args : ..Any,
	flags := Log_Flags.NONE,
	user_flags : u32 = 0,
	location := #caller_location
) -> bool
{
	message (fmt_str, ..args, (flags & ~.WARNING) | .ERROR, user_flags, location);
	return false;
}
