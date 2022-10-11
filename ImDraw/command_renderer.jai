Command :: struct
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

Command_Renderer :: struct
{
	vertices : [..]Vertex;
	commands : [..]Command;

	current_command : *Command;
}

init :: inline (using renderer : *Command_Renderer, preallocated_vertices : s64, preallocated_commands : s64, allocator := context.allocator)
{
	array.init (*vertices, preallocated_vertices, allocator);
	array.init (*commands, preallocated_commands, allocator);
	current_command = array.push (*commands);
}

clear :: inline (using renderer : *Command_Renderer)
{
	array.clear (*vertices);
	array.clear (*commands);
	current_command = array.push (*commands);
}

reset :: inline (using renderer : *Command_Renderer)
{
	array.reset (*vertices);
	array.reset (*commands);
	current_command = null;
}

flush :: inline (using renderer : *Command_Renderer)
{
	if current_command.vertex_count == 0
		return;
		
	header := current_command.header;
	current_command = array.push (*commands);
	current_command.header = header;
	current_command.first_vertex = vertices.count;
}

push_vertices :: inline (using renderer : *Command_Renderer, count : s64) -> *Vertex #must
{
	current_command.vertex_count += count;

	return array.push_multiple (*vertices, count, initialize = false);
}

get_clipping :: inline (using renderer : *Command_Renderer) -> bool #must
{
	return current_command.clipping_enabled;
}

set_clipping :: inline (using renderer : *Command_Renderer, enable : bool) -> previous : bool
{
	if current_command.clipping_enabled != enable
		flush (renderer);
	previous := current_command.clipping_enabled;
	current_command.clipping_enabled = enable;

	return previous;
}

get_clip_rect :: inline (using renderer : *Command_Renderer) -> math.Recti #must
{
	return current_command.clip_rect;
}

set_clip_rect :: inline (using renderer : *Command_Renderer, rect : math.Recti) -> previous_clip_rect : math.Recti, clipping_was_enabled : bool
{
	if !current_command.clipping_enabled || !mem.equals (current_command.clip_rect, rect)
		flush (renderer);
	previous_clip_rect := current_command.clip_rect;
	clipping_was_enabled := current_command.clipping_enabled;
	current_command.clipping_enabled = true;
	current_command.clip_rect = rect;

	return previous_clip_rect, clipping_was_enabled;
}

get_texture :: inline (using renderer : *Command_Renderer) -> *render.Texture #must
{
	return current_command.texture;
}

set_texture :: inline (using renderer : *Command_Renderer, texture : *render.Texture) -> previous : *render.Texture
{
	if current_command.texture != texture
		flush (renderer);
	previous := current_command.texture;
	current_command.texture = texture;

	return previous;
}

get_shader :: inline (using renderer : *Command_Renderer) -> *render.Shader #must
{
	return current_command.shader;
}

set_shader :: inline (using renderer : *Command_Renderer, shader : *render.Shader) -> previous : *render.Shader
{
	if current_command.shader != shader
		flush (renderer);
	previous := current_command.shader;
	current_command.shader = shader;

	return previous;
}

draw_to_framebuffer :: (using renderer : *Command_Renderer)
{
	for cmd : commands
	{
		set_texture (cmd.texture);
		set_shader (cmd.shader);
		set_clip_rect (cmd.clip_rect);
		set_clipping (cmd.clipping_enabled);

		i := 0;
		while i < cmd.vertex_count
		{
			defer i += 3;

			vert := push_vertices (3);
			vert[0] = vertices[cmd.first_vertex + i + 0];
			vert[1] = vertices[cmd.first_vertex + i + 1];
			vert[2] = vertices[cmd.first_vertex + i + 2];
		}
	}
	
	flush ();
}
