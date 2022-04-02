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
