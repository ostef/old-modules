#import "Runtime";
mem  :: #import "Memory";
fmt  :: #import "Fmt";
time :: #import "Apollo_Time";

ps     :: #import "Process";
window :: #import "Window";
input  :: #import "Input";
gl     :: #import "GL";

imgui          :: #import "ImGui";
imgui_platform :: #import "ImGui/Impl/Platform";
imgui_gl       :: #import "ImGui/Impl/GL";

g_window : window.Handle;
g_is_running : bool;

main :: ()
{
	error :: (fmt_str : string, args : ..Any) #expand
	{
		window.show_error_box (fmt_str, ..args);
		`return;
	}

	defer fmt.println ("Program ended gracefully.");
	fill_default_context ();
	
	gl.load ();
	
	g_window = window.create ("ImGui Example", -1, -1, -1, -1, .VISIBLE);
	if !g_window
		error ("Could not create main window.");
	defer window.destroy (g_window);
	
	gl_ctx := gl.create_context (g_window);
	if !gl_ctx
		error ("Could not create GL context.");
	defer gl.destroy_context (g_window, gl_ctx);

	imgui.CreateContext ();

	io := imgui.GetIO ();
	io.ConfigFlags_ |= .NavEnableKeyboard;
	io.ConfigFlags_ |= .DockingEnable;

	imgui.StyleColorsDark ();
	imgui.GetStyle ().WindowRounding = 5;
	imgui.GetStyle ().FrameRounding  = 3;
	imgui.GetStyle ().GrabRounding   = 3;
	imgui.GetStyle ().TabRounding    = 3;
	imgui.GetStyle ().FramePadding.x = 6;
	imgui.GetStyle ().FramePadding.y = 3;
	imgui.GetStyle ().ItemSpacing.y = 6;
	imgui.GetStyle ().WindowTitleAlign.x = 0.5;

	io.Fonts.AddFontFromFileTTF (io.Fonts, "fonts/OpenSans-Regular.ttf", 18);

	if !imgui_platform.init (g_window)
		error ("Could not initialize ImGui platform layer.");
	if !imgui_gl.init ()
		error ("Could not initialize ImGui GL layer.");

	show_demo_window := true;
	g_is_running = true;
	delta_time := 0.1666;
	while g_is_running
	{
		frame_start := time.to_float_seconds (time.current_monotonic ());
		mem.reset_temporary_storage ();

		input.update ();
		
		window.poll_messages (g_window);
		msg : window.Message;
		while window.get_next_message (g_window, *msg)
		{
			input.handle_window_message (msg);
			imgui_platform.handle_window_message (msg);

			if msg.kind ==
			{
			case .WINDOW_CLOSED;
				g_is_running = false;
			}
		}

		imgui_platform.new_frame (delta_time);
		imgui_gl.new_frame ();
		imgui.NewFrame ();

		if show_demo_window
			imgui.ShowDemoWindow (*show_demo_window);
		
		imgui.Render ();

		width, height := window.get_viewport_size (g_window);
		gl.Viewport (0, 0, xx width, xx height);
		gl.ClearColor (0.1, 0.1, 0.1, 1);
		gl.Clear (gl.COLOR_BUFFER_BIT);
		imgui_gl.render_draw_data (imgui.GetDrawData ());

		window.swap_buffers (g_window);
		
		ps.sleep_milliseconds (10);
		frame_end := time.to_float_seconds (time.current_monotonic ());
		delta_time = cast (f32) (frame_end - frame_start);
	}
}
