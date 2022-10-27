#import "Runtime";
mem  :: #import "Memory";
fmt  :: #import "Fmt";
time :: #import "Apollo_Time";
math :: #import "Math";
int128 :: #import "Math/Int128";
linalg :: #import "Linalg";
log :: #import "Log";

ps     :: #import "Process";
window :: #import "Window";
input  :: #import "Input";
gl     :: #import "GL";
gl_utils :: #import "GL/Utils";

im3d    :: #import "Im3d";
im3d_impl :: #import "Im3d/Impl/GL";

using, only (.["==","+","-","*","/"]) int128;
using, only (.["==","+","-","*","/"]) linalg;

#load "teapot.jai";

g_window : window.Handle;
g_is_running : bool;

Camera :: struct
{
	position : linalg.Vec3f;
	yaw, pitch : f32;

	fov := 60.0;
	transform : linalg.Mat4f;
	view_matrix : linalg.Mat4f;
	projection_matrix : linalg.Mat4f;
	view_projection_matrix : linalg.Mat4f;
	use_orthographic_projection : bool;
}

update_flying_camera :: (using camera : *Camera, delta_time : f32)
{
	left := cast (f32) input.is_key_down (.A);
	right := cast (f32) input.is_key_down (.D);
	back := cast (f32) input.is_key_down (.S);
	forward := cast (f32) input.is_key_down (.W);
	down := cast (f32) input.is_key_down (.Q);
	up := cast (f32) input.is_key_down (.E);

	input_vector : linalg.Vec3f;
	if !input.is_key_down (.CTRL)
	{
		input_vector = linalg.vec3f (right - left, up - down, forward - back);
		input_vector = linalg.normalized (input_vector);
		input_vector *= ifx input.is_key_down (.SHIFT) then 1.0 else 0.1;
		input_vector *= delta_time * 60;
	}

	position += input_vector.x * linalg.right_vector (transform)
		+ input_vector.y * linalg.up_vector (transform)
		+ input_vector.z * linalg.forward_vector (transform);

	mx, my := input.get_mouse_delta ();
	if input.is_mouse_button_down (.RIGHT)
	{
		yaw += mx * 0.5;
		pitch += my * 0.5;
		pitch = math.clamp (pitch, -80, 80);
	}

	transform = linalg.mat4f_translate (position)
		* (linalg.mat4f_rotate (.{0,1,0}, linalg.to_rads (yaw)) * linalg.mat4f_rotate (.{1,0,0}, linalg.to_rads (pitch)));
	view_matrix = linalg.inverse (transform);

	width, height := window.get_viewport_size (g_window);
	aspect_ratio := width / cast (f32) height;
	if use_orthographic_projection
		projection_matrix = linalg.mat4f_orthographic_projection (-5 * aspect_ratio, 5 * aspect_ratio, -5, 5, 0.1, 1000.0);
	else
		projection_matrix = linalg.mat4f_perspective_projection (fov, aspect_ratio, 0.1, 1000.0);

	view_projection_matrix = projection_matrix * view_matrix;
}

update_im3d_keys :: ()
{
	app := im3d.GetAppData ();
	app.keyDown[im3d.Key.Mouse_Left] = input.is_mouse_button_down (.LEFT);

	app.keyDown[im3d.Key.L] = input.is_key_down (.L);
	app.keyDown[im3d.Key.T] = input.is_key_down (.T);
	app.keyDown[im3d.Key.R] = input.is_key_down (.R);
	app.keyDown[im3d.Key.S] = input.is_key_down (.S);

	if input.is_key_down (.CTRL)
	{
		app.snapTranslation = 0.5;
		app.snapRotation    = linalg.to_rads (30.0);
		app.snapScale       = 0.5;
	}
	else
	{
		app.snapTranslation = 0;
		app.snapRotation    = 0;
		app.snapScale       = 0;
	}
}

main :: ()
{
	error :: (fmt_str : string, args : ..Any) #expand
	{
		window.show_error_box (fmt_str, ..args);
		`return;
	}

	defer fmt.println ("Program ended gracefully.");
	fill_default_context ();
	
	input.init ();

	gl.load ();
	
	g_window = window.create ("Im3d Example", -1, -1, -1, -1, .VISIBLE);
	if !g_window
		error ("Could not create main window.");
	defer window.destroy (g_window);
	
	gl_ctx := gl.create_context (g_window);
	if !gl_ctx
		error ("Could not create GL context.");
	defer gl.destroy_context (g_window, gl_ctx);

	if !im3d_impl.init (g_window)
		error ("Could not initialize Im3d implementation layer.");

	camera : Camera;
	camera.position.z = -10;

	gl.Enable (gl.DEPTH_TEST);
	teapot_transform : linalg.Mat4f;

	g_is_running = true;
	delta_time := 0.1666;
	while g_is_running
	{
		frame_start := time.current_monotonic ();

		mem.reset_temporary_storage ();

		input.update ();

		window.poll_messages (g_window);
		msg : window.Message;
		while window.get_next_message (g_window, *msg)
		{
			input.handle_window_message (msg);
			if msg.kind ==
			{
			case .WINDOW_CLOSED;
				g_is_running = false;
			}
		}

		update_flying_camera (*camera, delta_time);

		update_im3d_keys ();

		im3d_impl.new_frame (camera.fov, camera.transform, camera.projection_matrix, delta_time, camera.use_orthographic_projection);
		im3d.NewFrame ();
		{
			im3d.DrawXyzAxes ();

			for i : 0..10
				im3d.DrawLine (linalg.vec3f (i - 5.0, 0, -5), linalg.vec3f (i - 5.0, 0, 5), 1, im3d.Color_White);
			
			for i : 0..10
				im3d.DrawLine (linalg.vec3f (-5, 0, i - 5.0), linalg.vec3f (5, 0, i - 5.0), 1, im3d.Color_White);

			im3d.Gizmo ("Teapot transform", cast (*[16]f32) *teapot_transform.n);
		}
		im3d.EndFrame ();

		width, height := window.get_viewport_size (g_window);
		gl.Viewport (0, 0, xx width, xx height);
		gl.ClearColor (0.1, 0.1, 0.1, 1);
		gl.Clear (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

		draw_teapot (camera, teapot_transform);
		//draw_teapot (camera, linalg.mat4f_translate (.{0,0,-15}));
		//draw_teapot (camera, linalg.mat4f_translate (.{0,0,15}));
		im3d_impl.render_draw_lists (im3d.GetDrawLists (), im3d.GetDrawListCount ());

		window.swap_buffers (g_window);
		
		ps.sleep_milliseconds (10);

		frame_end := time.current_monotonic ();
		delta_time = cast (f32) time.to_f64_seconds (frame_end - frame_start);
	}
}
