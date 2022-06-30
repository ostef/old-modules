Window_Style :: struct
{
	move_caption_height : f32;
	resize_border_thickness : f32;

	title_font : *font.Font;
	title_font_height : u32;
	title_color : math.RGBA;
	title_weight : font.Weight;
	title_effects : imdraw.Text_Effects;

	clip := true;
	padding : f32;

	using common : Common_Style;
}

// For now, we need to pass some info to end_window, to modify the occluder
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

	if ui.mouse_focused_occluder == occl && input.is_mouse_button_down (.LEFT)
		raise_window ();

	width, height := occl.rect.w, occl.rect.h;
	button_flags := Control.Flags.FOCUSABLE | .INTERACT_ON_HELD | .CONTINUE_INTERACTION_WHEN_UNFOCUSED;
	min_width  := style.resize_border_thickness * 4;
	min_height := style.resize_border_thickness * 4 + style.move_caption_height;

	scope_id_offset (1, auto_increment = true);

	// Resize left
	{
		button_rect := math.xywhf (0, style.resize_border_thickness, style.resize_border_thickness, height - style.resize_border_thickness * 2);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_HORIZONTAL);

		if flagged (button.state_flags, .INTERACTING)
		{
			x2 := modified_window_rect.x + modified_window_rect.w;
			math.set_left (*modified_window_rect, ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x);
			if modified_window_rect.w < min_width
				math.set_left (*modified_window_rect, x2 - min_width);
		}
	}

	// Resize right
	{
		button_rect := math.xywhf (width - style.resize_border_thickness, style.resize_border_thickness, style.resize_border_thickness, height - style.resize_border_thickness * 2);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_HORIZONTAL);

		if flagged (button.state_flags, .INTERACTING)
		{
			math.set_right (*modified_window_rect, ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x + style.resize_border_thickness);
			if modified_window_rect.w < min_width
				math.set_right (*modified_window_rect, modified_window_rect.x + min_width);
		}
	}

	// Resize top
	{
		button_rect := math.xywhf (style.resize_border_thickness, 0, width - style.resize_border_thickness * 2, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_VERTICAL);

		if flagged (button.state_flags, .INTERACTING)
		{
			y2 := modified_window_rect.y + modified_window_rect.h;
			math.set_top (*modified_window_rect, ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y);
			if modified_window_rect.h < min_height
				math.set_top (*modified_window_rect, y2 - min_height);
		}
	}

	// Resize bottom
	{
		button_rect := math.xywhf (style.resize_border_thickness, height - style.resize_border_thickness, width - style.resize_border_thickness * 2, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_VERTICAL);

		if flagged (button.state_flags, .INTERACTING)
		{
			math.set_bottom (*modified_window_rect, ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y + style.resize_border_thickness);
			if modified_window_rect.h < min_height
				math.set_bottom (*modified_window_rect, modified_window_rect.y + min_height);
		}
	}

	// Resize top-right
	{
		button_rect := math.xywhf (width - style.resize_border_thickness, 0, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_NESW);

		if flagged (button.state_flags, .INTERACTING)
		{
			math.set_right (*modified_window_rect, ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x + style.resize_border_thickness);
			if modified_window_rect.w < min_width
				math.set_right (*modified_window_rect, modified_window_rect.x + min_width);
			
			y2 := modified_window_rect.y + modified_window_rect.h;
			math.set_top (*modified_window_rect, ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y);
			if modified_window_rect.h < min_height
				math.set_top (*modified_window_rect, y2 - min_height);
		}
	}

	// Resize bottom-right
	{
		button_rect := math.xywhf (width - style.resize_border_thickness, height - style.resize_border_thickness, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_NWSE);

		if flagged (button.state_flags, .INTERACTING)
		{
			math.set_right (*modified_window_rect, ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x + style.resize_border_thickness);
			if modified_window_rect.w < min_width
				math.set_right (*modified_window_rect, modified_window_rect.x + min_width);

			math.set_bottom (*modified_window_rect, ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y + style.resize_border_thickness);
			if modified_window_rect.h < min_height
				math.set_bottom (*modified_window_rect, modified_window_rect.y + min_height);
		}
	}

	// Resize bottom-left
	{
		button_rect := math.xywhf (0, height - style.resize_border_thickness, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_NESW);

		if flagged (button.state_flags, .INTERACTING)
		{
			x2 := modified_window_rect.x + modified_window_rect.w;
			math.set_left (*modified_window_rect, ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x);
			if modified_window_rect.w < min_width
				math.set_left (*modified_window_rect, x2 - min_width);

			math.set_bottom (*modified_window_rect, ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y + style.resize_border_thickness);
			if modified_window_rect.h < min_height
				math.set_bottom (*modified_window_rect, modified_window_rect.y + min_height);
		}
	}

	// Resize top-left
	{
		button_rect := math.xywhf (0, 0, style.resize_border_thickness, style.resize_border_thickness);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .FOCUSED)
			window.set_cursor (.SIZE_NWSE);

		if flagged (button.state_flags, .INTERACTING)
		{
			x2 := modified_window_rect.x + modified_window_rect.w;
			math.set_left (*modified_window_rect, ui.mouse_position.x - button.relative_mouse_position_when_started_interacting.x);
			if modified_window_rect.w < min_width
				math.set_left (*modified_window_rect, x2 - min_width);
			
			y2 := modified_window_rect.y + modified_window_rect.h;
			math.set_top (*modified_window_rect, ui.mouse_position.y - button.relative_mouse_position_when_started_interacting.y);
			if modified_window_rect.h < min_height
				math.set_top (*modified_window_rect, y2 - min_height);
		}
	}

	// Caption
	{
		button_rect := math.xywhf (0, 0, occl.rect.w, style.move_caption_height);
		button := declare_control (button_rect, location, button_flags);

		if flagged (button.state_flags, .INTERACTING)
		{
			new_position := ui.mouse_position - button.relative_mouse_position_when_started_interacting;
			modified_window_rect.position = new_position;
		}
	}

	draw_window (occl, title, style);

	return result;
}

end_window :: (using info : Window_Info)
{
	check_init ();

	ui.current_occluder.rect = modified_window_rect;

	end_occlusion ();
}

raise_window :: raise_occluder;	// If we ever want to do something when a window gets raised we can make this its own routine

draw_window :: (win : *Occluder, title : string, style : *Window_Style)
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

	if style.clip
		imdraw.push_clip_rect (get_renderer (), math.recti (math.truncate_all_sides (win.rect, style.padding)));

	if title
		imdraw.draw_text (
			get_renderer (),
			style.title_font,
			style.title_font_height,
			win.rect.position + linalg.vec2f (style.move_caption_height, style.move_caption_height) * 0.5,
			title,
			style.title_color,
			style.title_weight,
			style.title_effects,
			.CENTER_LEFT
		);
}
