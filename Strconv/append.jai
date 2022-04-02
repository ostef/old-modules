BINARY_BASE            :: "01";
OCTAL_BASE             :: "01234567";
DECIMAL_BASE           :: "0123456789";
HEXADECIMAL_BASE       :: "0123456789abcdef";
UPPER_HEXADECIMAL_BASE :: "0123456789ABCDEF";

append_bool :: inline (buff : []u8, val : bool) -> string, []u8
#no_context
{
	res_buff : []u8 = ---;
	if val
		res_buff = mem.copy (buff, str.to_array ("true"));
	else
		res_buff = mem.copy (buff, str.to_array ("false"));
	return str.from_array (res_buff), mem.advance (buff, res_buff.count);
}

append_u64 :: inline (buff : []u8, val : u64, $$base := DECIMAL_BASE) -> string, []u8
#no_context
#no_abc
{
	n := 0;
	tmp := val;
	while tmp > 0 || n == 0
	{
		tmp /= cast (u64) base.count;
		n += 1;
	}
	for < i : n - 1..0
	{
		if i < buff.count
			buff[i] = base[val % cast (u64) base.count];
		val /= cast (u64) base.count;
	}

	return str.from_array (mem.slice (buff, n)), mem.advance (buff, n);
}

append_s64 :: inline (buff : []u8, val : s64, $$base := DECIMAL_BASE) -> string, []u8
#no_context
#no_abc
{
	uval := cast, no_check (u64) val;
	n := 0;
	if val < 0
	{
		if buff.count > 0
			buff[n] = #char "-";
		uval = cast, no_check (u64) -val;
		n += 1;
	}
	s, res_buff := append_u64 (mem.advance (buff, n), uval, base);
	s.data  -= n;
	s.count += n;

	return s, res_buff;
}

append_f64 :: inline (buff : []u8, val : f64, precision : u32 = 6) -> string, []u8
#no_context
{
	if precision > 16
		precision = 16;
	ryu_fmt : ryu.Format;
	ryu_fmt.precision = precision;
	ryu_fmt.flags |= .REMOVE_TRAILING_ZEROES;
	temp_buffer : [500]u8 = ---;
	len := ryu.f64_to_fixed_buffered (val, ryu_fmt, temp_buffer.data);
	res_buff := mem.copy (buff, mem.make_array (temp_buffer.data, len));

	return str.from_array (res_buff), mem.advance (buff, res_buff.count);
}
