is_digit :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "0" && ascii <= #char "9";
}

is_bin_digit :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii == #char "0" || ascii == #char "1";
}

is_hex_digit :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "0" && ascii <= #char "9"
		|| ascii >= #char "a" && ascii <= #char "f"
		|| ascii >= #char "A" && ascii <= #char "F";
}

is_alpha :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "a" && ascii <= #char "z" ||
		ascii >= #char "A" && ascii <= #char "Z";
}

is_alnum :: is_alpha_numeric;
is_alpha_num :: is_alpha_numeric;
is_alpha_numeric :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii == #char "_" || is_digit (ascii) || is_alpha (ascii);
}

is_upper :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "A" && ascii <= #char "Z";
}

is_lower :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "a" && ascii <= #char "z";
}

is_ascii :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= 0 && ascii <= 127;
}

to_upper :: inline (ascii : u8) -> u8 #must
#no_context
{
	if is_lower (ascii)
		return #char "A" + (ascii - #char "a");
	return ascii;
}

to_lower :: inline (ascii : u8) -> u8 #must
#no_context
{
	if is_upper (ascii)
		return #char "a" + (ascii - #char "A");
	return ascii;
}

to_upper :: inline (s : string) -> string
#no_context
{
	for i : 0..s.count - 1
		s[i] = to_upper (s[i]);
	return s;
}

to_lower :: inline (s : string) -> string
#no_context
{
	for i : 0..s.count - 1
		s[i] = to_lower (s[i]);
	return s;
}

is_space :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii == #char " " || ascii == #char "\t" || ascii == #char "\n" || ascii == #char "\r";
}
