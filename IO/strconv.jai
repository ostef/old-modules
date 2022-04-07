#scope_module

str     :: #import "String";
strconv :: #import "String/Convert";

#scope_export

append :: inline (stream : Stream, s : string) -> written : s64, Error
{
	n, err := write (stream, s.data, s.count);
	return n, err;
}

append_bool :: inline (stream : Stream, val : bool) -> written : s64, Error
{
	buff : [5]u8 = ---;
	s, n := strconv.append_bool (buff, val);
	written, err := write (stream, buff.data, n);
	return written, err;
}

append_u64 :: inline (stream : Stream, val : u64, $$base := strconv.DECIMAL_BASE) -> written : s64, Error
{
	buff : [64]u8 = ---;
	s, n := strconv.append_u64 (buff, val, base);
	written, err := write (stream, buff.data, n);
	return written, err;
}

append_s64 :: inline (stream : Stream, val : s64, $$base := strconv.DECIMAL_BASE) -> written : s64, Error
{
	buff : [65]u8 = ---;
	s, n := strconv.append_s64 (buff, val, base);
	written, err := write (stream, buff.data, n);
	return written, err;
}

append_f64 :: inline (stream : Stream, val : f64, precision : u32 = 6) -> written : s64, Error
{
	ryu :: #import "Ryu";

	if precision > 16
		precision = 16;
	ryu_fmt : ryu.Format;
	ryu_fmt.precision = precision;
	ryu_fmt.flags |= .REMOVE_TRAILING_ZEROES;
	temp_buffer : [500]u8 = ---;
	len := ryu.f64_to_fixed_buffered (val, ryu_fmt, temp_buffer.data);
	written, err := write (stream, temp_buffer.data, len);
	return written, err;
}

parse_bool :: inline (stream : Stream) -> value : bool #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [5]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_bool (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_u64 :: inline (stream : Stream) -> value : u64 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [20]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_u64 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_u32 :: inline (stream : Stream) -> value : u32 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [10]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_u32 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_u16 :: inline (stream : Stream) -> value : u16 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [5]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_u16 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_u8 :: inline (stream : Stream) -> value : u8 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [3]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_u8 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_s64 :: inline (stream : Stream) -> value : s64 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [20]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_s64 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_s32 :: inline (stream : Stream) -> value : s32 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [11]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_s32 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_s16 :: inline (stream : Stream) -> value : s16 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [6]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_s16 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_s8 :: inline (stream : Stream) -> value : s8 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [4]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_s8 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_f32 :: inline (stream : Stream) -> value : f32 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [500]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_f32 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}

parse_f64 :: inline (stream : Stream) -> value : f64 #must, bytes_read : s64, conv_err : strconv.Error, stream_err : Error
{
	buff : [500]u8 = ---;
	size, stream_err := read (stream, buff.data, buff.count);
	value, bytes, conv_err := strconv.parse_f64 (str.make (buff.data, size));
	seek (stream, bytes - size, .CURRENT);
	return value, bytes, conv_err, stream_err;
}
