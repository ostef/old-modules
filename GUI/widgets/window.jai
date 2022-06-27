// For now, the way we need to pass some info to end_window, to modify the occluder
// after every control declaration/drawing relative to the window has been done
// Maybe we'll find a way to not have this later

Window_Info :: struct
{
	modified_window_rect : math.Rectf;
}

begin_window :: (rect : math.Rectf, set_rect_once := true, location := #caller_location) -> Window_Info #must
{
	check_init ();

	occl := begin_occlusion (rect, location, set_rect_once);
	using result : Window_Info;
	modified_window_rect = occl.rect;

	// Caption
	caption_rect := math.xywhf (0, 0, math.rect_width (occl.rect), 25);
	caption_ctrl := declare_control (
		caption_rect,
		location,
		flags = Control.Flags.FOCUSABLE | .INTERACT_ON_HELD | .CONTINUE_INTERACTION_WHEN_UNFOCUSED,
		id_offset = 1
	);

	if flagged (caption_ctrl.state_flags, .INTERACTING)
	{
		new_position := ui.mouse_position - caption_ctrl.relative_mouse_position_when_started_interacting;
		modified_window_rect = math.set_position (modified_window_rect, new_position);
		raise_occluder ();
	}
	
	// Resize button
	resize_button_rect := math.xywhf (math.rect_width (occl.rect) - 25, math.rect_height (occl.rect) - 25, 25, 25);
	resize_button_ctrl := declare_control (
		resize_button_rect,
		location,
		flags = Control.Flags.FOCUSABLE | .INTERACT_ON_HELD | .CONTINUE_INTERACTION_WHEN_UNFOCUSED,
		id_offset = 2
	);

	if flagged (resize_button_ctrl.state_flags, .INTERACTING)
	{
		new_position := ui.mouse_position - resize_button_ctrl.relative_mouse_position_when_started_interacting;
		modified_window_rect = math.set_size (modified_window_rect, new_position - math.rect_position (modified_window_rect) + math.rect_size (resize_button_rect));
		raise_occluder ();
	}

	// Drawing
	imdraw.set_clip_rect (get_renderer (), math.recti (occl.rect));
	color : math.RGBA;
	color.value = occl.id;
	color.a = 128;
	imdraw.draw_rect (get_renderer (), occl.rect, color, corner_radius = 10);

	draw_button (caption_ctrl);
	draw_button (resize_button_ctrl);

	return result;
}

end_window :: (using info : Window_Info)
{
	check_init ();

	imdraw.set_clipping (get_renderer (), false);
	if ui.mouse_focused_occluder && ui.mouse_focused_occluder == ui.current_occluder
		imdraw.draw_rect_outline (get_renderer (), ui.current_occluder.rect, .{255,0,0,50}, 1, corner_radius = 10);

	ui.current_occluder.rect = modified_window_rect;

	end_occlusion ();
}
