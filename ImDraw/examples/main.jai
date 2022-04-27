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

g_window : window.Window;
g_is_running : bool;

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

	gl.load ();
	g_window := window.create ("ImDraw Example", -1, -1, -1, -1, .VISIBLE);
	if !g_window
		error ("Could not create window.");
	defer window.destroy (g_window);
	gl_ctx := gl.create_context (g_window);
	if !gl_ctx
		error ("Could not create GL context.");
	defer gl.destroy_context (g_window, gl_ctx);
	imdraw_ctx := imdraw.create_context (g_window, gl_ctx);
	if !imdraw_ctx
		error ("Could not create ImDraw context.");
	defer imdraw.destroy_context (imdraw_ctx);
	jetbrains_mono := font.load_family ("data/jetbrains-mono/", "JetBrainsMono", mem.HEAP_ALLOC);
	if !jetbrains_mono
		error ("Could not load JetBrainsMono.");
	defer font.destroy_family (*jetbrains_mono, mem.HEAP_ALLOC);
	beau_rivage := font.load_family ("data/beau-rivage-regular/", "BeauRivage", mem.HEAP_ALLOC);
	if !beau_rivage
		error ("Could not load BeauRivage.");
	defer font.destroy_family (*beau_rivage, mem.HEAP_ALLOC);
	noto_sans_jp := font.load_family ("data/noto-sans-japanese/", "NotoSansJP", mem.HEAP_ALLOC);
	if !noto_sans_jp
		error ("Could not load NotoSansJP.");
	defer font.destroy_family (*noto_sans_jp, mem.HEAP_ALLOC);
	noto_sans_kr := font.load_family ("data/noto-sans-korean/", "NotoSansKR", mem.HEAP_ALLOC);
	if !noto_sans_kr
		error ("Could not load NotoSansKR.");
	defer font.destroy_family (*noto_sans_kr, mem.HEAP_ALLOC);
	uv_grid : render.Texture;
	if !render.load_texture_from_file (*uv_grid, "data/uv_grid.png")
		error ("Could not load UV grid texture.");
	defer render.destroy_texture (*uv_grid);

	g_is_running = true;
	while g_is_running
	{
		mem.reset_temporary_storage ();
		t := time.to_float_seconds (time.current_monotonic ());
		window.poll_messages (g_window);
		msg : window.Message;
		while window.get_next_message (g_window, *msg)
			handle_window_message (msg);
		
		width, height := window.get_viewport_size (g_window);
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
			imdraw.draw_text (jetbrains_mono, 30, pos, "Hello Sailor!", math.rgba (255, 95, 51), weight = .REGULAR, effects = imdraw.Text_Effects.ITALIC | .STRIKETHROUGH | .UNDERLINE);
			pos = vec2f (math.wrap (sin.x * -123.456, 0, cast (f32) width), 146 + sin.y * 6);
			imdraw.draw_text (beau_rivage, 30, pos, "Hello Sailor!", math.rgba (66, 135, 245), effects = .UNDERLINE);
			pos = vec2f (math.wrap (cos.x * 26, 0, cast (f32) width), 300 + cos.y * 13);
			imdraw.draw_text (noto_sans_jp, 30, pos, "こんにちはセーラー！", math.rgba (57, 250, 224), weight = .MEDIUM);
			pos = vec2f (math.wrap (sin.x * 4, 0, cast (f32) width), 420 + sin.y * 32);
			imdraw.draw_text (noto_sans_kr, 30, pos, "안녕하세요 선원님!", math.rgba (255, 56, 225), weight = .LIGHT, effects = imdraw.Text_Effects.STRIKEOUT);

			datetime := time.to_calendar (time.current_consensus (), .LOCAL);
			datetime_str := time.format (datetime, "{DD}, {MM} {d}, {yy}\n{hr:02}:{mn:02}:{sc:02} {AMPM}", mem.TEMP_ALLOC);
			imdraw.draw_text (
				jetbrains_mono,
				22,
				vec2f (width - 10.0, height - 10.0),
				datetime_str,
				math.RGBA_WHITE,
				anchor = .BOTTOM_RIGHT
			);
		}
		imdraw.end ();
		window.swap_buffers (g_window);
	}
}
