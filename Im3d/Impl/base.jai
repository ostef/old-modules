#scope_module

#import "Runtime";
mem :: #import "Memory";
str :: #import "String";
math :: #import "Math";
linalg :: #import "Linalg";
log :: #import "Log";

im3d :: #import "Im3d";
input  :: #import "Input";
window :: #import "Window";

using, only (.["==","+","-","*","/"]) linalg;

#scope_export

Implementation_Data :: struct
{
	win_handle : window.Handle;
	view_projection_matrix : linalg.Mat4f;
	projection_matrix : linalg.Mat4f;
	using renderer_data : Renderer_Data;
}

get_implementation_data :: inline () -> *Implementation_Data #must
{
	return cast (*Implementation_Data) im3d.GetAppData ().appData;
}

get_renderer_data :: inline () -> *Renderer_Data #must
{
	return *get_implementation_data ().renderer_data;
}

init :: (win_handle : window.Handle) -> bool
{
	data := mem.alloc (Implementation_Data);
	data.win_handle = win_handle;

	im3d.GetAppData ().appData = data;

	return init_renderer_data ();
}

terminate :: ()
{
	cleanup_renderer_data ();
	mem.free (im3d.GetAppData ().appData);
	im3d.GetAppData ().appData = null;
}

new_frame :: (fov : f32, camera_transform : linalg.Mat4f, projection : linalg.Mat4f, delta_time : f32, use_orthographic_projection := false)
{
	app := im3d.GetAppData ();
	data := get_implementation_data ();
	view_matrix := linalg.inverse (camera_transform);
	data.view_projection_matrix = projection * view_matrix;

	app.deltaTime = delta_time;

	width, height := window.get_viewport_size (data.win_handle);
	app.viewportSize.x = xx width;
	app.viewportSize.y = xx height;

	app.viewOrigin = linalg.translation_vector (camera_transform);
	app.viewDirection = linalg.forward_vector (camera_transform);
	app.projOrtho = use_orthographic_projection;

	mx, my := window.get_mouse_position (data.win_handle);
	cursor_pos := linalg.vec2f (mx / app.viewportSize.x - 0.5, my / app.viewportSize.y - 0.5) * 2;
	cursor_pos.y = -cursor_pos.y;

	if app.projOrtho
	{
		app.projScaleY = 2 / projection.r1c1;

		app.cursorRayOrigin.x = cursor_pos.x / projection.r0c0;
		app.cursorRayOrigin.y = cursor_pos.y / projection.r1c1;
		app.cursorRayOrigin.z = 0;
		app.cursorRayOrigin = linalg.transform_point (camera_transform, app.cursorRayOrigin);

		app.cursorRayDirection = app.viewDirection;
	}
	else
	{
		app.projScaleY = 2 * math.tan (linalg.to_rads (fov) * 0.5);

		app.cursorRayOrigin = app.viewOrigin;

		app.cursorRayDirection.x = cursor_pos.x / projection.r0c0;
		app.cursorRayDirection.y = cursor_pos.y / projection.r1c1;
		app.cursorRayDirection.z = 1;
		app.cursorRayDirection = linalg.transform_vector (camera_transform, linalg.normalized (app.cursorRayDirection));
	}

	im3d.AppData.setCullFrustum (app, data.view_projection_matrix, true);

	app.keyDown[im3d.Key.Mouse_Left] = input.is_mouse_button_down (.LEFT);

	ctrl_down := input.is_key_down (.CTRL);
	app.keyDown[im3d.Key.L] = ctrl_down && input.is_key_down (.L);
	app.keyDown[im3d.Key.T] = ctrl_down && input.is_key_down (.T);
	app.keyDown[im3d.Key.R] = ctrl_down && input.is_key_down (.R);
	app.keyDown[im3d.Key.S] = ctrl_down && input.is_key_down (.S);

	if ctrl_down
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
