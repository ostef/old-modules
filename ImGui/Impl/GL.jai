#scope_module

#import "Runtime";
str   :: #import "String";
imgui :: #import "ImGui";
gl    :: #import "GL";
mem   :: #import "Memory";
log   :: #import "Log";

#scope_export

Renderer_Data :: struct
{
	initialized_device_objects : bool;
	font_texture  : gl.GLuint;
	shader_handle : gl.GLuint;
	attrib_location_tex : gl.GLint;
	attrib_location_proj_mtx : gl.GLint;
	attrib_location_vtx_pos : gl.GLint;
	attrib_location_vtx_uv : gl.GLint;
	attrib_location_vtx_color : gl.GLint;
	vbo, ibo : gl.GLuint;
	vertex_buffer_size : s64;
	index_buffer_size : s64;
	use_buffer_sub_data : bool;
}

get_renderer_user_data :: inline () -> *Renderer_Data #must
{
	return ifx imgui.GetCurrentContext () != null
		then cast (*Renderer_Data) imgui.GetIO ().BackendRendererUserData
		else null;
}

init :: () -> bool
{
	io := imgui.GetIO ();

	data := mem.alloc (Renderer_Data);
	io.BackendRendererName = "OpenGL";
	io.BackendRendererUserData = cast (*void) data;
	io.BackendFlags_ |= .RendererHasVtxOffset;

	return true;
}

terminate :: ()
{
	destroy_device_objects ();

	io := imgui.GetIO ();
	io.BackendRendererName = null;
	io.BackendRendererUserData = null;

	data := get_renderer_user_data ();
	mem.free (data);
}

new_frame :: ()
{
	data := get_renderer_user_data ();
	if !data.initialized_device_objects
		create_device_objects ();
}

setup_render_state :: (draw_data : *imgui.ImDrawData, fw : s32, fh : s32, vao : gl.GLuint)
{
	data := get_renderer_user_data ();

	gl.Enable (gl.BLEND);
	gl.BlendEquation (gl.FUNC_ADD);
	gl.BlendFuncSeparate (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE_MINUS_SRC_ALPHA);
	gl.Disable (gl.CULL_FACE);
	gl.Disable (gl.DEPTH_TEST);
	gl.Disable (gl.STENCIL_TEST);
	gl.Enable (gl.SCISSOR_TEST);
	gl.PolygonMode (gl.FRONT_AND_BACK, gl.FILL);

	gl.Viewport (0, 0, xx fw, xx fh);
	l := draw_data.DisplayPos.x;
	r := draw_data.DisplayPos.x + draw_data.DisplaySize.x;
	t := draw_data.DisplayPos.y;
	b := draw_data.DisplayPos.y + draw_data.DisplaySize.y;

	ortho_projection : [4][4]f32;
	ortho_projection[0][0] = 2.0 / (r - l);
	ortho_projection[1][1] = 2.0 / (t - b);
	ortho_projection[2][2] = -1;
	ortho_projection[3][0] = (r + l) / (l - r);
	ortho_projection[3][1] = (t + b) / (b - t);
	ortho_projection[3][3] = 1;

	gl.UseProgram (data.shader_handle);
	gl.Uniform1i (data.attrib_location_tex, 0);
	gl.UniformMatrix4fv (data.attrib_location_proj_mtx, 1, gl.FALSE, *ortho_projection[0][0]);

	gl.BindSampler (0, 0);
	gl.BindVertexArray (vao);
	gl.BindBuffer (gl.ARRAY_BUFFER, data.vbo);
	gl.BindBuffer (gl.ELEMENT_ARRAY_BUFFER, data.ibo);

	gl.EnableVertexAttribArray (xx data.attrib_location_vtx_pos);
	gl.EnableVertexAttribArray (xx data.attrib_location_vtx_uv);
	gl.EnableVertexAttribArray (xx data.attrib_location_vtx_color);

	gl.VertexAttribPointer (xx data.attrib_location_vtx_pos, 2, gl.FLOAT, gl.FALSE, size_of (imgui.ImDrawVert), cast (*void) offset_of (imgui.ImDrawVert, "pos"));
	gl.VertexAttribPointer (xx data.attrib_location_vtx_uv, 2, gl.FLOAT, gl.FALSE, size_of (imgui.ImDrawVert), cast (*void) offset_of (imgui.ImDrawVert, "uv"));
	gl.VertexAttribPointer (xx data.attrib_location_vtx_color, 4, gl.UNSIGNED_BYTE, gl.TRUE, size_of (imgui.ImDrawVert), cast (*void) offset_of (imgui.ImDrawVert, "col"));
}

