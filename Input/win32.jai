#scope_file

win32 :: #import "Win32";

g_prev_keyboard_state : [Key_Code.COUNT]bool;
g_keyboard_state : [Key_Code.COUNT]bool;

g_repeated_keys : [Key_Code.COUNT]bool;

g_prev_mouse_button_states : [Mouse_Button.COUNT]bool;
g_mouse_button_states : [Mouse_Button.COUNT]bool;

g_mouse_delta_x, g_mouse_delta_y : s32;
g_mouse_wheel_x, g_mouse_wheel_y : f32;

#scope_export

is_key_down :: inline (key_code : Key_Code) -> bool #must
#no_context
{
	return (win32.GetAsyncKeyState (win32_key_code_to_vk (key_code)) & 0x8000) != 0;
}

is_key_pressed :: inline (key_code : Key_Code) -> bool #must
#no_context
{
	return !g_prev_keyboard_state[cast (int) key_code] && is_key_down (key_code);
}

is_key_repeated :: inline (key_code : Key_Code) -> bool #must
#no_context
{
	return g_repeated_keys[cast (int) key_code];
}

is_key_pressed_or_repeated :: inline (key_code : Key_Code) -> bool #must
#no_context
{
	return is_key_pressed (key_code) || g_repeated_keys[cast (int) key_code];
}

is_key_released :: inline (key_code : Key_Code) -> bool #must
#no_context
{
	return g_prev_keyboard_state[cast (int) key_code] && !is_key_down (key_code);
}

is_mouse_button_down :: inline (button : Mouse_Button) -> bool #must
#no_context
{
	return (win32.GetAsyncKeyState (win32_mouse_button_to_vk (button)) & 0x8000) != 0;
}

is_mouse_button_pressed :: inline (button : Mouse_Button) -> bool #must
#no_context
{
	return !g_prev_mouse_button_states[cast (int) button] && is_mouse_button_down (button);
}

is_mouse_button_released :: inline (button : Mouse_Button) -> bool #must
#no_context
{
	return g_prev_mouse_button_states[cast (int) button] && !is_mouse_button_down (button);
}

get_mouse_delta :: inline () -> x : s32, y : s32
{
	return g_mouse_delta_x, g_mouse_delta_y;
}

get_mouse_wheel :: inline () -> x : f32, y : f32
{
	return g_mouse_wheel_x, g_mouse_wheel_y;
}

get_mod_state :: inline () -> Mods #must
#no_context
{
	result : Mods;
	if is_key_down (.CTRL)
		result |= .CTRL;
	if is_key_down (.SHIFT)
		result |= .SHIFT;
	if is_key_down (.ALT)
		result |= .ALT;

	return result;
}

init :: inline () -> bool
{
	// Register raw mouse device
	mouse : win32.RAWINPUTDEVICE;
	mouse.usUsagePage = 0x01;
	mouse.usUsage     = 0x02;
	if !win32.RegisterRawInputDevices (*mouse, 1, size_of (win32.RAWINPUTDEVICE))
		return false;
	
	return true;
}

update :: inline ()
{
	g_mouse_delta_x = 0;
	g_mouse_delta_y = 0;
	g_mouse_wheel_x = 0;
	g_mouse_wheel_y = 0;

	mem.copy (g_prev_keyboard_state.data, g_keyboard_state.data, size_of (bool) * g_prev_keyboard_state.count);
	for i : 0..g_keyboard_state.count - 1
		g_keyboard_state[i] = is_key_down (cast, no_check (Key_Code) i);

	mem.set (g_repeated_keys.data, 0, size_of (bool) * g_repeated_keys.count);

	mem.copy (g_prev_mouse_button_states.data, g_mouse_button_states.data, size_of (bool) * g_prev_mouse_button_states.count);
	for i : 0..g_mouse_button_states.count - 1
		g_mouse_button_states[i] = is_mouse_button_down (cast, no_check (Mouse_Button) i);
}

handle_window_message :: (msg : window.Message)
{
	if msg.kind ==
	{
	case .KEY_REPEATED;
		g_repeated_keys[cast (int) msg.key_code] = true;

	case .RAW_MOUSE_MOVED;
		g_mouse_delta_x = msg.mouse_delta_x;
		g_mouse_delta_y = msg.mouse_delta_y;

	case .MOUSE_WHEEL;
		g_mouse_wheel_x = msg.mouse_wheel_x;
		g_mouse_wheel_y = msg.mouse_wheel_y;
	}
}

win32_vk_to_key_code :: inline (vk : s32) -> Key_Code #must
#no_context
{
	WIN32_VK_TO_KEY_CODE :: #insert -> string
	{
		code : strbuild.Builder;
		strbuild.init (*code);

		strbuild.append_line (*code, "Key_Code.[");
		for i : 0..256
		{
			key_code := Key_Code.UNKNOWN;
			for WIN32_VK_TO_KEY_CODE_MAP
			{
				if it.vk == xx i
				{
					key_code = it.key_code;
	
					break;
				}
			}

			strbuild.append_line (*code, "\t.%,", key_code);
		}

		strbuild.append_line (*code, "];");

		return strbuild.build (code);
	};

	return WIN32_VK_TO_KEY_CODE[vk];
}

