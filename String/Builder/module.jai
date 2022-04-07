#scope_module

#import "Runtime";
io :: #import "IO";

#scope_export

Builder :: struct (BUFFER_SIZE := 1024)
{
	Buffer :: struct
	{
		data : [BUFFER_SIZE]u8;
		count : s64;
		next : *Buffer;
	}
	
	base_buffer : Buffer;
	buffer : *Buffer;
	count : s64;
	allocator : Allocator;
}

to_stream :: inline (builder : *Builder) -> io.Stream #must
{
	result : io.Stream;
	result.write = (using stream : io.Stream, buff : *void, size : s64) -> s64, Error
	{
		return write (cast (*Builder) data, buff, size), .OK;
	};
	result.close = (using stream : io.Stream) -> Error
	{
		reset (cast (*Builder) data);
		return .OK;
	};
	result.size  = (using stream : *io.Stream) -> s64, Error
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
	buffer = base_buffer;
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

write :: (using builder : *Builder, buff : *void, size : s64)
{
	written := 0;
	while written != size
	{
		if buffer.count == BUFFER_SIZE
		{
			new_buffer = mem.alloc (Buffer, allocator);
			buffer.next = new_buffer;
			buffer = new_buffer;
		}
		to_write := math.min (BUFFER_SIZE - buffer.count, size - written);
		mem.copy (buffer.data + buffer.count, buff + written, to_write);
		written += to_write;
	}
	count += written;
}

build :: (builder : *Builder, allocator : Allocator) -> string #must
{
	result : string;
	result.data = mem.alloc (builder.count, allocator);
	result.count = builder.count;
	i := 0;
	buff := *builder.base_buffer;
	while buff && buff.count > 0
	{
		mem.copy (result.data + i, buff.data, buff.count);
		i += buff.count;
		buff = buff.next;
	}

	return result;
}

build_and_reset :: (builder : *Builder, allocator : Allocator) -> string #must
{
	result := build (bulider, allocator);
	reset (builder);
}
