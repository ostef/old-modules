#scope_module

#import "Runtime";
mem     :: #import "Memory";
builder :: #import "String/Builder";
window  :: #import "Window";

#scope_export

#if OS == .WINDOWS
	#load "win32.jai";

Key_Code :: enum
{
	UNKNOWN :: 0;
	BACKSPACE :: 1;
	TAB       :: 2;
	CLEAR     :: 3;
	RETURN    :: 4;
	SHIFT     :: 5;
	CTRL      :: 6;
	ALT       :: 7;
	PAUSE     :: 8;
	CAPS_LOCK :: 9;
	ESCAPE    :: 10;
	SPACE     :: 11;
	PAGE_UP   :: 12;
	PAGE_DOWN :: 13;
	END       :: 14;
	HOME      :: 15;
	LEFT  :: 16;
	UP    :: 17;
	RIGHT :: 18;
	DOWN  :: 19;
	SELECT       :: 20;
	PRINT        :: 21;
	EXECUTE      :: 22;
	PRINT_SCREEN :: 23;
	INSERT :: 24;
	DELETE :: 25;
	HELP   :: 26;
	ZERO  :: #char "0";
	ONE   :: #char "1";
	TWO   :: #char "2";
	THREE :: #char "3";
	FOUR  :: #char "4";
	FIVE  :: #char "5";
	SIX   :: #char "6";
	SEVEN :: #char "7";
	EIGHT :: #char "8";
	NINE  :: #char "9";
	A :: #char "A";
	B :: #char "B";
	C :: #char "C";
	D :: #char "D";
	E :: #char "E";
	F :: #char "F";
	G :: #char "G";
	H :: #char "H";
	I :: #char "I";
	J :: #char "J";
	K :: #char "K";
	L :: #char "L";
	M :: #char "M";
	N :: #char "N";
	O :: #char "O";
	P :: #char "P";
	Q :: #char "Q";
	R :: #char "R";
	S :: #char "S";
	T :: #char "T";
	U :: #char "U";
	V :: #char "V";
	W :: #char "W";
	X :: #char "X";
	Y :: #char "Y";
	Z :: #char "Z";
	LEFT_SUPER  :: 91;
	RIGHT_SUPER :: 92;
	APPS  :: 93;
	SLEEP :: 94;
	NUMPAD_0 :: 95;
	NUMPAD_1 :: 96;
	NUMPAD_2 :: 97;
	NUMPAD_3 :: 98;
	NUMPAD_4 :: 99;
	NUMPAD_5 :: 100;
	NUMPAD_6 :: 101;
	NUMPAD_7 :: 102;
	NUMPAD_8 :: 103;
	NUMPAD_9 :: 104;
	MULTIPLY  :: 105;
	ADD       :: 106;
	SEPARATOR :: 107;
	SUBTRACT  :: 108;
	SUBSTRACT :: SUBTRACT;
	DECIMAL   :: 109;
	DIVIDE    :: 110;
	F1  :: 120;
	F2  :: 121;
	F3  :: 122;
	F4  :: 123;
	F5  :: 124;
	F6  :: 125;
	F7  :: 126;
	F8  :: 127;
	F9  :: 128;
	F10 :: 129;
	F11 :: 130;
	F12 :: 131;
	F13 :: 132;
	F14 :: 133;
	F15 :: 134;
	F16 :: 135;
	F17 :: 136;
	F18 :: 137;
	F19 :: 138;
	F20 :: 139;
	F21 :: 140;
	F22 :: 141;
	F23 :: 142;
	F24 :: 143;
	NUM_LOCK    :: 144;
	SCROLL_LOCK :: 145;
	LEFT_SHIFT  :: 146;
	RIGHT_SHIFT :: 147;
	LEFT_CTRL   :: 148;
	RIGHT_CTRL  :: 149;
	LEFT_ALT    :: 150;
	RIGHT_ALT   :: 151;
	BROWSER_BACK    :: 152;
	BROWSER_FORWARD :: 153;
	BROWSER_REFRESH :: 154;
	BROWSER_STOP    :: 155;
	BROWSER_SEARCH  :: 156;
	BROWSER_FAVORITES :: 157;
	BROWSER_HOME    :: 158;
	VOLUME_MUTE :: 159;
	VOLUME_DOWN :: 160;
	VOLUME_UP   :: 161;
	MEDIA_NEXT_TRACK :: 162;
	MEDIA_PREV_TRACK :: 163;
	MEDIA_STOP       :: 164;
	MEDIA_PLAY_PAUSE :: 165;
	LAUNCH_MAIL :: 166;
	LAUNCH_MEDIA_SELECT :: 167;
	LAUNCH_APP1 :: 168;
	LAUNCH_APP2 :: 169;
	OEM_1 :: 170;
	US_COLON     :: OEM_1;
	US_SEMICOLON :: OEM_1;
	OEM_PLUS   :: 171;
	OEM_COMMA  :: 172;
	OEM_MINUS  :: 173;
	OEM_PERIOD :: 174;
	OEM_2 :: 175;
	US_SLASH              :: OEM_2;
	US_INTERROGATION_MARK :: OEM_2;
	OEM_3 :: 176;
	US_BACKTICK :: OEM_3;
	US_TILDE    :: OEM_3;
	OEM_4 :: 177;
	US_OPENING_SQUARE_BRACKET :: OEM_4;
	US_OPENING_CURLY_BRACKET  :: OEM_4;
	OEM_5 :: 178;
	US_BACKSLASH    :: OEM_5;
	US_VERTICAL_BAR :: OEM_5;
	OEM_6 :: 179;
	US_CLOSING_SQUARE_BRACKET :: OEM_6;
	US_CLOSING_CURLY_BRACKET  :: OEM_6;
	OEM_7 :: 180;
	US_SINGLE_QUOTE :: OEM_7;
	US_DOUBLE_QUOTE :: OEM_7;
	OEM_8   :: 181;
	OEM_102 :: 182;

	COUNT;
}

Mods :: enum_flags
{
	NONE  :: 0x00;
	CTRL  :: 0x01;
	SHIFT :: 0x02;
	ALT   :: 0x04;
}

Mouse_Button :: enum
{
	UNKNOWN :: 0;
	LEFT    :: 1;
	RIGHT   :: 2;
	MIDDLE  :: 3;

	COUNT;
}
