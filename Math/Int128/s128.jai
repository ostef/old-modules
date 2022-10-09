s128 :: struct
{
	high : s64;
	low  : u64;

	#place high;
	uhigh : u64;
	#place high;
	as_u128 : u128;
}

S128_MIN :: s128.{ 0x8000_0000_0000_0000, 0x0000_0000_0000_0000 };
S128_MAX :: s128.{ 0x7fff_ffff_ffff_ffff, 0xffff_ffff_ffff_ffff };

make_s128 :: inline (x : s64) -> s128 #must
#no_context
{
	result : s128 = ---;
	if x < 0
	{
		result.high = -1;
		result.low  = cast (u64) -x;
	}
	else
	{
		result.high = 0;
		result.low  = cast (u64) x;
	}

	return result;
}

make_s128 :: inline (high : s64, low : u64) -> s128 #must
#no_context
{
	result : s128 = ---;
	result.high = high;
	result.low  = low;

	return result;
}

to_u128 :: inline (a : s128, $no_check := false) -> u128 #must
{
	result : u128 = ---;
	result.low = a.low;
	#if no_check
		result.high = cast, no_check (u64) a.high;
	else
		result.high = cast (u64) a.high;

	return result;
}

to_s64 :: inline (a : s128, $no_check := false) -> s64 #must
#no_context
{
	#if no_check
		if (a.low & 0x8000_0000_0000_0000) != 0 || (a.high & 0x0fff_ffff_ffff_ffff) != 0
			contextless_panic ("Cast from s128 to s64 bounds check failed.");

	return cast, no_check (s64) (a.low | cast, no_check (u64) (a.high & 0x8000_0000_0000_0000));
}

add :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	result : s128 = ---;
	p := *result;
	#asm
	{
		mov	al:, [a + 8];
		mov	ah:, [a + 0];

		mov	bl:, [b + 8];
		mov	bh:, [b + 0];

		mov	[p + 8], al;
		mov	[p + 0], ah;

		add	[p + 8], bl;
		adc	[p + 0], bh;
	}

	return result;
}

sub :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	result : s128 = ---;
	p := *result;
	#asm
	{
		mov	al:, [a + 8];
		mov	ah:, [a + 0];

		mov	bl:, [b + 8];
		mov	bh:, [b + 0];

		mov	[p + 8], al;
		mov	[p + 0], ah;

		sub	[p + 8], bl;
		sbb	[p + 0], bh;
	}

	return result;
}

neg :: inline (a : s128) -> s128 #must
#no_context
{
	result : s128 = ---;
	result.low  = ~a.low;
	result.high = ~a.high;
	p := *result;
	#asm
	{
		add	[p + 8], 1;
		adc	[p + 0], 0;
	}

	return result;
}

mul :: inline (left : s64, right : s64) -> s128 #must
#no_context
{
	low := cast, no_check (u64) left;
	high : s64 = ---;
	#asm
	{
		right === c;
		low   === a;
		high  === d;
		imul	high, low, right;
	}

	return make_s128 (high, low);
}

mul :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	mut_a := a;
	mut_b := b;
	negate := false;

	if mut_a.high < 0
	{
		mut_a = -mut_a;
		negate = true;
	}

	if mut_b.high < 0
	{
		mut_b = -mut_b;
		negate = !negate;
	}

	result : s128 = ---;
	r  := *result;
	tmp_a := mut_a;
	tmp_b := mut_b;
	pa := *tmp_a;
	pb := *tmp_b;

	#asm
	{
		mul_low  : gpr === a;	// First and low destination operand of mul
		mul_high : gpr === d;	// High destination operand of mul
		mul_op2  : gpr;			// Second operand of mul
		high_sum : gpr;
		// a.low * b.low
		mov		mul_low, [pa + 8];
		mov		mul_op2, [pb + 8];
		mul		mul_high, mul_low, mul_op2;	// mul gpr.d, gpr.a, gpr
		// Store the low part of the mul into result, high part into high_sum
		mov		[r + 8],  mul_low;
		mov		high_sum, mul_high;
		// a.high * b.low
		mov		mul_low, [pa + 0];	// Store a.high into the first operand mul_low
		imul	mul_high, mul_low, mul_op2;	// At this point: mul_op2 = b.low
		add		high_sum, mul_low;
		// a.low * b.high
		mov		mul_low, [pa + 8];
		mov		mul_op2, [pb + 0];
		imul	mul_high, mul_low, mul_op2;
		add		high_sum, mul_low;
		// Store the high part in the result
		mov		[r + 0], high_sum;
	}

	if negate
		return -result;

	return result;
}

