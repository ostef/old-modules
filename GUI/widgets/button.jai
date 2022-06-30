Button_Style :: struct
{
	State_Style :: struct
	{
		using rect_style : Rectangle_Style;
		image_color := math.RGBA_WHITE;
		text_weight : font.Weight;
		text_effects : imdraw.Text_Effects;
		text_color : math.RGBA;
		text_and_image_offset : linalg.Vec2f;
	}

	text_font : *font.Font;
	text_font_height : u32;

	clip := true;
	padding : f32;

	normal  : State_Style;
	focused : State_Style;
	hot     : State_Style;
}

text_button :: (
	rect : math.Rectf,
	text : string,
	style : *Button_Style = null,
	location := #caller_location
) -> bool
{
	ctrl := declare_control (rect, location, Control.Flags.FOCUSABLE | .INTERACT_ON_RELEASED);
	draw_button (ctrl, text, null, .{}, style);

	return flagged (ctrl.state_flags, .INTERACTING);
}

image_button :: (
	rect : math.Rectf,
	image : *render.Texture,
	image_uv := math.Rectf.{0,0,1,1},
	style : *Button_Style = null,
	location := #caller_location
) -> bool
{
	ctrl := declare_control (rect, location, Control.Flags.FOCUSABLE | .INTERACT_ON_RELEASED);
	draw_button (ctrl, "", image, image_uv, style);

	return flagged (ctrl.state_flags, .INTERACTING);
}

draw_button :: (ctrl : *Control, text : string, image : *render.Texture, image_uv : math.Rectf, style : *Button_Style)
{
	state_style : Button_Style.State_Style;
	if flagged (ctrl.state_flags, .HOT)
		state_style = style.hot;
	else if flagged (ctrl.state_flags, .FOCUSED)
		state_style = style.focused;
	else
		state_style = style.normal;

	imdraw.draw_rect (get_renderer (), ctrl.rect, state_style.background_color, corner_radius = state_style.corner_radiuses.top_left);
	if state_style.border_thickness > 0
		imdraw.draw_rect_outline (
			get_renderer (),
			math.truncate_all_sides (ctrl.rect, state_style.border_inset),
			state_style.border_color,
			state_style.border_thickness,
			corner_radius = state_style.corner_radiuses.top_left
		);

	prev_clip : bool;
	prev_clip_rect : math.Recti;
	if style.clip
	{
		prev_clip = imdraw.get_clipping (get_renderer ());
		prev_clip_rect = imdraw.push_clip_rect (get_renderer (), math.recti (math.truncate_all_sides (ctrl.rect, style.padding)));
	}
	defer if style.clip
	{
		imdraw.set_clip_rect (get_renderer (), prev_clip_rect);
		imdraw.set_clipping (get_renderer (), prev_clip);
	}

	image_rect : math.Rectf;
	if image
	{
		image_padding := (ctrl.rect.h - xx image.height) * 0.5;
		image_rect = math.xywhf (image_padding + state_style.text_and_image_offset.x, image_padding + state_style.text_and_image_offset.y, xx image.width, xx image.height);
		imdraw.set_texture (get_renderer (), image);
		imdraw.draw_rect (get_renderer (), math.move (image_rect, ctrl.rect.position), state_style.image_color, uv_rect = image_uv);
		imdraw.set_texture (get_renderer (), null);
	}

	if text
		imdraw.draw_text (
			get_renderer (),
			style.text_font,
			style.text_font_height,
			linalg.vec2f (ctrl.rect.x + ctrl.rect.w * 0.5, ctrl.rect.y + ctrl.rect.h * 0.5) + state_style.text_and_image_offset + linalg.vec2f (image_rect.x + image_rect.w, 0),
			text,
			state_style.text_color,
			state_style.text_weight,
			state_style.text_effects,
			.CENTER
		);
}
