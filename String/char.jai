is_digit :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "0" && ascii <= #char "9";
}

is_alpha :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii >= #char "a" && ascii <= #char "z" ||
		ascii >= #char "A" && ascii <= #char "Z";
}

is_alnum :: is_alpha_numeric;
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

to_upper :: inline (s : string) -> string
#no_context
{
	for i : 0..s.count - 1
		if is_lower (s[i])
			s[i] = #char "A" + (s[i] - #char "a");
	return s;
}

to_lower :: inline (s : string) -> string
#no_context
{
	for i : 0..s.count - 1
		if is_upper (s[i])
			s[i] = #char "a" + (s[i] - #char "A");
	return s;
}

is_space :: inline (ascii : u8) -> bool #must
#no_context
{
	return ascii == #char " " || ascii == #char "\t" || ascii == #char "\n" || ascii == #char "\r";
}
