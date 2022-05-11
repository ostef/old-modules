Buffer_Usage :: enum
{
	STATIC_DRAW  :: 0;
	DYNAMIC_DRAW :: 1;
	STREAM_DRAW  :: 2;
	STATIC_READ  :: 3;
	DYNAMIC_READ :: 4;
	STREAM_READ  :: 5;
	STATIC_COPY  :: 6;
	DYNAMIC_COPY :: 7;
	STREAM_COPY  :: 8;
}

to_gl :: inline (usage : Buffer_Usage) -> gl.GLenum #must
{
	gl_usage : gl.GLenum;
	if #complete usage ==
	{
	case .STATIC_DRAW;
		gl_usage = gl.STATIC_DRAW;
	case .DYNAMIC_DRAW;
		gl_usage = gl.DYNAMIC_DRAW;
	case .STREAM_DRAW;
		gl_usage = gl.STREAM_DRAW;
	case .STATIC_READ;
		gl_usage = gl.STATIC_READ;
	case .DYNAMIC_READ;
		gl_usage = gl.DYNAMIC_READ;
	case .STREAM_READ;
		gl_usage = gl.STREAM_READ;
	case .STATIC_COPY;
		gl_usage = gl.STATIC_COPY;
	case .DYNAMIC_COPY;
		gl_usage = gl.DYNAMIC_COPY;
	case .STREAM_COPY;
		gl_usage = gl.STREAM_COPY;
	}
	return gl_usage;
}

Vertex_Buffer :: struct
{
	Binding :: struct
	{
		vao, vbo : gl.GLuint;
	}

	Elem :: struct
	{
		Kind :: enum
		{
			S8  :: 0;
			U8  :: 1;
			S16 :: 2;
			U16 :: 3;
			S32 :: 4;
			U32 :: 5;
			F32 :: 6;
			F64 :: 7;
		}

		kind  : Kind;
		count : s64;
		integer   : bool;
		normalize : bool;
	}

	Layout :: []Elem;

	VEC2F :: Elem.{ .F32, 2, false, false };
	VEC3F :: Elem.{ .F32, 3, false, false };
	VEC4F :: Elem.{ .F32, 4, false, false };
	VEC2I :: Elem.{ .S32, 2, false, false };
	VEC3I :: Elem.{ .S32, 3, false, false };
	VEC4I :: Elem.{ .S32, 4, false, false };
	RGBA  :: Elem.{ .U8,  4, false,  true };

	#as using binding : Binding;
}

get_elem_size :: inline (elem : Vertex_Buffer.Elem) -> u32 #must
{
	type_size : u32;
	if #complete elem.kind ==
	{
	case .S8; #through;
	case .U8;
		type_size = 1;
	case .S16; #through;
	case .U16;
		type_size = 2;
	case .S32; #through;
	case .U32; #through;
	case .F32;
		type_size = 4;
	case .F64;
		type_size = 8;
	}

	return type_size * cast (u32) elem.count;
}

get_layout_size :: inline (layout : Vertex_Buffer.Layout) -> u32 #must
{
	size : u32;
	for layout
		size += get_elem_size (it);
	return size;
}

to_gl :: inline (elem_kind : Vertex_Buffer.Elem.Kind) -> gl.GLenum #must
{
	if #complete elem_kind ==
	{
	case .S8;
		return gl.BYTE;
	case .U8;
		return gl.UNSIGNED_BYTE;
	case .S16;
		return gl.SHORT;
	case .U16;
		return gl.UNSIGNED_SHORT;
	case .S32;
		return gl.INT;
	case .U32;
		return gl.UNSIGNED_INT;
	case .F32;
		return gl.FLOAT;
	case .F64;
		return gl.DOUBLE;
	}
	return 0;
}

init_vertex_buffer :: inline (buffer : *Vertex_Buffer, layout : Vertex_Buffer.Layout)
{
	gl.GenVertexArrays (1, *buffer.vao);
	gl.BindVertexArray (buffer.vao);
	defer gl.BindVertexArray (0);
	gl.GenBuffers (1, *buffer.vbo);
	gl.BindBuffer (gl.ARRAY_BUFFER, buffer.vbo);
	defer gl.BindBuffer (gl.ARRAY_BUFFER, 0);

	elem_offset : u32;
	vertex_size := get_layout_size (layout);
	for elem, i : layout
	{
		gl.EnableVertexAttribArray (xx i);
		if elem.kind == .F64
			gl.VertexAttribLPointer (xx i, xx elem.count, to_gl (elem.kind), vertex_size, cast (*void) elem_offset);
		else if elem.integer
			gl.VertexAttribIPointer (xx i, xx elem.count, to_gl (elem.kind), vertex_size, cast (*void) elem_offset);
		else
			gl.VertexAttribPointer (xx i, xx elem.count, to_gl (elem.kind), xx elem.normalize, vertex_size, cast (*void) elem_offset);
		elem_offset += get_elem_size (elem);
	}
}

