s128 :: struct
{
	high : s64;
	low  : u64;

	#place high;
	uhigh : u64;
	#place high;
	as_u128 : u128;
}

make_s128 :: inline (x : s64) -> s128 #must
{
	result : s128;
	result.low  = cast, no_check (u64) x;
	if x < 0
		result.high = -1;
	return result;
}

make_s128 :: inline (high : s64, low : u64) -> s128 #must
{
	result : s128 = ---;
	result.high = high;
	result.low  = low;
	return result;
}

add :: inline (a : s128, b : s128) -> s128 #must
{
	result : s128 = ---;
	p := *result;
	#asm
	{
		mov	al:, [a + 0];
		mov	ah:, [a + 8];

		mov	bl:, [b + 0];
		mov	bh:, [b + 8];

		mov	[p + 0], al;
		mov	[p + 8], ah;

		add	[p + 0], bl;
		adc	[p + 8], bh;
	}
	return result;
}

sub :: inline (a : s128, b : s128) -> s128 #must
{
	result : s128 = ---;
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

neg :: inline (a : s128) -> s128 #must
{
	result : s128 = ---;
	result.low  = ~a.low;
	result.high = ~a.high;
	p := *result;
	#asm
	{
		add	[p + 0], 1;
		adc	[p + 8], 0;
	}
	return result;
}

mul :: inline (left : s64, right : s64) -> s128 #must
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
		mov		mul_low, [pa + 0];
		mov		mul_op2, [pb + 0];
		mul		mul_high, mul_low, mul_op2;	// mul gpr.d, gpr.a, gpr
		// Store the low part of the mul into result, high part into high_sum
		mov		[r + 0],  mul_low;
		mov		high_sum, mul_high;
		// a.high * b.low
		mov		mul_low, [pa + 8];	// Store a.high into the first operand mul_low
		imul	mul_high, mul_low, mul_op2;	// At this point: mul_op2 = b.low
		add		high_sum, mul_low;
		// a.low * b.high
		mov		mul_low, [pa + 0];
		mov		mul_op2, [pb + 8];
		imul	mul_high, mul_low, mul_op2;
		add		high_sum, mul_low;
		// Store the high part in the result
		mov		[r + 8], high_sum;
	}
	if negate
		return -result;
	return result;
}

mul :: inline (a : s128, b : s64) -> s128 #must
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
		mov		mul_low, [pa + 0];
		mul		mul_high, mul_low, b;
		// Store the low part of the mul into result, high part into high_sum
		mov		[r + 0],  mul_low;
		mov		high_sum, mul_high;
		// a.high * b.low
		mov		mul_low, [pa + 8];	// Store a.high into the first operand mul_low
		imul	mul_high, mul_low, b;
		add		high_sum, mul_low;
		// Store the high part in the result
		mov		[r + 8], high_sum;
	}
	if negate
		return -result;
	return result;
}

div :: inline (a : s128, b : s128) -> s128 #must
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
{
	return a / make_s128 (b);
}

lshift :: inline (a : s128, x : u8) -> s128 #must
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

// Logical (unsigned) shift
rlshift :: inline (a : s128, x : u8) -> s128 #must
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

// Arithmetic (signed) shift
rshift :: inline (a : s128, x : u8) -> s128 #must
{
	result := a;
	p := *result;
	#asm
	{
		x === c;
		mov		high:, [p + 8];
		shrd	[p + 0], high, x;
		sar		[p + 8], x;
	}
	return result;
}

operator + :: inline (a : s128, b : s128) -> s128 #must
{
	return add (a, b);
}

operator - :: inline (a : s128, b : s128) -> s128 #must
{
	return sub (a, b);
}

operator - :: inline (a : s128) -> s128 #must
{
	return neg (a);
}

operator * :: inline (a : s128, b : s128) -> s128 #must
{
	return mul (a, b);
}

operator / :: inline (a : s128, b : s128) -> s128 #must
{
	return div (a, b);
}

operator / :: inline (a : s128, b : s64) -> s128 #must
{
	return div (a, b);
}

operator << :: inline (a : s128, x : u8) -> s128 #must
{
	return lshift (a, x);
}

operator >> :: inline (a : s128, x : u8) -> s128 #must
{
	return rshift (a, x);
}

operator == :: inline (a : s128, b : s128) -> bool #must
{
	return a.low == b.low && a.high == b.high;
}

operator < :: inline (a : s128, b : s128) -> bool #must
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

operator <= :: inline (a : s128, b : s128) -> bool #must
{
	return a < b || a == b;
}

operator > :: inline (a : s128, b : s128) -> bool #must
{
	return !(a <= b);
}

operator >= :: inline (a : s128, b : s128) -> bool #must
{
	return !(a < b);
}
