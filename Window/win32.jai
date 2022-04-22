#scope_file

win32 :: #import "Win32";

#scope_export

Window :: win32.HWND;

Win32_Window_Context :: struct
{
	wndclass : win32.WNDCLASSEXW;
	custom_caption_wndclass : win32.WNDCLASSEXW;
}

#add_context win32_window_context : *Win32_Window_Context;

Win32_Window_Data :: struct
{
	wm_char_utf16_high_surrogate : u16;
	message_queue : [..]Message;
	last_retrieved_message : s64;
	flags : Flags;
	caption_hit_test : Caption_Hit_Test_Proc;
}

win32_init_window_context :: inline () -> bool
{
	context.win32_window_context = mem.alloc (Win32_Window_Context, mem.HEAP_ALLOC);
	{
		using context.win32_window_context.wndclass;
		cbSize        = size_of (win32.WNDCLASSEXW);
		style         = win32.CS_DBLCLKS | win32.CS_OWNDC;
		lpfnWndProc   = win32_wnd_proc;
		hInstance     = win32.GetModuleHandleW (null);
		lpszClassName = win32.utf8_to_wide ("WindowClass", mem.HEAP_ALLOC);
		if !win32.RegisterClassExW (*context.win32_window_context.wndclass)
		{
			show_error_box ("RegisterClassExW failed: %", win32.get_last_error_string ());
			return false;
		}
	}
	{
		using context.win32_window_context.custom_caption_wndclass;
		cbSize        = size_of (win32.WNDCLASSEXW);
		style         = win32.CS_DBLCLKS | win32.CS_OWNDC;
		lpfnWndProc   = win32_custom_caption_wnd_proc;
		hInstance     = win32.GetModuleHandleW (null);
		lpszClassName = win32.utf8_to_wide ("CustomCaptionWindowClass", mem.HEAP_ALLOC);
		if !win32.RegisterClassExW (*context.win32_window_context.custom_caption_wndclass)
		{
			show_error_box ("RegisterClassExW failed: %", win32.get_last_error_string ());
			return false;
		}
	}

	return true;
}

show_error_box :: inline (parent : Window, fmt_str : string, args : ..Any)
{
	mem.temporary_block ();
	str := fmt.format (mem.TEMP_ALLOC, fmt_str, ..args);
	win32.MessageBoxW (
		parent,
		win32.utf8_to_wide (str, mem.TEMP_ALLOC),
		win32.utf8_to_wide ("Error", mem.TEMP_ALLOC),
		win32.MB_ICONERROR | win32.MB_OK
	);
}

show_error_box :: inline (fmt_str : string, args : ..Any)
{
	show_error_box (null, fmt_str, ..args);
}

create :: inline (
	title : string,
	x : s32,
	y : s32,
	width : s32,
	height : s32,
	flags := Creation_Flags.VISIBLE,
	parent : Window = null
) -> Window #must
{
	if !context.win32_window_context
		win32_init_window_context ();

	if x == WINDOW_DEFAULT then x = win32.CW_USEDEFAULT;
	if y == WINDOW_DEFAULT then y = win32.CW_USEDEFAULT;
	if width  == WINDOW_DEFAULT then width  = win32.CW_USEDEFAULT;
	if height == WINDOW_DEFAULT then height = win32.CW_USEDEFAULT;

	wndclass := *context.win32_window_context.wndclass;
	window_flags : Flags;
	style : win32.DWORD = win32.WS_OVERLAPPEDWINDOW;
	if flagged (flags, .CUSTOM_CAPTION)
	{
		style = win32.WS_THICKFRAME | win32.WS_SYSMENU | win32.WS_MAXIMIZEBOX | win32.WS_MINIMIZEBOX;
		window_flags |= .CUSTOM_CAPTION;
		wndclass = *context.win32_window_context.custom_caption_wndclass;
	}
	if flagged (flags, .VISIBLE)
		style |= win32.WS_VISIBLE;
	if flagged (flags, .USE_CLIENT_COORDINATES)
	{
		rect : win32.RECT;
		rect.left = x;
		rect.right = x + width;
		rect.top = y;
		rect.bottom = y + height;
		if win32.AdjustWindowRectEx (*rect, style, 0, 0)
		{
			x = rect.left;
			y = rect.top;
			width = rect.right - rect.left;
			height = rect.bottom - rect.top;
		}
	}

	hwnd := win32.CreateWindowExW (
		0,
		wndclass.lpszClassName,
		win32.utf8_to_wide (title, mem.TEMP_ALLOC),
		style,
		x,
		y,
		width,
		height,
		parent,
		null,
		win32.GetModuleHandleW (null),
		null
	);
	data := mem.alloc (Win32_Window_Data, mem.HEAP_ALLOC);
	data.message_queue.allocator = mem.HEAP_ALLOC;
	win32.SetWindowLongPtrW (hwnd, win32.GWLP_USERDATA, cast (*win32.LONG) data);
	data.flags = window_flags;

	return hwnd;
}

