u128 :: struct
{
	high : u64;
	low  : u64;
}

make_u128 :: inline (low : u64) -> u128 #must
{
	result : u128 = ---;
	result.high = 0;
	result.low  = low;
	return result;
}

make_u128 :: inline (high : u64, low : u64) -> u128 #must
{
	result : u128 = ---;
	result.high = high;
	result.low = low;
	return result;
}

to_s128 :: inline (x : u128, $no_check := false) -> s128 #must
{
	result : s128 = ---;
	#if no_check
		result.high = cast, no_check (s64) x.high;
	else
		result.high = cast (s64) x.high;
	result.low = x.low;
	return result;
}

add :: inline (a : u128, b : u128) -> u128 #must
{
	result : u128 = ---;
	p := *result;
	#asm
	{
		mov	al:, [a + 0];
		mov	ah:, [a + 8];

		mov	bl:, [b + 0];
		mov	bh:, [b + 8];

		mov	[p + 0], al;
		mov	[p + 8], ah;

		add		[p + 0], bl;
		adc		[p + 8], bh;	// @Incomplete (stefan): Shouldn't we use ADCX instead ?
	}
	return result;
}

sub :: inline (a : u128, b : u128) -> u128 #must
{
	result : u128 = ---;
	p := *result;
	#asm
	{
		mov	al:, [a + 0];
		mov	ah:, [a + 8];

		mov	bl:, [b + 0];
		mov	bh:, [b + 8];

		mov	[p + 0], al;
		mov	[p + 8], ah;

		sub	[p + 0], bl;
		sbb	[p + 8], bh;
	}
	return result;
}

mul :: inline (left : u64, right : u64) -> u128 #must
{
	low := left;
	high : u64 = ---;
	#asm
	{
		right === c;
		low   === a;
		high  === d;
		mul	high, low, right;
	}

	return make_u128 (high, low);
}

mul :: inline (a : u128, b : u128) -> u128 #must
{
	// For a = 2^64 * ah + al, b = 2^64 * bh + bl:
	// c = a * b = 2^128 * ah * bh + 2^64 * ah * bl + 2^64 * bh * al + al * bl
	// c = (ah * bh) << 128 + (ah * bl) << 64 + (bh * al) << 64 + (al * bl)
	// We discard the first ah * bh multiplication, since it goes above the
	// 128-bit boundary:
	// cl = (al * bl).low
	// ch = (al * bl).high + (ah * bl).low + (bh * al).low
	result : u128 = ---;
	r  := *result;
	tmp_a := a;
	tmp_b := b;
	pa := *tmp_a;
	pb := *tmp_b;
	#asm
	{
		mul_low  : gpr === a;	// First and low destination operand of mul
		mul_high : gpr === d;	// High destination operand of mul
		mul_op2  : gpr;			// Second operand of mul
		high_sum : gpr;
		// a.low * b.low
		mov	mul_low, [pa + 0];
		mov	mul_op2, [pb + 0];
		mul	mul_high, mul_low, mul_op2;	// mul gpr.d, gpr.a, gpr
		// Store the low part of the mul into result, high part into high_sum
		mov	[r + 0],  mul_low;
		mov	high_sum, mul_high;
		// a.high * b.low
		mov	mul_low, [pa + 8];	// Store a.high into the first operand mul_low
		mul	mul_high, mul_low, mul_op2;	// At this point: mul_op2 = b.low
		add	high_sum, mul_low;
		// a.low * b.high
		mov	mul_low, [pa + 0];
		mov	mul_op2, [pb + 8];
		mul	mul_high, mul_low, mul_op2;
		add	high_sum, mul_low;
		// Store the high part in the result
		mov	[r + 8], high_sum;
	}
	return result;
}

mul :: inline (a : u128, b : u64) -> u128 #must
{
	// For a = 2^64 * ah + al, b a 64-bit unsigned integer:
	// c = a * b = 2^64 * ah * b + al * b
	// c = (ah * b) << 64 + (al * b)
	// cl = (al * b).low
	// ch = (al * b).high + (ah * b).low
	result : u128 = ---;
	r := *result;
	tmp_a := a;
	pa := *tmp_a;
	#asm
	{
		mul_low  : gpr === a;	// First and low destination operand of mul
		mul_high : gpr === d;	// High destination operand of mul
		high_sum : gpr;
		// a.low * b.low
		mov	mul_low, [pa + 0];
		mul	mul_high, mul_low, b;
		// Store the low part of the mul into result, high part into high_sum
		mov	[r + 0],  mul_low;
		mov	high_sum, mul_high;
		// a.high * b.low
		mov	mul_low, [pa + 8];	// Store a.high into the first operand mul_low
		mul	mul_high, mul_low, b;
		add	high_sum, mul_low;
		// Store the high part in the result
		mov	[r + 8], high_sum;
	}
	return result;
}

