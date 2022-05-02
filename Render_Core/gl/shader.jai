Shader :: struct
{
	Binding :: struct
	{
		spo : gl.GLuint;
	}

	Parameter :: struct
	{
		Kind :: enum
		{
			UNKNOWN :: 0;
			BOOL;
			S32;
			VEC2I;
			VEC3I;
			VEC4I;
			U32;
			VEC2U;
			VEC3U;
			VEC4U;
			F32;
			VEC2F;
			VEC3F;
			VEC4F;
			MAT3F;
			MAT4F;
		}

		kind : Kind;
		name : string;
		count : s32;
		location : gl.GLint;
	}

	#as using binding : Binding;
	parameters : []Parameter;	// @Cleanup (stefan): Make this a Hash_Map
}

shader_parameter_kind_from_gl :: inline (type : gl.GLenum) -> Shader.Parameter.Kind #must
{
	kind : Shader.Parameter.Kind;
	if type ==
	{
	case gl.BOOL;
		kind = .BOOL;
	case gl.INT;
		kind = .S32;
	case gl.INT_VEC2;
		kind = .VEC2I;
	case gl.INT_VEC3;
		kind = .VEC3I;
	case gl.INT_VEC4;
		kind = .VEC4I;
	case gl.UNSIGNED_INT;
		kind = .U32;
	case gl.UNSIGNED_INT_VEC2;
		kind = .VEC2U;
	case gl.UNSIGNED_INT_VEC3;
		kind = .VEC3U;
	case gl.UNSIGNED_INT_VEC4;
		kind = .VEC4U;
	case gl.FLOAT;
		kind = .F32;
	case gl.FLOAT_VEC2;
		kind = .VEC2F;
	case gl.FLOAT_VEC3;
		kind = .VEC3F;
	case gl.FLOAT_VEC4;
		kind = .VEC4F;
	case gl.FLOAT_MAT3;
		kind = .MAT3F;
	case gl.FLOAT_MAT4;
		kind = .MAT4F;
	}
	return kind;
}

init_shader :: inline (shader : *Shader, vertex_src : string, fragment_src : string, geometry_src := "") -> bool, info_log : string
{
	check_compile_errors :: (shader : gl.GLuint) -> bool, info_log : string
	{
		success : s32;
		gl.GetShaderiv (shader, gl.COMPILE_STATUS, *success);
		if !success
		{
			info_len : s32;
			gl.GetShaderiv (shader, gl.INFO_LOG_LENGTH, *info_len);
			info_data := cast (*u8) mem.alloc (info_len, mem.TEMP_ALLOC);
			gl.GetShaderInfoLog (shader, xx info_len, xx *info_len, info_data);

			return false, str.make (info_data, info_len);
		}

		return true, "";
	}

	vso, gso, fso : gl.GLuint;
	ok : bool;
	info_log : string;

	vso = gl.CreateShader (gl.VERTEX_SHADER);
	defer gl.DeleteShader (vso);
	gl.ShaderSource (vso, 1, *str.clone_to_cstring (vertex_src, mem.TEMP_ALLOC), null);
	gl.CompileShader (vso);
	ok, info_log = check_compile_errors (vso);
	if !ok
		return false, info_log;

	fso = gl.CreateShader (gl.FRAGMENT_SHADER);
	defer gl.DeleteShader (fso);
	gl.ShaderSource (fso, 1, *str.clone_to_cstring (fragment_src, mem.TEMP_ALLOC), null);
	gl.CompileShader (fso);
	ok, info_log = check_compile_errors (fso);
	if !ok
		return false, info_log;

	if geometry_src
	{
		gso = gl.CreateShader (gl.GEOMETRY_SHADER);
		defer gl.DeleteShader (gso);
		gl.ShaderSource (gso, 1, *str.clone_to_cstring (geometry_src, mem.TEMP_ALLOC), null);
		gl.CompileShader (gso);
		ok, info_log = check_compile_errors (gso);
		if !ok
			return false, info_log;
	}

	spo := gl.CreateProgram ();
	gl.AttachShader (spo, vso);
	gl.AttachShader (spo, fso);
	if geometry_src
		gl.AttachShader (spo, gso);
	gl.LinkProgram (spo);
	success : s32;
	gl.GetProgramiv (spo, gl.LINK_STATUS, *success);
	if !success
	{
		info_len : s32;
		gl.GetProgramiv (spo, gl.INFO_LOG_LENGTH, *info_len);
		info_data := cast (*u8) mem.alloc (info_len, mem.TEMP_ALLOC);
		gl.GetProgramInfoLog (spo, xx info_len, xx *info_len, info_data);
		gl.DeleteProgram (spo);
		
		return false, str.make (info_data, info_len);
	}

	shader.spo = spo;
	param_count : s32;
	gl.GetProgramiv (shader.spo, gl.ACTIVE_UNIFORMS, *param_count);
	shader.parameters.data = mem.alloc (size_of (Shader.Parameter) * param_count, mem.HEAP_ALLOC);
	shader.parameters.count = 0;
	name_data := cast (*u8) mem.alloc (256, mem.TEMP_ALLOC);
	for i : 0..param_count - 1
	{
		name_len  : u32;
		size : s32;
		type : gl.GLenum;
		gl.GetActiveUniform (shader.spo, xx i, 256, *name_len, *size, *type, name_data);
		param : Shader.Parameter;
		param.kind = shader_parameter_kind_from_gl (type);
		if param.kind == .UNKNOWN
			continue;
		param.name = str.clone (str.make (name_data, name_len), mem.HEAP_ALLOC);
		param.count = size;
		param.location = gl.GetUniformLocation (shader.spo, name_data);
		shader.parameters.data[shader.parameters.count] = param;
		shader.parameters.count += 1;
	}

	return true, "";
}

