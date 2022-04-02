// Implementation of Apollo_Time, that does not depend on Basic
// Version 0.1.015
// nocheckin: this probably should not be made public, since
// it is from the compiler modules!

#scope_module

#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
log  :: #import "Log";

#scope_export

#load "calendar.jai";
#if OS == .WINDOWS
	#load "win32.jai";

// 10**-15 seconds
Apollo_Time :: struct
{
	low : u64;
	high : s64;
}

INVALID_TIME :: Apollo_Time.{ 0, 0x8000_0000_0000_0000 };
FEMTOSECONDS :: 1_000_000_000_000_000;

operator + :: inline (a : Apollo_Time, b : Apollo_Time) -> Apollo_Time #must
{
	c : Apollo_Time = ---;
	p := *c;
	#asm
	{
		mov a_low:,  [a + 0];
		mov a_high:, [a + 8];

		mov b_low:,  [b + 0];
		mov b_high:, [b + 8];

		mov [p + 0], a_low;
		mov [p + 8], a_high;

		add [p + 0], b_low;
		adc [p + 8], b_high;
	}

	return c;
}

operator - :: inline (a : Apollo_Time, b : Apollo_Time) -> Apollo_Time #must
{
	c : Apollo_Time = ---;
	p := *c;
	#asm
	{
		mov a_low:,  [a + 0];
		mov a_high:, [a + 8];

		mov b_low:,  [b + 0];
		mov b_high:, [b + 8];

		mov [p + 0], a_low;
		mov [p + 8], a_high;

		sub [p + 0], b_low;
		sbb [p + 8], b_high;
	}

	return c;
}

operator - :: inline (a : Apollo_Time) -> Apollo_Time #must
{
	// Negation of two's complement is ~val + 1
	c : Apollo_Time = ---;
	c.low  = ~a.low;
	c.high = ~a.high;
	p := *c;
	#asm
	{
		add [p + 0], 1;
		adc [p + 8], 0;
	}

	return c;
}

operator << :: inline (a : Apollo_Time, x : u8) -> Apollo_Time #must
{
	c := a;
	p := *c;
	#asm
	{
		x === c;
		mov low:, [p + 0];
		shld [p + 8], low, x;
		shl  [p + 0], x;
	}

	return c;
}

operator >> :: inline (a : Apollo_Time, x : u8) -> Apollo_Time #must
{
	c := a;
	p := *c;
	#asm
	{
		x === c;
		mov high:, [p + 8];
		shrd [p + 0], high, x;
		sar  [p + 8], x;
	}

	return c;
}

//
// The sign handling in these operator * below is a little uncertain given
// that I don't really understand the difference between imul and mul.
// @Incomplete: Consult Hacker's Delight.
//
operator * :: (_a: Apollo_Time, _b: Apollo_Time) -> Apollo_Time {
	a := _a; // @Speed @Temporary
	b := _b;
	
	negate := false;
	if a.high < 0 {
		a = -a;
		negate = true;
	}

	if b.high < 0 {
		b = -b;
		negate = !negate;
	}

	pa := *a;
	pb := *b;

	result: Apollo_Time = ---;
	r := *result;

	// The code below is really convoluted because I am not sure if we can
	// bind multiple names to the same physical register? Would really like to.
	#asm {
		result_high: gpr === d;
		result_low:  gpr === a;

		factor:   gpr;
		high_sum: gpr;
		
		// Low times low:
		mov result_low, [pa + 0];  // This is input as well as result.
		mov factor,     [pb + 0];
		
		mul result_high, result_low, factor;

		mov [r + 0],  result_low;   // Store the low part.
		mov high_sum, result_high;  // Store the high part.

		// High a times low b. 'factor' still holds low b.
		mov result_low, [pa + 8];
		imul result_high, result_low, factor;
		add high_sum, result_low;
		
		// Low a times high b.
		mov result_low, [pa + 0];
		mov factor,     [pb + 8];
		imul result_high, result_low, factor;
		add high_sum, result_low;
		
		// High a times high b is discarded.

		mov [r + 8], high_sum;
	}

	if negate return -result;
	else      return result;
}

operator * :: (a: Apollo_Time, factor: s64) -> Apollo_Time {
	at := a; // @Speed @Temporary

	negate := false;
	if at.high < 0 {
		at = -at;
		negate = true;
	}

	if factor < 0 {
		factor = -factor;
		negate = !negate;
	}
	
	p := *at;
	
	result: Apollo_Time = ---;
	r := *result;
	
	// We would like to be able to bind multiple names to the same machine register
	// to make code like the following less confusing.
	#asm {
		result_high: gpr === d;
		result_low:  gpr === a;

		mov result_low, [p + 0];  // This is input as well as result.
		mul result_high, result_low, factor;

		mov [r + 0], result_low;
		
		mov carry:, result_high;
		
		mov result_low, [p + 8];  // This is input as well as result.
		imul result_high, result_low, factor;

		add result_low, carry;

		mov [r + 8], result_low;  // This is actually the high.
	}

	if negate return -result;
	else      return result;
}

