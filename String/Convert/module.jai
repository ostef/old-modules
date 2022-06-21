#scope_module

#import "Runtime";
str  :: #import "String";
mem  :: #import "Memory";
math :: #import "Math";
ryu  :: #import "Ryu";

#scope_export

#load "parse.jai";
#load "append.jai";

Error :: enum
{
	OK :: 0;

	BUFFER_TOO_SMALL :: 1;
	MALFORMED_INPUT  :: 2;
	OVERFLOW  :: 3;
	UNDERFLOW :: 4;
}
