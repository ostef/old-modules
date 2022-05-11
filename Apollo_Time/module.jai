// Custom implementation of Apollo_Time, from Basic/Apollo_Time (Jai version 0.1.015)

#scope_module

#import "Runtime";
mem  :: #import "Memory";
log  :: #import "Log";
math :: #import "Math";
#import "Math/Int128";

#scope_export

#load "calendar.jai";
#if OS == .WINDOWS
	#load "win32.jai";

// 10**-15 seconds resolution
Apollo_Time :: s128;

INVALID_TIME :: Apollo_Time.{ 0x8000_0000_0000_0000, 0 };
FEMTOSECONDS :: 1_000_000_000_000_000;

from_seconds :: inline (sec : s64) -> Apollo_Time #must
{
	return mul (sec, 1_000_000_000_000_000);
}

from_milliseconds :: inline (milli : s64) -> Apollo_Time #must
{
	return mul (milli, 1_000_000_000_000);
}

from_microseconds :: inline (micro : s64) -> Apollo_Time #must
{
	return mul (micro, 1_000_000_000);
}

from_nanoseconds :: inline (nano : s64) -> Apollo_Time #must
{
	return mul (nano, 1_000_000);
}

to_seconds :: inline (t : Apollo_Time) -> s64 #must
{
	return to_s64 (t / 1_000_000_000_000_000);
}

to_milliseconds :: inline (t : Apollo_Time) -> s64 #must
{
	return to_s64 (t / 1_000_000_000_000);
}

to_microseconds :: inline (t : Apollo_Time) -> s64 #must
{
	return to_s64 (t / 1_000_000_000);
}

to_nanoseconds :: inline (t : Apollo_Time) -> s64 #must
{
	return to_s64 (t / 1_000_000);
}

to_float_seconds :: inline (t : Apollo_Time) -> f64 #must
{
	// @Incomplete @Robustness:
	// Not sure what the best strategy is here. We probably should manually convert,
	// like we do in to_apollo(), but
	// as an intermediate low-effort thing I am going to convert each word separately to
	// f64 and then add them.

	a := t;
	if t.high < 0 then a = -a;  // Do this on a positive number and re-negate at the end.
	seconds := to_seconds (a); // @Robustness: Note that our 'seconds' is signed which means we are missing 1 bit of range.
	f := cast (f64) seconds;
	b := from_seconds (seconds);
	femto := a - b;
	assert (femto.high == 0);
	f_femto := femto.low / cast (f64) FEMTOSECONDS;
	f += f_femto;
	if t.high < 0
		return -f;
	return f;
}

from_float_seconds :: inline (sec : f64) -> Apollo_Time #must
{
	MANTISSA_BITS     :: 52;
	MANTISSA_HIGH_BIT :: 1 << MANTISSA_BITS;
	SIGN_BIT          :: 0x8000_0000_0000_0000;
	EXPONENT_MASK     :: 0x7ff0_0000_0000_0000;

	i64 := <<cast (*u64) *sec;
	exponent := cast (s16) ((i64 & EXPONENT_MASK) >> 52);
	exponent -= 1023;
	exponent -= MANTISSA_BITS;	// Not treating this as a decimal, just an integer.

	mantissa := (i64 & (MANTISSA_HIGH_BIT - 1)) | MANTISSA_HIGH_BIT;
	if !mantissa
		return .{};

	a := from_seconds (xx mantissa);	// In the current format, seconds start in the low word, so we know we have more than the mantissa size available.
	shift := exponent;
	if shift < 0
	{
		shift = -shift;
		if shift > 255
			return .{};
		a >>= cast (u8) shift;
	}
	else if shift
	{
		if shift > 255
			return .{};
		a <<= cast (u8) shift;
	}

	return a;
}