destroy :: inline (window : Window)
#no_context
{
	win32.DestroyWindow (window);
	// data is destroyed in the WM_DESTROY message. That way, child windows
	// that automatically get destroyed also free their user data.
}

close :: inline (window : Window)
#no_context
{
	win32.PostMessageW (window, win32.WM_CLOSE, 0, 0);
}

win32_get_window_data :: inline (window : Window) -> *Win32_Window_Data #must
#no_context
{
	return cast (*Win32_Window_Data) win32.GetWindowLongPtrW (window, win32.GWLP_USERDATA);
}

set_caption_hit_test :: inline (window : Window, proc : Caption_Hit_Test_Proc)
{
	data := win32_get_window_data (window);
	assert (data != null, "Could not retrieve window data.");
	data.caption_hit_test = proc;
}

swap_buffers :: inline (window : Window)
#no_context
{
	win32.SwapBuffers (win32.GetDC (window));
}

get_position :: inline (window : Window) -> x : s32, y : s32
#no_context
{
	rect : win32.RECT;
	win32.GetWindowRect (window, *rect);

	return rect.left, rect.top;
}

set_position :: inline (window : Window, x : s32, y : s32)
#no_context
{
	win32.SetWindowPos (window, null, x, y, 0, 0, win32.SWP_NOSIZE | win32.SWP_NOZORDER | win32.SWP_NOACTIVATE);
}

get_size :: inline (window : Window) -> width : s32, height : s32
#no_context
{
	rect : win32.RECT;
	win32.GetWindowRect (window, *rect);

	return rect.right - rect.left, rect.bottom - rect.top;
}

set_size :: inline (window : Window, width : s32, height : s32)
#no_context
{
	win32.SetWindowPos (window, null, 0, 0, width, height, win32.SWP_NOMOVE | win32.SWP_NOZORDER | win32.SWP_NOACTIVATE);
}

get_viewport_size :: inline (window : Window) -> width : s32, height : s32
#no_context
{
	rect : win32.RECT;
	win32.GetClientRect (window, *rect);

	return rect.right - rect.left, rect.bottom - rect.top;
}

get_focused :: inline () -> Window #must
{
	return win32.GetFocus ();
}

is_focused :: inline (window : Window) -> bool #must
#no_context
{
	return win32.GetFocus () == window;
}

is_maximized :: inline (window : Window) -> bool #must
#no_context
{
	placement : win32.WINDOWPLACEMENT;
	placement.length = size_of (win32.WINDOWPLACEMENT);
	if win32.GetWindowPlacement (window, *placement)
		return placement.showCmd == win32.SW_SHOWMAXIMIZED;
	return false;
}

is_minimized :: inline (window : Window) -> bool #must
#no_context
{
	placement : win32.WINDOWPLACEMENT;
	placement.length = size_of (win32.WINDOWPLACEMENT);
	if win32.GetWindowPlacement (window, *placement)
		return placement.showCmd == win32.SW_SHOWMINIMIZED;
	return false;
}