render_draw_data :: (draw_data : *imgui.ImDrawData)
{
	fw := cast (s32) (draw_data.DisplaySize.x * draw_data.FramebufferScale.x);
	fh := cast (s32) (draw_data.DisplaySize.y * draw_data.FramebufferScale.y);
	if fw <= 0 || fh <= 0
		return;
	
	data := get_renderer_user_data ();

	prev_active_texture : gl.GLint;
	gl.GetIntegerv (gl.ACTIVE_TEXTURE, *prev_active_texture);
	gl.ActiveTexture (gl.TEXTURE0);
	prev_shader, prev_texture, prev_sampler : gl.GLuint;
	gl.GetIntegerv (gl.CURRENT_PROGRAM, cast (*gl.GLint) *prev_shader);
	gl.GetIntegerv (gl.TEXTURE_BINDING_2D, cast (*gl.GLint) *prev_texture);
	gl.GetIntegerv (gl.SAMPLER_BINDING, cast (*gl.GLint) *prev_sampler);
	
	prev_vbo, prev_ibo, prev_vao : gl.GLuint;
	gl.GetIntegerv (gl.ARRAY_BUFFER_BINDING, cast (*gl.GLint) *prev_vbo);
	gl.GetIntegerv (gl.ELEMENT_ARRAY_BUFFER_BINDING, cast (*gl.GLint) *prev_ibo);
	gl.GetIntegerv (gl.VERTEX_ARRAY_BINDING, cast (*gl.GLint) *prev_vao);

	prev_polygon_mode : [2]gl.GLint = ---;
	gl.GetIntegerv (gl.POLYGON_MODE, prev_polygon_mode.data);
	prev_viewport : [4]gl.GLint = ---;
	gl.GetIntegerv (gl.VIEWPORT, prev_viewport.data);
	prev_scissor_box : [4]gl.GLint = ---;
	gl.GetIntegerv (gl.SCISSOR_BOX, prev_scissor_box.data);

	prev_blend_src_rgb, prev_blend_dst_rgb, prev_blend_src_a, prev_blend_dst_a : gl.GLint;
	gl.GetIntegerv (gl.BLEND_SRC_RGB, *prev_blend_src_rgb);
	gl.GetIntegerv (gl.BLEND_DST_RGB, *prev_blend_dst_rgb);
	gl.GetIntegerv (gl.BLEND_SRC_ALPHA, *prev_blend_src_a);
	gl.GetIntegerv (gl.BLEND_DST_ALPHA, *prev_blend_dst_a);

	prev_blend_equation_rgb, prev_blend_equation_a : gl.GLint;
	gl.GetIntegerv (gl.BLEND_EQUATION_RGB, *prev_blend_equation_rgb);
	gl.GetIntegerv (gl.BLEND_EQUATION_ALPHA, *prev_blend_equation_a);

	blend_was_enabled        := cast (bool) gl.IsEnabled (gl.BLEND);
	cull_face_was_enabled    := cast (bool) gl.IsEnabled (gl.CULL_FACE);
	depth_test_was_enabled   := cast (bool) gl.IsEnabled (gl.DEPTH_TEST);
	stencil_test_was_enabled := cast (bool) gl.IsEnabled (gl.STENCIL_TEST);
	scissor_test_was_enabled := cast (bool) gl.IsEnabled (gl.SCISSOR_TEST);
	
	// We recreate the VAO every time to easily allow multiple GL contexts, since
	// they are not shared among GL contexts (I am not even sure what is and what isn't)
	vao : gl.GLuint;
	gl.GenVertexArrays (1, *vao);

	setup_render_state (draw_data, fw, fh, vao);

	clip_off := draw_data.DisplayPos;
	clip_scale := draw_data.FramebufferScale;

	// Actual interesting stuff
	for n : 0..draw_data.CmdListsCount - 1
	{
		cmd_list := draw_data.CmdLists[n];
		// Upload vertex/index buffers
		// - On Intel windows drivers we got reports that regular glBufferData() led to accumulating leaks when using multi-viewports, so we started using orphaning + glBufferSubData(). (See https://github.com/ocornut/imgui/issues/4468)
		// - On NVIDIA drivers we got reports that using orphaning + glBufferSubData() led to glitches when using multi-viewports.
		// - OpenGL drivers are in a very sorry state in 2022, for now we are switching code path based on vendors.
		vtx_buffer_size := cmd_list.VtxBuffer.Size * size_of (imgui.ImDrawVert);
		idx_buffer_size := cmd_list.IdxBuffer.Size * size_of (imgui.ImDrawIdx);
		if data.use_buffer_sub_data
		{
			if data.vertex_buffer_size < vtx_buffer_size
				gl.BufferData (gl.ARRAY_BUFFER, vtx_buffer_size, null, gl.STREAM_DRAW);
			if data.index_buffer_size < idx_buffer_size
				gl.BufferData (gl.ELEMENT_ARRAY_BUFFER, idx_buffer_size, null, gl.STREAM_DRAW);
			gl.BufferSubData (gl.ARRAY_BUFFER, 0, vtx_buffer_size, cmd_list.VtxBuffer.Data);
			gl.BufferSubData (gl.ELEMENT_ARRAY_BUFFER, 0, idx_buffer_size, cmd_list.IdxBuffer.Data);
		}
		else
		{
			gl.BufferData (gl.ARRAY_BUFFER, vtx_buffer_size, cmd_list.VtxBuffer.Data, gl.STREAM_DRAW);
			gl.BufferData (gl.ELEMENT_ARRAY_BUFFER, idx_buffer_size, cmd_list.IdxBuffer.Data, gl.STREAM_DRAW);
		}

		data.vertex_buffer_size = vtx_buffer_size;
		data.index_buffer_size = idx_buffer_size;

		for cmd_i : 0..cmd_list.CmdBuffer.Size - 1
		{
			cmd := *cmd_list.CmdBuffer.Data[cmd_i];
			// User callback, registered via ImDrawList::AddCallback()
			// (ImDrawCallback_ResetRenderState is a special callback value used by the user to request the renderer to reset render state.)
			if cast (*void) cmd.UserCallback == cast (*void) imgui.ImDrawCallback_ResetRenderState
				setup_render_state (draw_data, fw, fh, vao);
			else if cmd.UserCallback
				cmd.UserCallback (cmd_list, cmd);
			else
			{
				// Project scissor/clipping rects into framebuffer space
				clip_x1 := (cmd.ClipRect.x - clip_off.x) * clip_scale.x;
				clip_y1 := (cmd.ClipRect.y - clip_off.y) * clip_scale.y;
				clip_x2 := (cmd.ClipRect.z - clip_off.x) * clip_scale.x;
				clip_y2 := (cmd.ClipRect.w - clip_off.y) * clip_scale.y;
				if clip_x2 <= clip_x1 || clip_y2 <= clip_y1
					continue;
				
				// Apply scissor/clipping rects (OpenGL is bottom-left)
				gl.Scissor (xx clip_x1, xx (fh - clip_y2), xx (clip_x2 - clip_x1), xx (clip_y2 - clip_y1));

				gl.BindTexture (gl.TEXTURE_2D, cast (gl.GLuint) cmd.TextureId);
				gl.DrawElementsBaseVertex (gl.TRIANGLES, cmd.ElemCount, xx ifx size_of (imgui.ImDrawIdx) == 2 then gl.UNSIGNED_SHORT else gl.UNSIGNED_INT, xx (cmd.IdxOffset * size_of (imgui.ImDrawIdx)), xx cmd.VtxOffset);
			}
		}
	}

	gl.DeleteVertexArrays (1, *vao);

	// Restore old GL state
	gl.UseProgram (prev_shader);
	gl.BindTexture (gl.TEXTURE_2D, prev_texture);
	gl.BindSampler (0, prev_sampler);
	gl.ActiveTexture (xx prev_active_texture);
	gl.BindVertexArray (prev_vao);
	gl.BindBuffer (gl.ARRAY_BUFFER, prev_vbo);
	gl.BindBuffer (gl.ELEMENT_ARRAY_BUFFER, prev_ibo);
	gl.BlendEquationSeparate (xx prev_blend_equation_rgb, xx prev_blend_equation_a);
	gl.BlendFuncSeparate (xx prev_blend_src_rgb, xx prev_blend_dst_rgb, xx prev_blend_src_a, xx prev_blend_dst_a);
	ifx blend_was_enabled        then gl.Enable (gl.BLEND)        else gl.Disable (gl.BLEND);
	ifx cull_face_was_enabled    then gl.Enable (gl.CULL_FACE)    else gl.Disable (gl.CULL_FACE);
	ifx depth_test_was_enabled   then gl.Enable (gl.DEPTH_TEST)   else gl.Disable (gl.DEPTH_TEST);
	ifx stencil_test_was_enabled then gl.Enable (gl.STENCIL_TEST) else gl.Disable (gl.STENCIL_TEST);
	ifx scissor_test_was_enabled then gl.Enable (gl.SCISSOR_TEST) else gl.Disable (gl.SCISSOR_TEST);
	gl.PolygonMode (gl.FRONT_AND_BACK, xx prev_polygon_mode[0]);
	gl.Viewport (prev_viewport[0], prev_viewport[1], xx prev_viewport[2], xx prev_viewport[3]);
	gl.Scissor (prev_scissor_box[0], prev_scissor_box[1], xx prev_scissor_box[2], xx prev_scissor_box[3]);
}

