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

clone_to_upper :: inline (s : string, allocator : Allocator) -> string #must
{
	return to_upper (clone (s, allocator));
}

clone_to_lower :: inline (s : string, allocator : Allocator) -> string #must
{
	return to_lower (clone (s, allocator));
}