div :: inline (a : u128, b : u128) -> u128 #must
{
	// Code adapted from Hacker's Delight by Henry S. Warren, Jr., Second Edition, section 9-5.
	// That listing was for 64-bit division, but here we do 128-bit division.

	div128_64 :: inline (a : u128, b : u64) -> u64 #must
	{
		// On x86_64, the div instruction allows a 128-bit dividend to be
		// divided by a 64-bit divisor, resulting in a 64-bit quotient.
		dividend := a;
		p := *dividend;
		quotient : u64 = ---;
		#asm
		{
			high : gpr === d;
			low  : gpr === a;

			mov	low,  [p + 0];
			mov	high, [p + 8];
			div	high, low, b;
			mov	quotient, low;
		}

		return quotient;
	}

	// Simple 128-bit by 64-bit division 
	if b.high == 0
	{
		// Easy case: no overflow. 64-bits is enough to store the quotient
		if a.high < b.low
			return make_u128 (div128_64 (a, b.low));
		q1 := a.high / b.low;
		k  := a.high - q1 * b.low;
		q0 := div128_64 (make_u128 (k, a.low), b.low);

		return make_u128 (q1, q0);
	}

	result : u64 = ---;
	input := b.high;
	#asm { lzcnt	result, input; }
	n := cast, no_check (u8) result;
	h := cast (u64) b.high;

	b1 := cast, no_check (u32) (b << n).high;
	// Right-shift a by 1 to ensure no overflow.
	q1 := make_u128 (div128_64 (a >> 1, b1));
	// Undo normalization and division of dividend by 2
	q0 := (q1 << n) >> 31;
	if q0.high || q0.low
	{
		if q0.low == 0
			q0.high -= 1;
		q0.low -= 1;
	}
	if a - q0 * b >= b
	{
		q0.low += 1;
		if q0.low == 0
			q0.high += 1;
	}

	return q0;
}

lshift :: inline (a : u128, x : u8) -> u128 #must
{
	result := a;
	p := *result;
	#asm
	{
		x === c;
		mov		low:, [p + 0];
		shld	[p + 8], low, x;
		shl		[p + 0], x;
	}
	return result;
}

rshift :: inline (a : u128, x : u8) -> u128 #must
{
	result := a;
	p := *result;
	#asm
	{
		x === c;
		mov		high:, [p + 8];
		shrd	[p + 0], high, x;
		shr		[p + 8], x;
	}
	return result;
}

operator + :: inline (a : u128, b : u128) -> u128 #must
{
	return add (a, b);
}

operator - :: inline (a : u128, b : u128) -> u128 #must
{
	return sub (a, b);
}

operator * :: inline (a : u128, b : u128) -> u128 #must
{
	return mul (a, b);
}

operator / :: inline (a : u128, b : u128) -> u128 #must
{
	return div (a, b);
}

operator << :: inline (a : u128, x : u8) -> u128 #must
{
	return lshift (a, x);
}

operator >> :: inline (a : u128, x : u8) -> u128 #must
{
	return rshift (a, x);
}

operator == :: inline (a : u128, b : u128) -> bool #must
{
	return a.low == b.low && a.high == b.high;
}

operator < :: inline (a : u128, b : u128) -> bool #must
{
	result : bool = ---;
	#asm
	{
		mov		al:, [a + 0];
		mov		ah:, [a + 8];
		mov		bl:, [b + 0];
		mov		bh:, [b + 8];
		sub		al, bl;
		sbb		ah, bh;
		setl	result;
	}
	return result;
}

operator <= :: inline (a : u128, b : u128) -> bool #must
{
	return a < b || a == b;
}

operator > :: inline (a : u128, b : u128) -> bool #must
{
	return !(a <= b);
}

operator >= :: inline (a : u128, b : u128) -> bool #must
{
	return !(a < b);
}