create_fonts_texture :: () -> bool
{
	io := imgui.GetIO ();
	data := get_renderer_user_data ();

	pixels : *u8;
	width, height : s32;
	io.Fonts.GetTexDataAsRGBA32 (io.Fonts, *pixels, *width, *height);

	prev_texture : gl.GLuint;
	gl.GetIntegerv (gl.TEXTURE_BINDING_2D, cast (*gl.GLint) *prev_texture);
	gl.GenTextures (1, *data.font_texture);
	gl.BindTexture (gl.TEXTURE_2D, data.font_texture);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
	gl.TexImage2D (gl.TEXTURE_2D, 0, gl.RGBA, xx width, xx height, 0, gl.RGBA, gl.UNSIGNED_BYTE, pixels);

	// There is ImFontAtlas::SetTexId, but since it is an inlined function it did not get outputted by the Bindings Generator
	io.Fonts.TexID = cast (imgui.ImTextureID) data.font_texture;

	gl.BindTexture (gl.TEXTURE_2D, prev_texture);

	return true;
}

destroy_fonts_texture :: ()
{
	io := imgui.GetIO ();
	data := get_renderer_user_data ();

	if data.font_texture
	{
		gl.DeleteTextures (1, *data.font_texture);
		io.Fonts.TexID = cast (imgui.ImTextureID) 0;
		data.font_texture = 0;
	}
}

