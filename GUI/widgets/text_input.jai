Text_Input_Style :: struct
{
	State_Style :: struct
	{
		using common : Common_Style;
		text_weight : font.Weight;
		text_effects : imdraw.Text_Effects;
		text_color : math.RGBA;
		text_offset : linalg.Vec2f;
	}

	text_font : *font.Font;
	text_font_height : u32;

	cursor_color : math.RGBA;

	clip := true;
	padding : f32;

	normal  : State_Style;
	focused : State_Style;
	hot     : State_Style;
	active  : State_Style;
}

text_input :: (rect : math.Rectf, buffer : *[..]u8, style : *Text_Input_Style = null, id_offset : u32 = 0, location := #caller_location) -> bool
{
	check_init ();
	ctrl := declare_control (rect, location, Control.Flags.FOCUSABLE | .INTERACT_ON_HELD, id_offset = id_offset);
	if input.is_mouse_button_pressed (.LEFT) && !flagged (ctrl.state_flags, .HOT)
		stop_grabbing_text_input (buffer);

	result := false;
	if is_editing_text (buffer) || flagged (ctrl.state_flags, .INTERACTING)
	{
		grab_text_input (buffer);
		if input.is_key_pressed_or_repeated (.RETURN)
		{
			result = true;
			stop_grabbing_text_input (buffer);
		}
		if input.is_key_pressed_or_repeated (.ESCAPE)
			stop_grabbing_text_input (buffer);
	}

	draw_text_input (ctrl, buffer, style);

	return result;
}

draw_text_input :: (ctrl : *Control, buffer : *[..]u8, style : *Text_Input_Style)
{
	state_style : Text_Input_Style.State_Style;
	if is_editing_text (buffer)
		state_style = style.active;
	else if flagged (ctrl.state_flags, .HOT)
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
		prev_clip = imdraw.set_clipping (get_renderer (), true);
		prev_clip_rect = imdraw.push_clip_rect (get_renderer (), math.recti (math.truncate_all_sides (ctrl.rect, style.padding)));
	}
	defer if style.clip
	{
		imdraw.set_clip_rect (get_renderer (), prev_clip_rect);
		imdraw.set_clipping (get_renderer (), prev_clip);
	}

	text_rect := imdraw.draw_text (
		get_renderer (),
		style.text_font,
		style.text_font_height,
		linalg.vec2f (style.padding + ctrl.rect.x, ctrl.rect.y + ctrl.rect.h * 0.5) + state_style.text_offset,
		str.from_array (<<buffer),
		state_style.text_color,
		state_style.text_weight,
		state_style.text_effects,
		.CENTER_LEFT
	);
	if is_editing_text (buffer)
		imdraw.draw_line (
			get_renderer (),
			math.top_right (text_rect) + linalg.vec2f (0.5, 0),
			math.bottom_right (text_rect) + linalg.vec2f (0.5, 0),
			style.cursor_color,
			thickness = 1
		);
}
