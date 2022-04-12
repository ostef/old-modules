Color :: RGBA;
RGBA :: struct
{
	r, g, b, a : u8;

	#place r;
	value : u32;

	#place r;
	n : [4]u8;
}

RGBA_TRANSPARENT :: RGBA.{ 0, 0, 0, 0 };
RGBA_WHITE :: RGBA.{ 255, 255, 255, 255 };
RGBA_BLACK :: RGBA.{ 0, 0, 0, 255 };
RGBA_RED   :: RGBA.{ 255, 0, 0, 255 };
RGBA_GREEN :: RGBA.{ 0, 255, 0, 255 };
RGBA_BLUE  :: RGBA.{ 0, 0, 255, 255 };

rgba :: make_rgba;
make_rgba :: inline (r : u8, g : u8, b : u8, a : u8 = 255) -> RGBA #must
{
	result : RGBA = ---;
	result.r = r;
	result.g = g;
	result.b = b;
	result.a = a;
	
	return result;
}

make_rgba :: inline (r : f32, g : f32, b : f32, a : f32 = 1) -> RGBA #must
{
	result : RGBA = ---;
	result.r = cast (u8) (r * 255);
	result.g = cast (u8) (g * 255);
	result.b = cast (u8) (b * 255);
	result.a = cast (u8) (a * 255);
	
	return result;
}

make_rgba :: inline (using color : RGBAf) -> RGBA #must
{
	result : RGBA = ---;
	result.r = cast (u8) (r * 255);
	result.g = cast (u8) (g * 255);
	result.b = cast (u8) (b * 255);
	result.a = cast (u8) (a * 255);
	
	return result;
}

make_rgba :: inline (color : RGBA, a : u8) -> RGBA #must
{
	result : RGBA = ---;
	result.r = color.r;
	result.g = color.g;
	result.b = color.b;
	result.a = a;
	
	return result;
}

blend :: inline (a : RGBA, b : RGBA, t : f32) -> RGBA #must
{
	result : RGBA = ---;
	result.r = cast, trunc (u8) (a.r * (1 - t) + b.r * t);
	result.g = cast, trunc (u8) (a.g * (1 - t) + b.g * t);
	result.b = cast, trunc (u8) (a.b * (1 - t) + b.b * t);
	result.a = cast, trunc (u8) (a.a * (1 - t) + b.a * t);

	return result;
}

operator == :: inline (left : RGBA, right : RGBA) -> bool #must
{
	return left.r == right.r && left.g == right.g && left.b == right.b && left.a == right.a;
}

Colorf :: RGBAf;
RGBAf :: struct
{
	r, g, b, a : f32;

	#place r;
	n : [4]f32;
}

RGBAF_TRANSPARENT :: RGBAf.{ 0, 0, 0, 0 };
RGBAF_WHITE :: RGBAf.{ 1, 1, 1, 1 };
RGBAF_BLACK :: RGBAf.{ 0, 0, 0, 1 };

rgbaf :: make_rgbaf;
make_rgbaf :: inline (r : f32 = 0, g : f32 = 0, b : f32 = 0, a : f32 = 0) ->  RGBAf #must
{
	result : RGBAf = ---;
	result.r = saturate (r);
	result.g = saturate (g);
	result.b = saturate (b);
	result.a = saturate (a);
	
	return result;
}

make_rgbaf :: inline (using color : RGBA) -> RGBAf #must
{
	result : RGBAf = ---;
	result.r = r / 255.0;
	result.g = g / 255.0;
	result.b = b / 255.0;
	result.a = a / 255.0;
	
	return result;
}

invert :: inline (using color : RGBA) -> RGBA #must
{
	result : RGBA = ---;
	result.r = 255 - r;
	result.g = 255 - g;
	result.b = 255 - b;
	result.a = a;
	
	return result;
}

dim :: inline (using color : RGBA, factor : f32) -> RGBA #must
{
	result : RGBA = ---;
	result.r = xx clamp (r / factor, 0, 255);
	result.g = xx clamp (g / factor, 0, 255);
	result.b = xx clamp (b / factor, 0, 255);
	result.a = a;
	
	return result;
}

operator == :: inline (left : RGBAf, right : RGBAf) -> bool #must
{
	return left.r == right.r && left.g == right.g && left.b == right.b && left.a == right.a;
}
