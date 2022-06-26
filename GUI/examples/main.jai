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
render :: #import "Render_Core";
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
			update_ui ();
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

g_window_rect := math.Rectf.{50, 30, 150, 230};
g_show_second_control := true;

button :: (rect : math.Rectf, location := #caller_location) -> gui.State
{
	ctrl := gui.declare_control (rect, location);

	color : math.RGBA;
	color.value = ctrl.id;
	color.a = 255;
	gui.draw_rect (gui.get_draw_data (), ctrl.rect, color, corner_radius = 10);
	if ctrl.state == .HOVERED
		gui.draw_rect_outline (gui.get_draw_data (), ctrl.rect, math.RGBA_WHITE, 2);
	else if ctrl.state == .DOWN
		gui.draw_rect_outline (gui.get_draw_data (), ctrl.rect, .{100, 100, 100, 255}, 2);
	else if ctrl.state == .RELEASED
		gui.draw_rect_outline (gui.get_draw_data (), ctrl.rect, .{255, 0, 0, 255}, 2);

	return ctrl.state;
}

begin_window :: (rect : math.Rectf, location := #caller_location)
{
	occl := gui.begin_occlusion (rect, location);

	color : math.RGBA;
	color.value = occl.id;
	color.a = 128;
	gui.draw_rect (gui.get_draw_data (), occl.rect, color, corner_radius = 10);
	if context.ui_context.mouse_hovered_occluder && context.ui_context.mouse_hovered_occluder == occl
		gui.draw_rect_outline (gui.get_draw_data (), occl.rect, .{255,0,0,255}, 2, corner_radius = 10);
}

end_window :: ()
{
	ui_window := context.ui_context.current_occluder;
	gui.draw_text (gui.get_draw_data (), g_font, 12, vec2f (ui_window.rect.x1 + 4, ui_window.rect.y1 + 4), "Window", math.RGBA_WHITE);
	gui.end_occlusion ();
}

update_ui :: ()
{
	if button (math.xywhf (10, 10, 50, 50)) == .RELEASED
		g_show_second_control = !g_show_second_control;

	begin_window (math.xywhf (30, 30, 30, 30));
	end_window ();

	prev := gui.set_occlusion_layer ("Windows");
	
	begin_window (g_window_rect);
	{
		caption_rect := math.xywhf (0, 0, math.rect_width (g_window_rect), 25);
		if button (caption_rect) == .DOWN
		{
			mx, my := window.get_mouse_position (g_window);
			g_window_rect = math.set_position (g_window_rect, xx mx - math.rect_width (g_window_rect) * 0.5, xx my - math.rect_height (caption_rect) * 0.5);
			gui.raise_occluder ();
		}
		
		resize_button_rect := math.xywhf (math.rect_width (g_window_rect) - 25, math.rect_height (g_window_rect) - 25, 25, 25);
		if button (resize_button_rect) == .DOWN
		{
			mx, my := window.get_mouse_position (g_window);
			g_window_rect = math.set_size (g_window_rect, mx + 12.5 - g_window_rect.x1, my + 12.5 - g_window_rect.y1);
			gui.raise_occluder ();
		}
	}
	end_window ();

	begin_window (math.xywhf (100, 10, 50, 75));
	{
		if button (math.xywhf (10, 0, 50, 20)) == .DOWN
			gui.raise_occluder ();
	}
	end_window ();

	gui.set_occlusion_layer (prev);

	if g_show_second_control
		button (math.xywhf (20, 20, 50, 50));
}
