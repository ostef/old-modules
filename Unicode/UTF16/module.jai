#scope_module

#import "Unicode";
mem :: #import "Memory";

#scope_export

decode :: inline (s : []u16, allocator : Allocator) -> []u32 #must, valid : bool
{
	valid_input := true;
	result := mem.alloc (u32, length (s), allocator);
	i := 0;
	offset := 0;
	while offset < s.count
	{
		codepoint, advance, valid := decode (s, offset);
		result[i] = codepoint;
		i += 1;
		offset += advance;
		valid_input &= valid;
	}

	return result, valid_input;
}

decode :: inline (buffer : []u16, byte_offset : s64) -> codepoint : u32, size : s64, valid : bool
{
	codepoint, size, valid := decode (mem.advance (buffer, byte_offset));
	return codepoint, size, valid;
}

decode :: (buffer : []u16) -> codepoint : u32, size : s64, valid : bool
{
	if buffer.count > 0
	{
		b0 := buffer[0];
		if b0 >= 0xd800 && b0 <= 0xdbff
		{
			b0 -= 0xd800;
			b0 *= 0x400;
			if buffer.count < 2
				return CODEPOINT_INVALID, 1, false;
			b1 := buffer[1];
			b1 -= 0xdc00;
			codepoint := cast (u32) (b0 + b1 + 0x10000);
			
			return codepoint, 2, true;
		}
		else if b0 <= 0xd7ff || (b0 >= 0xe000 && b0 <= 0xffff)
		{
			codepoint := cast (u32) b0;
			return codepoint, 1, true;
		}
	}
	
	return CODEPOINT_INVALID, 1, false;
}

encoding_length :: inline (codepoint : u32) -> size : s64, valid : bool
{
	if codepoint <= 0xd7ff || (codepoint >= 0xe000 && codepoint <= 0xffff)
		return 1, true;
	else if codepoint > CODEPOINT_MAX || (codepoint >= 0xd800 && codepoint <= 0xdfff)
		return 1, false;
	else
		return 2, true;
}

encode :: inline (s : []u32, allocator : Allocator) -> []u16 #must, valid : bool
{
	valid := true;
	result : []u16;
	for s
		result.count += encoding_length (it);
	result = mem.alloc (u16, result.count, allocator);
	i := 0;
	for s
	{
		advance, ok := encode (result, i, it);
		valid &= ok;
		i += advance;
	}

	return result, valid;
}

encode :: inline (buffer : []u16, offset : s64, codepoint : u32) -> size : s64, valid : bool
{
	size, valid := encode (mem.advance (buffer, offset), codepoint);
	return size, valid;
}

encode :: (buffer : []u16, codepoint : u32) -> size : s64, valid : bool
{
	if codepoint <= 0xd7ff || (codepoint >= 0xe000 && codepoint <= 0xffff)
	{
		buffer[0] = cast (u16) codepoint;
		return 1, true;
	}
	else if codepoint > CODEPOINT_MAX || (codepoint >= 0xd800 && codepoint <= 0xdfff)
	{
		buffer[0] = cast (u16) CODEPOINT_INVALID;
		return 1, false;
	}
	else
	{
		codepoint -= 0x10000;
		high_surrogate := cast (u16) (0xd800 + (codepoint >> 10));
		low_surrogate  := cast (u16) (0xdc00 + (codepoint & 0x03ff));
		buffer[0] = high_surrogate;
		buffer[1] = low_surrogate;

		return 2, true;
	}
}

length :: inline (s : []u16) -> s64 #must, valid : bool
{
	len := 0;
	i := 0;
	while i < s.count
	{
		c := s[i];
		if c <= 0xd7ff || (c >= 0xe000 && c <= 0xffff)
			i += 1;
		else if c >= 0xd800 && c <= 0xdbff && i + 2 <= s.count
			i += 2;
		else
			return len, false;
		len += 1;
	}

	return len, true;
}
