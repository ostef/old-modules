#scope_module

fmt :: #import "Fmt";
gl :: #import "GL";
gl_utils :: #import "GL/Utils";

#scope_export

#load "../base.jai";
#load "shaders.jai";

Renderer_Data :: struct
{
	Shader_Data :: struct
	{
		handle : gl.GLuint;
		viewport_uniform_location : gl.GLint;
		view_projection_uniform_location : gl.GLint;
	}

	points_shader : Shader_Data;
	lines_shader : Shader_Data;
	triangles_shader : Shader_Data;
	vbo, vao : gl.GLuint;
}

init_renderer_data :: () -> bool
{
	data := get_renderer_data ();

	mem.allocator_block (mem.TEMP_ALLOC);
	mem.temporary_storage_block ();

	data.points_shader.handle = gl_utils.create_shader_program (
		str.join (POINTS_HEADER, VERTEX_SHADER),
		str.join (POINTS_HEADER, FRAGMENT_SHADER));
	
	if !data.points_shader.handle
		return log.error ("Im3d_GL: Could not create points shader program.");
	
	data.points_shader.viewport_uniform_location = gl.GetUniformLocation (data.points_shader.handle, "u_Viewport");
	data.points_shader.view_projection_uniform_location = gl.GetUniformLocation (data.points_shader.handle, "u_View_Projection_Matrix");

	data.lines_shader.handle = gl_utils.create_shader_program (
		str.join (LINES_HEADER, VERTEX_SHADER),
		str.join (LINES_HEADER, FRAGMENT_SHADER),
		str.join (LINES_HEADER, GEOMETRY_SHADER));
	
	if !data.lines_shader.handle
		return log.error ("Im3d_GL: Could not create lines shader program.");
	
	data.lines_shader.viewport_uniform_location = gl.GetUniformLocation (data.lines_shader.handle, "u_Viewport");
	data.lines_shader.view_projection_uniform_location = gl.GetUniformLocation (data.lines_shader.handle, "u_View_Projection_Matrix");

	data.triangles_shader.handle = gl_utils.create_shader_program (
		str.join (TRIANGLES_HEADER, VERTEX_SHADER),
		str.join (TRIANGLES_HEADER, FRAGMENT_SHADER));
	
	if !data.triangles_shader.handle
		return log.error ("Im3d_GL: Could not create triangles shader program.");
	
	data.triangles_shader.viewport_uniform_location = gl.GetUniformLocation (data.triangles_shader.handle, "u_Viewport");
	data.triangles_shader.view_projection_uniform_location = gl.GetUniformLocation (data.triangles_shader.handle, "u_View_Projection_Matrix");

	gl.GenVertexArrays (1, *data.vao);
	gl.BindVertexArray (data.vao);

	gl.GenBuffers (1, *data.vbo);
	gl.BindBuffer (gl.ARRAY_BUFFER, data.vbo);

	gl.EnableVertexAttribArray (0);
	gl.VertexAttribPointer (0, 4, gl.FLOAT, gl.FALSE, size_of (im3d.VertexData), cast (*void) offset_of (im3d.VertexData, "positionSize"));

	gl.EnableVertexAttribArray (1);
	gl.VertexAttribPointer (1, 4, gl.UNSIGNED_BYTE, gl.TRUE, size_of (im3d.VertexData), cast (*void) offset_of (im3d.VertexData, "color"));

	gl.BindBuffer (gl.ARRAY_BUFFER, 0);
	gl.BindVertexArray (0);

	return true;
}

cleanup_renderer_data :: ()
{
	data := get_renderer_data ();
	gl.DeleteBuffers (1, *data.vbo);
	gl.DeleteVertexArrays (1, *data.vao);
	gl.DeleteProgram (data.points_shader.handle);
	gl.DeleteProgram (data.lines_shader.handle);
	gl.DeleteProgram (data.triangles_shader.handle);
}

render_draw_lists :: (draw_lists : *im3d.DrawList, count : s64)
{
	app_data := im3d.GetAppData ();
	data := get_renderer_data ();
	impl_data := get_implementation_data ();

	gl_utils.disable_block (gl.DEPTH_TEST);
	gl_utils.enable_block (gl.POINT_SPRITE);
	gl_utils.enable_block (gl.PROGRAM_POINT_SIZE);
	gl_utils.enable_block (gl.BLEND);
	gl.BlendEquation (gl.FUNC_ADD);
	gl.BlendFunc (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

	gl.BindVertexArray (data.vao);
	gl.BindBuffer (gl.ARRAY_BUFFER, data.vbo);

	for i : 0..count - 1
	{
		list := draw_lists[i];
		
		primitive : gl.GLenum;
		shader : Renderer_Data.Shader_Data;
		if #complete list.primType ==
		{
		case .DrawPrimitive_Points;
			primitive = gl.POINTS;
			shader = data.points_shader;
			gl.Disable (gl.CULL_FACE);

		case .DrawPrimitive_Lines;
			primitive = gl.LINES;
			shader = data.lines_shader;
			gl.Disable (gl.CULL_FACE);
			
		case .DrawPrimitive_Triangles;
			primitive = gl.TRIANGLES;
			shader = data.triangles_shader;
			gl.Enable (gl.CULL_FACE);
		
		case .DrawPrimitive_Count;
			unreachable ();
		}

		gl.BufferData (gl.ARRAY_BUFFER, list.vertexCount * size_of (im3d.VertexData), list.vertexData, gl.DYNAMIC_DRAW);

		gl.UseProgram (shader.handle);
		gl.Uniform2f (shader.viewport_uniform_location, app_data.viewportSize.x, app_data.viewportSize.y);
		gl.UniformMatrix4fv (shader.view_projection_uniform_location, 1, gl.TRUE, *impl_data.view_projection_matrix.r0c0);

		gl.DrawArrays (primitive, 0, xx list.vertexCount);
	}

	gl.BindVertexArray (0);
	gl.BindBuffer (gl.ARRAY_BUFFER, 0);
}
