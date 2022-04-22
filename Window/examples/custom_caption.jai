#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
#import "Linalg";
log  :: #import "Log";
window :: #import "Window";
imdraw :: #import "ImDraw";
gl     :: #import "GL";

main_window : window.Window;
is_running  : bool;

CAPTION_HEIGHT :: 32;
BUTTON_RADIUS :: 6.0;
BUTTON_MARGIN :: 10.0;

handle_window_message :: (msg : window.Message)
{
	if msg.kind ==
	{
	case .WINDOW_CLOSED;
		is_running = false;
	case .MOUSE_BUTTON_RELEASED;
		if msg.mouse_button == .LEFT
		{
			width, height := window.get_viewport_size (main_window);
			for i : 1..3
			{
				pos := vec2f (cast (f32) width - i * (BUTTON_RADIUS + BUTTON_MARGIN), CAPTION_HEIGHT * 0.5);
				mouse_pos := vec2f (xx msg.mouse_x, xx msg.mouse_y);
				if distance (pos, mouse_pos) < BUTTON_RADIUS
				{
					if i ==
					{
					case 1;
						window.close (main_window);
					case 2;
						if !window.is_maximized (main_window)
							window.maximize (main_window);
						else
							window.restore (main_window);
					case 3;
						window.minimize (main_window);
					}
				}
			}
		}
	}
}

caption_hit_test :: (win : window.Window, mouse_x : s32, mouse_y : s32) -> bool
{
	width, height := window.get_viewport_size (win);
	for i : 1..3
	{
		pos := vec2f (cast (f32) width - i * (BUTTON_RADIUS + BUTTON_MARGIN), CAPTION_HEIGHT * 0.5);
		mouse_pos := vec2f (xx mouse_x, xx mouse_y);
		if distance (pos, mouse_pos) < BUTTON_RADIUS
			return false;
	}
	if mouse_y < CAPTION_HEIGHT
		return true;
	return false;
}

main :: ()
{
	fill_default_context ();
	gl.load ();
	main_window = window.create ("Custom Frame Window", -1, -1, -1, -1, window.Creation_Flags.VISIBLE | .CUSTOM_CAPTION);
	window.set_caption_hit_test (main_window, caption_hit_test);
	assert (main_window != null, "Could not create window.");
	defer window.destroy (main_window);
	gl_ctx := gl.create_context (main_window);
	assert (main_window != null, "Could not create GL context.");
	defer gl.destroy_context (main_window, gl_ctx);
	imdraw_ctx := imdraw.create_context (main_window, gl_ctx);
	assert (main_window != null, "Could not create ImDraw context.");
	defer imdraw.destroy_context (imdraw_ctx);

	is_running = true;
	while is_running
	{
		mem.reset_temporary_storage ();
		window.poll_messages (main_window);
		msg : window.Message;
		while window.get_next_message (main_window, *msg)
			handle_window_message (msg);

		width, height := window.get_viewport_size (main_window);
		gl.ClearColor (0.1, 0.1, 0.1, 1);
		gl.Clear (gl.COLOR_BUFFER_BIT);
		imdraw.begin (imdraw_ctx);
		imdraw.draw_rect (math.xywhf (0, 0, xx width, xx CAPTION_HEIGHT), math.rgba (100, 100, 100));
		// Draw circles at each corner so we can make sure that the corners are not
		// outside the screen when maximized (which is what Windows does by default).
		imdraw.draw_circle (vec2f (0, 0), 10, math.rgba (255, 0, 0));
		imdraw.draw_circle (vec2f (xx width, 0), 10, math.rgba (255, 0, 0));
		imdraw.draw_circle (vec2f (xx width, xx height), 10, math.rgba (255, 0, 0));
		imdraw.draw_circle (vec2f (0, xx height), 10, math.rgba (255, 0, 0));
		for i : 1..3
		{
			pos := vec2f (cast (f32) width - i * (BUTTON_RADIUS + BUTTON_MARGIN), CAPTION_HEIGHT * 0.5);
			color : math.RGBA;
			if i ==
			{
			case 1;
				color = math.rgba (255, 0, 0);
			case 2;
				color = math.rgba (0, 255, 0);
			case 3;
				color = math.rgba (255, 255, 0);
			}
			imdraw.draw_circle (pos, BUTTON_RADIUS, color);
		}
		imdraw.end ();
		window.swap_buffers (main_window);
	}
}
