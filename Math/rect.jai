#import "Linalg";

Rect :: struct (T : Type)
{
	V :: Vec2 (T);

	x1, y1, x2, y2 : T;

	#place x1;
	left, top, right, bottom : T;

	#place x1;
	l, t, r, b : T;

	#place x1;
	min, max : V;

	#place x1;
	n : [4]T;
}

Recti :: Rect (s32);
Rectf :: Rect (f32);

rectf :: make_rectf;
ltrbf :: make_rectf;
make_rectf :: inline (x1 : f32, y1 : f32, x2 : f32, y2 : f32) -> Rectf #must
{
	return make_rect (x1, y1, x2, y2);
}

make_rectf :: inline (other : $R/Rect) -> Rectf #must
{
	return make_rectf (xx other.x1, xx other.y1, xx other.x2, xx other.y2);
}

xywhf :: make_rectf_size;
make_rectf_size :: inline (x : f32, y : f32, w : f32, h : f32) -> Rectf #must
{
	return make_rect_size (x, y, w, h);
}

recti :: make_recti;
ltrbi :: make_recti;
make_recti :: inline (x1 : s32, y1 : s32, x2 : s32, y2 : s32) -> Recti #must
{
	return make_rect (x1, y1, x2, y2);
}

make_recti :: inline (other : $R/Rect) -> Recti #must
{
	return make_recti (xx other.x1, xx other.y1, xx other.x2, xx other.y2);
}

xywhi :: make_recti_size;
make_recti_size :: inline (x : s32, y : s32, w : s32, h : s32) -> Recti #must
{
	return make_rect_size (x, y, w, h);
}

ltrb :: make_rect;
make_rect :: inline (x1 : $T, y1 : T, x2 : T, y2 : T) -> Rect (T) #must
{
	result : Rect (T) = ---;
	result.x1 = x1;
	result.y1 = y1;
	result.x2 = x2;
	result.y2 = y2;
	
	return result;
}

xywh :: make_rect_size;
make_rect_size :: inline (x : $T, y : T, w : T, h : T) -> Rect (T) #must
{
	result : Rect (T) = ---;
	result.x1 = x;
	result.y1 = y;
	result.x2 = x + w;
	result.y2 = y + h;
	
	return result;
}

rect_top_left :: inline (using rect : $R/Rect) -> R.V #must
{
	return vec2 (rect.left, rect.top);
}

rect_top_right :: inline (using rect : $R/Rect) -> R.V #must
{
	return vec2 (rect.right, rect.top);
}

rect_bottom_left :: inline (using rect : $R/Rect) -> R.V #must
{
	return vec2 (rect.left, rect.bottom);
}

rect_bottom_right :: inline (using rect : $R/Rect) -> R.V #must
{
	return vec2 (rect.right, rect.bottom);
}

rect_x :: inline (using rect : $R/Rect) -> R.T #must
{
	return x1;
}

rect_y :: inline (using rect : $R/Rect) -> R.T #must
{
	return y1;
}

rect_width :: inline (using rect : $R/Rect) -> R.T #must
{
	return x2 - x1;
}

rect_height :: inline (using rect : $R/Rect) -> R.T #must
{
	return y2 - y1;
}

rect_position :: inline (using rect : $R/Rect) -> R.V #must
{
	return vec2 (x1, y1);
}

rect_size :: inline (using rect : $R/Rect) -> R.V #must
{
	return vec2 (x2 - x1, y2 - y1);
}

expand_all_sides :: inline (using rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.x1 -= amount;
	result.y1 -= amount;
	result.x2 += amount;
	result.y2 += amount;
	
	return result;
}

expand_left :: inline (using rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.left -= amount;
	
	return result;
}

expand_top :: inline (using rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.top -= amount;
	
	return result;
}

expand_right :: inline (using rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.right += amount;
	
	return result;
}

expand_bottom :: inline (using rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.bottom += amount;
	
	return result;
}

truncate_all_sides :: inline (rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.x1 += amount;
	result.y1 += amount;
	result.x2 -= amount;
	result.y2 -= amount;
	
	return result;
}

truncate_left :: inline (rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.left += amount;
	
	return result;
}

truncate_top :: inline (rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.top += amount;
	
	return result;
}

truncate_right :: inline (rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.right -= amount;
	
	return result;
}

truncate_bottom :: inline (rect : $R/Rect, amount : R.T) -> R #must
{
	result := rect;
	result.bottom -= amount;
	
	return result;
}

set_position :: inline (rect : $R/Rect, new_x : R.T, new_y : R.T) -> R #must
{
	width  := rect_width (rect);
	height := rect_height (rect);
	result : R = ---;
	result.x1 = new_x;
	result.y1 = new_y;
	result.x2 = new_x + width;
	result.y2 = new_y + height;
	
	return result;
}

set_position :: inline (rect : $R/Rect, new_position : R.V) -> R #must
{
	return set_position (rect, new_position.x, new_position.y);
}

move :: inline (rect : $R/Rect, x_amount : R.T, y_amount : R.T) -> R #must
{
	result := rect;
	result.x1 += x_amount;
	result.y1 += y_amount;
	result.x2 += x_amount;
	result.y2 += y_amount;
	
	return result;
}

move :: inline (rect : $R/Rect, amount : R.V) -> R #must
{
	return move (rect, amount.x, amount.y);
}

set_width :: inline (rect : $R/Rect, new_w : R.T) -> R #must
{
	result := rect;
	result.x2 = result.x1 + new_w;
	
	return result;
}

set_height :: inline (rect : $R/Rect, new_h : R.T) -> R #must
{
	result := rect;
	result.y2 = result.y1 + new_h;
	
	return result;
}

set_size :: inline (rect : $R/Rect, new_w : R.T, new_h : R.T) -> R #must
{
	result := rect;
	result.x2 = result.x1 + new_w;
	result.y2 = result.y1 + new_h;
	
	return result;
}

set_size :: inline (rect : $R/Rect, new_size : R.V) -> R #must
{
	return set_size (rect, new_size.w, new_size.h);
}

grow :: inline (rect : $R/Rect, x_amount : R.T, y_amount : R.T) -> R #must
{
	result := rect;
	result.x2 += x_amount;
	result.y2 += y_amount;
	
	return result;
}

grow :: inline (rect : $R/Rect, amount : R.V) -> R #must
{
	return grow (rect, amount.w, amount.h);
}

clip :: inline (rect : $R/Rect, clip_by : R) -> R #must
{
	result : R = ---;
	result.x1 = max (rect.x1, clip_by.x1);
	result.y1 = max (rect.y1, clip_by.y1);
	result.x2 = min (rect.x2, clip_by.x2);
	result.y2 = min (rect.y2, clip_by.y2);
	
	return result;
}

contains :: inline (rect : $R/Rect, point : R.V) -> bool #must
{
	return point.x >= rect.x1 && point.x <= rect.x2 && point.y >= rect.y1 && point.y <= rect.y2;
}

operator == :: inline (left : $R/Rect, right : R) -> bool #must
{
	return left.x1 == right.x1 && left.y1 == right.y1 && left.x2 == right.x2 && left.y2 == right.y2;
}
