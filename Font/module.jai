#module_parameters (DEFAULT_FONT_ATLAS_WIDTH : u32 = 1024, DEFAULT_FONT_ATLAS_HEIGHT : u32 = 1024);

// @Note (stefan): We used to use ImDraw to draw the glyphs into a font atlas.
// The problem is, with the way we designed ImDraw contexts, we can't render glyphs
// in between debug_draw_begin and debug_draw_end calls because imdraw_begin hasn't
// been called. We can't have a Debug_Draw context and an ImDraw context active at
// the same time, because ImDraw is used for 2D, and draw calls should be made after
// every 3D draw calls. The thing is, Font draws to its own framebuffers, and it's ok
// in this case to mangle Debug_Draw and ImDraw flushes. But again, we can't have these
// two modules do their thing at the same time. All this is a problem because we 
// want to be able to draw debug text using Debug_Draw.
// The solution might be to make an ImDraw context specifically for the Font module,
// meaning we'd call imdraw_begin and imdraw_end for each glyph rendered. This is
// tedious, and we'd lose the benefit of using ImDraw anyway, since we won't be
// buffering vertices (although we already don't even do that in practice, since
// we almost always have a render_glyph followed by an imdraw_rect call,
// so we have a flush for both calls because we change the framebuffer).
// For this reason, I've decided instead to do the all the glyph rendering
// without ImDraw.
//
//											7 February 2022

#scope_module

#import "Runtime";
mem    :: #import "Memory";
str    :: #import "String";
path   :: #import "Path";
log    :: #import "Log";
using linalg :: #import "Linalg";
math   :: #import "Math";
array  :: #import "Containers/Array";
map    :: #import "Containers/Hash_Map";
for_expansion :: map.for_expansion;
list   :: #import "Containers/List";
for_expansion :: list.for_expansion;
gl     :: #import "GL";
render :: #import "Render_Core";
ft     :: #import "freetype255";

#scope_export

Weight :: enum s8
{
	INVALID :: -1;
	UNKNOWN :: 0;
	THIN    :: 1;
	LIGHT   :: 3;
	REGULAR :: 4;
	MEDIUM  :: 5;
	BOLD    :: 7;
	BLACK   :: 8;
}

Effects :: enum_flags u8
{
	NONE   :: 0x00;
	ITALIC :: 0x01;
}

Font :: struct
{
	filename : string;
	weight  : Weight;
	effects : Effects;
	ft_face : ft.Face;
	pages : map.Hash_Map (u32, Page);
	prev : *Font;	// In a Font_Family
	next : *Font;	// In a Font_Family
}

Glyph :: struct
{
	codepoint : u32;

	rendered : bool;
	width, height : u32;
	bearing_x, bearing_y : s32;
	advance : u32;
	bitmap_bearing_x, bitmap_bearing_y : s32;
	bitmap_width, bitmap_height : u32;

	uv_rect : math.Rectf;
	atlas_texture : *render.Texture;
}

Page :: struct
{
	font    : *Font;
	height  : u32;
	atlases : [..]Atlas;
	glyphs  : map.Hash_Map (u32, Glyph);
	ascent, descent : s32;	// ascent is positive and goes upwards, descent is negative and goes downward. This might be confusing.
	space_advance : u32;
}

Atlas :: struct
{
	texture     : render.Texture;
	framebuffer : render.Framebuffer;
	width, height : u32;
	pen_x, pen_y  : u32;
	row_end : u32;
}

#scope_file

Vertex :: struct
{
	position : Vec2f;
	tex_coords : Vec2f;
	color : math.RGBA;

	LAYOUT :: render.Vertex_Buffer.Elem.[
		render.Vertex_Buffer.VEC2F,
		render.Vertex_Buffer.VEC2F,
		render.Vertex_Buffer.RGBA,
	];
}

g_ft_lib : *ft.Library;
g_rect_vertex_buffer : render.Vertex_Buffer;

#scope_export

g_glyph_shader : render.Shader;

init :: inline () -> bool
{
	ft_err := ft.Init_FreeType (*g_ft_lib);
	if ft_err != ft.Err_Ok
		return log.error ("Could not initialize FreeType. Error was %.", ft_err);
	ok, info_log := render.init_shader (*g_glyph_shader, GL_GLYPH_VERTEX_SHADER, GL_GLYPH_FRAGMENT_SHADER);
	if !ok
		return log.error ("Could not initialize glyph shader:\n%", info_log);
	render.init_vertex_buffer (*g_rect_vertex_buffer, Vertex.LAYOUT);
	render.allocate_vertex_buffer_data (*g_rect_vertex_buffer, 6 * size_of (Vertex), .DYNAMIC_DRAW);

	return true;
}