maximize :: inline (window : Window)
#no_context
{
	win32.ShowWindow (window, win32.SW_MAXIMIZE);
}

restore :: inline (window : Window)
#no_context
{
	win32.ShowWindow (window, win32.SW_RESTORE);
}

minimize :: inline (window : Window)
#no_context
{
	win32.ShowWindow (window, win32.SW_MINIMIZE);
}

get_mouse_position :: inline () -> x : s32, y : s32
#no_context
{
	result : win32.POINT;
	win32.GetCursorPos (*result);
	return result.x, result.y;
}

get_mouse_position :: inline (window : Window) -> x : s32, y : s32
#no_context
{
	result : win32.POINT;
	win32.GetCursorPos (*result);
	win32.ScreenToClient (window, *result);
	return result.x, result.y;
}

set_mouse_position :: inline (window : Window, x : s32, y : s32)
#no_context
{
	pt : win32.POINT;
	pt.x = x;
	pt.y = y;
	win32.ClientToScreen (window, *pt);
	win32.SetCursorPos (pt.x, pt.y);
}

poll_messages :: inline (window : Window)
{
	data := win32_get_window_data (window);
	msg : win32.MSG;
	while win32.PeekMessageW (*msg, window, 0, 0, win32.PM_REMOVE)
	{
		win32.TranslateMessage (*msg);
		win32.DispatchMessageW (*msg);
	}
}

get_next_message :: inline (window : Window, msg : *Message) -> bool
{
	data := win32_get_window_data (window);
	if data.last_retrieved_message >= data.message_queue.count
	{
		array.clear (*data.message_queue);
		data.last_retrieved_message = 0;
		return false;
	}
	<<msg = data.message_queue[data.last_retrieved_message];
	data.last_retrieved_message += 1;

	return true;
}

set_cursor_visibility :: inline (visible : bool)
#no_context
{
	win32.ShowCursor (xx visible);
}

show_cursor :: inline ()
#no_context
{
	set_cursor_visibility (true);
}

hide_cursor :: inline ()
#no_context
{
	set_cursor_visibility (false);
}

#scope_file

decompose_keystroke_lparam :: inline (lparam : win32.LPARAM) ->
	repeat_count : s16,
	scan_code : u8,
	extended : bool,
	previous_key_state : bool,
	transition_state : bool,
	alt_down : bool,
	dialog_mode : bool,
	menu_mode : bool
	#no_context
{
	repeat_count := win32.LOWORD (lparam);
	scan_code := cast, no_check (u8) win32.HIWORD (lparam);
	extended           := (win32.HIWORD (lparam) & win32.KF_EXTENDED) == win32.KF_EXTENDED;
	previous_key_state := (win32.HIWORD (lparam) & win32.KF_REPEAT) == win32.KF_REPEAT;
	transition_state   := (win32.HIWORD (lparam) & win32.KF_UP) == win32.KF_UP;
	alt_down           := (win32.HIWORD (lparam) & win32.KF_ALTDOWN) == win32.KF_ALTDOWN;
	dialog_mode        := (win32.HIWORD (lparam) & win32.KF_DLGMODE) == win32.KF_DLGMODE;
	menu_mode          := (win32.HIWORD (lparam) & win32.KF_MENUMODE) == win32.KF_MENUMODE;

	return repeat_count, scan_code, extended, previous_key_state, transition_state, alt_down, dialog_mode, menu_mode;
}

push_message :: inline (data : *Win32_Window_Data, msg : Message)
{
	array.push (*data.message_queue, msg);
}

