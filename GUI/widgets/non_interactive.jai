image :: (rect : math.Rectf, texture : *render.Texture, color := math.RGBA_WHITE, uv_rect := math.Rectf.{ 0, 0, 1, 1 })
{
	check_init ();

	absolute_rect : math.Rectf;
	if ui.current_occluder
		absolute_rect = math.move (rect, math.rect_position (ui.current_occluder.rect));
	else
		absolute_rect = rect;

	imdraw.set_texture (get_renderer (), texture);
	imdraw.draw_rect (get_renderer (), absolute_rect, color, uv_rect);
	imdraw.set_texture (get_renderer (), null);
}
