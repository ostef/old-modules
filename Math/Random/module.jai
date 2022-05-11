// MCG random number generator, from Random.jai in jai/modules, using the Int128 module.
// https://www.pcg-random.org/posts/does-it-beat-the-minimal-standard.html

#scope_module

#import "Runtime";
math :: #import "Math";
#import "Math/Int128";

RAND_RANGE :: cast (u32) 0x1000_0000;
MASK       :: RAND_RANGE - 1;
#assert (RAND_RANGE & MASK) == 0;

MCG :: struct
{
	state : u128;
}

#scope_export

#add_context rng := MCG.{ state = .{ 69, 105 } };	// Must be odd

seed :: inline (x : u64) { seed (x, *context.rng); }
seed :: inline (x : u64, rng : *MCG)
{
	rng.state.low  = 1;
	rng.state.high = x;
}

seed :: inline (x : u128) { seed (x, *context.rng); }
seed :: inline (x : u128, rng : *MCG)
{
	rng.state = x;
	if rng.state.low & 1 == 0
		rng.state.low += 1;
}

get :: inline () -> u64 #must { return get (*context.rng); }
get :: inline (rng : *MCG) -> u64 #must
{
	MULTIPLIER :: u128.{ 0x0fc9_4e3b_f4e9_ab32, 0x8664_58cd_56f5_e605 };
	rng.state *= MULTIPLIER;
	return rng.state.high;
}

range :: inline (low : f32, high : f32) -> f32 #must { return range (low, high, *context.rng); }
range :: inline (low : f32, high : f32, rng : *MCG) -> f32 #must
{
	rand := get (rng) & MASK;
	t := (rand / cast (f32) RAND_RANGE) * (high - low);

	return low + t;
}

rangei :: inline (low : s64, high : s64) -> s64 #must { return rangei (low, high, *context.rng); }
rangei :: inline (low : s64, high : s64, rng : *MCG) -> s64 #must
{
	rand := cast, trunc (s64) get (rng);
	return math.wrap (rand, low, high);
}

chance :: inline (x : f32) -> bool #must { return chance (x, *context.rng); }
chance :: inline (x : f32, rng : *MCG) -> bool #must
{
	return range (0, 1, rng) <= x;
}
