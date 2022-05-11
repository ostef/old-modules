#scope_module

img :: #import "Image";

#scope_export

Texture :: struct
{
	Binding :: struct
	{
		tex : gl.GLuint;
	}

	Filtering :: enum
	{
		NEAREST;
		LINEAR;
	}

	#as using binding : Binding;
}

to_gl :: inline (filtering : Texture.Filtering) -> s32 #must
{
	if #complete filtering ==
	{
	case .LINEAR;
		return gl.LINEAR;
	case .NEAREST;
		return gl.NEAREST;
	}
}

init_texture :: inline (texture : *Texture, width : u32, height : u32, channels : s32, data : *void) -> bool
{
	gl.GenTextures (1, *texture.tex);
	gl.BindTexture (gl.TEXTURE_2D, texture.tex);
	defer gl.BindTexture (gl.TEXTURE_2D, 0);
	source_format : gl.GLenum;
	if channels ==
	{
	case 1; source_format = gl.RED;
	case 2; source_format = gl.RG;
	case 3; source_format = gl.RGB;
	case 4; source_format = gl.RGBA;
	case;
		return log.error ("Invalid channel count for texture, expected 1, 2, 3 or 4, got %.", channels);
	}
	if channels == 1 then gl.PixelStorei (gl.UNPACK_ALIGNMENT, 1);
	gl.TexImage2D (gl.TEXTURE_2D, 0, gl.RGBA, width, height, 0, source_format, gl.UNSIGNED_BYTE, data);
	if channels == 1 then gl.PixelStorei (gl.UNPACK_ALIGNMENT, 4);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_BORDER);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_BORDER);

	return true;
}

init_texture :: inline (texture : *Texture, image : img.Image) -> bool
{
	return init_texture (texture, xx image.width, xx image.height, image.channels, image.data);
}

load_texture_from_file :: inline (texture : *Texture, filename : string) -> bool
{
	image : img.Image;
	if !img.load_from_file (*image, filename)
		return false;
	defer img.destroy (*image);

	return init_texture (texture, *image);
}

destroy_texture :: inline (texture : *Texture)
{
	gl.DeleteTextures (1, *texture.tex);
	texture.tex = 0;
}

set_texture_min_filtering :: inline (texture : *Texture, filtering : Texture.Filtering)
{
	prev := use_texture (texture);
	defer use_texture (*prev);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, to_gl (filtering));
}

set_texture_mag_filtering :: inline (texture : *Texture, filtering : Texture.Filtering)
{
	prev := use_texture (texture);
	defer use_texture (*prev);
	gl.TexParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, to_gl (filtering));
}

get_current_texture :: inline (index : u32 = 0) -> Texture.Binding #must
{
	active : s32;
	gl.GetIntegerv (gl.ACTIVE_TEXTURE, *active);
	gl.ActiveTexture (gl.TEXTURE0 + index);
	defer gl.ActiveTexture (gl.TEXTURE0 + cast (u32) active);

	tex : s32;
	gl.GetIntegerv (gl.TEXTURE_BINDING_2D, *tex);
	result : Texture.Binding = ---;
	result.tex = xx tex;

	return result;
}

use_texture :: inline (binding : *Texture.Binding, index : u32 = 0) -> previous : Texture.Binding
{
	previous := get_current_texture (index);
	gl.ActiveTexture (gl.TEXTURE0 + index);
	if binding
		gl.BindTexture (gl.TEXTURE_2D, binding.tex);
	else
		gl.BindTexture (gl.TEXTURE_2D, 0);

	return previous;
}
