image :: (rect : math.Rectf, texture : *render.Texture, color := math.RGBA_WHITE, uv_rect := math.Rectf.{ 0, 0, 1, 1 })
{
	check_init ();

	absolute_rect := rect;
	if ui.current_occluder
		absolute_rect.position += ui.current_occluder.rect.position;

	imdraw.set_texture (get_renderer (), texture);
	imdraw.draw_rect (get_renderer (), absolute_rect, color, uv_rect);
	imdraw.set_texture (get_renderer (), null);
}
