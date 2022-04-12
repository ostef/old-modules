#scope_module

#import "Runtime";
types :: #import "Types";

#scope_export

#load "integer.jai";
#load "ieee754.jai";
#load "easing.jai";
#load "crt.jai";
#load "rect.jai";
#load "rgba.jai";

abs :: (val : $T) -> T #expand
#modify { return types.is_numeric (T); }
#no_context
{
	return ifx val < 0 then -val else val;
}

min :: (a : $T, b : T) -> T #expand
#modify { return types.is_numeric (T); }
#no_context
{
	return ifx a < b then a else b;
}

max :: (a : $T, b : T) -> T #expand
#modify { return types.is_numeric (T); }
#no_context
{
	return ifx a > b then a else b;
}

sign :: (val : $T) -> T #expand
#modify { return types.is_numeric (T); }
#no_context
{
	#if #run types.is_unsigned (T)
		return 1;
	else
		return ifx val < 0 then cast (T) -1 else cast (T) 1;
}

clamp :: (x : $T, min : T, max : T) -> T #expand
#modify { return types.is_numeric (T); }
#no_context
{
	if x > max then x = max;
	if x < min then x = min;
	return x;
}

saturate :: (x : $T) -> T #expand
#modify { return types.is_numeric (T); }
#no_context
{
	if x > 1 then x = 1;
	if x < 0 then x = 0;
	return x;
}

round :: inline (x : $T) -> T #must
#modify { return types.is_numeric (T); }
#no_context
{
	#if #run types.is_float (T)
		return cast (T) (cast (int) (x + sign (x) * 0.5));
	else
		return x;
}

floor :: inline (x : $T) -> T #must
#modify { return types.is_numeric (T); }
#no_context
{
	#if #run types.is_float (T)
	{
		i := cast (int) round (x);
		diff := x - i;

		return cast (T) (i - cast (int) (diff < 0));
	}
	else
		return x;
}

ceil :: inline (x : $T) -> T #must
#modify { return types.is_numeric (T); }
#no_context
{
	#if #run types.is_float (T)
	{
		i := cast (int) round (x);
		diff := i - x;

		return cast (T) (i + cast (int) (diff < 0));
	}
	else
		return x;
}

approx_zero :: inline (val : $T, epsilon : $T2) -> bool #must
#modify {
	return types.is_numeric (T) && types.is_float (T2);
}
#no_context
{
	#if #run types.is_float (T)
		return abs (val) <= epsilon;
	else
		return val == 0;
}

approx_equals :: inline (left : $T, right : T, epsilon : $T2) -> bool #must
#modify {
	return types.is_numeric (T) && types.is_float (T2);
}
#no_context
{
	#if #run types.is_float (T)
		return abs (left - right) <= epsilon;
	else
		return left == right;
}

to_rads :: inline (angle_in_degrees : $T) -> T #must
#modify { return types.is_float (T); }
#no_context
{
	return angle_in_degrees * PI / 180.0;
}

to_degs :: inline (angle_in_radians : $T) -> T #must
#modify { return types.is_float (T); }
#no_context
{
	return 180.0 * angle_in_radians / PI;
}

wrap :: inline (a : $T, min : T, max : T) -> T #must
#modify { return types.is_numeric (T); }
#no_context
{
	a += min;
	#if #run types.is_float (T)
		a = fmod (a, (max - min));
	else
		a %= (max - min);
	if a < 0 then a += (max - min);
	a -= min;

	return a;
}

wrap :: inline (a : $T, max : T) -> T #must
#modify { return types.is_numeric (T); }
#no_context
{
	#if #run types.is_float (T)
		a = fmod (a, max);
	else
		a %= max;
	if a < 0 then a += max;

	return a;
}

range_map :: inline (value : $T, low : T, high : T, mapped_low : T, mapped_high : T) -> T #must
#modify { return types.is_numeric (T); }
{
	value -= low;
	value /= high - low;
	value *= mapped_high - mapped_low;
	value += mapped_low;

	return value;
}

range_map01 :: inline (value : $T, mapped_low : T, mapped_high : T) -> T #must
#modify { return types.is_numeric (T); }
{
	return range_map (value, 0, 1, mapped_low, mapped_high);
}

snap_down :: inline (value : $T, grid_size : T) -> T #must
#modify { return types.is_float (T); }
#no_context
{
	return floor (value / grid_size) * grid_size;
}

snap :: inline (value : $T, grid_size : T) -> T #must
#modify { return types.is_float (T); }
#no_context
{
	return round (value / grid_size) * grid_size;
}

snap_up :: inline (value : $T, grid_size : T) -> T #must
#modify { return types.is_float (T); }
#no_context
{
	return ceil (value / grid_size) * grid_size;
}

lerp :: inline (x : $T, y : T, t : $T2) -> T #must
#modify {
	return types.is_numeric (T) && types.is_float (T2);
}
#no_context
{
	return x + cast (T) (t * (y - x));
}

lerp_angle :: inline (x : $T, y : T, t : $T2) -> T #must
#modify {
	return types.is_numeric (T) && types.is_float (T2);
}
#no_context
{
	return wrap (lerp (x, y, t), 0, 2 * PI);
}

cos_lerp :: inline (x : $T, y : T, t : $T2) -> T #must
#modify {
	return types.is_numeric (T) && types.is_float (T2);
}
#no_context
{
	t = (1 - cos (t * PI)) / 2;

	return lerp (x, y, t);
}

smoothstep :: inline (x : $T, y : T, t : $T2) -> T #must
#modify {
	return types.is_numeric (T) && types.is_float (T2);
}
#no_context
{
	t = clamp ((t - x) / (y - x), 0, 1);

	return cast (T) (t * t * (3 - 2 * t));
}
