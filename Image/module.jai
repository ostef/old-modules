// @Note (stefan): I wanted to separate images and rendering, so this
// is not in i.e. the Render_Core module, but I kinda don't like it
// because there is not much here. I guess when will add our own image
// reading and writing functions later on, so this module will get
// substantial in the future.

#scope_module

#import "Runtime";
mem  :: #import "Memory";
str  :: #import "String";
stbi :: #import "stb/image";

#scope_export

Image :: struct
{
	data   : *void;
	width  : s32;
	height : s32;
	channels : s32;
}

load_from_file :: inline (image : *Image, filename : string, desired_channels : s32 = 0) -> bool
{
	width, height, channels : s32;
	data := stbi.load (str.clone_to_cstring (filename, mem.TEMP_ALLOC), *width, *height, *channels, desired_channels);
	if !data
		return false;

	image.data = data;
	image.width = width;
	image.height = height;
	if desired_channels != 0
		image.channels = desired_channels;
	else
		image.channels = channels;

	return true;
}

load_from_memory :: inline (image : *Image, buffer : *void, size : s64, desired_channels : s32 = 0) -> bool
{
	width, height, channels : s32;
	data := stbi.load_from_memory (buffer, xx size, *width, *height, *channels, desired_channels);
	if !data
		return false;

	image.data = data;
	image.width = width;
	image.height = height;
	if desired_channels != 0
		image.channels = desired_channels;
	else
		image.channels = channels;

	return true;
}

destroy :: inline (image : *Image)
{
	stbi.image_free (image.data);
	image.data = null;
	image.width = 0;
	image.height = 0;
	image.channels = 0;
}