win32_key_code_to_vk :: inline (key_code : Key_Code) -> s32 #must
#no_context
{
	WIN32_KEY_CODE_TO_VK :: #insert -> string
	{
		code : strbuild.Builder;
		strbuild.init (*code);

		strbuild.append_line (*code, "s32.[");
		for i : 0..256
		{
			vk := 0;
			for WIN32_VK_TO_KEY_CODE_MAP
			{
				if it.key_code == xx i
				{
					vk = it.vk;

					break;
				}
			}

			strbuild.append_line (*code, "\t%,", vk);
		}

		strbuild.append_line (*code, "];");

		return strbuild.build (code);
	};

	return WIN32_KEY_CODE_TO_VK[cast (s64) key_code];
}

win32_vk_to_mouse_button :: inline (vk : win32.DWORD) -> Mouse_Button #must
#no_context
{
	if vk ==
	{
	case win32.VK_LBUTTON;
		return .LEFT;
	case win32.VK_RBUTTON;
		return .RIGHT;
	case win32.VK_MBUTTON;
		return .MIDDLE;
	}

	return .UNKNOWN;
}

win32_mouse_button_to_vk :: inline (button : Mouse_Button) -> s32 #must
#no_context
{
	if button ==
	{
	case .LEFT;
		return win32.VK_LBUTTON;
	case .RIGHT;
		return win32.VK_RBUTTON;
	case .MIDDLE;
		return win32.VK_MBUTTON;
	}
	
	return 0;
}

#scope_file

Win32_VK_Key_Code_Pair :: struct
{
	vk : s32;
	key_code : Key_Code;
}

