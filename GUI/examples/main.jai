#import "Runtime";
mem  :: #import "Memory";
time :: #import "Apollo_Time";
#import "Math/Int128";
math :: #import "Math";
using linalg :: #import "Linalg";
hash :: #import "Hash";
fmt  :: #import "Fmt";
ps   :: #import "Process";
array   :: #import "Containers/Array";
list    :: #import "Containers/List";
for_expansion :: list.for_expansion;
storage :: #import "Containers/Storage";
for_expansion :: storage.for_expansion;

gl     :: #import "GL";
window :: #import "Window";
input  :: #import "Input";
imdraw :: #import "ImDraw";
font   :: #import "Font";

gui :: #import "GUI";

g_window : window.Window;
g_font   : *font.Font;
g_is_running : bool;
g_show_second_window := false;

handle_window_message :: (msg : window.Message)
{
	input.handle_window_message (msg);
	if msg.kind ==
	{
	case .WINDOW_CLOSED;
		g_is_running = false;
	}
}

main :: ()
{
	error :: (msg : string, args : ..Any) #expand
	{
		window.show_error_box (msg, ..args);
		`return;
	}

	defer fmt.println ("Program ended gracefully.");

	gl.load ();
	
	g_window = window.create ("GUI", -1, -1, -1, -1, .VISIBLE);
	defer window.destroy (g_window);
	
	gl_ctx := gl.create_context (g_window);
	defer gl.destroy_context (g_window, gl_ctx);
	
	imdraw_ctx := imdraw.create_context (g_window, gl_ctx);
	defer imdraw.destroy_context (imdraw_ctx);
	
	g_font = font.load_family ("C:/Windows/Fonts/", "Roboto", mem.HEAP_ALLOC);
	if !g_font
		error ("Could not load font.");
	defer font.destroy_family (*g_font, mem.HEAP_ALLOC);
	
	gui.init ();
	defer gui.terminate ();

	window_rect := math.xywhf (50, 30, 100, 200);
	show_second_control := true;
	gl.ClearColor (0.1, 0.1, 0.1, 1);
	g_is_running = true;
	delta_time := 0.01667;
	while g_is_running
	{
		frame_start := time.current_monotonic ();
		
		mem.reset_temporary_storage ();
		
		input.update ();
		window.poll_messages (g_window);
		msg : window.Message;
		while window.get_next_message (g_window, *msg)
			handle_window_message (msg);

		gl.Clear (gl.COLOR_BUFFER_BIT);
		imdraw.begin (imdraw_ctx);

		new_frame (delta_time);
		gui.begin ();
		{
			if gui.declare_control (math.xywhf (10, 10, 50, 50), #location ()) == .RELEASED
				show_second_control = !show_second_control;

			gui.begin_occlusion (math.xywhf (30, 30, 30, 30), #location ());
			gui.end_occlusion ();

			prev := gui.set_occlusion_layer ("Windows");
			gui.begin_occlusion (window_rect, #location ());
			{
				caption_rect := math.xywhf (0, 0, math.rect_width (window_rect), 25);
				if gui.declare_control (caption_rect, #location ()) == .DOWN
				{
					mx, my := window.get_mouse_position (g_window);
					window_rect = math.set_position (window_rect, xx mx - math.rect_width (window_rect) * 0.5, xx my - math.rect_height (caption_rect) * 0.5);
					gui.raise_occluder ();
				}
				
				resize_button_rect := math.xywhf (math.rect_width (window_rect) - 25, math.rect_height (window_rect) - 25, 25, 25);
				if gui.declare_control (resize_button_rect, #location ()) == .DOWN
				{
					mx, my := window.get_mouse_position (g_window);
					window_rect = math.set_size (window_rect, mx + 12.5 - window_rect.x1, my + 12.5 - window_rect.y1);
					gui.raise_occluder ();
				}
			}
			gui.end_occlusion ();

			gui.begin_occlusion (math.xywhf (100, 10, 50, 75), #location ());
			if gui.declare_control (math.xywhf (10, 0, 50, 20), #location ()) == .DOWN
				gui.raise_occluder ();
			gui.end_occlusion ();

			gui.set_occlusion_layer (prev);

			if show_second_control
				gui.declare_control (math.xywhf (20, 20, 50, 50), #location ());

		}
		gui.end ();
		
		imdraw.end ();
		window.swap_buffers (g_window);
		
		ps.sleep_milliseconds (10);
		frame_end := time.current_monotonic ();
		delta_time = xx time.to_float_seconds (frame_end - frame_start);
	}
}

new_frame :: (delta_time : f32)
{
	gui.check_init ();

	dw, dh := window.get_viewport_size (g_window);
	ui.viewport_size.x = dw;
	ui.viewport_size.y = dh;

	mx, my := window.get_mouse_position (g_window);
	ui.mouse_position.x = cast (f32) mx;
	ui.mouse_position.y = cast (f32) my;

	wx, wy := input.get_mouse_wheel ();
	ui.mouse_wheel.x = wx * 5.0;
	ui.mouse_wheel.y = wy * 5.0;
}
