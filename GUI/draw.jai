// @Cleanup @Temporary (stefan): a lot of the stuff here is copied from ImDraw. Later on we'll
// de-duplicate this code.

Vertex :: imdraw.Vertex;

Draw_Command :: struct
{
	// These are all the fields that get copied over to
	// the new command when it gets pushed.
	Header :: struct
	{
		texture : *render.Texture;
		shader  : *render.Shader;
		clipping_enabled : bool;
		clip_rect : math.Recti;
	}

	using header : Header;
	first_vertex : s64;
	vertex_count : s64;
}

Draw_Data :: struct
{
	vertices : [..]imdraw.Vertex;
	commands : [..]Draw_Command;

	current_command : *Draw_Command;
}

init :: inline (using data : *Draw_Data, preallocated_vertices : s64, preallocated_commands : s64, allocator : Allocator)
{
	array.init (*vertices, preallocated_vertices, allocator);
	array.init (*commands, preallocated_commands, allocator);
	current_command = array.push (*commands);
}

clear :: inline (using data : *Draw_Data)
{
	array.clear (*vertices);
	array.clear (*commands);
	current_command = array.push (*commands);
}

reset :: inline (using data : *Draw_Data)
{
	array.reset (*vertices);
	array.reset (*commands);
	current_command = null;
}

flush :: inline (using data : *Draw_Data)
{
	if current_command.vertex_count == 0
		return;
	header := current_command.header;
	current_command = array.push (*commands);
	current_command.header = header;
	current_command.first_vertex = vertices.count;
}

push_vertices :: inline (using data : *Draw_Data, count : s64) -> *imdraw.Vertex #must
{
	current_command.vertex_count += count;

	return array.push_multiple (*vertices, count, initialize = false);
}

get_clipping :: inline (using data : *Draw_Data) -> bool #must
{
	return current_command.clipping_enabled;
}

set_clipping :: inline (using data : *Draw_Data, enable : bool) -> previous : bool
{
	if current_command.clipping_enabled != enable
		flush (data);
	previous := current_command.clipping_enabled;
	current_command.clipping_enabled = enable;

	return previous;
}

get_clip_rect :: inline (using data : *Draw_Data) -> math.Recti #must
{
	return current_command.clip_rect;
}

set_clip_rect :: inline (using data : *Draw_Data, rect : math.Recti) -> previous_clip_rect : math.Recti, clipping_was_enabled : bool
{
	if !current_command.clipping_enabled || !mem.equals (current_command.clip_rect, rect)
		flush (data);
	previous_clip_rect := current_command.clip_rect;
	clipping_was_enabled := current_command.clipping_enabled;
	current_command.clipping_enabled = true;
	current_command.clip_rect = rect;

	return previous_clip_rect, clipping_was_enabled;
}

get_texture :: inline (using data : *Draw_Data) -> *render.Texture #must
{
	return current_command.texture;
}

set_texture :: inline (using data : *Draw_Data, texture : *render.Texture) -> previous : *render.Texture
{
	if current_command.texture != texture
		flush (data);
	previous := current_command.texture;
	current_command.texture = texture;

	return previous;
}

get_shader :: inline (using data : *Draw_Data) -> *render.Shader #must
{
	return current_command.shader;
}

set_shader :: inline (using data : *Draw_Data, shader : *render.Shader) -> previous : *render.Shader
{
	if current_command.shader != shader
		flush (data);
	previous := current_command.shader;
	current_command.shader = shader;

	return previous;
}

draw_triangle :: inline (
	data : *Draw_Data,
	p0 : Vec2f,
	p1 : Vec2f,
	p2 : Vec2f,
	color : math.RGBA,
	uv0 := Vec2f.{ 0, 0 },
	uv1 := Vec2f.{ 0.5, 1 },
	uv2 := Vec2f.{ 1, 0 }
)
{
	if p0 == p1 || p1 == p2 || p2 == p0
		return;

	v0 := push_vertices (data, 3);
	v0.position = p0;
	v0.tex_coords = uv0;
	v0.color = color;

	v1 := v0 + 1;
	v1.position = p1;
	v1.tex_coords = uv1;
	v1.color = color;

	v2 := v1 + 1;
	v2.position = p2;
	v2.tex_coords = uv2;
	v2.color = color;
}