WIN32_VK_TO_KEY_CODE_MAP :: Win32_VK_Key_Code_Pair.[
	.{ win32.VK_BACK, .BACKSPACE },
	.{ win32.VK_TAB, .TAB },
	.{ win32.VK_CLEAR, .CLEAR },
	.{ win32.VK_RETURN, .RETURN },
	.{ win32.VK_SHIFT, .SHIFT },
	.{ win32.VK_CONTROL, .CTRL },
	.{ win32.VK_MENU, .ALT },
	.{ win32.VK_PAUSE, .PAUSE },
	.{ win32.VK_CAPITAL, .CAPS_LOCK },
	.{ win32.VK_ESCAPE, .ESCAPE },
	.{ win32.VK_SPACE, .SPACE },
	.{ win32.VK_PRIOR, .PAGE_UP },
	.{ win32.VK_NEXT, .PAGE_DOWN },
	.{ win32.VK_END, .END },
	.{ win32.VK_HOME, .HOME },
	.{ win32.VK_LEFT, .LEFT },
	.{ win32.VK_UP, .UP },
	.{ win32.VK_RIGHT, .RIGHT },
	.{ win32.VK_DOWN, .DOWN },
	.{ win32.VK_SELECT, .SELECT },
	.{ win32.VK_PRINT, .PRINT },
	.{ win32.VK_EXECUTE, .EXECUTE },
	.{ win32.VK_SNAPSHOT, .PRINT_SCREEN },
	.{ win32.VK_INSERT, .INSERT },
	.{ win32.VK_DELETE, .DELETE },
	.{ win32.VK_HELP, .HELP },
	.{ #char "0", .ZERO },
	.{ #char "1", .ONE },
	.{ #char "2", .TWO },
	.{ #char "3", .THREE },
	.{ #char "4", .FOUR },
	.{ #char "5", .FIVE },
	.{ #char "6", .SIX },
	.{ #char "7", .SEVEN },
	.{ #char "8", .EIGHT },
	.{ #char "9", .NINE },
	.{ #char "A", .A },
	.{ #char "B", .B },
	.{ #char "C", .C },
	.{ #char "D", .D },
	.{ #char "E", .E },
	.{ #char "F", .F },
	.{ #char "G", .G },
	.{ #char "H", .H },
	.{ #char "I", .I },
	.{ #char "J", .J },
	.{ #char "K", .K },
	.{ #char "L", .L },
	.{ #char "M", .M },
	.{ #char "N", .N },
	.{ #char "O", .O },
	.{ #char "P", .P },
	.{ #char "Q", .Q },
	.{ #char "R", .R },
	.{ #char "S", .S },
	.{ #char "T", .T },
	.{ #char "U", .U },
	.{ #char "V", .V },
	.{ #char "W", .W },
	.{ #char "X", .X },
	.{ #char "Y", .Y },
	.{ #char "Z", .Z },
	.{ win32.VK_LWIN, .LEFT_SUPER },
	.{ win32.VK_RWIN, .RIGHT_SUPER },
	.{ win32.VK_APPS, .APPS },
	.{ win32.VK_SLEEP, .SLEEP },
	.{ win32.VK_NUMPAD0, .NUMPAD_0 },
	.{ win32.VK_NUMPAD1, .NUMPAD_1 },
	.{ win32.VK_NUMPAD2, .NUMPAD_2 },
	.{ win32.VK_NUMPAD3, .NUMPAD_3 },
	.{ win32.VK_NUMPAD4, .NUMPAD_4 },
	.{ win32.VK_NUMPAD5, .NUMPAD_5 },
	.{ win32.VK_NUMPAD6, .NUMPAD_6 },
	.{ win32.VK_NUMPAD7, .NUMPAD_7 },
	.{ win32.VK_NUMPAD8, .NUMPAD_8 },
	.{ win32.VK_NUMPAD9, .NUMPAD_9 },
	.{ win32.VK_MULTIPLY, .MULTIPLY },
	.{ win32.VK_ADD, .ADD },
	.{ win32.VK_SEPARATOR, .SEPARATOR },
	.{ win32.VK_SUBTRACT, .SUBSTRACT },
	.{ win32.VK_DECIMAL, .DECIMAL },
	.{ win32.VK_DIVIDE, .DIVIDE },
	.{ win32.VK_F1, .F1 },
	.{ win32.VK_F2, .F2 },
	.{ win32.VK_F3, .F3 },
	.{ win32.VK_F4, .F4 },
	.{ win32.VK_F5, .F5 },
	.{ win32.VK_F6, .F6 },
	.{ win32.VK_F7, .F7 },
	.{ win32.VK_F8, .F8 },
	.{ win32.VK_F9, .F9 },
	.{ win32.VK_F10, .F10 },
	.{ win32.VK_F11, .F11 },
	.{ win32.VK_F12, .F12 },
	.{ win32.VK_F13, .F13 },
	.{ win32.VK_F14, .F14 },
	.{ win32.VK_F15, .F15 },
	.{ win32.VK_F16, .F16 },
	.{ win32.VK_F17, .F17 },
	.{ win32.VK_F18, .F18 },
	.{ win32.VK_F19, .F19 },
	.{ win32.VK_F20, .F20 },
	.{ win32.VK_F21, .F21 },
	.{ win32.VK_F22, .F22 },
	.{ win32.VK_F23, .F23 },
	.{ win32.VK_F24, .F24 },
	.{ win32.VK_NUMLOCK, .NUM_LOCK },
	.{ win32.VK_SCROLL, .SCROLL_LOCK },
	.{ win32.VK_LSHIFT, .LEFT_SHIFT },
	.{ win32.VK_RSHIFT, .RIGHT_SHIFT },
	.{ win32.VK_LCONTROL, .LEFT_CTRL },
	.{ win32.VK_RCONTROL, .RIGHT_CTRL },
	.{ win32.VK_LMENU, .LEFT_ALT },
	.{ win32.VK_RMENU, .RIGHT_ALT },
	.{ win32.VK_BROWSER_BACK, .BROWSER_BACK },
	.{ win32.VK_BROWSER_FORWARD, .BROWSER_FORWARD },
	.{ win32.VK_BROWSER_REFRESH, .BROWSER_REFRESH },
	.{ win32.VK_BROWSER_STOP, .BROWSER_STOP },
	.{ win32.VK_BROWSER_SEARCH, .BROWSER_SEARCH },
	.{ win32.VK_BROWSER_FAVORITES, .BROWSER_FAVORITES },
	.{ win32.VK_BROWSER_HOME, .BROWSER_HOME },
	.{ win32.VK_VOLUME_MUTE, .VOLUME_MUTE },
	.{ win32.VK_VOLUME_DOWN, .VOLUME_DOWN },
	.{ win32.VK_VOLUME_UP, .VOLUME_UP },
	.{ win32.VK_MEDIA_NEXT_TRACK, .MEDIA_NEXT_TRACK },
	.{ win32.VK_MEDIA_PREV_TRACK, .MEDIA_PREV_TRACK },
	.{ win32.VK_MEDIA_STOP, .MEDIA_STOP },
	.{ win32.VK_MEDIA_PLAY_PAUSE, .MEDIA_PLAY_PAUSE },
	.{ win32.VK_LAUNCH_MAIL, .LAUNCH_MAIL },
	.{ win32.VK_LAUNCH_MEDIA_SELECT, .LAUNCH_MEDIA_SELECT },
	.{ win32.VK_LAUNCH_APP1, .LAUNCH_APP1 },
	.{ win32.VK_LAUNCH_APP2, .LAUNCH_APP2 },
	.{ win32.VK_OEM_1, .OEM_1 },
	.{ win32.VK_OEM_PLUS, .OEM_PLUS },
	.{ win32.VK_OEM_COMMA, .OEM_COMMA },
	.{ win32.VK_OEM_MINUS, .OEM_MINUS },
	.{ win32.VK_OEM_PERIOD, .OEM_PERIOD },
	.{ win32.VK_OEM_2, .OEM_2 },
	.{ win32.VK_OEM_3, .OEM_3 },
	.{ win32.VK_OEM_4, .OEM_4 },
	.{ win32.VK_OEM_5, .OEM_5 },
	.{ win32.VK_OEM_6, .OEM_6 },
	.{ win32.VK_OEM_7, .OEM_7 },
	.{ win32.VK_OEM_8, .OEM_8 },
	.{ win32.VK_OEM_102, .OEM_102 }
];
