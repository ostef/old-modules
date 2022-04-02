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

#scope_export

#if OS == .WINDOWS
{
	#load "win32/error.jai";
	#load "win32/heap.jai";
	#load "win32/file.jai";
	#load "win32/directory.jai";
	#load "win32/search.jai";
}

#load "file.jai";

Error :: enum
{
	OK :: 0;

	ALLOCATION_FAILURE;

	ACCESS_DENIED;
	FILE_NOT_FOUND;
	TOO_MANY_OPEN_FILES;
	OPEN_FAILED;

	UNKNOWN;
}