operator == :: (a: Apollo_Time, b: Apollo_Time) -> bool {
	return (a.low == b.low) && (a.high == b.high);
}

operator < :: (a: Apollo_Time, b: Apollo_Time) -> bool {
	result: bool = ---;
	
	#asm {
		mov a_low:,  [a + 0];
		mov a_high:, [a + 8];

		mov b_low:,  [b + 0];
		mov b_high:, [b + 8];

		sub a_low,  b_low;
		sbb a_high, b_high;

		setl  result;
	}

	return result;
}

operator <= :: (a: Apollo_Time, b: Apollo_Time) -> bool {
	// We would like the compiler to generate this for us, probably, like it does with +=.
	return (a == b) || (a < b);  // Probably not very efficient.
}

operator > :: (a: Apollo_Time, b: Apollo_Time) -> bool {
	// We would like the compiler to generate this for us, probably, like it does with +=.
	return !(a <= b);
}

operator >= :: (a: Apollo_Time, b: Apollo_Time) -> bool {
	// We would like the compiler to generate this for us, probably, like it does with +=.
	return !(a < b);
}

logical_shift_right :: inline (a : Apollo_Time, x : u8) -> Apollo_Time #must
{
	c := a;
	p := *c;
	#asm
	{
		x === c;
		mov high:, [p + 8];
		shrd [p + 0], high, x;
		shr  [p + 8], x;
	}

	return c;
}

unsigned_divide :: (u : Apollo_Time, v : Apollo_Time) -> Apollo_Time #must
{
	// Code adapted from Hacker's Delight by Henry S. Warren, Jr., Second Edition, section 9-5.
	// That listing was for 64-bit division, but here we do 128-bit division.

	divu_ff :: inline (a : Apollo_Time, d : u64) -> u64 #must
	{
		_a := a;
		p := *_a;
		quotient : u64 = ---;
		#asm
		{
			high : gpr === d;
			low  : gpr === a;
			
			mov low,  [p + 0];
			mov high, [p + 8];
			div high, low, d;

			mov quotient, low;
		}

		return quotient;
	}

	if v.high == 0
	{
		u1 := cast, no_check (u64) u.high;
		d  := v.low;
		if u1 < d
		{
			result : Apollo_Time = ---;
			result.high = 0;
			result.low  = divu_ff (u, d);

			return result;
		}
		else	// Overflow
		{
			u0 := u.low;
			q1 := u1 / d;
			k  := u1 - q1 * d;

			c : Apollo_Time = ---;
			c.high = cast, no_check (s64) k;
			c.low  = u0;

			q0 := divu_ff (c, d);

			result : Apollo_Time = ---;
			result.high = cast, no_check (s64) q1;
			result.low  = q0;

			return result;
		}
	}

	result : s64 = ---;
	input := v.high;
	#asm { lzcnt result, input; }
	n := cast, no_check (u8) result;
	h := cast (u64) v.high;

	_v1 := v << n;
	v1 := cast, no_check (u32) _v1.high;
	// Right-shift u by 1 bit, to ensure no overflow.
	u1 := logical_shift_right (u, 1);
	q1 := divu_ff (u1, v1);
	// Undo normalization and division of u by 2.
	_q1 : Apollo_Time;
	_q1.low = q1;
	q0 := logical_shift_right (_q1 << n, 31);

	// Make q0 correct or too small by 1.
	if q0.high || q0.low
	{
		if q0.low == 0
		{
			q0.low  -= 1;
			q0.high -= 1;
		}
		else
		{
			q0.low -= 1;
		}
	}

	if u - q0 * v >= v
	{
		q0.low += 1;
		if q0.low == 0
			q0.high += 1;
	}

	return q0;
}

operator / :: inline (num : Apollo_Time, denom : Apollo_Time) -> Apollo_Time #must
{
	u := num;
	v := denom;
	neg := false;
	if u.high < 0
	{
		neg = true;
		u = -u;
	}
	if v.high < 0
	{
		neg = !neg;
		v = -v;
	}
	result := unsigned_divide (u, v);

	return ifx neg then -result else result;;
}

operator / :: inline (a : Apollo_Time, factor : s64) -> Apollo_Time #must
{
	b : Apollo_Time;
	b.low = cast, no_check (u64) factor;
	if factor < 0
		b.high = -1;
	
	return a / b;
}

compare :: inline (a : Apollo_Time, b : Apollo_Time) -> s32 #must
{
	if a < b
		return -1;
	if a > b
		return 1;
	return 0;
}

