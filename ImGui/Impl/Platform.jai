#scope_module

#import "Runtime";
imgui  :: #import "ImGui";
window :: #import "Window";
input  :: #import "Input";
utf8   :: #import "Unicode/UTF8";

#scope_export

init :: (window_handle : window.Handle) -> bool
{
	io := imgui.GetIO ();

	#if OS == .WINDOWS
		io.BackendPlatformName = "Win32";
	else #if OS == .LINUX
		io.BackendPlatformName = "Linux";
	else #if OS == .MACOS
		io.BackendPlatformName = "MacOS";

	io.BackendFlags_ |= .HasMouseCursors;
	io.BackendFlags_ |= .HasSetMousePos;
	imgui.GetMainViewport ().PlatformHandleRaw = cast (*void) window_handle;

	return true;
}

handle_window_message :: (msg : window.Message) -> handled : bool
{
	io := imgui.GetIO ();

	if msg.kind ==
	{
	case .MOUSE_MOVED;
		io.AddMousePosEvent (io, xx msg.mouse_x, xx msg.mouse_y);

		return true;

	case .MOUSE_WHEEL;
		io.AddMouseWheelEvent (io, msg.mouse_wheel_x, msg.mouse_wheel_y);

		return true;

	case .MOUSE_BUTTON_PRESSED; #through;
	case .MOUSE_BUTTON_REPEATED; #through;
	case .MOUSE_BUTTON_RELEASED;
		mouse_button : s32;
		if msg.mouse_button ==
		{
		case .LEFT;   mouse_button = 0;
		case .MIDDLE; mouse_button = 2;
		case .RIGHT;  mouse_button = 1;
		case;
			return false;
		}
		io.AddMouseButtonEvent (io, mouse_button, msg.kind != .MOUSE_BUTTON_RELEASED);

		return true;

	case .TEXT_INPUT;
		utf8_data : [5]u8 = ---;
		utf8_len := utf8.encode (utf8_data, msg.codepoint);
		utf8_data[utf8_len] = 0;
		io.AddInputCharactersUTF8 (io, utf8_data.data);

		return true;
	
	case .KEY_PRESSED; #through;
	//case .KEY_REPEATED; #through;
	case .KEY_RELEASED;
		key := keycode_to_imgui_key (msg.key_code);
		io.AddKeyEvent (io, .ModCtrl, (msg.mods & .CTRL) != 0);
		io.AddKeyEvent (io, .ModShift, (msg.mods & .SHIFT) != 0);
		io.AddKeyEvent (io, .ModAlt, (msg.mods & .ALT) != 0);
		io.AddKeyEvent (io, key, msg.kind != .KEY_RELEASED);

		return true;

	case .WINDOW_RECEIVED_FOCUS;
		io.AddFocusEvent (io, true);
		return true;

	case .WINDOW_LOST_FOCUS;
		io.AddFocusEvent (io, false);
		return true;
	}

	return false;
}

new_frame :: (delta_time : f32)
{
	win_handle := cast (window.Handle) imgui.GetMainViewport ().PlatformHandleRaw;
	io := imgui.GetIO ();

	io.DeltaTime = delta_time;

	if window.is_focused (win_handle)
	{
		if io.WantSetMousePos
		{
			window.set_mouse_position (win_handle, xx io.MousePos.x, xx io.MousePos.y);
		}
		else
		{
			mouse_x, mouse_y := window.get_mouse_position (win_handle);
			io.AddMousePosEvent (io, xx mouse_x, xx mouse_y);
		}
	}

	if imgui.GetMouseCursor () ==
	{
	case .Arrow;      window.set_cursor (.ARROW);
	case .TextInput;  window.set_cursor (.IBEAM);
	case .ResizeAll;  window.set_cursor (.SIZE);
	case .ResizeEW;   window.set_cursor (.SIZE_HORIZONTAL);
	case .ResizeNS;   window.set_cursor (.SIZE_VERTICAL);
	case .ResizeNESW; window.set_cursor (.SIZE_NESW);
	case .ResizeNWSE; window.set_cursor (.SIZE_NWSE);
	case .Hand;       window.set_cursor (.HAND);
	case .NotAllowed; window.set_cursor (.NOT_ALLOWED);
	}

	width, height := window.get_viewport_size (win_handle);
	io.DisplaySize.x = xx width;
	io.DisplaySize.y = xx height;
}

