#scope_module

#import "Runtime";
mem :: #import "Memory";
str :: #import "String";

#scope_export

standardize :: inline (filename : *string)
{
	is_sep :: inline (char : u8) -> bool #must
	{
		return char == #char "/" || char == #char "\\";
	}

	remove_at :: inline (filename : *string, at : s64)
	{
		for i : at..filename.count - 2
			filename.data[i] = filename.data[i + 1];
		filename.count -= 1;
	}

	i := 0;
	while i < filename.count
	{
		if i != 0 && is_sep (filename.data[i]) && filename.data[i - 1] == #char "/"
		{
			remove_at (filename, i);
			continue;
		}
		if filename.data[i] == #char "\\"
			filename.data[i] = #char "/";
		i += 1;
	}
}

join :: (parts : ..string) -> string #must
{
	return join (context.allocator, ..parts);
}

join :: (allocator : Allocator, parts : ..string) -> string #must
{
	total_size := 0;
	for parts
	#no_abc
	{
		if it.count <= 0
			continue;
		total_size += it.count;
		if it_index != parts.count - 1 && it[it.count - 1] != #char "/" && it[it.count - 1] != #char "\\"
			total_size += 1;
	}
	if total_size == 0
		return "";
	result : string;
	result.data = mem.alloc (total_size, allocator);
	for parts
	{
		mem.copy (result.data + result.count, it.data, it.count);
		result.count += it.count;
		if it_index != parts.count - 1 && result[result.count - 1] != #char "/"
		{
			result.count += 1;
			result[result.count - 1] = #char "/";
		}
	}
	standardize (*result);

	return result;
}

remove_extension :: inline (filename : string) -> string #must
{
	slash_index := str.find_last (filename, #char "/");
	dot_index := str.find_last (filename, #char ".");
	if dot_index == -1 || dot_index < slash_index
		return filename;
	return str.slice (filename, dot_index);
}

get_extension :: inline (filename : string) -> string #must
{
	slash_index := str.find_last (filename, #char "/");
	dot_index := str.find_last (filename, #char ".");
	if dot_index == -1 || dot_index < slash_index
		return "";
	return str.advance (filename, dot_index + 1);
}

get_basename :: inline (filename : string) -> string #must
{
	slash_index := str.find_last (filename, #char "/");
	if slash_index == -1
		return filename;
	return str.advance (filename, slash_index + 1);
}

get_parent_dir :: inline (filename : string) -> string #must
{
	name := filename;
	if name.count > 0 && name[name.count - 1] == #char "/"
		name.count -= 1;
	slash_index := str.find_last (name, #char "/");
	if slash_index == -1
		return "";
	return str.slice (name, slash_index);
}
