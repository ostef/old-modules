#import "Linalg";

Rect :: struct (T : Type)
{
	V :: Vec2 (T);

	x, y, w, h : T;

	#place x;
	position : V;
	size : V;

	#place x;
	n : [4]T;
}

Recti :: Rect (s32);
Rectf :: Rect (f32);

rectf :: make_rectf;
xywhf :: make_rectf;
make_rectf :: inline (x : f32, y : f32, w : f32, h : f32) -> Rectf #must
#no_context
{
	return make_rect (x, y, w, h);
}

make_rectf :: inline (other : $R/Rect) -> Rectf #must
#no_context
{
	return make_rectf (xx other.x, xx other.y, xx other.w, xx other.h);
}

ltrbf :: inline (l : f32, t : f32, r : f32, b : f32) -> Rectf #must
#no_context
{
	return make_rectf (l, t, r - l, b - t);
}


recti :: make_recti;
xywhi :: make_recti;
make_recti :: inline (x : s32, y : s32, w : s32, h : s32) -> Recti #must
#no_context
{
	return make_rect (x, y, w, h);
}

make_recti :: inline (other : $R/Rect) -> Recti #must
#no_context
{
	return make_recti (xx other.x, xx other.y, xx other.w, xx other.h);
}

ltrbi :: inline (l : s32, t : s32, r : s32, b : s32) -> Recti #must
#no_context
{
	return make_recti (l, t, r - l, b - t);
}

xywh :: make_rect;
make_rect :: inline (x : $T, y : T, w : T, h : T) -> Rect (T) #must
#no_context
{
	result : Rect (T) = ---;
	result.x = x;
	result.y = y;
	result.w = w;
	result.h = h;
	
	return result;
}

ltrb :: inline (l : $T, t : T, r : T, b : T) -> Rect (T) #must
#no_context
{
	result : Rect (T) = ---;
	result.x = l;
	result.y = t;
	result.w = r - l;
	result.h = b - t;
	
	return result;
}

top_left :: inline (using rect : $R/Rect) -> R.V #must
#no_context
{
	result : R.V;
	result.x = rect.x;
	result.y = rect.y;
	
	return result;
}

top_right :: inline (using rect : $R/Rect) -> R.V #must
#no_context
{
	result : R.V;
	result.x = rect.x + rect.w;
	result.y = rect.y;

	return result;
}

bottom_left :: inline (using rect : $R/Rect) -> R.V #must
#no_context
{
	result : R.V;
	result.x = rect.x;
	result.y = rect.y + rect.h;

	return result;
}

bottom_right :: inline (using rect : $R/Rect) -> R.V #must
#no_context
{
	result : R.V;
	result.x = rect.x + rect.w;
	result.y = rect.y + rect.h;

	return result;
}

set_left :: inline (using rect : *$R/Rect, l : R.T)
{
	w += x - l;
	x = l;
}

set_right :: inline (using rect : *$R/Rect, r : R.T)
{
	w = r - x;
}

set_top :: inline (using rect : *$R/Rect, t : R.T)
{
	h += y - t;
	y = t;
}

set_bottom :: inline (using rect : *$R/Rect, b : R.T)
{
	h = b - y;
}

expand_all_sides :: inline (using rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.x -= amount;
	result.y -= amount;
	result.w += amount * 2;
	result.h += amount * 2;
	
	return result;
}

expand_left :: inline (using rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.x -= amount;
	result.w += amount;

	return result;
}

expand_top :: inline (using rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.y -= amount;
	result.h += amount;

	return result;
}

expand_right :: inline (using rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.w += amount;

	return result;
}

expand_bottom :: inline (using rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.h += amount;

	return result;
}

truncate_all_sides :: inline (rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.x += amount;
	result.y += amount;
	result.w -= amount * 2;
	result.h -= amount * 2;
	
	return result;
}

truncate_left :: inline (rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.x += amount;
	result.w -= amount;
	
	return result;
}

truncate_top :: inline (rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.y += amount;
	result.h -= amount;

	return result;
}

truncate_right :: inline (rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.w -= amount;
	
	return result;
}

truncate_bottom :: inline (rect : $R/Rect, amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.h -= amount;
	
	return result;
}

move :: inline (rect : $R/Rect, x_amount : R.T, y_amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.x += x_amount;
	result.y += y_amount;
	
	return result;
}

move :: inline (rect : $R/Rect, amount : R.V) -> R #must
#no_context
{
	return move (rect, amount.x, amount.y);
}

grow :: inline (rect : $R/Rect, x_amount : R.T, y_amount : R.T) -> R #must
#no_context
{
	result := rect;
	result.w += x_amount;
	result.h += y_amount;
	
	return result;
}

grow :: inline (rect : $R/Rect, amount : R.V) -> R #must
#no_context
{
	return grow (rect, amount.w, amount.h);
}

clip :: inline (rect : $R/Rect, clip_by : R) -> R #must
#no_context
{
	result : R = ---;
	result.x = max (rect.x, clip_by.x);
	result.y = max (rect.y, clip_by.y);
	result.w = min (rect.x + rect.w, clip_by.x + clip_by.w) - result.x;
	result.h = min (rect.y + rect.h, clip_by.y + clip_by.h) - result.y;
	
	return result;
}

contains :: inline (rect : $R/Rect, point : R.V) -> bool #must
#no_context
{
	return point.x >= rect.x && point.x <= rect.x + rect.w && point.y >= rect.y && point.y <= rect.y + rect.h;
}

operator == :: inline (left : $R/Rect, right : R) -> bool #must
#no_context
{
	return left.x == right.x && left.y == right.y && left.w == right.w && left.h == right.h;
}
