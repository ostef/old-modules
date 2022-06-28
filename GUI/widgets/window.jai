Window_Style :: struct
{
	move_caption_height : f32;
	resize_border_thickness : f32;

	title_font : *font.Font;
	title_font_height : u32;
	title_color : math.RGBA;
	title_weight : font.Weight;
	title_effects : imdraw.Text_Effects;

	using common : Common_Style;
}

// For now, the way we need to pass some info to end_window, to modify the occluder
// after every control declaration/drawing relative to the window has been done
// Maybe we'll find a way to not have this later

Window_Info :: struct
{
	modified_window_rect : math.Rectf;
}

begin_window :: (rect : math.Rectf, title : string, style : *Window_Style = null, set_rect_once := true, location := #caller_location) -> Window_Info #must
{
	check_init ();

	occl := begin_occlusion (rect, location, set_rect_once);
	using result : Window_Info;
	modified_window_rect = occl.rect;

	width, height := math.rect_width (occl.rect), math.rect_height (occl.rect);
	button_flags := Control.Flags.FOCUSABLE | .INTERACT_ON_HELD | .CONTINUE_INTERACTION_WHEN_UNFOCUSED;

	// Resize left
	{
		button_rect := math.xywhf (0, style.resize_border_thickness, style.resize_border_thickness, height - style.resize_border_thickness * 2);
		button := declare_control (button_rect, location, button_flags, id_offset = 1);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.x1 = ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x;
			raise_occluder ();
		}
	}

	// Resize right
	{
		button_rect := math.xywhf (width - style.resize_border_thickness, style.resize_border_thickness, style.resize_border_thickness, height - style.resize_border_thickness * 2);
		button := declare_control (button_rect, location, button_flags, id_offset = 2);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.x2 = ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x + style.resize_border_thickness;
			raise_occluder ();
		}
	}

	// Resize top
	{
		button_rect := math.xywhf (style.resize_border_thickness, 0, width - style.resize_border_thickness * 2, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags, id_offset = 3);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.y1 = ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y;
			raise_occluder ();
		}
	}

	// Resize bottom
	{
		button_rect := math.xywhf (style.resize_border_thickness, height - style.resize_border_thickness, width - style.resize_border_thickness * 2, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags, id_offset = 4);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.y2 = ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y + style.resize_border_thickness;
			raise_occluder ();
		}
	}

	// Resize top-right
	{
		button_rect := math.xywhf (width - style.resize_border_thickness, 0, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags, id_offset = 5);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.x2 = ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x + style.resize_border_thickness;
			modified_window_rect.y1 = ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y;
			raise_occluder ();
		}
	}

	// Resize bottom-right
	{
		button_rect := math.xywhf (width - style.resize_border_thickness, height - style.resize_border_thickness, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags, id_offset = 6);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.x2 = ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x + style.resize_border_thickness;
			modified_window_rect.y2 = ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y + style.resize_border_thickness;
			raise_occluder ();
		}
	}

	// Resize bottom-left
	{
		button_rect := math.xywhf (0, height - style.resize_border_thickness, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags, id_offset = 7);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.x1 = ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x;
			modified_window_rect.y2 = ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y + style.resize_border_thickness;
			raise_occluder ();
		}
	}

	// Resize top-left
	{
		button_rect := math.xywhf (0, 0, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags, id_offset = 8);

		if flagged (button.state_flags, .INTERACTING)
		{
			modified_window_rect.x1 = ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x;
			modified_window_rect.y1 = ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y;
			raise_occluder ();
		}
	}

	// Caption
	{
		button_rect := math.xywhf (0, 0, math.rect_width (occl.rect), style.move_caption_height);
		button := declare_control (button_rect, location, button_flags, id_offset = 9);

		if flagged (button.state_flags, .INTERACTING)
		{
			new_position := ui.mouse_position - button.relative_mouse_position_when_started_interacting;
			modified_window_rect = math.set_position (modified_window_rect, new_position);
			raise_occluder ();
		}
	}

	// Drawing
	imdraw.set_clip_rect (get_renderer (), math.recti (occl.rect));
	draw_window (occl, title, style);

	return result;
}

end_window :: (using info : Window_Info)
{
	check_init ();

	ui.current_occluder.rect = modified_window_rect;

	end_occlusion ();
}

draw_window :: (win : *Occluder, title : string, style : *Window_Style = null)
{
	imdraw.draw_rect (get_renderer (), win.rect, style.background_color, corner_radius = style.corner_radiuses.top_left);
	if style.border_thickness > 0
		imdraw.draw_rect_outline (
			get_renderer (),
			math.truncate_all_sides (win.rect, style.border_inset),
			style.border_color,
			style.border_thickness,
			corner_radius = style.corner_radiuses.top_left
		);

	if title
		imdraw.draw_text (
			get_renderer (),
			style.title_font,
			style.title_font_height,
			math.rect_position (win.rect) + linalg.vec2f (style.move_caption_height, style.move_caption_height) * 0.5,
			title,
			style.title_color,
			style.title_weight,
			style.title_effects,
			.CENTER_LEFT
		);
}
