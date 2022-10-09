// Multiplicative congruential random number generator.
// https://www.pcg-random.org/posts/does-it-beat-the-minimal-standard.html

#scope_module

#import "Runtime";
math :: #import "Math";
#import "Math/Int128";

F32_RAND_RANGE :: math.F32_HIGHEST_REPRESENTABLE_INTEGER;
F32_MASK       :: F32_RAND_RANGE - 1;
#assert (F32_RAND_RANGE & F32_MASK) == 0;

F64_RAND_RANGE :: math.F64_HIGHEST_REPRESENTABLE_INTEGER;
F64_MASK       :: F64_RAND_RANGE - 1;
#assert (F64_RAND_RANGE & F64_MASK) == 0;

#scope_export

// MCG stands for Multiplicative Congruential Generator
MCG :: struct
{
	state : u128;
}

#add_context rng := MCG.{ state = .{ 69, 105 } };	// Must be odd

seed :: inline (x : u64) { seed (*context.rng, x); }
seed :: inline (rng : *MCG, x : u64)
{
	rng.state.low  = 1;
	rng.state.high = x;
}

seed :: inline (x : u128) { seed (*context.rng, x); }
seed :: inline (rng : *MCG, x : u128)
{
	rng.state = x;
	if rng.state.low & 1 == 0
		rng.state.low += 1;
}

next :: inline () -> MCG #must { return next (context.rng); }
next :: inline (rng : MCG) -> MCG #must
{
	result := rng;
	get (*result);

	return result;
}

get :: inline () -> u64 { return get (*context.rng); }
get :: inline (rng : *MCG) -> u64
{
	MULTIPLIER :: u128.{ 0x0fc9_4e3b_f4e9_ab32, 0x8664_58cd_56f5_e605 };
	rng.state *= MULTIPLIER;

	return rng.state.high;
}

get_f32 :: inline () -> f32 #must { return get_f32 (*context.rng); }
get_f32 :: inline (rng : *MCG) -> f32 #must
{
	return cast (f32) (get (rng) & F32_MASK);
}

get_f64 :: inline () -> f64 #must { return get_f64 (*context.rng); }
get_f64 :: inline (rng : *MCG) -> f64 #must
{
	return cast (f64) (get (rng) & F64_MASK);
}

range :: inline (low : f32, high : f32) -> f32 #must { return range (*context.rng, low, high); }
range :: inline (rng : *MCG, low : f32, high : f32) -> f32 #must
{
	rand := get (rng) & F32_MASK;
	t := (rand / cast (f32) F32_RAND_RANGE) * (high - low);

	return low + t;
}

rangei :: inline (low : s64, high : s64) -> s64 #must { return rangei (*context.rng, low, high); }
rangei :: inline (rng : *MCG, low : s64, high : s64) -> s64 #must
{
	rand := cast, trunc (s64) get (rng);
	
	return math.wrap (rand, low, high);
}

chance :: inline (x : f32) -> bool #must { return chance (*context.rng, x); }
chance :: inline (rng : *MCG, x : f32) -> bool #must
{
	return range (rng, 0, 1) <= x;
}