create_device_objects :: () -> bool
{
	data := get_renderer_user_data ();

	prev_texture, prev_vbo, prev_vao : gl.GLuint;

	gl.GetIntegerv (gl.TEXTURE_BINDING_2D, cast (*gl.GLint) *prev_texture);
	defer gl.BindTexture (gl.TEXTURE_2D, prev_texture);

	gl.GetIntegerv (gl.ARRAY_BUFFER_BINDING, cast (*gl.GLint) *prev_vbo);
	defer gl.BindBuffer (gl.ARRAY_BUFFER, prev_vbo);

	gl.GetIntegerv (gl.VERTEX_ARRAY_BINDING, cast (*gl.GLint) *prev_vao);
	defer gl.BindVertexArray (prev_vao);

	// Create shader program
	vert_shader_src := VERTEX_SHADER;
	vert_shader := gl.CreateShader (gl.VERTEX_SHADER);
	defer gl.DeleteShader (vert_shader);

	gl.ShaderSource (vert_shader, 1, *vert_shader_src.data, null);
	gl.CompileShader (vert_shader);

	if !check_gl_shader (vert_shader, "vertex shader")
		return false;

	frag_shader_src := FRAGMENT_SHADER;
	frag_shader := gl.CreateShader (gl.FRAGMENT_SHADER);
	defer gl.DeleteShader (frag_shader);

	gl.ShaderSource (frag_shader, 1, *frag_shader_src.data, null);
	gl.CompileShader (frag_shader);

	if !check_gl_shader (frag_shader, "fragment shader")
		return false;

	data.shader_handle = gl.CreateProgram ();

	gl.AttachShader (data.shader_handle, vert_shader);
	defer gl.DetachShader (data.shader_handle, vert_shader);
	gl.AttachShader (data.shader_handle, frag_shader);
	defer gl.DetachShader (data.shader_handle, frag_shader);
	
	gl.LinkProgram (data.shader_handle);

	if !check_gl_program (data.shader_handle, "shader program")
		return false;

	data.attrib_location_tex = gl.GetUniformLocation (data.shader_handle, "u_Texture");
	data.attrib_location_proj_mtx = gl.GetUniformLocation (data.shader_handle, "u_Projection_Mtx");
	data.attrib_location_vtx_pos = gl.GetAttribLocation (data.shader_handle, "a_Position");
	data.attrib_location_vtx_uv = gl.GetAttribLocation (data.shader_handle, "a_UV");
	data.attrib_location_vtx_color = gl.GetAttribLocation (data.shader_handle, "a_Color");

	gl.GenBuffers (1, *data.vbo);
	gl.GenBuffers (1, *data.ibo);

	if !create_fonts_texture ()
		return false;

	data.initialized_device_objects = true;

	return true;

	VERTEX_SHADER :: #string GLSL
#version 330 core

layout (location = 0) in vec2 a_Position;
layout (location = 1) in vec2 a_UV;
layout (location = 2) in vec4 a_Color;

uniform mat4 u_Projection_Mtx;

out vec2 Frag_UV;
out vec4 Frag_Color;

void main ()
{
	Frag_UV = a_UV;
	Frag_Color = a_Color;
	gl_Position = u_Projection_Mtx * vec4 (a_Position.xy, 0, 1);
}
GLSL

	FRAGMENT_SHADER :: #string GLSL
#version 330 core

in vec2 Frag_UV;
in vec4 Frag_Color;

uniform sampler2D u_Texture;

layout (location = 0) out vec4 Out_Color;

void main ()
{
	Out_Color = Frag_Color * texture (u_Texture, Frag_UV.st);
}
GLSL

}

