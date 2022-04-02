Result :: enum
{
	OK;
	MALFORMED_INPUT;
	OVERFLOW;
	UNDERFLOW;
}

parse_bool :: inline (s : string) -> value : bool #must, bytes_read : s64, result : Result
#no_context
{
	if str.starts_with (s, "true")
		return true, "true".count, .OK;
	if str.starts_with (s, "false")
		return false, "false".count, .OK;
	return false, 0, .MALFORMED_INPUT;
}

parse_u64 :: inline (s : string) -> value : u64 #must, bytes_read : s64, result : Result
#no_context
{
	will_overflow :: inline (value : u64, digit : u64) -> bool #must
	#no_context
	{
		if value > math.U64_MAX / 10
			return true;
		if value == math.U64_MAX / 10 && digit > math.U64_MAX % cast (u64) 10
			return true;
		return false;
	}
	
	if s.count <= 0 || !str.is_digit (s[0])
		return 0, 0, .MALFORMED_INPUT;
	result := Result.OK;
	i := 0;
	value : u64;
	while i < s.count && str.is_digit (s[i])
	{
		digit := cast (u64) s[i] - #char "0";
		if result != .OVERFLOW && will_overflow (value, digit)
			result = .OVERFLOW;
		value *= 10;
		value += digit;
		i += 1;
	}

	return value, i, result;
}

parse_u32 :: inline (s : string) -> value : u32 #must, bytes_read : s64, result : Result
#no_context
{
	val, read, res := parse_u64 (s);
	if val > math.U32_MAX
		res = .OVERFLOW;

	return cast, no_check (u32) val, read, res;
}

parse_u16 :: inline (s : string) -> value : u16 #must, bytes_read : s64, result : Result
#no_context
{
	val, read, res := parse_u64 (s);
	if val > math.U16_MAX
		res = .OVERFLOW;

	return cast, no_check (u16) val, read, res;
}

parse_u8 :: inline (s : string) -> value : u8 #must, bytes_read : s64, result : Result
#no_context
{
	val, read, res := parse_u64 (s);
	if val > math.U8_MAX
		res = .OVERFLOW;

	return cast, no_check (u8) val, read, res;
}

parse_s64 :: inline (s : string) -> value : s64 #must, bytes_read : s64, result : Result
#no_context
{
	if s.count == 0 then return 0, 0, .MALFORMED_INPUT;

	i := 0;
	sign := 1;
	if s[0] == #char "-" || s[0] == #char "+"
	{
		sign = cast (s64) (s[0] == #char "+") * 2 - 1;
		i += 1;
	}
	unsigned_value, bytes_read, result := parse_u64 (str.advance (s, i));
	if bytes_read == 0 then return 0, 0, result;
	signed_value := sign * cast (s64) unsigned_value;

	return signed_value, i + bytes_read, result;
}

parse_s32 :: inline (s : string) -> value : s32 #must, bytes_read : s64, result : Result
#no_context
{
	val, read, res := parse_s64 (s);
	if val < math.S32_MIN
		res = .UNDERFLOW;
	else if val > math.S32_MAX
		res = .OVERFLOW;

	return cast, no_check (s32) val, read, res;
}

parse_s16 :: inline (s : string) -> value : s16 #must, bytes_read : s64, result : Result
#no_context
{
	val, read, res := parse_s64 (s);
	if val < math.S16_MIN
		res = .UNDERFLOW;
	else if val > math.S16_MAX
		res = .OVERFLOW;

	return cast, no_check (s16) val, read, res;
}

parse_s8 :: inline (s : string) -> value : s8 #must, bytes_read : s64, result : Result
#no_context
{
	val, read, res := parse_s64 (s);
	if val < math.S8_MIN
		res = .UNDERFLOW;
	else if val > math.S8_MAX
		res = .OVERFLOW;

	return cast, no_check (s8) val, read, res;
}

parse_f32 :: inline (s : string) -> value : f32 #must, bytes_read : s64, result : Result
#no_context
{
	value, status, bytes_read := ryu.string_to_f32 (s);
	if status == .MALFORMED_INPUT
		return 0.0, 0, .MALFORMED_INPUT;
	else if status == .INPUT_TOO_LONG
		return 0.0, 0, .OVERFLOW;

	return value, bytes_read, .OK;
}

parse_f64 :: inline (s : string) -> value : f64 #must, bytes_read : s64, result : Result
#no_context
{
	value, status, bytes_read := ryu.string_to_f64 (s);
	if status == .MALFORMED_INPUT
		return 0.0, 0, .MALFORMED_INPUT;
	else if status == .INPUT_TOO_LONG
		return 0.0, 0, .OVERFLOW;

	return value, bytes_read, .OK;
}
