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
g_icons : struct
{
	exclamation : render.Texture;
	check : render.Texture;
};

handle_window_message :: (msg : window.Message)
{
	gui.check_init ();

	input.handle_window_message (msg);
	if msg.kind ==
	{
	case .WINDOW_CLOSED;
		g_is_running = false;

	case .TEXT_INPUT;
		gui.input_text (msg.codepoint);
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

	if !render.load_texture_from_file (*g_icons.exclamation, "data/icons/exclamation_16.png")
		error ("Could not load icon.");

	if !render.load_texture_from_file (*g_icons.check, "data/icons/check_16.png")
		error ("Could not load icon.");

	gui.init ();
	defer gui.terminate ();

	gl.ClearColor (0.1, 0.3, 0.2, 1);
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

	ui.delta_time = delta_time;
}

g_text_buffer  : [..]u8;
g_text_buffer2 : [..]u8;
g_show_second_control := true;

update_ui :: ()
{
	g_text_buffer.allocator = mem.HEAP_ALLOC;
	g_text_buffer2.allocator = mem.HEAP_ALLOC;

	button_style : gui.Button_Style;
	button_style.text_font = g_font;
	button_style.text_font_height = 13;
	button_style.padding = 2;
	button_style.normal.background_color = .{80,80,80,255};
	button_style.normal.text_color = .{255,255,255,255};
	button_style.normal.border_color = .{10,10,10,255};
	button_style.normal.border_thickness = 1;
	button_style.normal.border_inset = button_style.normal.border_thickness * 0.5;
	button_style.normal.corner_radiuses.top_left = 5;
	button_style.focused = button_style.normal;
	button_style.focused.background_color = .{100,100,100,255};
	button_style.hot = button_style.normal;
	button_style.hot.background_color = .{60,60,60,255};
	button_style.hot.text_and_image_offset.y = 1;

	image_button_style : gui.Button_Style;
	image_button_style.text_font = g_font;
	image_button_style.text_font_height = 13;
	image_button_style.padding = 2;
	image_button_style.normal.background_color = math.RGBA_TRANSPARENT;
	image_button_style.normal.image_color = .{255,255,255,200};
	image_button_style.normal.corner_radiuses.top_left = 5;
	image_button_style.focused = image_button_style.normal;
	image_button_style.focused.background_color = .{100,100,100,255};
	image_button_style.focused.image_color = .{255,255,255,255};
	image_button_style.hot = image_button_style.normal;
	image_button_style.hot.background_color = .{60,60,60,255};
	image_button_style.hot.image_color = .{255,255,255,255};
	image_button_style.hot.text_and_image_offset.y = 1;

	text_input_style : gui.Text_Input_Style;
	text_input_style.text_font = g_font;
	text_input_style.text_font_height = 13;
	text_input_style.cursor_color = .{255,255,255,255};
	text_input_style.padding = 2;
	text_input_style.normal.background_color = .{80,80,80,255};
	text_input_style.normal.text_color = .{255,255,255,255};
	text_input_style.normal.corner_radiuses.top_left = 5;
	text_input_style.focused = text_input_style.normal;
	text_input_style.focused.background_color = .{100,100,100,255};
	text_input_style.hot = text_input_style.normal;
	text_input_style.hot.background_color = .{60,60,60,255};
	text_input_style.hot.text_offset.y = 1;
	text_input_style.active = text_input_style.normal;
	text_input_style.active.border_color = .{50,75,190,200};
	text_input_style.active.border_thickness = 2;

	window_style : gui.Window_Style;
	window_style.move_caption_height = 30;
	window_style.resize_border_thickness = 8;
	window_style.padding = window_style.resize_border_thickness;
	window_style.title_font = g_font;
	window_style.title_font_height = 13;
	window_style.title_color = .{255,255,255,255};
	window_style.background_color = .{20,20,20,200};
	window_style.border_color = .{80,80,80,255};
	window_style.border_thickness = 1;
	window_style.border_inset = button_style.normal.border_thickness * 0.5 + 2;
	window_style.corner_radiuses.top_left = 6;

	if gui.text_button (math.xywhf (10, 10, 150, 25), "Show Second Button", *button_style)
		g_show_second_control = !g_show_second_control;

	if g_show_second_control
		gui.text_button (math.xywhf (10, 40, 80, 25), "Press Me", *button_style);

	window_info := gui.begin_window (math.xywhf (30, 345, 200, 145), "Window 1", style = *window_style);
		if gui.text_button (math.xywhf (10, window_style.move_caption_height + 10, 150, 25), "Show Second Button", *button_style)
			g_show_second_control = !g_show_second_control;

		if g_show_second_control
			gui.text_button (math.xywhf (10, window_style.move_caption_height + 40, 80, 25), "Press Me", *button_style);
	gui.end_window (window_info);

	prev := gui.set_occlusion_layer ("Windows");
	
	window_info = gui.begin_window (math.xywhf (50, 30, 300, 200), "Window 2", style = *window_style);
	{
		size := gui.get_occluder_size ();

		gui.text_input (math.xywhf (10, window_style.move_caption_height + 10, size.x * 0.5, 25), *g_text_buffer, *text_input_style);
		
		gui.image_button (math.xywhf (10 + size.x * 0.5 + 2, window_style.move_caption_height + 10, 25, 25), *g_icons.check, style = *image_button_style);
		
		gui.text_input (math.xywhf (10, window_style.move_caption_height + 40, size.x * 0.5, 25), *g_text_buffer2, *text_input_style);

		gui.image_button (math.xywhf (10 + size.x * 0.5 + 2, window_style.move_caption_height + 40, 25, 25), *g_icons.check, style = *image_button_style);
	}
	gui.end_window (window_info);

	window_info = gui.begin_window (math.xywhf (100, 10, 80, 75), "Window 3", style = *window_style);
	gui.end_window (window_info);

	gui.set_occlusion_layer (prev);
}
