#scope_module

#import "Runtime";
mem     :: #import "Memory";
log     :: #import "Log";
str     :: #import "String";
builder :: #import "String/Builder";
math    :: #import "Math";
using linalg  :: #import "Linalg";
gl      :: #import "GL";

#scope_export

#load "gl/texture.jai";
#load "gl/framebuffer.jai";
#load "gl/shader.jai";
#load "gl/buffer.jai";

// @Todo (stefan): Depth testing, clipping, viewport, clearing, blending...

// The kind of design we have for graphics data is that for each struct that define
// graphics data (vertex buffers, index buffers, textures ...), we have a Binding
// struct definition inside it, that holds the API specific information of the data.
// Typically, this is an index/handle type of data, such as vertex/index buffer/array
// objects in OpenGL. For example:
//
// Vertex_Buffer :: struct
// {
//     Binding :: struct
//     {
//         vao, vbo : GLuint;
//     }
//
//     using binding : Binding;
//     ...
// }
//
// This is important because we have functions that call into the graphics API, returning
// this kind of information, and we can't reconstruct our data with only the graphics API
// data (i.e we can go from Vertex_Buffer to vbo because we have this info, but not from
// a vbo to a Vertex_Buffer).
// One example of this is the get_current_XXX_binding functions, that return the currently
// bound XXX object, of type XXX.Binding.
// The reason we are not making these the same as their binding, is because we might want to
// store more data than just the rendering API specific one (i.e. in Shader, we store
// all the shader parameters).

Mesh :: struct (Vertex_Type : Type)
{
	vertices : []Vertex_Type;
	vertex_buffer : Vertex_Buffer;
	indices : []u32;
	index_buffer : Index_Buffer;
}

init_mesh_buffers :: inline (using mesh : *Mesh)
{
	init_vertex_buffer (*vertex_buffer, Vertex_Type.LAYOUT);
	init_index_buffer (*index_buffer);
	allocate_vertex_buffer_data (*vertex_buffer, vertices.count * size_of (Vertex_Type), .STATIC_DRAW, vertices.data);
	allocate_index_buffer_data (*index_buffer, indices.count * size_of (u32), .STATIC_DRAW, indices.data);
}

destroy_mesh_buffers :: inline (using mesh : *Mesh)
{
	destroy_index_buffer (*index_buffer);
	destroy_vertex_buffer (*vertex_buffer);
}
