// This file actually tests more than just ImDraw. It has Math,
// Linalg, Apollo_Time, Input, Window, Font, Random things in it.
// We might want to move this elsewhere at some point.

#import "Runtime";
mem    :: #import "Memory";
fmt    :: #import "Fmt";
using linalg :: #import "Linalg";
math   :: #import "Math";
rand   :: #import "Math/Random";
input  :: #import "Input";
window :: #import "Window";
gl     :: #import "GL";
font   :: #import "Font";
render :: #import "Render_Core";
imdraw :: #import "ImDraw";
time   :: #import "Apollo_Time";

main_window : window.Window;
is_running : bool;

handle_window_message :: (msg : window.Message)
{
	if msg.kind ==
	{
	case .WINDOW_CLOSED;
		is_running = false;
	}
}

main :: ()
{
	error :: (msg : string, args : ..Any) #expand
	{
		window.show_error_box (msg, ..args);
		`return;
	}

	gl.load ();
	main_window := window.create ("ImDraw Example", -1, -1, -1, -1, .VISIBLE);
	if !main_window
		error ("Could not create window.");
	defer window.destroy (main_window);
	gl_ctx := gl.create_context (main_window, );
	if !gl_ctx
		error ("Could not create GL context.");
	defer gl.destroy_context (main_window, gl_ctx);
	imdraw_ctx := imdraw.create_context (main_window, gl_ctx);
	if !imdraw_ctx
		error ("Could not create ImDraw context.");
	defer imdraw.destroy_context (imdraw_ctx);
	jetbrains_mono, beau_rivage, noto_sans_jp, noto_sans_kr : font.Font;
	if !font.load_from_file (*jetbrains_mono, "data/jetbrains-mono/JetBrainsMono-Regular.ttf")
		error ("Could not load JetBrainsMono-Regular.ttf");
	defer font.destroy (*jetbrains_mono);
	if !font.load_from_file (*beau_rivage, "data/beau-rivage-regular/BeauRivage-Regular.ttf")
		error ("Could not load BeauRivage-Regular.ttf");
	defer font.destroy (*beau_rivage);
	if !font.load_from_file (*noto_sans_jp, "data/noto-sans-japanese/NotoSansJP-Regular.otf")
		error ("Could not load NotoSansJP-Regular.otf");
	defer font.destroy (*noto_sans_jp);
	if !font.load_from_file (*noto_sans_kr, "data/noto-sans-korean/NotoSansKR-Regular.otf")
		error ("Could not load NotoSansKR-Regular.otf");
	defer font.destroy (*noto_sans_kr);
	uv_grid : render.Texture;
	if !render.load_texture_from_file (*uv_grid, "data/uv_grid.png")
		error ("Could not load UV grid texture.");
	defer render.destroy_texture (*uv_grid);

	is_running = true;
	while is_running
	{
		mem.reset_temporary_storage ();
		t := time.to_float_seconds (time.current_monotonic ());
		window.poll_messages (main_window);
		msg : window.Message;
		while window.get_next_message (main_window, *msg)
			handle_window_message (msg);
		
		width, height := window.get_viewport_size (main_window);
		gl.ClearColor (0.1, 0.1, 0.1, 1);
		gl.Clear (gl.COLOR_BUFFER_BIT);
		imdraw.begin (imdraw_ctx);
		{
			prev_texture := imdraw.set_texture (*uv_grid);
			imdraw.draw_circle (vec2f (500, 200), 150 + math.sin (cast (f32) t) * 50, math.RGBA_WHITE);
			imdraw.set_texture (prev_texture);

			cos := vec2f (xx t, math.cos (cast (f32) t));
			sin := vec2f (xx t, math.sin (cast (f32) t));
			pos := vec2f (math.wrap (cos.x * 69.105, 0, cast (f32) width), 30 + cos.y * 10);
			imdraw.draw_text (*jetbrains_mono, 30, round (pos), "Hello Sailor!", math.RGBA_WHITE);
			pos = vec2f (math.wrap (sin.x * -123.456, 0, cast (f32) width), 146 + sin.y * 6);
			imdraw.draw_text (*beau_rivage, 30, round (pos), "Hello Sailor!", math.RGBA_WHITE);
			pos = vec2f (math.wrap (cos.x * 26, 0, cast (f32) width), 300 + cos.y * 13);
			imdraw.draw_text (*noto_sans_jp, 30, round (pos), "こんにちはセーラー！", math.RGBA_WHITE);
			pos = vec2f (math.wrap (sin.x * 4, 0, cast (f32) width), 420 + sin.y * 32);
			imdraw.draw_text (*noto_sans_kr, 30, round (pos), "안녕하세요 선원님!", math.RGBA_WHITE);

			datetime := time.to_calendar (time.current_consensus (), .LOCAL);
			datetime_str := time.format (datetime, "{DD}, {MM} {d}, {yy}\n{hr:02}:{mn:02}:{sc:02} {AMPM}", mem.TEMP_ALLOC);
			size := font.calculate_text_extents (*jetbrains_mono, 22, datetime_str);
			imdraw.draw_text (*jetbrains_mono, 22, round (vec2f (width - 10.0, height - 10.0) - size), datetime_str, math.RGBA_WHITE);
		}
		imdraw.end ();
		window.swap_buffers (main_window);
	}
}
