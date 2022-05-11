F32_MIN :: 0h0080_0000;
F32_MAX :: 0h7f7f_ffff;
F32_MIN_SUBNORMAL :: 0h0000_0001;
F32_MAX_SUBNORMAL :: 0h007f_ffff;
F32_POSITIVE_INFINITY :: 0h7f80_0000;
F32_NEGATIVE_INFINITY :: 0hff80_0000;
F32_NAN :: 0h7fc0_0000;
F32_EPSILON :: 0h3400_0000;

F32_MANTISSA_BITS :: 23;
F32_EXPONENT_BITS :: 8;
F32_EXPONENT_BIAS :: 127;

F64_MIN :: 0h0010_0000_0000_0000;
F64_MAX :: 0h7fef_ffff_ffff_ffff;
F64_MIN_SUBNORMAL :: 0h0000_0000_0000_0001;
F64_MAX_SUBNORMAL :: 0h000f_ffff_ffff_ffff;
F64_POSITIVE_INFINITY :: 0h7ff0_0000_0000_0000;
F64_NEGATIVE_INFINITY :: 0hfff0_0000_0000_0000;
F64_NAN :: 0h7ff8_0000_0000_0000;
F64_EPSILON :: 0h3cb0_0000_0000_0000;

F64_MANTISSA_BITS :: 52;
F64_EXPONENT_BITS :: 11;
F64_EXPONENT_BIAS :: 1023;

PI    : f32 : 3.1415927;
PI64  : f64 : 3.141592653589793;

ieee_decompose :: inline (f : f32) -> sign : bool, exponent : u64, mantissa : u64
#no_context
{
	as_u32 := <<cast (*u32) *f;
	sign     := ((as_u32 >> (F32_MANTISSA_BITS + F32_EXPONENT_BITS)) & 1) != 0;
	exponent := ((as_u32 >> F32_MANTISSA_BITS) & ((1 << F32_EXPONENT_BITS) - 1));
	mantissa := as_u32 & ((1 << F32_MANTISSA_BITS) - 1);

	return sign, exponent, mantissa;
}

ieee_decompose :: inline (f : f64) -> sign : bool, exponent : u64, mantissa : u64
#no_context
{
	as_u64 := <<cast (*u64) *f;
	sign     := ((as_u64 >> (F64_MANTISSA_BITS + F64_EXPONENT_BITS)) & 1) != 0;
	exponent := ((as_u64 >> F64_MANTISSA_BITS) & ((1 << F64_EXPONENT_BITS) - 1));
	mantissa := as_u64 & ((1 << F64_MANTISSA_BITS) - 1);

	return sign, exponent, mantissa;
}

is_nan :: inline (f : f64) -> bool #must
#no_context
{
	s, e, m := ieee_decompose (f);

	return e == ((1 << F64_EXPONENT_BITS) - 1) && m != 0;
}

is_inf :: inline (f : f64) -> bool #must
#no_context
{
	s, e, m := ieee_decompose (f);

	return e == ((1 << F64_EXPONENT_BITS) - 1) && m == 0;
}

is_nan :: inline (f : f32) -> bool #must
#no_context
{
	s, e, m := ieee_decompose (f);

	return e == ((1 << F32_EXPONENT_BITS) - 1) && m != 0;
}

is_inf :: inline (f : f32) -> bool #must
#no_context
{
	s, e, m := ieee_decompose (f);

	return e == ((1 << F32_EXPONENT_BITS) - 1) && m == 0;
}
