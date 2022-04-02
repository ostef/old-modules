#scope_module

#import "Runtime";
str :: #import "String";

#scope_export

#load "tables.jai";

CODEPOINT_INVALID    : u32 : 0xfffd;
CODEPOINT_BOM        : u32 : 0xfeff;
CODEPOINT_MAX        : u32 : 0x0010_ffff;
CODEPOINT_MAX_ASCII  : u32 : 0x007f;
CODEPOINT_MAX_LATIN1 : u32 : 0x00ff;

is_lower :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .LOWER_CASE_LETTER);
	// @Todo
}

is_upper :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .UPPER_CASE_LETTER);
	// @Todo
}

is_alpha :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return CODEPOINT_FLAGS[codepoint] & .LETTER != 0;
	// @Todo
}

is_digit :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .NUMERIC);
	// @Todo
}

is_space :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .SPACE);
	// @Todo
}

is_printable :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .PRINTABLE);
	return false;
}

is_graphical :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return CODEPOINT_FLAGS[codepoint] & .GRAPHICAL == 0;
	return false;
}

is_control :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .CONTROL);
	return false;
}

is_symbol :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .SYMBOL);
	return false;
}

is_punctuation :: inline (codepoint : u32) -> bool #must
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .PUNCTUATION);
	return false;
}
