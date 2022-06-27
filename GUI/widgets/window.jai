begin_window :: (rect : math.Rectf, set_rect_once := true, location := #caller_location)
{
	check_init ();

	occl := begin_occlusion (rect, location, set_rect_once);
	window_rect := occl.rect;

	color : math.RGBA;
	color.value = occl.id;
	color.a = 128;
	imdraw.draw_rect (get_renderer (), occl.rect, color, corner_radius = 10);
	if context.ui_context.mouse_focused_occluder && context.ui_context.mouse_focused_occluder == occl
		imdraw.draw_rect_outline (get_renderer (), occl.rect, .{255,0,0,255}, 2, corner_radius = 10);

	// Move caption
	caption_rect := math.xywhf (0, 0, math.rect_width (window_rect), 25);
	caption_ctrl := declare_control (
		caption_rect,
		location,
		flags = Control.Flags.FOCUSABLE | .INTERACT_ON_HELD | .CONTINUE_INTERACTION_WHEN_UNFOCUSED,
		id_offset = 1
	);
	draw_button (caption_ctrl);

	if flagged (caption_ctrl.state_flags, .INTERACTING)
	{
		new_position := ui.mouse_position - caption_ctrl.relative_mouse_position_when_started_interacting;
		window_rect = math.set_position (window_rect, new_position);
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
	draw_button (resize_button_ctrl);

	if flagged (resize_button_ctrl.state_flags, .INTERACTING)
	{
		new_position := ui.mouse_position - resize_button_ctrl.relative_mouse_position_when_started_interacting;
		window_rect = math.set_size (window_rect, new_position - math.rect_position (window_rect) + math.rect_size (resize_button_rect));
		raise_occluder ();
	}

	occl.rect = window_rect;
}

end_window :: ()
{
	end_occlusion ();
}
