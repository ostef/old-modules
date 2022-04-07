#module_parameters (DEFAULT_BUFFER_SIZE := 1000);

#scope_module

#import "Runtime";
mem     :: #import "Memory";
math    :: #import "Math";
io      :: #import "IO";
strconv :: #import "String/Convert";

#scope_export

Builder :: struct (BUFFER_SIZE := DEFAULT_BUFFER_SIZE)
{
	Buffer :: struct
	{
		data  : [BUFFER_SIZE]u8 = ---;
		count : s64;
		next  : *Buffer;
	}

	// Fmt uses this
	write_byte :: (builder : *Builder (BUFFER_SIZE), byte : u8)
	{
		if builder && byte != 0
			write (builder, *byte, 1);
	}

	base_buffer : Buffer;
	buffer : *Buffer;
	count : s64;
	allocator : Allocator;
}

to_stream :: inline (builder : *Builder) -> io.Stream #must
{
	result : io.Stream;
	result.write = (stream : io.Stream, buff : *void, size : s64) -> s64, io.Error
	{
		return write (cast (*Builder) stream.data, buff, size), .OK;
	};
	result.close = (using stream : io.Stream) -> io.Error
	{
		reset (cast (*Builder) data);
		return .OK;
	};
	result.size  = (using stream : io.Stream) -> s64, io.Error
	{
		return (cast (*Builder) data).count, .OK;
	};
	result.data = builder;

	return result;
}

init :: inline (builder : *Builder, allocator : Allocator)
{
	builder.base_buffer.count = 0;
	builder.base_buffer.next = null;
	builder.buffer = *builder.base_buffer;
	builder.count = 0;
	builder.allocator = allocator;
}

reset :: inline (using builder : *Builder)
{
	current := base_buffer.next;
	while current
	{
		next := current.next;
		mem.free (current, allocator);
		current = next;
	}
	buffer = *base_buffer;
	base_buffer.next = null;
	base_buffer.count = 0;
	count = 0;
}

clear :: inline (using builder : *Builder)
{
	base_buffer.count = 0;
	current := base_buffer.next;
	while current
	{
		current.count = 0;
		current = current.next;
	}
	count = 0;
	buffer = *base_buffer;
}

write :: (using builder : *Builder, buff : *void, size : s64) -> s64
{
	written := 0;
	while written != size
	{
		if buffer.count == BUFFER_SIZE
		{
			if !buffer.next
			{
				next := mem.alloc (Buffer, allocator);
				buffer.next = next;
			}
			buffer = buffer.next;
		}
		to_write := math.min (BUFFER_SIZE - buffer.count, size - written);
		mem.copy (buffer.data.data + buffer.count, buff + written, to_write);
		buffer.count += to_write;
		written += to_write;
	}
	count += written;

	return written;
}

build :: (builder : Builder, allocator : Allocator) -> string #must
{
	result : string;
	result.data = mem.alloc (builder.count, allocator);
	result.count = builder.count;
	i := 0;
	buff := *builder.base_buffer;
	while buff && buff.count > 0
	{
		mem.copy (result.data + i, buff.data.data, buff.count);
		i += buff.count;
		buff = buff.next;
	}

	return result;
}

build_and_reset :: inline (builder : *Builder, allocator : Allocator) -> string #must
{
	result := build (builder, allocator);
	reset (builder);
	return result;
}

append :: inline (builder : *Builder, s : string)
{
	write (builder, s.data, s.count);
}

append_bool :: inline (builder : *Builder, val : bool)
{
	io.append_bool (to_stream (builder), val);
}

append_u64 :: inline (builder : *Builder, val : u64, $$base := strconv.DECIMAL_BASE)
{
	io.append_u64 (to_stream (builder), val, base);
}

append_s64 :: inline (builder : *Builder, val : s64, $$base := strconv.DECIMAL_BASE)
{
	io.append_s64 (to_stream (builder), val, base);
}

append_f64 :: inline (builder : *Builder, val : f64, precision : u32 = 6)
{
	io.append_f64 (to_stream (builder), val, precision);
}

append_newline :: inline (builder : *Builder)
{
	append (builder, "\n");
}

append_fmt :: inline (builder : *Builder, fmt_str : string, args : ..Any)
{
	fmt :: #import "Fmt";
	fmt.format (builder, fmt_str, ..args);
}

append_line :: inline (builder : *Builder, fmt_str : string, args : ..Any)
{
	fmt :: #import "Fmt";
	fmt.format (builder, fmt_str, ..args);
	append_newline (builder);
}
