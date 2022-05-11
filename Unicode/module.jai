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

#scope_file

binary_search :: (c : s32, table : []s32, length : s64, stride : s64) -> s64
#no_context
#no_abc
{
	n := length;
	t := 0;
	while n > 1
	{
		m := n / 2;
		p := t + m * stride;
		if c >= table[p]
		{
			t = p;
			n = n - m;
		}
		else
			n = m;
	}
	if n != 0 && c >= table[t]
		return t;
	return -1;
}

#scope_export

is_lower :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .LOWER_CASE_LETTER);
	c := cast (s32) codepoint;
	p := binary_search (c, TO_UPPER_RANGES, TO_UPPER_RANGES.count / 3, 3);
	if p >= 0 && TO_UPPER_RANGES[p] <= c && c <= TO_UPPER_RANGES[p + 1]
		return true;
	p = binary_search (c, TO_UPPER_SINGLETS, TO_UPPER_SINGLETS.count / 2, 2);
	if p >= 0 && c == TO_UPPER_SINGLETS[p]
		return true;
	return false;
}

is_upper :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .UPPER_CASE_LETTER);
	c := cast (s32) codepoint;
	p := binary_search (c, TO_LOWER_RANGES, TO_LOWER_RANGES.count / 3, 3);
	if p >= 0 && TO_LOWER_RANGES[p] <= c && c <= TO_LOWER_RANGES[p + 1]
		return true;
	p = binary_search (c, TO_LOWER_SINGLETS, TO_LOWER_SINGLETS.count / 2, 2);
	if p >= 0 && c == TO_LOWER_SINGLETS[p]
		return true;
	return false;
}

is_alpha :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return CODEPOINT_FLAGS[codepoint] & .LETTER != 0;
	if is_upper (codepoint) || is_lower (codepoint)
		return true;
	c := cast (s32) codepoint;
	p := binary_search (c, ALPHA_RANGES, ALPHA_RANGES.count / 2, 2);
	if p >= 0 && ALPHA_RANGES[p] <= c && c <= ALPHA_RANGES[p + 1]
		return true;
	p = binary_search (c, ALPHA_SINGLETS, ALPHA_SINGLETS.count / 2, 2);
	if p >= 0 && c == ALPHA_SINGLETS[p]
		return true;
	return false;
}

is_numeric :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .NUMERIC);
	return false;
}

is_alnum :: is_alpha_numeric;
is_alppha_num :: is_alpha_numeric;
is_alpha_numeric :: inline (codepoint : u32) -> bool #must
#no_context
{
	return is_alpha (codepoint) || is_numeric (codepoint) || codepoint == #char "_";
}

is_space :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .SPACE);
	c := cast (s32) codepoint;
	p := binary_search (c, SPACE_RANGES, SPACE_RANGES.count / 2, 2);
	if p >= 0 && SPACE_RANGES[p] <= c && c <= SPACE_RANGES[p + 1]
		return true;
	return false;
}

is_printable :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .PRINTABLE);
	return false;
}

is_graphical :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return CODEPOINT_FLAGS[codepoint] & .GRAPHICAL == 0;
	return false;
}

is_control :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .CONTROL);
	return false;
}

is_symbol :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .SYMBOL);
	return false;
}

is_punctuation :: inline (codepoint : u32) -> bool #must
#no_context
{
	if codepoint <= CODEPOINT_MAX_LATIN1
		return flagged (CODEPOINT_FLAGS[codepoint], .PUNCTUATION);
	return false;
}