win32_wnd_proc :: (window : win32.HWND, msg : u32, wparam : win32.WPARAM, lparam : win32.LPARAM) -> win32.LRESULT
#c_call
{
	using data := win32_get_window_data (window);
	if !data
		return win32.DefWindowProcW (window, msg, wparam, lparam);
	window_msg : Message;
	window_msg.window = window;

	ctx : Context;
	fill_default_context (*ctx);
	push_context ctx
	{
		if msg ==
		{
		case win32.WM_DESTROY;
			array.reset (*message_queue);
			mem.free (data, mem.HEAP_ALLOC);
			data = null;

		case win32.WM_MOVE;
			window_msg.kind = .WINDOW_MOVED;
			window_msg.window_x = win32.LOWORD (lparam);
			window_msg.window_y = win32.HIWORD (lparam);
			push_message (data, window_msg);

		case win32.WM_SIZE;
			if wparam ==
			{
			case win32.SIZE_RESTORED;
				window_msg.kind = .WINDOW_RESIZED;
			case win32.SIZE_MINIMIZED;
				window_msg.kind = .WINDOW_MINIMIZED;
			case win32.SIZE_MAXIMIZED;
				window_msg.kind = .WINDOW_MAXIMIZED;
			case;
				return win32.DefWindowProcW (window, msg, wparam, lparam);
			}
			window_msg.viewport_width  = win32.LOWORD (lparam);
			window_msg.viewport_height = win32.HIWORD (lparam);
			push_message (data, window_msg);

		case win32.WM_CLOSE;
			window_msg.kind = .WINDOW_CLOSED;
			push_message (data, window_msg);

		case win32.WM_SHOWWINDOW;
			if wparam
				window_msg.kind = .WINDOW_SHOWN;
			else
				window_msg.kind = .WINDOW_HIDDEN;
			push_message (data, window_msg);

		case win32.WM_SETFOCUS;
			window_msg.kind = .WINDOW_RECEIVED_FOCUS;
			push_message (data, window_msg);

		case win32.WM_KILLFOCUS;
			window_msg.kind = .WINDOW_LOST_FOCUS;
			push_message (data, window_msg);

		case win32.WM_CHAR;
			codepoint := cast (u32) wparam;
			UTF16_HI_SURROGATE  :: cast (u16) 0xd800;
			UTF16_LO_SURROGATE  :: cast (u16) 0xdc00;
			UTF16_SURROGATE_END :: cast (u16) 0xdfff;

			if codepoint >= UTF16_HI_SURROGATE && codepoint < UTF16_LO_SURROGATE
			{
				wm_char_utf16_high_surrogate = cast (u16) codepoint;
			}
			else
			{
				if codepoint >= UTF16_LO_SURROGATE && codepoint <= UTF16_SURROGATE_END
				{
					low_surrogate := cast (u16) codepoint;
					codepoint  = (wm_char_utf16_high_surrogate - UTF16_HI_SURROGATE) << 10;
					codepoint |= (low_surrogate - UTF16_HI_SURROGATE);
					codepoint += 0x10000;
				}

				window_msg.kind      = .TEXT_INPUT;
				window_msg.mods      = input.get_mod_state ();
				window_msg.codepoint = codepoint;
				push_message (data, window_msg);
			}

		case win32.WM_SYSKEYDOWN; #through;
		case win32.WM_SYSKEYUP; #through;
		case win32.WM_KEYDOWN; #through;
		case win32.WM_KEYUP;
			repeat_count,
			scan_code,
			extended,
			previous_key_state,
			transition_state,
			alt_down,
			dialog_mode,
			menu_mode := decompose_keystroke_lparam (lparam);

			if msg == win32.WM_KEYUP || msg == win32.WM_SYSKEYUP
				window_msg.kind = .KEY_RELEASED;
			else if previous_key_state
				window_msg.kind = .KEY_REPEATED;
			else
				window_msg.kind = .KEY_PRESSED;
			window_msg.mods     = input.get_mod_state ();
			window_msg.key_code = input.win32_vk_to_key_code (xx wparam);
			push_message (data, window_msg);

			if msg == win32.WM_SYSKEYDOWN || msg == win32.WM_SYSKEYUP
				return win32.DefWindowProcW (window, msg, wparam, lparam);

		case win32.WM_LBUTTONDOWN; #through;
		case win32.WM_LBUTTONUP; #through;
		case win32.WM_LBUTTONDBLCLK; #through;
		case win32.WM_MBUTTONDOWN; #through;
		case win32.WM_MBUTTONUP; #through;
		case win32.WM_MBUTTONDBLCLK; #through;
		case win32.WM_RBUTTONDOWN; #through;
		case win32.WM_RBUTTONUP; #through;
		case win32.WM_RBUTTONDBLCLK;
			if msg ==
			{
			case win32.WM_LBUTTONDOWN;
				window_msg.kind = .MOUSE_BUTTON_PRESSED;
				window_msg.mouse_button = .LEFT;

			case win32.WM_LBUTTONUP;
				window_msg.kind = .MOUSE_BUTTON_RELEASED;
				window_msg.mouse_button = .LEFT;

			case win32.WM_LBUTTONDBLCLK;
				window_msg.kind = .MOUSE_BUTTON_REPEATED;
				window_msg.mouse_button = .LEFT;
			
			case win32.WM_MBUTTONDOWN;
				window_msg.kind = .MOUSE_BUTTON_PRESSED;
				window_msg.mouse_button = .MIDDLE;
			
			case win32.WM_MBUTTONUP;
				window_msg.kind = .MOUSE_BUTTON_RELEASED;
				window_msg.mouse_button = .MIDDLE;
			
			case win32.WM_MBUTTONDBLCLK;
				window_msg.kind = .MOUSE_BUTTON_REPEATED;
				window_msg.mouse_button = .MIDDLE;
			
			case win32.WM_RBUTTONDOWN;
				window_msg.kind = .MOUSE_BUTTON_PRESSED;
				window_msg.mouse_button = .RIGHT;
			
			case win32.WM_RBUTTONUP;
				window_msg.kind = .MOUSE_BUTTON_RELEASED;
				window_msg.mouse_button = .RIGHT;
			
			case win32.WM_RBUTTONDBLCLK;
				window_msg.kind = .MOUSE_BUTTON_REPEATED;
				window_msg.mouse_button = .RIGHT;
			}
			window_msg.mods = input.get_mod_state ();
			window_msg.mouse_x = win32.LOWORD (lparam);
			window_msg.mouse_y = win32.HIWORD (lparam);
			push_message (data, window_msg);

		case win32.WM_MOUSEHWHEEL; #through;
		case win32.WM_MOUSEWHEEL;
			window_msg.kind = .MOUSE_WHEEL;
			window_msg.mods = input.get_mod_state ();
			if msg == win32.WM_MOUSEHWHEEL
				window_msg.mouse_wheel_x = win32.HIWORD (wparam) / 120.0;
			else
				window_msg.mouse_wheel_y = win32.HIWORD (wparam) / 120.0;
			window_msg.mouse_x, window_msg.mouse_y = get_mouse_position (window);
			push_message (data, window_msg);

		case win32.WM_MOUSEMOVE;
			window_msg.kind = .MOUSE_MOVED;
			window_msg.mods = input.get_mod_state ();
			window_msg.mouse_x = win32.LOWORD (lparam);
			window_msg.mouse_y = win32.HIWORD (lparam);
			push_message (data, window_msg);

		case win32.WM_INPUT;
			size := cast (u32) size_of (win32.RAWINPUT);
			rawinput : win32.RAWINPUT;
			win32.GetRawInputData (cast (win32.HRAWINPUT) lparam, win32.RID_INPUT, *rawinput, *size, size_of (win32.RAWINPUTHEADER));
			if rawinput.header.dwType == win32.RIM_TYPEMOUSE
			{
				if flagged (rawinput.data.mouse.usFlags, win32.MOUSE_MOVE_RELATIVE) && (rawinput.data.mouse.lLastX != 0 || rawinput.data.mouse.lLastY != 0)
				{
					window_msg.kind = .RAW_MOUSE_MOVED;
					window_msg.mods = input.get_mod_state ();
					window_msg.mouse_delta_x = rawinput.data.mouse.lLastX;
					window_msg.mouse_delta_y = rawinput.data.mouse.lLastY;
					push_message (data, window_msg);

					return 0;
				}
			}

			return win32.DefWindowProcW (window, msg, wparam, lparam);

		case win32.WM_SETCURSOR;
			win32.SetCursor (win32.LoadCursorW (null, cast (*win32.WCHAR) win32.IDC_ARROW));
			return win32.DefWindowProcW (window, msg, wparam, lparam);

		case;
			return win32.DefWindowProcW (window, msg, wparam, lparam);
		}
	}
	return 0;
}

