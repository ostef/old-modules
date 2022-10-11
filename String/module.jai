#scope_module

#import "Runtime";
math :: #import "Math";
mem  :: #import "Memory";

#scope_export

#load "char.jai";

make :: inline (data : *u8, count : s64) -> string #must
#no_context
{
	result : string = ---;
	result.data = data;
	result.count = count;

	return result;
}

length :: inline (cstr : *u8) -> s64 #must
{
	i := 0;
	while cstr[i]
		i += 1;

	return i;
}

from_array :: inline (array : []u8) -> string #must
#no_context
{
	return make (array.data, array.count);
}

to_array :: inline (s : string) -> []u8 #must
#no_context
{
	result : []u8 = ---;
	result.data = s.data;
	result.count = s.count;

	return result;
}

slice :: inline (s : string, start : s64, count : s64) -> string #must
#no_context
{
	contextless_assert (start >= 0 && count >= 0, "Invalid parameters.");
	contextless_assert (start + count <= s.count, "Invalid slice range.");

	return make (s.data + start, count);
}

slice :: inline (s : string, count : s64) -> string #must
#no_context
{
	return slice (s, 0, count);
}

advance :: inline (s : string, count := 1) -> string #must
#no_context
{
	count = math.clamp (count, 0, s.count);
	result := s;
	result.data  += count;
	result.count -= count;

	return result;
}

advance :: inline (s : *string, count := 1)
#no_context
{
	count = math.clamp (count, 0, s.count);
	s.data  += count;
	s.count -= count;
}

copy :: inline (dst : string, src : string) -> string
#no_context
{
	n := math.min (dst.count, src.count);
	mem.copy (dst.data, src.data, n);

	return slice (dst, n);
}

copy :: inline (dst : *string, src : string)
#no_context
{
	n := math.min (dst.count, src.count);
	mem.copy (dst.data, src.data, n);
	dst.count = n;
}

clone :: inline (s : string, allocator := context.allocator) -> string #must
{
	data := mem.alloc (s.count, allocator);
	mem.copy (data, s.data, s.count);

	return make (data, s.count);
}

clone_to_cstring :: inline (s : string, allocator := context.allocator) -> *u8 #must
{
	result := cast (*u8) mem.alloc (s.count + 1, allocator);
	mem.copy (result, s.data, s.count);
	result[s.count] = 0;

	return result;
}

compare :: inline (a : string, b : string) -> int #must
#no_context
#no_abc
{
	if a.count < b.count
		return -cast (int) b[a.count - 1];

	if a.count > b.count
		return  cast (int) a[b.count - 1];

	for i : 0..a.count - 1
		if a[i] != b[i]
			return cast (int) a[i] - cast (int) b[i];

	return 0;
}

starts_with :: inline (s : string, with : string) -> bool #must
#no_context
#no_abc
{
	if s.count < with.count
		return false;

	for i : 0..with.count - 1
	{
		if s[i] != with[i]
			return false;
	}

	return true;
}

ends_with :: inline (s : string, with : string) -> bool #must
#no_context
#no_abc
{
	if s.count < with.count
		return false;
		
	for i : 0..with.count - 1
	{
		if s[s.count - 1 - i] != with[with.count - 1 - i]
			return false;
	}

	return true;
}

find_first :: inline (s : string, char : u8) -> s64 #must
#no_context
#no_abc
{
	for i : 0..s.count - 1
	{
		if s[i] == char
			return i;
	}

	return -1;
}

find_last :: inline (s : string, char : u8) -> s64 #must
#no_context
#no_abc
{
	for < i : s.count - 1..0
	{
		if s[i] == char
			return i;
	}

	return -1;
}

join :: inline (args : ..string) -> string #must
{
	return join (context.allocator, ..args);
}

join :: (allocator : Allocator, args : ..string) -> string #must
#no_abc
{
	total_size := 0;
	for args
		total_size += it.count;
	
	if total_size == 0
		return "";
	
	result : string = ---;
	result.data = mem.alloc (total_size, allocator);
	result.count = total_size;
	
	i := 0;
	for args
	{
		mem.copy (result.data + i, it.data, it.count);
		i += it.count;
	}

	return result;
}

join_sep :: inline (sep : string, args : ..string) -> string #must
{
	return join_sep (context.allocator, sep, ..args);
}

join_sep :: (allocator : Allocator, sep : string, args : ..string) -> string #must
#no_abc
{
	total_size := 0;
	
	for args
	{
		if it_index != 0
			total_size += sep.count;
		total_size += it.count;
	}
	
	if total_size == 0
		return "";
	
	result : string = ---;
	result.data = mem.alloc (total_size, allocator);
	result.count = total_size;
	
	i := 0;
	for args
	{
		if it_index != 0
		{
			mem.copy (result.data + i, sep.data, sep.count);
			i += sep.count;
		}
	
		mem.copy (result.data + i, it.data, it.count);
		i += it.count;
	}

	return result;
}

