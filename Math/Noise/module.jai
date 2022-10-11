#module_parameters (PERLIN_REPEAT := 255, PERMUTATION_SEED := 123456);

#scope_module

#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
rand :: #import "Math/Random";
strbuild :: #import "String/Builder";

#scope_export

/*
 * This module implements the Improved Perlin Noise algorithm in 3 dimensions.
 * Perlin Noise is a kind of coherent noise, that is a type of smooth
 * pseudo-random noise.
 * A smooth pseudo-random noise has the following properties:
 *    - Small changes in the input produces small changes in the output,
 *    - Large changes in the input produces large (seemingly random) changes in the output,
 *    - An input A will always produce the same output A'.
 *
 * There are three versions of the Perlin noise algorithm: the "classic" one from 1980,
 * the "improved" one from 2002 and the Simplex noise algorithm from 2001, all made
 * by Ken Perlin.
 */

// https://adrianb.io/2014/08/09/perlinnoise.html
// Seamless tiling of perlin noise: https://gamedev.stackexchange.com/a/23639
perlin :: (x : f64, y : f64, z : f64) -> f64 #must
{
	// The permutation table is a random arrangement of all the numbers in [0, PERLIN_REPEAT]
	P :: #insert #run generate_perlin_permutation_table ();

	fade :: inline (t : f64) -> f64
	{
		// 6t^5 - 15t^4 + 10t^3
		return t * t * t * (t * (t * 6 - 15) + 10);
	}

	/*
	incr_repeat :: inline (i : int, repeat : int) -> int
	{
		i += 1;
		if repeat > 0 then i %= repeat;

		return i;
	}
	*/

	gradient :: (hash : int, x : f64, y : f64, z : f64) -> f64
	{
		if (hash & 0xf) ==
		{
		case 0x0; return  x + y;
		case 0x1; return -x + y;
		case 0x2; return  x - y;
		case 0x3; return -x - y;
		
		case 0x4; return  x + z;
		case 0x5; return -x + z;
		case 0x6; return  x - z;
		case 0x7; return -x - z;
		
		case 0x8; return  y + z;
		case 0x9; return -y + z;
		case 0xa; return  y - z;
		case 0xb; return -y - z;
		
		case 0xc; return  y + x;
		case 0xd; return -y + z;
		case 0xe; return  y - x;
		case 0xf; return -y - z;
		}
		
		return 0;
	}

	x = math.wrap (x, cast (f64) PERLIN_REPEAT);
	y = math.wrap (y, cast (f64) PERLIN_REPEAT);
	z = math.wrap (z, cast (f64) PERLIN_REPEAT);
	xi := cast (int) x;
	yi := cast (int) y;
	zi := cast (int) z;
	xf := x - xi;
	yf := y - yi;
	zf := z - zi;

	u := fade (xf);
	v := fade (yf);
	w := fade (zf);

	aaa := P[P[P[xi    ] + yi    ] + zi    ];
	aba := P[P[P[xi    ] + yi + 1] + zi    ];
	aab := P[P[P[xi    ] + yi    ] + zi + 1];
	abb := P[P[P[xi    ] + yi + 1] + zi + 1];
	baa := P[P[P[xi + 1] + yi    ] + zi    ];
	bba := P[P[P[xi + 1] + yi + 1] + zi    ];
	bab := P[P[P[xi + 1] + yi    ] + zi + 1];
	bbb := P[P[P[xi + 1] + yi + 1] + zi + 1];

	x1 := math.lerp (gradient (aaa, xf, yf,     zf), gradient (baa, xf - 1, yf,     zf), u);
	x2 := math.lerp (gradient (aba, xf, yf - 1, zf), gradient (bba, xf - 1, yf - 1, zf), u);

	y1 := math.lerp (x1, x2, v);

	x1  = math.lerp (gradient (aab, xf, yf,     zf - 1), gradient (bab, xf - 1, yf,     zf - 1), u);
	x2  = math.lerp (gradient (abb, xf, yf - 1, zf - 1), gradient (bbb, xf - 1, yf - 1, zf - 1), u);

	y2 := math.lerp (x1, x2, v);

	result := math.lerp (y1, y2, w);

	return math.range_map (result, -1, 1, 0, 1);
}

#scope_file

generate_perlin_permutation_table :: () -> string
{
	shuffle :: (array : []$T, iterations := -1)
	{
		if iterations <= 0
			iterations = array.count;
			
		for i : 0..iterations - 1
		{
			a := rand.rangei (0, array.count - 1);
			b := rand.rangei (0, array.count - 1);
			array[a], array[b] = swap (array[a], array[b]);
		}
	}

	rand.seed (PERMUTATION_SEED);
	ints : [PERLIN_REPEAT * 2]int;

	// Populate the array with ordered integers from 0 to PERLIN_REPEAT - 1
	for i : 0..PERLIN_REPEAT - 1
		ints[i] = i;

	to_shuffle : []int = ints;
	to_shuffle.count = PERLIN_REPEAT;
	shuffle (to_shuffle);

	for i : 0..PERLIN_REPEAT - 1
		ints[PERLIN_REPEAT + i] = ints[i];

	// Generate int array literal
	code : strbuild.Builder;
	strbuild.init (*code);

	strbuild.append (*code, "int.[ ");
	for ints
	{
		strbuild.append_s64 (*code, it);
		if it_index != PERLIN_REPEAT - 1
			strbuild.append (*code, ", ");
	}
	strbuild.append (*code, " ];");

	return strbuild.build (code);
}