cleanup :: inline ()
{
	ft.Done_FreeType (g_ft_lib);
}

find_font :: inline (family : *Font, weight : Weight, effects : Effects, fallback : *Font = null) -> *Font #must
{
	for family
	{
		if it.weight == weight && it.effects == effects
			return it;
	}
	return fallback;
}

get_weight_and_effects :: (suffix : string) -> Weight, Effects
{
	if suffix ==
	{
	case "-Thin";
		return .THIN, .NONE;
	case "-ThinItalic";
		return .THIN, .ITALIC;
	case "-Light";
		return .LIGHT, .NONE;
	case "-LightItalic";
		return .LIGHT, .ITALIC;
	case "-Regular";
		return .REGULAR, .NONE;
	case "-Italic";
		return .REGULAR, .ITALIC;
	case "-Medium";
		return .MEDIUM, .NONE;
	case "-MediumItalic";
		return .MEDIUM, .ITALIC;
	case "-Bold";
		return .BOLD, .NONE;
	case "-BoldItalic";
		return .BOLD, .ITALIC;
	case "-Black";
		return .BLACK, .NONE;
	case "-BlackItalic";
		return .BLACK, .ITALIC;
	}
	return .INVALID, .NONE;
}

load_from_file :: inline (font : *Font, filename : string) -> bool
{
	if !g_ft_lib && !init ()
		return false;
	ft_face : ft.Face;
	ft_err := ft.New_Face (g_ft_lib, str.clone_to_cstring (filename, mem.TEMP_ALLOC), 0, *ft_face);
	if ft_err != ft.Err_Ok
		return log.error ("Could not load FT_Face from file '%'. Error was %.", filename, ft_err);
	font.filename = filename;
	font.ft_face = ft_face;
	map.init (*font.pages, 10, mem.HEAP_ALLOC);
	suffix := path.remove_extension (font.filename);
	dash_index := str.find_last (suffix, #char "-");
	if dash_index != -1
	{
		suffix = str.advance (suffix, dash_index);
		font.weight, font.effects = get_weight_and_effects (suffix);
	}

	return true;
}

load_family :: inline (search_dir : string, name : string, allocator : Allocator, recursive := true) -> *Font #must
{
	fs :: #import "File_System";
	for_expansion :: fs.for_expansion;

	flags := fs.File_Search.Flags.VISIT_FILES;
	if recursive
		flags |= .RECURSIVE;
	result : *Font;
	tmp_font : Font;
	for info : fs.file_search (search_dir, flags)
	{
		basename := path.remove_extension (info.name);
		if str.starts_with (basename, name)
		{
			weight, effects := get_weight_and_effects (str.advance (basename, name.count));
			if weight == .INVALID
				continue;
			mem.init (*tmp_font);
			if load_from_file (*tmp_font, info.full_name)
			{
				ptr := mem.alloc (Font, allocator);
				<<ptr = tmp_font;
				list.push (*result, ptr);
			}
		}
	}
	// Make regular font the first in the family
	regular := find_font (result, .REGULAR, .NONE);
	if regular
	{
		list.pop (*result, regular);
		list.push_front (*result, regular);
	}
	return result;
}

destroy_family :: inline (family : **Font, allocator : Allocator)
{
	for (<<family)
	{
		destroy (it);
		mem.free (it, allocator);
	}
	family = null;
}

destroy :: (using font : *Font)
{
	filename = "";
	ft.Done_Face (ft_face);
	ft_face = null;
	for * page, height : pages
	{
		for atlas, i : page.atlases
		{
			render.destroy_framebuffer (*atlas.framebuffer);
			render.destroy_texture (*atlas.texture);
		}
		array.reset (*page.atlases);
		map.reset (*page.glyphs);
	}
	map.reset (*pages);
}

load_page :: inline (using font : *Font, height : u32) -> *Page
{
	page, was_present := map.insert (*pages, height);
	if was_present then return page;
	page.font   = font;
	page.height = height;
	array.init (*page.atlases, 3, mem.HEAP_ALLOC);
	map.init (*page.glyphs, 512, mem.HEAP_ALLOC);
	space_glyph := load_glyph (page, #char " ");
	page.ascent        = xx (ft_face.size.metrics.ascender >> 6);
	page.descent       = xx (ft_face.size.metrics.descender >> 6);
	page.space_advance = xx (space_glyph.advance);

	return page;
}

add_atlas_to_page :: inline (using page : *Page, atlas_width := DEFAULT_FONT_ATLAS_WIDTH, atlas_height := DEFAULT_FONT_ATLAS_HEIGHT) -> *Atlas
{
	result := array.push (*atlases);
	result.width  = atlas_width;
	result.height = atlas_height;
	render.init_texture (*result.texture, atlas_width, atlas_height, 4, null);
	ok := render.init_framebuffer (*result.framebuffer, *result.texture);
	assert (ok, "Could not init atlas framebuffer.");

	return result;
}

load_glyph :: inline (font : *Font, codepoint : u32, height : u32) -> *Glyph
{
	return load_glyph (load_page (font, height), codepoint);
}

render_glyph :: inline (font : *Font, codepoint : u32, height : u32) -> *Glyph
{
	return render_glyph (load_page (font, height), codepoint);
}

load_glyph :: (using page : *Page, codepoint : u32) -> *Glyph
{
	glyph, was_present := map.insert (*glyphs, codepoint);
	if was_present
		return glyph;
	ft.Set_Pixel_Sizes (font.ft_face, 0, height);
	ft_error := ft.Load_Char (font.ft_face, codepoint, ft.LOAD_DEFAULT);
	assert (ft_error == ft.Err_Ok, "Could not load glyph %.", codepoint);
	slot := font.ft_face.glyph;

	glyph.codepoint = codepoint;
	glyph.width     = xx (slot.metrics.width  >> 6);
	glyph.height    = xx (slot.metrics.height >> 6);
	glyph.bearing_x = xx (slot.metrics.horiBearingX >> 6);
	glyph.bearing_y = xx (slot.metrics.horiBearingY >> 6);
	glyph.advance   = xx (slot.metrics.horiAdvance >> 6);
	
	glyph.bitmap_width     = xx slot.bitmap.width;
	glyph.bitmap_height    = xx slot.bitmap.rows;
	glyph.bitmap_bearing_x = xx slot.bitmap_left;
	glyph.bitmap_bearing_y = xx slot.bitmap_top;

	return glyph;
}

render_glyph :: (using page : *Page, codepoint : u32) -> *Glyph
{
	glyph, was_present := map.insert (*glyphs, codepoint);
	if was_present && glyph.rendered
		return glyph;
	ft.Set_Pixel_Sizes (font.ft_face, 0, height);
	ft_error := ft.Load_Char (font.ft_face, codepoint, ft.LOAD_RENDER);
	assert (ft_error == ft.Err_Ok, "Could not load glyph %.", codepoint);
	slot := font.ft_face.glyph;

	glyph.codepoint = codepoint;
	glyph.width     = xx (slot.metrics.width  >> 6);
	glyph.height    = xx (slot.metrics.height >> 6);
	glyph.bearing_x = xx (slot.metrics.horiBearingX >> 6);
	glyph.bearing_y = xx (slot.metrics.horiBearingY >> 6);
	glyph.advance   = xx (slot.metrics.horiAdvance >> 6);
	
	glyph.bitmap_width     = xx slot.bitmap.width;
	glyph.bitmap_height    = xx slot.bitmap.rows;
	glyph.bitmap_bearing_x = xx slot.bitmap_left;
	glyph.bitmap_bearing_y = xx slot.bitmap_top;

	atlas : *Atlas;
	for * atlases
	{
		if it.width - it.pen_y > glyph.bitmap_width && it.height - it.pen_y > glyph.bitmap_height
		{
			atlas = it;
			break;
		}
	}
	if !atlas then atlas = add_atlas_to_page (page);

	if atlas.width - atlas.pen_x < glyph.bitmap_width || atlas.height - atlas.pen_y < glyph.bitmap_height
	{
		atlas.pen_x = 0;
		atlas.pen_y = atlas.row_end;
		atlas.row_end += glyph.bitmap_height;
	}

	glyph.uv_rect = math.rectf (
		atlas.pen_x / cast (f32) atlas.width,
		1 - atlas.pen_y / cast (f32) atlas.height,
		(atlas.pen_x + glyph.bitmap_width) / cast (f32) atlas.width,
		1 - (atlas.pen_y + glyph.bitmap_height) / cast (f32) atlas.height
	);
	glyph.atlas_texture = *atlas.texture;

	glyph_texture : render.Texture;
	render.init_texture (*glyph_texture, glyph.bitmap_width, glyph.bitmap_height, 1, slot.bitmap.buffer);
	defer render.destroy_texture (*glyph_texture);
	prev_texture := render.use_texture (*glyph_texture);
	defer render.use_texture (*prev_texture);
	prev_framebuffer := render.use_framebuffer_for_drawing (*atlas.framebuffer);
	defer render.use_framebuffer_for_drawing (*prev_framebuffer);
	prev_shader := render.use_shader (*g_glyph_shader);
	defer render.use_shader (*prev_shader);
	prev_vertex_buffer := render.use_vertex_buffer (*g_rect_vertex_buffer);
	defer render.use_vertex_buffer (*prev_vertex_buffer);
	gl.Viewport (0, 0, xx atlas.width, xx atlas.height);
	gl.Disable (gl.SCISSOR_TEST);
	gl.Disable (gl.DEPTH_TEST);
	gl.Enable (gl.BLEND);
	gl.BlendFunc (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

	rect_vertices : [6]Vertex = ---;
	rect_vertices[0].position = vec2f (xx atlas.pen_x, xx (atlas.pen_y + glyph.bitmap_height));
	rect_vertices[0].tex_coords = vec2f (0, 1);
	rect_vertices[0].color = math.RGBA_WHITE;
	rect_vertices[1].position = vec2f (xx atlas.pen_x, xx atlas.pen_y);
	rect_vertices[1].tex_coords = vec2f (0, 0);
	rect_vertices[1].color = math.RGBA_WHITE;
	rect_vertices[2].position = vec2f (xx (atlas.pen_x + glyph.bitmap_width), xx atlas.pen_y);
	rect_vertices[2].tex_coords = vec2f (1, 0);
	rect_vertices[2].color = math.RGBA_WHITE;

	rect_vertices[3] = rect_vertices[0];
	rect_vertices[4] = rect_vertices[2];
	rect_vertices[5].position = vec2f (xx (atlas.pen_x + glyph.bitmap_width), xx (atlas.pen_y + glyph.bitmap_height));
	rect_vertices[5].tex_coords = vec2f (1, 1);
	rect_vertices[5].color = math.RGBA_WHITE;

	view_projection := mat4f_orthographic_projection (0, cast (f32) atlas.width, cast (f32) atlas.height, 0, 0, 1);
	render.set_shader_parameter (*g_glyph_shader, "u_View_Projection_Matrix", view_projection);
	render.set_shader_parameter (*g_glyph_shader, "u_Use_Texture", true);
	render.set_vertex_buffer_data (*g_rect_vertex_buffer, rect_vertices.data, rect_vertices.count * size_of (Vertex));
	gl.DrawArrays (gl.TRIANGLES, 0, rect_vertices.count);

	atlas.pen_x += glyph.bitmap_width;
	atlas.row_end = math.max (atlas.row_end, atlas.pen_y + glyph.bitmap_height);
	glyph.rendered = true;

	return glyph;
}

calculate_text_extents :: inline (font : *Font, height : u32, text : string) -> Vec2f #must
{
	utf8 :: #import "Unicode/UTF8";
	for_expansion :: utf8.for_expansion;

	page := load_page (font, height);
	width : f32;
	pen := vec2f (0, cast (f32) page.ascent);
	for codepoint, i : utf8.make_str (text)
	{
		if codepoint ==
		{
		case #char "\n";
			width = math.max (width, pen.x);
			pen.x = 0;
			pen.y += page.ascent - page.descent;
		case #char "\t";
			glyph := load_glyph (page, codepoint);
			pen.x = math.snap_up (pen.x + glyph.advance, page.space_advance * 4.0);
			width = math.max (width, pen.x);
		case;
			glyph := load_glyph (page, codepoint);
			pen.x += glyph.advance;
			width = math.max (width, pen.x);
		}
	}

	return vec2f (width, pen.y - page.descent);
}

#scope_file

// We have the same shader parameters as ImDraw requires so we can use
// this shader with ImDraw.

GL_GLYPH_VERTEX_SHADER :: #string GLSL
#version 330 core

layout (location = 0) in vec2 a_Position;
layout (location = 1) in vec2 a_Tex_Coords;
layout (location = 2) in vec4 a_Color;

uniform mat4 u_View_Projection_Matrix;

out vec4 Vertex_Color;
out vec2 Tex_Coords;

void main ()
{
	gl_Position = u_View_Projection_Matrix * vec4 (a_Position, 0, 1);
	Vertex_Color = a_Color;
	Tex_Coords = a_Tex_Coords;
}
GLSL

GL_GLYPH_FRAGMENT_SHADER :: #string GLSL
#version 330 core

in vec2 Tex_Coords;
in vec4 Vertex_Color;
out vec4 Frag_Color;

uniform sampler2D u_Texture;
uniform bool u_Use_Texture;

void main ()
{
	if (u_Use_Texture)
	{
		float alpha = texture (u_Texture, Tex_Coords).r;
		Frag_Color = vec4 (1, 1, 1, alpha) * Vertex_Color;
	}
	else
	{
		Frag_Color = Vertex_Color;
	}
}
GLSL
