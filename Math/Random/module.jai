// MCG random number generator, from Random.jai in jai/modules, using the Int128 module.
// https://www.pcg-random.org/posts/does-it-beat-the-minimal-standard.html

#scope_module

#import "Runtime";
math :: #import "Math";
#import "Math/Int128";

RAND_RANGE :: cast (u32) 0x1000_0000;
MASK       :: RAND_RANGE - 1;
#assert (RAND_RANGE & MASK) == 0;

#scope_export

#add_context random_current := u128.{ 69, 105 };	// Must be odd

seed :: inline (x : u64)
{
	context.random_current.low  = 1;
	context.random_current.high = x;
}

seed :: inline (x : u128)
{
	context.random_current = x;
	if context.random_current.low & 1 == 0
		context.random_current.low += 1;
}

get :: inline () -> u64
{
	MULTIPLIER :: u128.{ 0x0fc9_4e3b_f4e9_ab32, 0x8664_58cd_56f5_e605 };
	context.random_current *= MULTIPLIER;
	return context.random_current.high;
}

range :: inline (low : f32, high : f32) -> f32 #must
{
	rand := get () & MASK;
	t := (rand / cast (f32) RAND_RANGE) * (high - low);

	return low + t;
}

rangei :: inline (low : s64, high : s64) -> s64 #must
{
	rand := cast, trunc (s64) get ();
	return math.wrap (rand, low, high);
}

chance :: inline (x : f32) -> bool #must
{
	return range (0, 1) <= x;
}