mul :: inline (a : s128, b : s64) -> s128 #must
#no_context
{
	mut_a := a;
	negate := false;

	if mut_a.high < 0
	{
		mut_a = -mut_a;
		negate = true;
	}

	if b < 0
	{
		b = -b;
		negate = !negate;
	}

	// For a = 2^64 * ah + al, b a 64-bit unsigned integer:
	// c = a * b = 2^64 * ah * b + al * b
	// c = (ah * b) << 64 + (al * b)
	// cl = (al * b).low
	// ch = (al * b).high + (ah * b).low
	result : s128 = ---;
	r := *result;
	tmp_a := mut_a;
	pa := *tmp_a;
	#asm
	{
		mul_low  : gpr === a;	// First and low destination operand of mul
		mul_high : gpr === d;	// High destination operand of mul
		high_sum : gpr;
		// a.low * b.low
		mov		mul_low, [pa + 8];
		mul		mul_high, mul_low, b;
		// Store the low part of the mul into result, high part into high_sum
		mov		[r + 8],  mul_low;
		mov		high_sum, mul_high;
		// a.high * b.low
		mov		mul_low, [pa + 0];	// Store a.high into the first operand mul_low
		imul	mul_high, mul_low, b;
		add		high_sum, mul_low;
		// Store the high part in the result
		mov		[r + 0], high_sum;
	}

	if negate
		return -result;

	return result;
}

div :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	mut_a := a;
	mut_b := b;
	negate := false;

	if mut_a.high < 0
	{
		mut_a = -mut_a;
		negate = true;
	}
	
	if mut_b.high < 0
	{
		mut_b = -mut_b;
		negate = !negate;
	}

	result := to_s128 (mut_a.as_u128 / mut_b.as_u128);

	if negate
		return -result;

	return result;
}

div :: inline (a : s128, b : s64) -> s128 #must
#no_context
{
	return a / make_s128 (b);
}

lshift :: inline (a : s128, x : u8) -> s128 #must
#no_context
{
	result := a;
	p := *result;
	#asm
	{
		x === c;
		mov		low:, [p + 8];
		shld	[p + 0], low, x;
		shl		[p + 8], x;
	}

	return result;
}

// Logical (unsigned) shift
rlshift :: inline (a : s128, x : u8) -> s128 #must
#no_context
{
	result := a;
	p := *result;
	#asm
	{
		x === c;
		mov		high:, [p + 0];
		shrd	[p + 8], high, x;
		shr		[p + 0], x;
	}

	return result;
}

// Arithmetic (signed) shift
rshift :: inline (a : s128, x : u8) -> s128 #must
#no_context
{
	result := a;
	p := *result;
	#asm
	{
		x === c;
		mov		high:, [p + 0];
		shrd	[p + 8], high, x;
		sar		[p + 0], x;
	}

	return result;
}

operator + :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	return add (a, b);
}

operator - :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	return sub (a, b);
}

operator - :: inline (a : s128) -> s128 #must
#no_context
{
	return neg (a);
}

operator * :: inline (a : s128, b : s64) -> s128 #must
#no_context
{
	return mul (a, b);
}

operator * :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	return mul (a, b);
}

operator / :: inline (a : s128, b : s128) -> s128 #must
#no_context
{
	return div (a, b);
}

operator / :: inline (a : s128, b : s64) -> s128 #must
#no_context
{
	return div (a, b);
}

operator << :: inline (a : s128, x : u8) -> s128 #must
#no_context
{
	return lshift (a, x);
}

operator >> :: inline (a : s128, x : u8) -> s128 #must
#no_context
{
	return rshift (a, x);
}

operator == :: inline (a : s128, b : s128) -> bool #must
#no_context
{
	return a.low == b.low && a.high == b.high;
}

operator < :: inline (a : s128, b : s128) -> bool #must
#no_context
{
	result : bool = ---;
	#asm
	{
		mov		al:, [a + 8];
		mov		ah:, [a + 0];
		mov		bl:, [b + 8];
		mov		bh:, [b + 0];
		sub		al, bl;
		sbb		ah, bh;
		setl	result;
	}
	
	return result;
}

operator <= :: inline (a : s128, b : s128) -> bool #must
#no_context
{
	return a < b || a == b;
}

operator > :: inline (a : s128, b : s128) -> bool #must
#no_context
{
	return !(a <= b);
}

operator >= :: inline (a : s128, b : s128) -> bool #must
#no_context
{
	return !(a < b);
}