destroy_vertex_buffer :: inline (buffer : *Vertex_Buffer)
{
	// @Note (stefan): In the documentation for gl.DeleteBuffers: "If a buffer object that is
	// currently bound is deleted, the binding reverts to 0 (the absence of any buffer object)."
	// Same for vertex arrays.
	gl.DeleteBuffers (1, *buffer.vbo);
	gl.DeleteVertexArrays (1, *buffer.vao);
	buffer.vbo = 0;
	buffer.vao = 0;
}

get_current_vertex_buffer_binding :: inline () -> Vertex_Buffer.Binding #must
{
	vao, vbo : s32;
	gl.GetIntegerv (gl.VERTEX_ARRAY_BINDING, *vao);
	gl.GetIntegerv (gl.ARRAY_BUFFER_BINDING, *vbo);
	result : Vertex_Buffer.Binding;
	result.vao = xx vao;
	result.vbo = xx vbo;

	return result;
}

use_vertex_buffer :: inline (binding : *Vertex_Buffer.Binding) -> previous : Vertex_Buffer.Binding
{
	previous := get_current_vertex_buffer_binding ();
	if !binding
	{
		gl.BindVertexArray (0);
		gl.BindBuffer (gl.ARRAY_BUFFER, 0);
	}
	else
	{
		gl.BindVertexArray (binding.vao);
		gl.BindBuffer (gl.ARRAY_BUFFER, binding.vbo);
	}

	return previous;
}

allocate_vertex_buffer_data :: inline (buffer : *Vertex_Buffer, size : s64, usage : Buffer_Usage, data := null)
{
	previous := use_vertex_buffer (buffer);
	defer use_vertex_buffer (*previous);
	gl.BufferData (gl.ARRAY_BUFFER, size, data, to_gl (usage));
}

set_vertex_buffer_data :: inline (buffer : *Vertex_Buffer, data : *void, size : s64)
{
	previous := use_vertex_buffer (buffer);
	defer use_vertex_buffer (*previous);
	gl.BufferSubData (gl.ARRAY_BUFFER, 0, size, data);
}

Index_Buffer :: struct
{
	Binding :: struct
	{
		ibo : gl.GLuint;
	}

	#as using binding : Binding;
}

init_index_buffer :: inline (buffer : *Index_Buffer)
{
	gl.GenBuffers (1, *buffer.ibo);
	gl.BindBuffer (gl.ELEMENT_ARRAY_BUFFER, buffer.ibo);
	gl.BindBuffer (gl.ELEMENT_ARRAY_BUFFER, 0);
}

destroy_index_buffer :: inline (buffer : *Index_Buffer)
{
	gl.DeleteBuffers (1, *buffer.ibo);
	buffer.ibo = 0;
}

get_current_index_buffer_binding :: inline () -> Index_Buffer.Binding #must
{
	ibo : s32;
	gl.GetIntegerv (gl.ELEMENT_ARRAY_BUFFER_BINDING, *ibo);
	result : Index_Buffer.Binding = ---;
	result.ibo = xx ibo;

	return result;
}

use_index_buffer :: inline (binding : *Index_Buffer.Binding) -> previous : Index_Buffer.Binding
{
	previous := get_current_index_buffer_binding ();
	if !binding
		gl.BindBuffer (gl.ELEMENT_ARRAY_BUFFER, 0);
	else
		gl.BindBuffer (gl.ELEMENT_ARRAY_BUFFER, binding.ibo);

	return previous;
}

allocate_index_buffer_data :: inline (buffer : *Index_Buffer, size : s64, usage : Buffer_Usage, data := null)
{
	previous := use_index_buffer (buffer);
	defer use_index_buffer (*previous);
	gl.BufferData (gl.ELEMENT_ARRAY_BUFFER, size, data, to_gl (usage));
}

set_index_buffer_data :: inline (buffer : *Index_Buffer, data : *void, size : s64)
{
	previous := use_index_buffer (buffer);
	defer use_index_buffer (*previous);
	gl.BufferSubData (gl.ELEMENT_ARRAY_BUFFER, 0, size, data);
}
