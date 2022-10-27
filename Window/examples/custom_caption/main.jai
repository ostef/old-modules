#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
#import "Linalg";
log  :: #import "Log";
input  :: #import "Input";
window :: #import "Window";
imdraw :: #import "ImDraw";
gl     :: #import "GL";

g_window : window.Handle;
g_is_running  : bool;

CAPTION_HEIGHT :: 32;
BUTTON_RADIUS :: 7.5;
BUTTON_MARGIN :: 7.0;

Caption_Button :: enum
{
	CLOSE :: 0;
	MAXIMIZE :: 1;
	MINIMIZE :: 2;
}

get_button_position :: inline (button : Caption_Button) -> Vec2f
{
	width, height := window.get_viewport_size (g_window);
	i := cast (s32) button;
	return vec2f (
		cast (f32) width - BUTTON_RADIUS - BUTTON_MARGIN - i * (2 * BUTTON_RADIUS + BUTTON_MARGIN),
		CAPTION_HEIGHT * 0.5);
}

is_button_hovered :: inline (button : Caption_Button) -> bool
{
	mx, my := window.get_mouse_position (g_window);
	return distance (vec2f (xx mx, xx my), get_button_position (button)) < BUTTON_RADIUS;
}

handle_window_message :: (msg : window.Message)
{
	input.handle_window_message (msg);
	if msg.kind ==
	{
	case .WINDOW_CLOSED;
		g_is_running = false;
	case .MOUSE_MOVED;
		if is_button_hovered (.CLOSE)
		|| is_button_hovered (.MAXIMIZE)
		|| is_button_hovered (.MINIMIZE)
			window.set_cursor (.HAND);
		else
			window.set_cursor (.ARROW);
	case .MOUSE_BUTTON_RELEASED;
		if msg.mouse_button == .LEFT
		{
			if is_button_hovered (.CLOSE)
				window.close (g_window);
			if is_button_hovered (.MAXIMIZE)
			{
				if !window.is_maximized (g_window)
					window.maximize (g_window);
				else
					window.restore (g_window);
			}
			if is_button_hovered (.MINIMIZE)
				window.minimize (g_window);
		}
	}
}

caption_hit_test :: (win : window.Handle, mouse_x : s32, mouse_y : s32) -> bool
{
	if is_button_hovered (.CLOSE) || is_button_hovered (.MAXIMIZE) || is_button_hovered (.MINIMIZE)
		return false;
	if mouse_y < CAPTION_HEIGHT
		return true;
	return false;
}

main :: ()
{
	fill_default_context ();
	gl.load ();
	input.init ();
	g_window = window.create ("Custom Frame Window", -1, -1, -1, -1, window.Creation_Flags.VISIBLE | .CUSTOM_CAPTION);
	window.set_caption_hit_test (g_window, caption_hit_test);
	assert (g_window != null, "Could not create window.");
	defer window.destroy (g_window);
	gl_ctx := gl.create_context (g_window);
	assert (g_window != null, "Could not create GL context.");
	defer gl.destroy_context (g_window, gl_ctx);
	imdraw_ctx := imdraw.create_context (g_window, gl_ctx);
	assert (g_window != null, "Could not create ImDraw context.");
	defer imdraw.destroy_context (imdraw_ctx);

	g_is_running = true;
	while g_is_running
	{
		mem.reset_temporary_storage ();
		window.poll_messages (g_window);
		msg : window.Message;
		while window.get_next_message (g_window, *msg)
			handle_window_message (msg);

		width, height := window.get_viewport_size (g_window);
		gl.ClearColor (0.1, 0.1, 0.1, 1);
		gl.Clear (gl.COLOR_BUFFER_BIT);
		imdraw.begin (imdraw_ctx);
		imdraw.draw_rect (math.xywhf (0, 0, xx width, xx CAPTION_HEIGHT), math.RGBA_BLACK);
		// Draw circles at each corner so we can make sure that the corners are not
		// outside the screen when maximized (which is what Windows does by default).
		/*
		imdraw.draw_circle (vec2f (0, 0), 10, math.rgba (255, 0, 0));
		imdraw.draw_circle (vec2f (xx width, 0), 10, math.rgba (255, 0, 0));
		imdraw.draw_circle (vec2f (xx width, xx height), 10, math.rgba (255, 0, 0));
		imdraw.draw_circle (vec2f (0, xx height), 10, math.rgba (255, 0, 0));
		*/
		if is_button_hovered (.CLOSE) && input.is_mouse_button_down (.LEFT)
			imdraw.draw_circle (get_button_position (.CLOSE), BUTTON_RADIUS, math.rgba (255, 50, 50));
		else if is_button_hovered (.CLOSE)
			imdraw.draw_circle (get_button_position (.CLOSE), BUTTON_RADIUS, math.rgba (255, 0, 0));
		else
			imdraw.draw_circle (get_button_position (.CLOSE), BUTTON_RADIUS, math.rgba (200, 0, 0));
		if is_button_hovered (.MAXIMIZE) && input.is_mouse_button_down (.LEFT)
			imdraw.draw_circle (get_button_position (.MAXIMIZE), BUTTON_RADIUS, math.rgba (50, 255, 50));
		else if is_button_hovered (.MAXIMIZE)
			imdraw.draw_circle (get_button_position (.MAXIMIZE), BUTTON_RADIUS, math.rgba (0, 255, 0));
		else
			imdraw.draw_circle (get_button_position (.MAXIMIZE), BUTTON_RADIUS, math.rgba (0, 200, 0));
		if is_button_hovered (.MINIMIZE) && input.is_mouse_button_down (.LEFT)
			imdraw.draw_circle (get_button_position (.MINIMIZE), BUTTON_RADIUS, math.rgba (255, 255, 50));
		else if is_button_hovered (.MINIMIZE)
			imdraw.draw_circle (get_button_position (.MINIMIZE), BUTTON_RADIUS, math.rgba (255, 255, 0));
		else
			imdraw.draw_circle (get_button_position (.MINIMIZE), BUTTON_RADIUS, math.rgba (200, 200, 0));
		imdraw.end ();
		window.swap_buffers (g_window);
	}
}