keycode_to_imgui_key :: inline (keycode : input.Key_Code) -> imgui.Key #must
{
	if keycode ==
	{
	case .TAB; return .Tab;
	case .LEFT; return .LeftArrow;
	case .RIGHT; return .RightArrow;
	case .UP; return .UpArrow;
	case .DOWN; return .DownArrow;
	case .PAGE_UP; return .PageUp;
	case .PAGE_DOWN; return .PageDown;
	case .HOME; return .Home;
	case .END; return .End;
	case .INSERT; return .Insert;
	case .DELETE; return .Delete;
	case .BACKSPACE; return .Backspace;
	case .SPACE; return .Space;
	case .RETURN; return .Enter;
	case .ESCAPE; return .Escape;
	case .US_SINGLE_QUOTE; return .Apostrophe;
	case .OEM_COMMA; return .Comma;
	case .OEM_MINUS; return .Minus;
	case .OEM_PERIOD; return .Period;
	case .US_SLASH; return .Slash;
	case .US_SEMICOLON; return .Semicolon;
	case .OEM_PLUS; return .Equal;
	case .US_OPENING_SQUARE_BRACKET; return .LeftBracket;
	case .US_BACKSLASH; return .Backslash;
	case .US_CLOSING_SQUARE_BRACKET; return .RightBracket;
	case .US_BACKTICK; return .GraveAccent;
	case .CAPS_LOCK; return .CapsLock;
	case .SCROLL_LOCK; return .ScrollLock;
	case .NUM_LOCK; return .NumLock;
	case .PRINT_SCREEN; return .PrintScreen;
	case .PAUSE; return .Pause;
	case .NUMPAD_0; return .Keypad0;
	case .NUMPAD_1; return .Keypad1;
	case .NUMPAD_2; return .Keypad2;
	case .NUMPAD_3; return .Keypad3;
	case .NUMPAD_4; return .Keypad4;
	case .NUMPAD_5; return .Keypad5;
	case .NUMPAD_6; return .Keypad6;
	case .NUMPAD_7; return .Keypad7;
	case .NUMPAD_8; return .Keypad8;
	case .NUMPAD_9; return .Keypad9;
	case .DECIMAL; return .KeypadDecimal;
	case .DIVIDE; return .KeypadDivide;
	case .MULTIPLY; return .KeypadMultiply;
	case .SUBSTRACT; return .KeypadSubtract;
	case .ADD; return .KeypadAdd;
	case .LEFT_CTRL; return .LeftCtrl;
	case .LEFT_SHIFT; return .LeftShift;
	case .LEFT_ALT; return .LeftAlt;
	case .LEFT_SUPER; return .LeftSuper;
	case .RIGHT_CTRL; return .RightCtrl;
	case .RIGHT_SHIFT; return .RightShift;
	case .RIGHT_ALT; return .RightAlt;
	case .RIGHT_SUPER; return .RightSuper;
	case .ZERO; return .ImGuiKey_0;
	case .ONE; return .ImGuiKey_1;
	case .TWO; return .ImGuiKey_2;
	case .THREE; return .ImGuiKey_3;
	case .FOUR; return .ImGuiKey_4;
	case .FIVE; return .ImGuiKey_5;
	case .SIX; return .ImGuiKey_6;
	case .SEVEN; return .ImGuiKey_7;
	case .EIGHT; return .ImGuiKey_8;
	case .NINE; return .ImGuiKey_9;
	case .A; return .A;
	case .B; return .B;
	case .C; return .C;
	case .D; return .D;
	case .E; return .E;
	case .F; return .F;
	case .G; return .G;
	case .H; return .H;
	case .I; return .I;
	case .J; return .J;
	case .K; return .K;
	case .L; return .L;
	case .M; return .M;
	case .N; return .N;
	case .O; return .O;
	case .P; return .P;
	case .Q; return .Q;
	case .R; return .R;
	case .S; return .S;
	case .T; return .T;
	case .U; return .U;
	case .V; return .V;
	case .W; return .W;
	case .X; return .X;
	case .Y; return .Y;
	case .Z; return .Z;
	case .F1; return .F1;
	case .F2; return .F2;
	case .F3; return .F3;
	case .F4; return .F4;
	case .F5; return .F5;
	case .F6; return .F6;
	case .F7; return .F7;
	case .F8; return .F8;
	case .F9; return .F9;
	case .F10; return .F10;
	case .F11; return .F11;
	case .F12; return .F12;
	}

	return .None;
}
