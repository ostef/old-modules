#scope_module

#import "Runtime";
mem   :: #import "Memory";
array :: #import "Containers/Array";
fmt   :: #import "Fmt";
input :: #import "Input";
math  :: #import "Math";

#scope_export

#if OS == .WINDOWS
	#load "win32.jai";

DEFAULT :: -1;

Cursor :: enum
{
	ARROW;
	ARROW_BUSY;
	BUSY;
	CROSS;
	HAND;
	IBEAM;
	SIZE;
	SIZE_NWSE;
	SIZE_NESW;
	SIZE_HORIZONTAL;
	SIZE_VERTICAL;
	COUNT;
}

Creation_Flags :: enum_flags
{
	NONE :: 0x00;
	VISIBLE :: 0x01;
	USE_CLIENT_COORDINATES  :: 0x02;
	CUSTOM_CAPTION :: 0x04;
}

Flags :: enum_flags
{
	NONE :: 0x00;
	CUSTOM_CAPTION :: 0x01;
}

Caption_Hit_Test_Proc :: #type (Window, mouse_x : s32, mouse_y : s32) -> on_caption : bool;

Message :: struct
{
	Kind :: enum
	{
		UNKNOWN :: 0;

		WINDOW_MOVED     :: 1;
		WINDOW_RESIZED   :: 2;
		WINDOW_MAXIMIZED :: 3;
		WINDOW_MINIMIZED :: 4;
		WINDOW_CLOSED    :: 5;
		WINDOW_SHOWN     :: 6;
		WINDOW_HIDDEN    :: 7;
		WINDOW_RECEIVED_FOCUS :: 8;
		WINDOW_LOST_FOCUS     :: 9;

		TEXT_INPUT   :: 100;
		KEY_PRESSED  :: 101;
		KEY_REPEATED :: 102;
		KEY_RELEASED :: 103;

		RAW_MOUSE_MOVED :: 104;
		MOUSE_MOVED :: 105;
		MOUSE_WHEEL :: 106;
		MOUSE_BUTTON_PRESSED  :: 107;
		MOUSE_BUTTON_REPEATED :: 108;
		MOUSE_BUTTON_RELEASED :: 109;
	}

	kind : Kind;
	window : Window;
	window_x : s32;
	window_y : s32;
	viewport_width : s32;
	viewport_height : s32;
	mods : input.Mods;
	codepoint : u32;
	key_code : input.Key_Code;
	mouse_delta_x, mouse_delta_y : s32;
	mouse_x, mouse_y : s32;
	mouse_wheel_x, mouse_wheel_y : f32;
	mouse_button : input.Mouse_Button;
}