win32_custom_caption_wnd_proc :: (window : win32.HWND, msg : u32, wparam : win32.WPARAM, lparam : win32.LPARAM) -> win32.LRESULT
#c_call
{
	using data := win32_get_window_data (window);

	ctx : Context;
	fill_default_context (*ctx);
	push_context ctx
	{
		if msg ==
		{
		case win32.WM_CREATE;
			size_rect : win32.RECT;
			win32.GetWindowRect (window, *size_rect);
			win32.SetWindowPos (window, null,
				size_rect.left, size_rect.top,
				size_rect.right - size_rect.left, size_rect.bottom - size_rect.top,
				win32.SWP_FRAMECHANGED | win32.SWP_NOMOVE | win32.SWP_NOSIZE
			);
			return win32.DefWindowProcW (window, msg, wparam, lparam);
	
		case win32.WM_NCCALCSIZE;
			if wparam == 0
				return win32.DefWindowProcW (window, msg, wparam, lparam);
			frame_x := win32.GetSystemMetrics (win32.SM_CXFRAME);
			frame_y := win32.GetSystemMetrics (win32.SM_CYFRAME);
			padding := win32.GetSystemMetrics (win32.SM_CXPADDEDBORDER);
			params := cast (*win32.NCCALCSIZE_PARAMS)lparam;
			client_rect := *params.rgrc[0];
			client_rect.right  -= frame_x + padding;
			client_rect.left   += frame_x + padding;
			client_rect.bottom -= frame_y + padding;
			if is_maximized (window)
				client_rect.top += padding * 2;
			return 0;

		case win32.WM_NCHITTEST;
			hit := win32.DefWindowProcW (window, msg, wparam, lparam);
			if !data
				return hit;
			if hit ==
			{
			case win32.HTNOWHERE; #through;
			case win32.HTRIGHT; #through;
			case win32.HTLEFT; #through;
			case win32.HTTOPLEFT; #through;
			case win32.HTTOP; #through;
			case win32.HTTOPRIGHT; #through;
			case win32.HTBOTTOMRIGHT; #through;
			case win32.HTBOTTOM; #through;
			case win32.HTBOTTOMLEFT;
				return hit;
			}

			cursor : win32.POINT;
			cursor.x = win32.LOWORD (lparam);
			cursor.y = win32.HIWORD (lparam);
			win32.ScreenToClient (window, *cursor);
			on_caption := data.caption_hit_test && data.caption_hit_test (window, cursor.x, cursor.y);
			on_resize_border := cursor.y > 0 && cursor.y < win32.GetSystemMetrics (win32.SM_CYFRAME) + win32.GetSystemMetrics (win32.SM_CXPADDEDBORDER);
			// Don't resize when we are not on the caption, because we could be on
			// some UI elements. If we don't have a caption_hit_test, then ignore
			// that. The user should provide a hit test function anyway...
			if on_resize_border && (on_caption || !data.caption_hit_test)
				return win32.HTTOP;
			else if on_caption
				return win32.HTCAPTION;
			return win32.HTCLIENT;
		}
	}
	return win32_wnd_proc (window, msg, wparam, lparam);
}