draw_quad :: inline (
	data : *Draw_Data,
	p0 : Vec2f,
	p1 : Vec2f,
	p2 : Vec2f,
	p3 : Vec2f,
	color : math.RGBA,
	uv0 := Vec2f.{ 0, 0 },
	uv1 := Vec2f.{ 0, 1 },
	uv2 := Vec2f.{ 1, 1 },
	uv3 := Vec2f.{ 1, 0 }
)
{
	draw_triangle (
		data,
		p1,
		p0,
		p3,
		color,
		uv0 = uv1,
		uv1 = uv0,
		uv2 = uv3
	);
	draw_triangle (
		data,
		p1,
		p3,
		p2,
		color,
		uv0 = uv1,
		uv1 = uv3,
		uv2 = uv2
	);
}

draw_rect :: inline (
	data : *Draw_Data,
	rect : math.Rectf,
	color : math.RGBA,
	uv_rect := math.Rectf.{ 0, 0, 1, 1 }
)
{
	if rect.x1 >= rect.x2 || rect.y1 >= rect.y2
		return;
	draw_triangle (
		data,
		vec2f (rect.x1, rect.y2),
		vec2f (rect.x1, rect.y1),
		vec2f (rect.x2, rect.y1),
		color,
		uv0 = vec2f (uv_rect.x1, uv_rect.y2),
		uv1 = vec2f (uv_rect.x1, uv_rect.y1),
		uv2 = vec2f (uv_rect.x2, uv_rect.y1)
	);
	draw_triangle (
		data,
		vec2f (rect.x1, rect.y2),
		vec2f (rect.x2, rect.y1),
		vec2f (rect.x2, rect.y2),
		color,
		uv0 = vec2f (uv_rect.x1, uv_rect.y2),
		uv1 = vec2f (uv_rect.x2, uv_rect.y1),
		uv2 = vec2f (uv_rect.x2, uv_rect.y2)
	);
}

Rectangle_Corners :: enum_flags
{
	NONE         :: 0x00;
	TOP_LEFT     :: 0x01;
	TOP_RIGHT    :: 0x02;
	BOTTOM_RIGHT :: 0x04;
	BOTTOM_LEFT  :: 0x08;
	ALL :: TOP_LEFT | TOP_RIGHT | BOTTOM_RIGHT | BOTTOM_LEFT;
}

