Framebuffer :: struct
{
	Binding :: struct
	{
		fbo : gl.GLuint;
	}

	#as using binding : Binding;
}

init_framebuffer :: inline (framebuffer : *Framebuffer, color_texture : *Texture) -> bool
{
	gl.GenFramebuffers (1, *framebuffer.fbo);
	gl.BindFramebuffer (gl.FRAMEBUFFER, framebuffer.fbo);
	defer gl.BindFramebuffer (gl.FRAMEBUFFER, 0);
	gl.FramebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, color_texture.tex, 0);

	status := gl.CheckFramebufferStatus (gl.FRAMEBUFFER);
	if status != gl.FRAMEBUFFER_COMPLETE
	{
		gl.DeleteFramebuffers (1, *framebuffer.fbo);
		framebuffer.fbo = 0;
		return false;
	}

	return true;
}

destroy_framebuffer :: inline (framebuffer : *Framebuffer)
{
	gl.DeleteFramebuffers (1, *framebuffer.fbo);
	framebuffer.fbo = 0;
}

get_current_draw_framebuffer :: inline () -> Framebuffer.Binding #must
{
	fbo : s32;
	gl.GetIntegerv (gl.DRAW_FRAMEBUFFER_BINDING, *fbo);
	result : Framebuffer.Binding = ---;
	result.fbo = xx fbo;

	return result;
}

get_current_read_framebuffer :: inline () -> Framebuffer.Binding #must
{
	fbo : s32;
	gl.GetIntegerv (gl.READ_FRAMEBUFFER_BINDING, *fbo);
	result : Framebuffer.Binding = ---;
	result.fbo = xx fbo;

	return result;
}

use_framebuffer_for_drawing :: inline (binding : *Framebuffer.Binding) -> previous : Framebuffer.Binding
{
	previous := get_current_draw_framebuffer ();
	if binding
		gl.BindFramebuffer (gl.DRAW_FRAMEBUFFER, binding.fbo);
	else
		gl.BindFramebuffer (gl.DRAW_FRAMEBUFFER, 0);

	return previous;
}

use_framebuffer_for_reading :: inline (binding : *Framebuffer.Binding) -> previous : Framebuffer.Binding
{
	previous := get_current_read_framebuffer ();
	if binding
		gl.BindFramebuffer (gl.READ_FRAMEBUFFER, binding.fbo);
	else
		gl.BindFramebuffer (gl.READ_FRAMEBUFFER, 0);

	return previous;
}
