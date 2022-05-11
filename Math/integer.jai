 S8_MIN ::                       -128;
 S8_MAX ::                        127;
 U8_MAX ::                        255;
S16_MIN ::                    -32_768;
S16_MAX ::                     32_767;
U16_MAX ::                     65_535;
S32_MIN ::             -2_147_483_648;
S32_MAX ::              2_147_483_647;
U32_MAX ::              4_294_967_295;
S64_MIN :: -9_223_372_036_854_775_808;
S64_MAX ::  9_223_372_036_854_775_807;
U64_MAX :: 18_446_744_073_709_551_615;

decimal_length :: inline (value : $T, $$base : u64 = 10) -> s64 #must
#no_context
{
	unsigned_value : u64;
	if value < 0
		unsigned_value = cast (u64) -value;
	else
		unsigned_value = cast (u64) value;
	length := 0;
	while unsigned_value > 0 || length == 0
	{
		unsigned_value /= base;
		length += 1;
	}
	if value < 0 then length += 1;

	return length;
}

next_power_of_two :: inline (x : s64) -> s64 #must
#no_context
{
	contextless_assert (x > 0, "Invalid x.");
	p := 1;
	while x > p
		p += p;
	return p;
}