draw_rect :: inline (
	data : *Draw_Data,
	rect : math.Rectf,
	color : math.RGBA,
	corner_radius : f32,
	round_corners := Rectangle_Corners.ALL,
	uv_rect := math.Rectf.{ 0, 0, 1, 1 }
)
{
	if rect.x1 >= rect.x2 || rect.y1 >= rect.y2
		return;
	if corner_radius <= 0 || round_corners == .NONE
	{
		draw_rect (data, rect, color, uv_rect);
		return;
	}
	inner_rect    := math.truncate_all_sides (rect, corner_radius);
	uv_radius     := (corner_radius / math.rect_width (rect)) * math.rect_width (uv_rect);
	inner_uv_rect := math.truncate_all_sides (uv_rect, uv_radius);
	// Inner rect
	draw_triangle (
		data,
		vec2f (inner_rect.x1, inner_rect.y2),
		vec2f (inner_rect.x1, inner_rect.y1),
		vec2f (inner_rect.x2, inner_rect.y1),
		color,
		uv0 = vec2f (inner_uv_rect.x1, inner_uv_rect.y2),
		uv1 = vec2f (inner_uv_rect.x1, inner_uv_rect.y1),
		uv2 = vec2f (inner_uv_rect.x2, inner_uv_rect.y1)
	);
	draw_triangle (
		data,
		vec2f (inner_rect.x1, inner_rect.y2),
		vec2f (inner_rect.x2, inner_rect.y1),
		vec2f (inner_rect.x2, inner_rect.y2),
		color,
		uv0 = vec2f (inner_uv_rect.x1, inner_uv_rect.y2),
		uv1 = vec2f (inner_uv_rect.x2, inner_uv_rect.y1),
		uv2 = vec2f (inner_uv_rect.x2, inner_uv_rect.y2)
	);
	// Draw corners
	if flagged (round_corners, .TOP_LEFT)
		draw_semi_circle (
			data,
			math.rect_top_left (inner_rect),
			corner_radius,
			math.PI / 2,
			math.PI / 2,
			color,
			uv_center = math.rect_top_left (inner_uv_rect),
			uv_radius = uv_radius
		);
	else
		draw_rect (
			data,
			math.rectf (rect.x1, rect.y1, inner_rect.x1, inner_rect.y1),
			color,
			uv_rect = math.rectf (uv_rect.x1, uv_rect.y1, inner_uv_rect.x1, inner_uv_rect.y1)
		);
	if flagged (round_corners, .TOP_RIGHT)
		draw_semi_circle (
			data,
			math.rect_top_right (inner_rect),
			corner_radius,
			0,
			math.PI / 2,
			color,
			uv_center = math.rect_top_right (inner_uv_rect),
			uv_radius = uv_radius
		);
	else
		draw_rect (
			data,
			math.rectf (inner_rect.x2, rect.y1, rect.x2, inner_rect.y1),
			color,
			uv_rect = math.rectf (inner_uv_rect.x2, uv_rect.y1, uv_rect.x2, inner_uv_rect.y1)
		);
	if flagged (round_corners, .BOTTOM_LEFT)
		draw_semi_circle (
			data,
			math.rect_bottom_left (inner_rect),
			corner_radius,
			math.PI,
			math.PI / 2,
			color,
			uv_center = math.rect_bottom_left (inner_uv_rect),
			uv_radius = uv_radius
		);
	else
		draw_rect (
			data,
			math.rectf (rect.x1, inner_rect.y2, inner_rect.x1, rect.y2),
			color,
			uv_rect = math.rectf (uv_rect.x1, inner_uv_rect.y2, inner_uv_rect.x1, uv_rect.y2)
		);
	if flagged (round_corners, .BOTTOM_RIGHT)
		draw_semi_circle (
			data,
			math.rect_bottom_right (inner_rect),
			corner_radius,
			3 * math.PI / 2,
			math.PI / 2,
			color,
			uv_center = math.rect_bottom_right (inner_uv_rect),
			uv_radius = uv_radius
		);
	else
		draw_rect (
			data,
			math.rectf (inner_rect.x2, inner_rect.y2, rect.x2, rect.y2),
			color,
			uv_rect = math.rectf (inner_uv_rect.x2, inner_uv_rect.y2, uv_rect.x2, uv_rect.y2)
		);
	// Top
	draw_triangle (
		data,
		vec2f (inner_rect.x1, rect.y1),
		vec2f (inner_rect.x2, rect.y1),
		vec2f (inner_rect.x1, inner_rect.y1),
		color,
		uv0 = vec2f (inner_uv_rect.x1, uv_rect.y1),
		uv1 = vec2f (inner_uv_rect.x2, uv_rect.y1),
		uv2 = vec2f (inner_uv_rect.x1, inner_uv_rect.y1),
	);
	draw_triangle (
		data,
		vec2f (inner_rect.x1, inner_rect.y1),
		vec2f (inner_rect.x2, rect.y1),
		vec2f (inner_rect.x2, inner_rect.y1),
		color,
		uv0 = vec2f (inner_uv_rect.x1, inner_uv_rect.y1),
		uv1 = vec2f (inner_uv_rect.x2, uv_rect.y1),
		uv2 = vec2f (inner_uv_rect.x2, inner_uv_rect.y1),
	);
	// Right
	draw_triangle (
		data,
		vec2f (inner_rect.x2, inner_rect.y1),
		vec2f (rect.x2, inner_rect.y1),
		vec2f (rect.x2, inner_rect.y2),
		color,
		uv0 = vec2f (inner_uv_rect.x2, inner_uv_rect.y1),
		uv1 = vec2f (uv_rect.x2, inner_uv_rect.y1),
		uv2 = vec2f (uv_rect.x2, inner_uv_rect.y2),
	);
	draw_triangle (
		data,
		vec2f (inner_rect.x2, inner_rect.y1),
		vec2f (rect.x2, inner_rect.y2),
		vec2f (inner_rect.x2, inner_rect.y2),
		color,
		uv0 = vec2f (inner_uv_rect.x2, inner_uv_rect.y1),
		uv1 = vec2f (uv_rect.x2, inner_uv_rect.y2),
		uv2 = vec2f (inner_uv_rect.x2, inner_uv_rect.y2),
	);
	// Bottom
	draw_triangle (
		data,
		vec2f (inner_rect.x1, inner_rect.y2),
		vec2f (inner_rect.x2, inner_rect.y2),
		vec2f (inner_rect.x2, rect.y2),
		color,
		uv0 = vec2f (inner_uv_rect.x1, inner_uv_rect.y2),
		uv1 = vec2f (inner_uv_rect.x2, inner_uv_rect.y2),
		uv2 = vec2f (inner_uv_rect.x2, uv_rect.y2),
	);
	draw_triangle (
		data,
		vec2f (inner_rect.x1, inner_rect.y2),
		vec2f (inner_rect.x2, rect.y2),
		vec2f (inner_rect.x1, rect.y2),
		color,
		uv0 = vec2f (inner_uv_rect.x1, inner_uv_rect.y2),
		uv1 = vec2f (inner_uv_rect.x2, uv_rect.y2),
		uv2 = vec2f (inner_uv_rect.x1, uv_rect.y2),
	);
	// Left
	draw_triangle (
		data,
		vec2f (rect.x1, inner_rect.y1),
		vec2f (inner_rect.x1, inner_rect.y1),
		vec2f (inner_rect.x1, inner_rect.y2),
		color,
		uv0 = vec2f (uv_rect.x1, inner_uv_rect.y1),
		uv1 = vec2f (inner_uv_rect.x1, inner_uv_rect.y1),
		uv2 = vec2f (inner_uv_rect.x1, inner_uv_rect.y2),
	);
	draw_triangle (
		data,
		vec2f (rect.x1, inner_rect.y1),
		vec2f (inner_rect.x1, inner_rect.y2),
		vec2f (rect.x1, inner_rect.y2),
		color,
		uv0 = vec2f (uv_rect.x1, inner_uv_rect.y1),
		uv1 = vec2f (inner_uv_rect.x1, inner_uv_rect.y2),
		uv2 = vec2f (uv_rect.x1, inner_uv_rect.y2),
	);
}