destroy_shader :: inline (shader : *Shader)
{
	for shader.parameters
		mem.free (it.name, mem.HEAP_ALLOC);
	mem.free (shader.parameters, mem.HEAP_ALLOC);
	gl.DeleteProgram (shader.spo);
	shader.spo = 0;
	shader.parameters = .[];
}

get_current_shader :: inline () -> Shader.Binding #must
{
	spo : s32;
	gl.GetIntegerv (gl.CURRENT_PROGRAM, *spo);
	result : Shader.Binding = ---;
	result.spo = xx spo;

	return result;
}

use_shader :: inline (binding : *Shader.Binding) -> previous : Shader.Binding
{
	previous := get_current_shader ();
	if !binding
		gl.UseProgram (0);
	else
		gl.UseProgram (binding.spo);

	return previous;
}

get_shader_parameter :: inline (shader : *Shader, name : string) -> Shader.Parameter, bool
{
	for shader.parameters
	{
		if it.name == name
			return it, true;
	}
	return .{}, false;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : bool) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .BOOL
		return false;
	gl.Uniform1i (param.location, cast (s32) val);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : s32) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .S32
		return false;
	gl.Uniform1i (param.location, val);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : u32) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .U32
		return false;
	gl.Uniform1ui (param.location, val);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : f32) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .F32
		return false;
	gl.Uniform1f (param.location, val);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : Vec2f) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .VEC2F
		return false;
	gl.Uniform2f (param.location, val.x, val.y);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : Vec3f) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .VEC3F
		return false;
	gl.Uniform3f (param.location, val.x, val.y, val.z);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : Vec4f) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .VEC4F
		return false;
	gl.Uniform4f (param.location, val.x, val.y, val.z, val.w);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : Mat3f) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .MAT3F
		return false;
	gl.UniformMatrix3fv (param.location, 1, gl.TRUE, *val.r0c0);

	return true;
}

set_shader_parameter :: inline (shader : *Shader, name : string, val : Mat4f) -> bool
{
	param, ok := get_shader_parameter (shader, name);
	if !ok || param.kind != .MAT4F
		return false;
	gl.UniformMatrix4fv (param.location, 1, gl.TRUE, *val.r0c0);

	return true;
}
