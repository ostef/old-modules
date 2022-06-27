begin_window :: (rect : math.Rectf, location := #caller_location)
{
	occl := begin_occlusion (rect, location);

	color : math.RGBA;
	color.value = occl.id;
	color.a = 128;
	imdraw.draw_rect (get_renderer (), occl.rect, color, corner_radius = 10);
	if context.ui_context.mouse_focused_occluder && context.ui_context.mouse_focused_occluder == occl
		imdraw.draw_rect_outline (get_renderer (), occl.rect, .{255,0,0,255}, 2, corner_radius = 10);
}

end_window :: ()
{
	end_occlusion ();
}
