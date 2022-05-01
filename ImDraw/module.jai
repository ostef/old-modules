#module_parameters (MAX_VERTICES := 10000);

// @Todo (stefan): Layers

#scope_module

#import "Runtime";
mem    :: #import "Memory";
log    :: #import "Log";
math   :: #import "Math";
using linalg :: #import "Linalg";
window :: #import "Window";
gl     :: #import "GL";
render :: #import "Render_Core";
font   :: #import "Font";

Recti :: math.Recti;
Rectf :: math.Rectf;
RGBA  :: math.RGBA;

#scope_export

#load "draw.jai";

Vertex :: struct
{
	position   : Vec2f;
	tex_coords : Vec2f;
	color      : RGBA;

	LAYOUT :: render.Vertex_Buffer.Elem.[
		render.Vertex_Buffer.VEC2F,
		render.Vertex_Buffer.VEC2F,
		render.Vertex_Buffer.RGBA
	];
}

Draw_Context :: struct
{
	win    : *window.Window;
	gl_ctx : *gl.GL_Context;

	vertices : [MAX_VERTICES]Vertex;
	vertex_count : s64;
	clip_rect : Recti;
	clipping_enabled : bool;
	viewport : Recti;

	texture        : *render.Texture;
	framebuffer    : *render.Framebuffer;
	shader         : *render.Shader;
	vertex_buffer  : render.Vertex_Buffer;
	default_shader : render.Shader;
}

#add_context imdraw_context : *Draw_Context;	// Currently active ImDraw context

Rectangle_Corners :: enum_flags
{
	NONE         :: 0x00;
	TOP_LEFT     :: 0x01;
	TOP_RIGHT    :: 0x02;
	BOTTOM_RIGHT :: 0x04;
	BOTTOM_LEFT  :: 0x08;
	ALL :: TOP_LEFT | TOP_RIGHT | BOTTOM_RIGHT | BOTTOM_LEFT;
}

check_init :: () #expand
{
	`imdraw := context.imdraw_context;
	assert (imdraw != null, "No drawing context.");
}

create_context :: inline (win : *window.Window, gl_ctx : *gl.GL_Context) -> *Draw_Context #must
{
	if !win || !gl_ctx
		return null;
	imdraw := mem.alloc (Draw_Context, mem.HEAP_ALLOC);
	if !imdraw
		return null;
	imdraw.win = win;
	imdraw.gl_ctx = gl_ctx;
	shader_ok, info_log := render.init_shader (*imdraw.default_shader, GL_VERTEX_SHADER, GL_FRAGMENT_SHADER);
	if !shader_ok
	{
		log.error ("Could not load ImDraw default shader:\n%", info_log);
		destroy_context (imdraw);
		return null;
	}
	render.init_vertex_buffer (*imdraw.vertex_buffer, Vertex.LAYOUT);
	render.allocate_vertex_buffer_data (*imdraw.vertex_buffer, MAX_VERTICES * size_of (Vertex), .DYNAMIC_DRAW);

	return imdraw;
}

destroy_context :: inline (imdraw : *Draw_Context)
{
	assert (context.imdraw_context != imdraw, "Cannot destroy ImDraw context because it is in use; end was not called.");
	render.destroy_vertex_buffer (*imdraw.vertex_buffer);
	render.destroy_shader (*imdraw.default_shader);
	mem.free (imdraw, mem.HEAP_ALLOC);
}

begin :: inline (imdraw : *Draw_Context)
{
	assert (context.imdraw_context != imdraw, "Called begin before calling end on the same context.");
	assert (context.imdraw_context == null, "Called begin but another context is in use.");
	assert (gl.get_current_context () == imdraw.gl_ctx, "Current GL context does not match ImDraw GL context.");
	context.imdraw_context = imdraw;
}

end :: inline ()
{
	flush ();
	context.imdraw_context = null;
}

flush :: inline ()
{
	check_init ();
	if imdraw.vertex_count == 0
		return;
	shader := ifx imdraw.shader then imdraw.shader else *imdraw.default_shader;
	prev_vertex_buffer := render.use_vertex_buffer (*imdraw.vertex_buffer);
	defer render.use_vertex_buffer (*prev_vertex_buffer);
	prev_shader := render.use_shader (shader);
	defer render.use_shader (*prev_shader);
	prev_texture := render.use_texture (imdraw.texture);
	defer render.use_texture (*prev_texture);
	prev_framebuffer := render.use_framebuffer_for_drawing (imdraw.framebuffer);
	defer render.use_framebuffer_for_drawing (*prev_framebuffer);

	viewport := imdraw.viewport;
	if !imdraw.framebuffer
	{
		viewport_w, viewport_h := window.get_viewport_size (imdraw.win);
		viewport.x1 = 0;
		viewport.y1 = 0;
		viewport.x2 = viewport_w;
		viewport.y2 = viewport_h;
	}
	view_projection := mat4f_orthographic_projection (
		cast (f32) viewport.x1,
		cast (f32) viewport.x2,
		cast (f32) viewport.y2,
		cast (f32) viewport.y1,
		0,
		1
	);
	gl.Viewport (viewport.x1, viewport.y1, xx math.rect_width (viewport), xx math.rect_height (viewport));
	render.set_shader_parameter (shader, "u_View_Projection_Matrix", view_projection);
	render.set_shader_parameter (shader, "u_Use_Texture", imdraw.texture != null);

	if imdraw.clipping_enabled
	{
		clip_rect := imdraw.clip_rect;
		gl.Enable (gl.SCISSOR_TEST);
		new_y1 := math.rect_height (viewport) - clip_rect.y2;
		new_y2 := math.rect_height (viewport) - clip_rect.y1;
		clip_rect.y1 = new_y1;
		clip_rect.y2 = new_y2;
		gl.Scissor (xx clip_rect.x1, xx clip_rect.y1, xx math.rect_width (clip_rect), xx math.rect_height (clip_rect));
	}
	defer gl.Disable (gl.SCISSOR_TEST);
	gl.Disable (gl.DEPTH_TEST);
	gl.Enable (gl.BLEND);
	gl.BlendFunc (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

	render.set_vertex_buffer_data (*imdraw.vertex_buffer, imdraw.vertices.data, imdraw.vertex_count * size_of (Vertex));
	gl.DrawArrays (gl.TRIANGLES, 0, xx imdraw.vertex_count);
	imdraw.vertex_count = 0;
}

reserve :: inline (count : s64) -> *Vertex #must
{
	assert (count < MAX_VERTICES, "Reserving too many vertices (requested %, maximum is %).", count, MAX_VERTICES);
	check_init ();
	if imdraw.vertex_count + count > MAX_VERTICES
		flush ();
	result := *imdraw.vertices[imdraw.vertex_count];
	imdraw.vertex_count += count;

	return result;
}

get_clip_rect :: inline () -> Recti #must
{
	check_init ();
	return imdraw.clip_rect;
}

set_clip_rect :: inline (clip_rect : Recti) -> previous : Recti
{
	check_init ();
	previous := imdraw.clip_rect;
	// We can't use operator == for rects because it is in math
	if !mem.equals (previous, clip_rect) || !imdraw.clipping_enabled then flush ();
	imdraw.clipping_enabled = true;
	imdraw.clip_rect = clip_rect;
	using imdraw.clip_rect;
	if x1 > x2 then x1 = x2;
	if y1 > y2 then y1 = y2;

	return previous;
}

push_clip_rect :: inline (clip_rect : Recti) -> previous : Recti
{
	check_init ();
	if imdraw.clipping_enabled
		return set_clip_rect (math.clip (clip_rect, imdraw.clip_rect));
	return set_clip_rect (clip_rect);
}

scope_clip_rect :: (clip_rect : Recti) #expand
{
	previous := push_clip_rect (clip_rect);
	`defer set_clip_rect (previous);
}