draw_rect_outline :: inline (
	data : *Draw_Data,
	rect : math.Rectf,
	color : math.RGBA,
	thickness : f32,
	corner_radius := 0.0,
	round_corners := Rectangle_Corners.ALL,
	uv_rect := math.Rectf.{ 0, 0, 1, 1 }
)
{
	if rect.x1 >= rect.x2 || rect.y1 >= rect.y2
		return;
	inner_rect := math.truncate_all_sides (rect, thickness * 0.5);
	outer_rect := math.expand_all_sides (rect, thickness * 0.5);
	uv_thickness  := thickness / math.rect_width (rect) * math.rect_width (uv_rect);
	uv_radius     := (corner_radius / math.rect_width (rect)) * math.rect_width (uv_rect);
	inner_uv_rect := math.truncate_all_sides (uv_rect, uv_thickness * 0.5);
	outer_uv_rect := math.expand_all_sides (uv_rect, uv_thickness * 0.5);
	inset := corner_radius - thickness;
	uv_inset := uv_radius - uv_thickness;

	// Draw corners
	if flagged (round_corners, .TOP_LEFT)
		draw_semi_circle_outline (
			data,
			math.rect_top_left (inner_rect) + vec2f (inset, inset),
			corner_radius,
			math.PI / 2,
			math.PI / 2,
			color,
			thickness,
			uv_center = math.rect_top_left (inner_uv_rect),
			uv_radius = uv_radius
		);
	
	if flagged (round_corners, .TOP_RIGHT)
		draw_semi_circle_outline (
			data,
			math.rect_top_right (inner_rect) + vec2f (-inset, inset),
			corner_radius,
			0,
			math.PI / 2,
			color,
			thickness,
			uv_center = math.rect_top_right (inner_uv_rect),
			uv_radius = uv_radius
		);
	if flagged (round_corners, .BOTTOM_LEFT)
		draw_semi_circle_outline (
			data,
			math.rect_bottom_left (inner_rect) + vec2f (inset, -inset),
			corner_radius,
			math.PI,
			math.PI / 2,
			color,
			thickness,
			uv_center = math.rect_bottom_left (inner_uv_rect),
			uv_radius = uv_radius
		);
	if flagged (round_corners, .BOTTOM_RIGHT)
		draw_semi_circle_outline (
			data,
			math.rect_bottom_right (inner_rect) + vec2f (-inset, -inset),
			corner_radius,
			3 * math.PI / 2,
			math.PI / 2,
			color,
			thickness,
			uv_center = math.rect_bottom_right (inner_uv_rect),
			uv_radius = uv_radius
		);
	
	// Top
	draw_quad (
		data,
		vec2f (inner_rect.x1 + inset, inner_rect.y1),
		vec2f (inner_rect.x1 + inset, outer_rect.y1),
		vec2f (inner_rect.x2 - inset, outer_rect.y1),
		vec2f (inner_rect.x2 - inset, inner_rect.y1),
		color,
		vec2f (inner_uv_rect.x1 + uv_inset, inner_uv_rect.y1),
		vec2f (inner_uv_rect.x1 + uv_inset, outer_uv_rect.y1),
		vec2f (inner_uv_rect.x2 - uv_inset, outer_uv_rect.y1),
		vec2f (inner_uv_rect.x2 - uv_inset, inner_uv_rect.y1),
	);
	// Right
	draw_quad (
		data,
		vec2f (inner_rect.x2, inner_rect.y1 + inset),
		vec2f (outer_rect.x2, inner_rect.y1 + inset),
		vec2f (outer_rect.x2, inner_rect.y2 - inset),
		vec2f (inner_rect.x2, inner_rect.y2 - inset),
		color,
		vec2f (inner_uv_rect.x2, inner_uv_rect.y1 + uv_inset),
		vec2f (outer_uv_rect.x2, inner_uv_rect.y1 + uv_inset),
		vec2f (outer_uv_rect.x2, inner_uv_rect.y2 - uv_inset),
		vec2f (inner_uv_rect.x2, inner_uv_rect.y2 - uv_inset),
	);
	// Bottom
	draw_quad (
		data,
		vec2f (inner_rect.x1 + inset, outer_rect.y2),
		vec2f (inner_rect.x1 + inset, inner_rect.y2),
		vec2f (inner_rect.x2 - inset, inner_rect.y2),
		vec2f (inner_rect.x2 - inset, outer_rect.y2),
		color,
		vec2f (inner_uv_rect.x1 + uv_inset, outer_uv_rect.y2),
		vec2f (inner_uv_rect.x1 + uv_inset, inner_uv_rect.y2),
		vec2f (inner_uv_rect.x2 - uv_inset, inner_uv_rect.y2),
		vec2f (inner_uv_rect.x2 - uv_inset, outer_uv_rect.y2),
	);
	// Left
	draw_quad (
		data,
		vec2f (outer_rect.x1, inner_rect.y1 + inset),
		vec2f (inner_rect.x1, inner_rect.y1 + inset),
		vec2f (inner_rect.x1, inner_rect.y2 - inset),
		vec2f (outer_rect.x1, inner_rect.y2 - inset),
		color,
		vec2f (outer_uv_rect.x1, inner_uv_rect.y1 + uv_inset),
		vec2f (inner_uv_rect.x1, inner_uv_rect.y1 + uv_inset),
		vec2f (inner_uv_rect.x1, inner_uv_rect.y2 - uv_inset),
		vec2f (outer_uv_rect.x1, inner_uv_rect.y2 - uv_inset),
	);
}

