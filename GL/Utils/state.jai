enable_block :: (val : gl.GLenum) #expand
{
	prev : gl.GLboolean;
	gl.GetBooleanv (val, *prev);
	
	if !prev
		gl.Enable (val);
	
	`defer {
		if !prev
			gl.Disable (val);
	}
}

disable_block :: (val : gl.GLenum) #expand
{
	prev : gl.GLboolean;
	gl.GetBooleanv (val, *prev);
	
	if prev
		gl.Disable (val);
	
	`defer {
		if prev
			gl.Enable (val);
	}
}
