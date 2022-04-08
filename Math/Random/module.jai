// https://en.wikipedia.org/wiki/Pseudorandom_number_generator
// https://en.wikipedia.org/wiki/Lehmer_random_number_generator

#scope_module

#import "Runtime";

#scope_file

// @Todo (stefan): 64-bit

M :: 0x7fff_ffff;	// The modulus is the mersene prime M31: 2^31 - 1 = 2,147,483,647
A :: 16_807;

RAND_RANGE :: cast (u32) 0x1000_0000;
MASK       :: RAND_RANGE - 1;
#assert (RAND_RANGE & MASK) == 0;

_state := cast (s32) 0x0173_965;

#scope_export

seed :: inline (x : s32)
{
	_state = x & M;
	if _state == 0 || _state == 1 then _state += 2;
}

get :: inline () -> u32
{
	x := _state;
	hi := x / 127773;
	lo := x % 127773;
	_state = A * lo - 2836 * hi;
	if _state <= 0 then _state += M;

	return cast (u32) _state;
}

range :: inline (low : f32, high : f32) -> f32
{
	rand := get () & MASK;
	t := (rand / cast (f32) RAND_RANGE) * (high - low);

	return low + t;
}

rangei :: inline (low : int, high : int) -> int
{
	return cast (int) range (xx low, xx high);
}

chance :: inline (x : f32) -> bool
{
	return range (0, 1) <= x;
}