draw_semi_circle :: inline (
	data : *Draw_Data,
	center : Vec2f,
	radius : f32,
	start_angle : f32,
	angle : f32,
	color : math.RGBA,
	resolution := 0,
	uv_center := Vec2f.{ 0.5, 0.5 },
	uv_radius := 0.5
)
{
	if radius <= 0
		return;
	if resolution <= 0
		resolution = math.max (cast (int) radius, 20);
	theta := -angle / cast (f32) resolution;
	tan_factor := math.tan (theta);
	rad_factor := math.cos (theta);
	p := vec2f (math.cos (-start_angle), math.sin (-start_angle));

	for 0..resolution - 1
	{
		p1 := p;
		t := vec2f (-p.y, p.x);
		p += t * tan_factor;
		p *= rad_factor;
		p2 := p;
		draw_triangle (
			data,
			center,
			center + p1 * radius,
			center + p2 * radius,
			color,
			uv0 = uv_center,
			uv1 = uv_center + p1 * uv_radius,
			uv2 = uv_center + p2 * uv_radius
		);
	}
}

draw_circle :: inline(
	data : *Draw_Data,
	center : Vec2f,
	radius : f32,
	color : math.RGBA,
	resolution := 0,
	uv_center := Vec2f.{ 0.5, 0.5 },
	uv_radius := 0.5
)
{
	draw_semi_circle (
		data,
		center,
		radius,
		0,
		2 * math.PI,
		color,
		resolution,
		uv_center,
		uv_radius
	);
}

