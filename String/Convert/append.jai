BINARY_BASE            :: "01";
OCTAL_BASE             :: "01234567";
DECIMAL_BASE           :: "0123456789";
HEXADECIMAL_BASE       :: "0123456789abcdef";
UPPER_HEXADECIMAL_BASE :: "0123456789ABCDEF";

append_bool :: inline (buff : []u8, val : bool) -> string, s64, Error
#no_context
{
	if buff.count == 0
		return "", 0, .BUFFER_TOO_SMALL;

	if val
	{
		n := mem.copy (buff, str.to_array ("true"));
		err : Error;
		if n < "true".count
			err = .BUFFER_TOO_SMALL;

		return str.from_array (mem.slice (buff, "true".count)), n, err;
	}

	n := mem.copy (buff, str.to_array ("false"));
	err : Error;
	if n < "false".count
		err = .BUFFER_TOO_SMALL;

	return str.from_array (mem.slice (buff, "false".count)), n, err;
}

append_u64 :: inline (buff : []u8, val : u64, $$base := DECIMAL_BASE) -> string, s64, Error
#no_context
#no_abc
{
	if buff.count == 0
		return "", 0, .BUFFER_TOO_SMALL;

	err : Error;
	n := 0;
	tmp := val;

	while tmp > 0 || n == 0
	{
		tmp /= cast (u64) base.count;
		n += 1;
	}

	if buff.count < n
		err = .BUFFER_TOO_SMALL;

	for < i : n - 1..0
	{
		if i < buff.count
			buff[i] = base[val % cast (u64) base.count];

		val /= cast (u64) base.count;
	}

	return str.from_array (mem.slice (buff, n)), n, err;
}

append_s64 :: inline (buff : []u8, val : s64, $$base := DECIMAL_BASE) -> string, s64, Error
#no_context
#no_abc
{
	if buff.count == 0
		return "", 0, .BUFFER_TOO_SMALL;
	
	uval := cast, no_check (u64) val;
	n := 0;
	
	if val < 0
	{
		if buff.count > 0
			buff[n] = #char "-";

		uval = cast, no_check (u64) -val;
		n += 1;
	}
	
	s, un, err := append_u64 (mem.advance (buff, n), uval, base);
	s.data  -= n;
	s.count += n;

	return s, n + un, err;
}

append_f64 :: inline (buff : []u8, val : f64, precision : u32 = 6) -> string, s64, Error
#no_context
{
	if buff.count == 0
		return "", 0, .BUFFER_TOO_SMALL;

	if precision > 16
		precision = 16;

	ryu_fmt : ryu.Format;
	ryu_fmt.precision = precision;
	ryu_fmt.flags |= .REMOVE_TRAILING_ZEROES;
	temp_buffer : [500]u8 = ---;
	len := ryu.f64_to_fixed_buffered (val, ryu_fmt, temp_buffer.data);
	n := mem.copy (buff, mem.make_array (temp_buffer.data, len));
	err := ifx n < len then Error.BUFFER_TOO_SMALL else Error.OK;

	return str.from_array (mem.slice (buff, n)), n, err;
}