destroy_device_objects :: ()
{
	data := get_renderer_user_data ();

	if data.vbo
	{
		gl.DeleteBuffers (1, *data.vbo);
		data.vbo = 0;
	}

	if data.ibo
	{
		gl.DeleteBuffers (1, *data.ibo);
		data.ibo = 0;
	}

	if data.shader_handle
	{
		gl.DeleteProgram (data.shader_handle);
		data.shader_handle = 0;
	}

	destroy_fonts_texture ();

	data.initialized_device_objects = false;
}

check_gl_shader :: (handle : gl.GLuint, desc : string) -> bool
{
	status, log_length : gl.GLint;
	gl.GetShaderiv (handle, gl.COMPILE_STATUS, *status);
	gl.GetShaderiv (handle, gl.INFO_LOG_LENGTH, *log_length);

	if !status
	{
		if log_length > 1
		{
			buffer := mem.alloc (log_length + 1, mem.TEMP_ALLOC);
			gl.GetShaderInfoLog (handle, xx log_length, null, buffer);
			log.error ("create_device_objects: failed to compile %. Info:\n%", desc, str.make (buffer, log_length));
		}
		else
			log.error ("create_device_objects: failed to compile %.", desc);
	}

	return status != 0;
}

check_gl_program :: (handle : gl.GLuint, desc : string) -> bool
{
	status, log_length : gl.GLint;
	gl.GetProgramiv (handle, gl.LINK_STATUS, *status);
	gl.GetProgramiv (handle, gl.INFO_LOG_LENGTH, *log_length);

	if !status
	{
		if log_length > 1
		{
			buffer := mem.alloc (log_length + 1, mem.TEMP_ALLOC);
			gl.GetShaderInfoLog (handle, xx log_length, null, buffer);
			log.error ("create_device_objects: failed to link %. Info:\n%", desc, str.make (buffer, log_length));
		}
		else
			log.error ("create_device_objects: failed to link %.", desc);
	}

	return status != 0;
}