draw_semi_circle_outline :: inline (
	data : *Draw_Data,
	center : Vec2f,
	radius : f32,
	start_angle : f32,
	angle : f32,
	color : math.RGBA,
	thickness : f32,
	resolution := 0,
	uv_center := Vec2f.{ 0.5, 0.5 },
	uv_radius := 0.5
)
{
	if radius <= 0
		return;
	if resolution <= 0
		resolution = math.max (cast (int) radius, 20);
	uv_thickness := thickness / radius * uv_radius;
	inner_radius := radius - thickness;
	inner_uv_radius := uv_radius - uv_thickness;
	theta := -angle / cast (f32) resolution;
	tan_factor := math.tan (theta);
	rad_factor := math.cos (theta);
	p := vec2f (math.cos (-start_angle), math.sin (-start_angle));
	
	for 0..resolution - 1
	{
		p1 := p;
		t := vec2f (-p.y, p.x);
		p += t * tan_factor;
		p *= rad_factor;
		p2 := p;
		draw_triangle (
			data,
			center + p1 * inner_radius,
			center + p1 * radius,
			center + p2 * radius,
			color,
			uv0 = uv_center + p1 * inner_uv_radius,
			uv1 = uv_center + p1 * uv_radius,
			uv2 = uv_center + p2 * uv_radius
		);
		draw_triangle (
			data,
			center + p1 * inner_radius,
			center + p2 * radius,
			center + p2 * inner_radius,
			color,
			uv0 = uv_center + p1 * inner_uv_radius,
			uv1 = uv_center + p2 * uv_radius,
			uv2 = uv_center + p2 * inner_uv_radius
		);
	}
}

draw_circle_outline :: inline (
	data : *Draw_Data,
	center : Vec2f,
	radius : f32,
	color : math.RGBA,
	thickness : f32,
	resolution := 0,
	uv_center := Vec2f.{ 0.5, 0.5 },
	uv_radius := 0.5
)
{
	draw_semi_circle_outline (
		data,
		center,
		radius,
		0,
		2 * math.PI,
		color,
		thickness,
		resolution,
		uv_center,
		uv_radius
	);
}

draw_line :: inline (
	data : *Draw_Data,
	start : Vec2f,
	end : Vec2f,
	color : math.RGBA,
	thickness : f32
)
{
	line_dir := normalized (end - start);
	theta    := math.atan2 (line_dir.x, -line_dir.y);
	cost     := math.cos (theta);
	sint     := math.sin (theta);
	offset   := vec2f (cost, sint) * thickness * 0.5;
	draw_triangle (data, start - offset, start + offset, end + offset, color);
	draw_triangle (data, start - offset, end + offset, end - offset, color);
}

Anchor :: enum_flags
{
	TOP     :: 0x01;
	VCENTER :: 0x02;
	BOTTOM  :: 0x04;
	LEFT    :: 0x08;
	HCENTER :: 0x10;
	RIGHT   :: 0x20;

	TOP_LEFT   :: TOP | LEFT;
	TOP_CENTER :: TOP | HCENTER;
	TOP_RIGHT  :: TOP | RIGHT;
	CENTER_LEFT  :: VCENTER | LEFT;
	CENTER       :: VCENTER | HCENTER;
	CENTER_RIGHT :: VCENTER | RIGHT;
	BOTTOM_LEFT   :: BOTTOM | LEFT;
	BOTTOM_CENTER :: BOTTOM | HCENTER;
	BOTTOM_RIGHT  :: BOTTOM | RIGHT;
}

Text_Effects :: enum_flags u8
{
	NONE :: 0x00;
	ITALIC :: 0x01;
	UNDERLINE :: 0x02;
	STRIKETHROUGH :: 0x04;
	STRIKEOUT :: STRIKETHROUGH;
}

