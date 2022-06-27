draw_button :: (ctrl : *Control)
{
	color : math.RGBA;
	color.value = ctrl.id;
	color.a = 255;
	imdraw.draw_rect (get_renderer (), ctrl.rect, color, corner_radius = 10);
	if flagged (ctrl.focus_state, .RELEASED)
		imdraw.draw_rect_outline (get_renderer (), ctrl.rect, .{255, 0, 0, 255}, 2);
	else if flagged (ctrl.focus_state, .DOWN)
		imdraw.draw_rect_outline (get_renderer (), ctrl.rect, .{100, 100, 100, 255}, 2);
	else if flagged (ctrl.focus_state, .FOCUSED)
		imdraw.draw_rect_outline (get_renderer (), ctrl.rect, math.RGBA_WHITE, 2);
}

button :: (
	rect : math.Rectf,
	interaction_flags := Control.Flags.DEFAULT_INTERACTION,
	id_offset : u32 = 0,
	location := #caller_location
) -> bool
{
	ctrl := declare_control (rect, location, Control.Flags.FOCUSABLE | interaction_flags, id_offset = id_offset);

	draw_button (ctrl);

	return flagged (ctrl.state_flags, .INTERACTING);
}