get_clipping :: inline () -> bool #must
{
	check_init ();
	return imdraw.clipping_enabled;
}

set_clipping :: inline (enable : bool) -> previous : bool
{
	check_init ();
	previous := imdraw.clipping_enabled;
	if previous != enable then flush ();
	imdraw.clipping_enabled = enable;
	return previous;
}

get_viewport :: inline () -> Recti #must
{
	check_init ();
	return imdraw.viewport;
}

set_viewport :: inline (viewport : Recti) -> Recti
{
	check_init ();
	previous := imdraw.viewport;
	if !mem.equals (previous, viewport) then flush ();
	imdraw.viewport = viewport;
	return previous;
}

get_texture :: inline () -> *render.Texture #must
{
	check_init ();
	return imdraw.texture;
}

set_texture :: inline (texture : *render.Texture) -> previous : *render.Texture
{
	check_init ();
	previous := imdraw.texture;
	if previous != texture then flush ();
	imdraw.texture = texture;
	return previous;
}

get_framebuffer :: inline () -> *render.Framebuffer #must
{
	check_init ();
	return imdraw.framebuffer;
}

set_framebuffer :: inline (framebuffer : *render.Framebuffer) -> *render.Framebuffer
{
	check_init ();
	previous := imdraw.framebuffer;
	if previous != framebuffer then flush ();
	imdraw.framebuffer = framebuffer;
	return previous;
}

get_shader :: inline () -> *render.Shader #must
{
	check_init ();
	return imdraw.shader;
}

set_shader :: inline (shader : *render.Shader) -> *render.Shader
{
	check_init ();
	previous := imdraw.shader;
	if previous != shader then flush ();
	imdraw.shader = shader;
	return previous;
}

#scope_file

GL_VERTEX_SHADER :: #string GLSL
#version 330 core

layout (location = 0) in vec2 a_Position;
layout (location = 1) in vec2 a_Tex_Coords;
layout (location = 2) in vec4 a_Color;

out vec2 Tex_Coords;
out vec4 Color;

uniform mat4 u_View_Projection_Matrix;

void main ()
{
	gl_Position = u_View_Projection_Matrix * vec4 (a_Position, 0, 1);
	Tex_Coords = a_Tex_Coords;
	Color      = a_Color;
}
GLSL

GL_FRAGMENT_SHADER :: #string GLSL
#version 330 core

in vec2 Tex_Coords;
in vec4 Color;

out vec4 Frag_Color;

uniform sampler2D u_Texture;
uniform bool u_Use_Texture;

void main ()
{
	vec4 sampled = vec4 (1, 1, 1, 1);
	if (u_Use_Texture)
		sampled = texture (u_Texture, Tex_Coords);
	Frag_Color = sampled * Color;
}
GLSL
