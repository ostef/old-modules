check_shader :: (handle : gl.GLuint, desc : string) -> bool #must
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
			log.error ("%:\n\n%", desc, str.make (buffer, log_length));
		}
		else
			log.error ("%.", desc);
	}

	return status != 0;
}

check_shader_program :: (handle : gl.GLuint, desc : string) -> bool #must
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
			log.error ("%:\n\n%", desc, str.make (buffer, log_length));
		}
		else
			log.error ("%.", desc);
	}

	return status != 0;
}

create_shader_program :: ($$vertex_source : string, $$fragment_source : string, $$geometry_source := "") -> gl.GLuint #must
{
	mem.allocator_block (mem.TEMP_ALLOC);

	vertex_shader := gl.CreateShader (gl.VERTEX_SHADER);
	defer gl.DeleteShader (vertex_shader);

	#if is_constant (vertex_source)
		cstr_vertex_source := vertex_source.data;
	else
		cstr_vertex_source := str.clone_to_cstring (vertex_source);
	gl.ShaderSource (vertex_shader, 1, *cstr_vertex_source, null);
	gl.CompileShader (vertex_shader);

	if !check_shader (vertex_shader, "Could not compile vertex shader")
		return 0;

	geometry_shader : gl.GLuint;
	defer gl.DeleteShader (geometry_shader);

	if geometry_source
	{
		geometry_shader = gl.CreateShader (gl.GEOMETRY_SHADER);

		#if is_constant (geometry_source)
			cstr_geometry_source := geometry_source.data;
		else
			cstr_geometry_source := str.clone_to_cstring (geometry_source);
		gl.ShaderSource (geometry_shader, 1, *cstr_geometry_source, null);
		gl.CompileShader (geometry_shader);

		if !check_shader (geometry_shader, "Could not compile geometry shader")
			return 0;
	}

	fragment_shader := gl.CreateShader (gl.FRAGMENT_SHADER);
	defer gl.DeleteShader (fragment_shader);

	#if is_constant (fragment_source)
		cstr_fragment_source := fragment_source.data;
	else
		cstr_fragment_source := str.clone_to_cstring (fragment_source);
	gl.ShaderSource (fragment_shader, 1, *cstr_fragment_source, null);
	gl.CompileShader (fragment_shader);
	
	if !check_shader (fragment_shader, "Could not compile fragment shader")
		return 0;

	shader_program := gl.CreateProgram ();

	gl.AttachShader (shader_program, vertex_shader);
	if geometry_shader
		gl.AttachShader (shader_program, geometry_shader);
	gl.AttachShader (shader_program, fragment_shader);
	gl.LinkProgram (shader_program);
	
	if !check_shader_program (shader_program, "Could not link shader program")
	{
		gl.DeleteProgram (shader_program);

		return 0;
	}

	return shader_program;
}
