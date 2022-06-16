parse_bool :: inline (s : string) -> value : bool #must, bytes_read : s64, Error
#no_context
{
	if str.starts_with (s, "true")
		return true, "true".count, .OK;
	if str.starts_with (s, "false")
		return false, "false".count, .OK;
	return false, 0, .MALFORMED_INPUT;
}

parse_u64 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : u64 #must, bytes_read : s64, Error
#no_context
{
	get_digit :: (char : u8, $base : string, $case_sensitive : bool) -> s64 #must
	#no_context
	{
		for i : 0..base.count - 1
		{
			if base[i] == char
				return i;
			#if !case_sensitive
			{
				if str.to_lower (base[i]) == str.to_lower (char)
					return i;
			}
		}
		return -1;
	}

	will_overflow :: inline (value : u64, digit : u64, $base : string) -> bool #must
	#no_context
	{
		if value > math.U64_MAX / base.count
			return true;
		if value == math.U64_MAX / base.count && digit > math.U64_MAX % cast (u64) base.count
			return true;
		return false;
	}
	
	if s.count <= 0 || get_digit (s[0], base, case_sensitive) < 0
		return 0, 0, .MALFORMED_INPUT;
	err := Error.OK;
	i := 0;
	value : u64;
	while i < s.count
	{
		digit := get_digit (s[i], base, case_sensitive);
		if digit < 0
			break;
		if err != .OVERFLOW && will_overflow (value, cast (u64) digit, base)
			err = .OVERFLOW;
		value *= base.count;
		value += cast (u64) digit;
		i += 1;
	}

	return value, i, err;
}

parse_u32 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : u32 #must, bytes_read : s64, Error
#no_context
{
	val, read, err := parse_u64 (s, base, case_sensitive);
	if val > math.U32_MAX
		err = .OVERFLOW;
	return cast, no_check (u32) val, read, err;
}

parse_u16 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : u16 #must, bytes_read : s64, Error
#no_context
{
	val, read, err := parse_u64 (s, base, case_sensitive);
	if val > math.U16_MAX
		err = .OVERFLOW;
	return cast, no_check (u16) val, read, err;
}

parse_u8 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : u8 #must, bytes_read : s64, Error
#no_context
{
	val, read, err := parse_u64 (s, base, case_sensitive);
	if val > math.U8_MAX
		err = .OVERFLOW;
	return cast, no_check (u8) val, read, err;
}

parse_s64 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : s64 #must, bytes_read : s64, Error
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
	unsigned_value, bytes_read, err := parse_u64 (str.advance (s, i), base, case_sensitive);
	if bytes_read == 0 then return 0, 0, err;
	signed_value := sign * cast (s64) unsigned_value;
	if err == .OVERFLOW && sign < 0
		err = .UNDERFLOW;

	return signed_value, i + bytes_read, err;
}

parse_s32 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : s32 #must, bytes_read : s64, Error
#no_context
{
	val, read, err := parse_s64 (s, base, case_sensitive);
	if val < math.S32_MIN
		err = .UNDERFLOW;
	else if val > math.S32_MAX
		err = .OVERFLOW;
	return cast, no_check (s32) val, read, err;
}

parse_s16 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : s16 #must, bytes_read : s64, Error
#no_context
{
	val, read, err := parse_s64 (s, base, case_sensitive);
	if val < math.S16_MIN
		err = .UNDERFLOW;
	else if val > math.S16_MAX
		err = .OVERFLOW;
	return cast, no_check (s16) val, read, err;
}

parse_s8 :: inline (s : string, $base := DECIMAL_BASE, $case_sensitive := false) -> value : s8 #must, bytes_read : s64, Error
#no_context
{
	val, read, err := parse_s64 (s, base, case_sensitive);
	if val < math.S8_MIN
		err = .UNDERFLOW;
	else if val > math.S8_MAX
		err = .OVERFLOW;
	return cast, no_check (s8) val, read, err;
}

parse_f32 :: inline (s : string) -> value : f32 #must, bytes_read : s64, Error
#no_context
{
	value, status, bytes_read := ryu.string_to_f32 (s);
	if status == .MALFORMED_INPUT
		return 0.0, 0, .MALFORMED_INPUT;
	else if status == .INPUT_TOO_LONG
		return 0.0, 0, .OVERFLOW;
	return value, bytes_read, .OK;
}

parse_f64 :: inline (s : string) -> value : f64 #must, bytes_read : s64, Error
#no_context
{
	value, status, bytes_read := ryu.string_to_f64 (s);
	if status == .MALFORMED_INPUT
		return 0.0, 0, .MALFORMED_INPUT;
	else if status == .INPUT_TOO_LONG
		return 0.0, 0, .OVERFLOW;
	return value, bytes_read, .OK;
}