draw_text :: inline (
	data : *Draw_Data,
	fnt : *font.Font,
	height : u32,
	position : linalg.Vec2f,
	text : string,
	color : math.RGBA,
	weight : font.Weight,
	effects := Text_Effects.NONE,
	anchor := Anchor.TOP_LEFT
) -> text_rect : math.Rectf
{
	if flagged (effects, .ITALIC)
		fnt = font.find_font (fnt, weight, .ITALIC, fallback = fnt);
	else
		fnt = font.find_font (fnt, weight, fnt.effects, fallback = fnt);
	return draw_text (data, fnt, height, position, text, color, effects, anchor);
}

draw_text :: (
	data : *Draw_Data,
	fnt : *font.Font,
	height : u32,
	position : linalg.Vec2f,
	text : string,
	color : math.RGBA,
	effects := Text_Effects.NONE,
	anchor := Anchor.TOP_LEFT
) -> text_rect : math.Rectf
#no_abc
{
	utf8 :: #import "Unicode/UTF8";
	for_expansion :: utf8.for_expansion;

	prev_texture := get_texture (data, );
	defer set_texture (data, prev_texture);
	prev_shader := set_shader (data, *font.g_glyph_shader);
	defer set_shader (data, prev_shader);

	if flagged (effects, .ITALIC)
		fnt = font.find_font (fnt, fnt.weight, .ITALIC, fallback = fnt);
	page := font.load_page (fnt, height);
	pen := vec2f (0, cast (f32) page.ascent);
	offset : Vec2f;
	size := font.calculate_text_extents (fnt, height, text);
	if flagged (anchor, .VCENTER)
		offset.y = -size.y * 0.5;
	else if flagged (anchor, .BOTTOM)
		offset.y = -size.y;
	if flagged (anchor, .HCENTER)
		offset.x = -size.x * 0.5;
	else if flagged (anchor, .RIGHT)
		offset.x = -size.x;
	for codepoint, i : utf8.make_str (text)
	{
		if codepoint ==
		{
		case #char "\n";
			if flagged (effects, .UNDERLINE)
			{
				set_texture (data, null);
				draw_line (
					data,
					round (position + offset) + vec2f (0, pen.y + 0.5),
					round (position + offset) + vec2f (pen.x, pen.y + 0.5),
					color,
					1
				);
			}
			if flagged (effects, .STRIKETHROUGH)
			{
				set_texture (data, null);
				draw_line (
					data,
					round (position + offset) + vec2f (0, pen.y - math.round (page.ascent * (2.0 / 5.0)) + 0.5),
					round (position + offset) + vec2f (pen.x, pen.y - math.round (page.ascent * (2.0 / 5.0)) + 0.5),
					color,
					1
				);
			}
			pen.x = 0;
			pen.y += page.ascent - page.descent;
		case #char "\t";
			glyph := font.load_glyph (page, codepoint);
			pen.x = math.snap_up (pen.x + glyph.advance, page.space_advance * 4.0);
		case;
			glyph := font.render_glyph (page, codepoint);
			glyph_rect := math.xywhf (
				math.round (position.x + offset.x) + pen.x + glyph.bitmap_bearing_x,
				math.round (position.y + offset.y) + pen.y - glyph.bitmap_bearing_y,
				cast (f32) glyph.bitmap_width,
				cast (f32) glyph.bitmap_height
			);
			pen.x += glyph.advance;
			set_texture (data, glyph.atlas_texture);
			draw_rect (data, glyph_rect, color, glyph.uv_rect);
		}
	}
	if pen.x != 0 && flagged (effects, .UNDERLINE)
	{
		set_texture (data, null);
		draw_line (
			data,
			round (position + offset) + vec2f (0, pen.y + 0.5),
			round (position + offset) + vec2f (pen.x, pen.y + 0.5),
			color,
			1
		);
	}
	if pen.x != 0 && flagged (effects, .STRIKETHROUGH)
	{
		set_texture (data, null);
		draw_line (
			data,
			round (position + offset) + vec2f (0, pen.y - math.round (page.ascent * (2.0 / 5.0)) + 0.5),
			round (position + offset) + vec2f (pen.x, pen.y - math.round (page.ascent * (2.0 / 5.0)) + 0.5),
			color,
			1
		);
	}

	return math.xywhf (math.round (position.x + offset.x), math.round (position.y + offset.y), size.x, size.y);
}