to_apollo :: (m : s64, factor : s64) -> Apollo_Time #must #expand
{
	result : Apollo_Time = ---;
	p := *result;
	#asm
	{
		high : gpr === d;
		low  : gpr === a;

		mov low, factor;
		imul high, low, m;

		mov [p + 0], low;
		mov [p + 8], high;
	}

	return result;
}

from_seconds :: inline (sec : s64) -> Apollo_Time #must
{
	return to_apollo (sec, 1_000_000_000_000_000);
}

from_milliseconds :: inline (milli : s64) -> Apollo_Time #must
{
	return to_apollo (milli, 1_000_000_000_000);
}

from_microseconds :: inline (micro : s64) -> Apollo_Time #must
{
	return to_apollo (micro, 1_000_000_000);
}

from_nanoseconds :: inline (nano : s64) -> Apollo_Time #must
{
	return to_apollo (nano, 1_000_000);
}

from_apollo :: (t : Apollo_Time, factor : s64, $round := true) -> s64 #must, bool #expand
{
	_t := t;
	p := *_t;  // We don't want to have to do these explicit pointer assignments, but I think #asm doesn't understand large values currently.
	
	ROUND :: factor / 2;
	
	result:  s64  = ---;
	fail_a := false;
	fail_b := false;
	
	#asm {
		high: gpr === d;
		low:  gpr === a;

		mov low,  [p + 0];
		mov high, [p + 8];

		idiv  high, low, factor;
		mov result, low;    // Quotient.

		// If high is nonzero, we overflowed.
		// (Do we actually need this? What does idiv do with flags?)
		test high, high;
		seto fail_a;
	}

	#if round
		#asm {
			add high, ROUND;  // See if we round up by adding to the remainder.
			adc result, 0;    // Carry into the quotient in order to round.
			// If this overflowed result, set success == false.

			seto  fail_b;
		}

	return result, !(fail_a || fail_b);
}

to_seconds :: inline (t : Apollo_Time) -> s64 #must, bool
{
	res, ok := from_apollo (t, 1_000_000_000_000_000);
	return res, ok;
}

to_milliseconds :: inline (t : Apollo_Time) -> s64 #must, bool
{
	res, ok := from_apollo (t, 1_000_000_000_000);
	return res, ok;
}

to_microseconds :: inline (t : Apollo_Time) -> s64 #must, bool
{
	res, ok := from_apollo (t, 1_000_000_000);
	return res, ok;
}

to_nanoseconds :: inline (t : Apollo_Time) -> s64 #must, bool
{
	res, ok := from_apollo (t, 1_000_000);
	return res, ok;
}

to_float_seconds :: inline (t : Apollo_Time) -> f64 #must, bool
{
	// @Incomplete @Robustness:
	// Not sure what the best strategy is here. We probably should manually convert,
	// like we do in to_apollo(), but
	// as an intermediate low-effort thing I am going to convert each word separately to
	// f64 and then add them.

	a := t;
	if t.high < 0  a = -a;  // Do this on a positive number and re-negate at the end.

	seconds, success := to_seconds(a); // @Robustness: Note that our 'seconds' is signed which means we are missing 1 bit of range.
	if !success return 0, false;

	f := cast(f64) seconds;

	b := from_seconds(seconds);
	femto := a - b;

	assert(femto.high == 0);
	f_femto := femto.low / cast(f64)FEMTOSECONDS;

	f += f_femto;

	if t.high < 0  f = -f;
	return f, true;
}

from_float_seconds :: inline (sec : f64) -> Apollo_Time #must
{
	MANTISSA_BITS   :: 52;
	SIGN_BIT        :: 0x8000_0000_0000_0000;
	EXPONENT_MASK   :: 0x7ff0_0000_0000_0000;

	i64 := << cast(*u64) *sec;
	exponent := cast(s16)((i64 & EXPONENT_MASK) >> 52);
	exponent -= 1023;
	exponent -= MANTISSA_BITS;  // Not treating this as a decimal, just an integer.

	MANTISSA_HIGH_BIT :: 1 << MANTISSA_BITS;
	mantissa := (i64 & (MANTISSA_HIGH_BIT-1)) | MANTISSA_HIGH_BIT;

	if !mantissa {
		a: Apollo_Time;
		return a;  // Zero.
	}

	a := from_seconds (xx mantissa);  // In the current format, seconds start in the low word, so we know we have more than the mantissa size available.

	shift := exponent;
	if shift < 0 {
		shift = -shift;
		if shift > 255 return .{};

		a >>= cast(u8)(shift);
	} else if shift {
		if shift > 255 return .{};
		a <<= cast(u8) shift;
	}

	return a;
}
