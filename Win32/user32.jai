MessageBoxA :: (hWnd : HWND, lpText : *CHAR, lpCaption : *CHAR, uType : UINT) -> s32 #foreign user32;
MessageBoxW :: (hWnd : HWND, lpText : *WCHAR, lpCaption : *WCHAR, uType : UINT) -> s32 #foreign user32;

#if UNICODE then MessageBox :: MessageBoxW;
else             MessageBox :: MessageBoxA;

MB_OK                :: 0x00000000;
MB_OKCANCEL          :: 0x00000001;
MB_ABORTRETRYIGNORE  :: 0x00000002;
MB_YESNOCANCEL       :: 0x00000003;
MB_YESNO             :: 0x00000004;
MB_RETRYCANCEL       :: 0x00000005;
MB_CANCELTRYCONTINUE :: 0x00000006;
MB_HELP              :: 0x00004000;

MB_ICONERROR       :: 0x00000010;
MB_ICONHAND        :: 0x00000010;
MB_ICONSTOP        :: 0x00000010;
MB_ICONQUESTION    :: 0x00000020;
MB_ICONEXCLAMATION :: 0x00000030;
MB_ICONWARNING     :: 0x00000030;
MB_ICONINFORMATION :: 0x00000040;
MB_ICONASTERISK    :: 0x00000040;

MB_DEFBUTTON1 :: 0x00000000;
MB_DEFBUTTON2 :: 0x00000100;
MB_DEFBUTTON3 :: 0x00000200;
MB_DEFBUTTON4 :: 0x00000300;

MB_APPLMODAL   :: 0x00000000;
MB_SYSTEMMODAL :: 0x00001000;
MB_TASKMODAL   :: 0x00002000;

MB_DEFAULT_DESKTOP_ONLY :: 0x00020000;

MB_SETFOREGROUND        :: 0x00010000;
MB_TOPMOST              :: 0x00040000;
MB_RIGHT                :: 0x00080000;
MB_RTLREADING           :: 0x00100000;
MB_SERVICE_NOTIFICATION :: 0x00200000;

IDOK       :: 1;
IDCANCEL   :: 2;
IDABORT    :: 3;
IDRETRY    :: 4;
IDIGNORE   :: 5;
IDYES      :: 6;
IDNO       :: 7;
IDTRYAGAIN :: 10;
IDCONTINUE :: 11;

CreateWindowExA :: (
	dwExStyle : DWORD,
	lpClassName : *CHAR,
	lpWindowName : *CHAR,
	dwStyle : DWORD,
	x : INT,
	y : INT,
	nWidth : INT,
	nHeight : INT,
	hWndParent : HWND,
	hMenu : HMENU,
	hInstance : HINSTANCE,
	lpParam : *VOID
) -> HWND #must #foreign user32;

CreateWindowExW :: (
	dwExStyle : DWORD,
	lpClassName : *WCHAR,
	lpWindowName : *WCHAR,
	dwStyle : DWORD,
	x : INT,
	y : INT,
	nWidth : INT,
	nHeight : INT,
	hWndParent : HWND,
	hMenu : HMENU,
	hInstance : HINSTANCE,
	lpParam : *VOID
) -> HWND #must #foreign user32;

#if UNICODE then CreateWindowEx :: CreateWindowExW;
else             CreateWindowEx :: CreateWindowExA;

DestroyWindow :: (hWnd : HWND) -> BOOL #foreign user32;
EnableWindow :: (hWnd : HWND, bEnable : BOOL) -> BOOL #foreign user32;
ShowWindow :: (hWnd : HWND, nCmdShow : INT) -> BOOL #foreign user32;
SetWindowLongPtrW :: (hWnd : HWND, nIndex : INT, dwNewLong : *LONG) -> *LONG #foreign user32;
SetWindowLongPtrA :: (hWnd : HWND, nIndex : INT, dwNewLong : *LONG) -> *LONG #foreign user32;
#if UNICODE then SetWindowLongPtr :: SetWindowLongPtrW;
else             SetWindowLongPtr :: SetWindowLongPtrA;
GetWindowLongPtrW :: (hWnd : HWND, nIndex : INT) -> *LONG #foreign user32;
GetWindowLongPtrA :: (hWnd : HWND, nIndex : INT) -> *LONG #foreign user32;
#if UNICODE then GetWindowLongPtr :: GetWindowLongPtrW;
else             GetWindowLongPtr :: GetWindowLongPtrA;
GetDC :: (hWnd : HWND) -> HDC #foreign user32;
ReleaseDC :: (hWnd : HWND, hDC : HDC) -> INT #foreign user32;
ChoosePixelFormat :: (hdc : HDC, ppfd : *PIXELFORMATDESCRIPTOR) -> INT #foreign gdi32;
SetPixelFormat :: (hdc : HDC, format : INT, ppfd : *PIXELFORMATDESCRIPTOR) -> BOOL #foreign gdi32;
PeekMessageA :: (lpMsg : *MSG, hWnd : HWND, wMsgFilterMin : UINT, wMsgFilterMax : UINT, wRemoveMsg : UINT) -> BOOL #foreign user32;
PeekMessageW :: (lpMsg : *MSG, hWnd : HWND, wMsgFilterMin : UINT, wMsgFilterMax : UINT, wRemoveMsg : UINT) -> BOOL #foreign user32;
#if UNICODE then PeekMessage :: PeekMessageW;
else             PeekMessage :: PeekMessageA;
GetMessageA :: (lpMsg : *MSG, hWnd : HWND, wMsgFilterMin : UINT, wMsgFilterMax : UINT) -> BOOL #foreign user32;
GetMessageW :: (lpMsg : *MSG, hWnd : HWND, wMsgFilterMin : UINT, wMsgFilterMax : UINT) -> BOOL #foreign user32;
#if UNICODE then GetMessage :: GetMessageW;
else             GetMessage :: GetMessageA;
TranslateMessage :: (lpMsg : *MSG) -> BOOL #foreign user32;
DispatchMessageA :: (lpMsg : *MSG) -> BOOL #foreign user32;
DispatchMessageW :: (lpMsg : *MSG) -> BOOL #foreign user32;
#if UNICODE then DispatchMessage :: DispatchMessageW;
else             DispatchMessage :: DispatchMessageA;
SwapBuffers :: (hdc : HDC) -> BOOL #foreign gdi32;
GetWindowRect :: (hWnd : HWND, lpRect : *RECT) -> BOOL #foreign user32;
GetClientRect :: (hWnd : HWND, lpRect : *RECT) -> BOOL #foreign user32;
SetWindowPos :: (hWnd : HWND, hWndInsertAfter : HWND, X : s32, Y : s32, cx : s32, cy : s32, uFlags : UINT) -> BOOL #foreign user32;
AdjustWindowRect :: (lpRect : *RECT, dwStyle : DWORD, bMenu : BOOL) -> BOOL #foreign user32;
AdjustWindowRectEx :: (lpRect : *RECT, dwStyle : DWORD, bMenu : BOOL, dwExStyle : DWORD) -> BOOL #foreign user32;
GetFocus :: () -> HWND #foreign user32;

ScreenToClient :: (hWnd : HWND, lpPoint : *POINT) -> BOOL #foreign user32;
ClientToScreen :: (hWnd : HWND, lpPoint : *POINT) -> BOOL #foreign user32;
GetCursorPos :: (lpPoint : *POINT) -> BOOL #foreign user32;
SetCursorPos :: (X : s32, Y : s32) -> BOOL #foreign user32;
ShowCursor :: (bShow : BOOL) -> s32 #foreign user32;
GetAsyncKeyState :: (vKey : s32) -> SHORT #foreign user32;
GetKeyState :: (vKey : s32) -> SHORT #foreign user32;

HIWORD :: (wparam: WPARAM) -> s16 #expand { return cast, no_check (s16) ((cast, no_check (s32) (wparam) >> 16) & 0xffff); }
LOWORD :: (wparam: WPARAM) -> s16 #expand { return cast, no_check (s16) (wparam); }
HIWORD :: (lparam: LPARAM) -> s16 #expand { return cast, no_check (s16) ((cast, no_check (s32) (lparam) >> 16) & 0xffff); }
LOWORD :: (lparam: LPARAM) -> s16 #expand { return cast, no_check (s16) (lparam); }

// SetWindowPos
HWND_NOTOPMOST :: cast (HWND) -2;
HWND_TOPMOST   :: cast (HWND) -1;
HWND_TOP       :: cast (HWND)  0;
HWND_BOTTOM    :: cast (HWND)  1;

SWP_NOSIZE         :: 0x0001;
SWP_NOMOVE         :: 0x0002;
SWP_NOZORDER       :: 0x0004;
SWP_NOREDRAW       :: 0x0008;
SWP_NOACTIVATE     :: 0x0010;
SWP_FRAMECHANGED   :: 0x0020;
SWP_DRAWFRAME      :: 0x0020;
SWP_SHOWWINDOW     :: 0x0040;
SWP_HIDEWINDOW     :: 0x0080;
SWP_NOCOPYBITS     :: 0x0100;
SWP_DEFERERASE     :: 0x2000;
SWP_ASYNCWINDOWPOS :: 0x4000;
SWP_NOOWNERZORDER  :: 0x0200;
SWP_NOREPOSITION   :: 0x0200;
SWP_NOSENDCHANGING :: 0x0400;

CW_USEDEFAULT :: 0x80000000;

// PeekMessage
PM_NOREMOVE :: 0x0000;
PM_REMOVE   :: 0x0001;
PM_NOYIELD  :: 0x0002;

// ShowWindow, nCmdShow
SW_HIDE            : INT : 0;
SW_SHOWNORMAL      : INT : 1;
SW_SHOWMINIMIZED   : INT : 2;
SW_MAXIMIZE        : INT : 3;
SW_SHOWMAXIMIZED   : INT : 3;
SW_SHOWNOACTIVATE  : INT : 4;
SW_SHOW            : INT : 5;
SW_MINIMIZE        : INT : 6;
SW_SHOWMINNOACTIVE : INT : 7;
SW_SHOWNA          : INT : 8;
SW_RESTORE         : INT : 9;
SW_SHOWDEFAULT     : INT : 10;
SW_FORCEMINIMIZE   : INT : 11;

// SetWindowLongPtrW, GetWindowLongPtrW
GWLP_USERDATA  : INT : -21;
GWL_EXSTYLE    : INT : -20;
GWL_STYLE      : INT : -16;
GWLP_ID        : INT : -12;
GWLP_HINSTANCE : INT : -6;
GWLP_WNDPROC   : INT : -4;

WNDPROC :: #type (HWND, UINT, WPARAM, LPARAM) -> LRESULT #c_call;

DefWindowProcA :: (hWnd : HWND, Msg : UINT, wParam : WPARAM, lParam : LPARAM) -> LRESULT #foreign user32;
DefWindowProcW :: (hWnd : HWND, Msg : UINT, wParam : WPARAM, lParam : LPARAM) -> LRESULT #foreign user32;
#if UNICODE then DefWindowProc :: DefWindowProcW;
else             DefWindowProc :: DefWindowProcA;

WNDCLASSA :: struct
{
	style : UINT;
	lpfnWndProc : WNDPROC;
	cbClsExtra : s32;
	cbWndExtra : s32;
	hInstance : HINSTANCE;
	hIcon : HICON;
	hCursor : HCURSOR;
	hbrBackground : HBRUSH;
	lpszMenuName : *CHAR;
	lpszClassName : *CHAR;
}

WNDCLASSW :: struct
{
	style : UINT;
	lpfnWndProc : WNDPROC;
	cbClsExtra : s32;
	cbWndExtra : s32;
	hInstance : HINSTANCE;
	hIcon : HICON;
	hCursor : HCURSOR;
	hbrBackground : HBRUSH;
	lpszMenuName : *WCHAR;
	lpszClassName : *WCHAR;
}

#if UNICODE then WNDCLASS :: WNDCLASSW;
else             WNDCLASS :: WNDCLASSA;

WNDCLASSEXA :: struct
{
	cbSize : UINT;
	style : UINT;
	lpfnWndProc : WNDPROC;
	cbClsExtra : s32;
	cbWndExtra : s32;
	hInstance : HINSTANCE;
	hIcon : HICON;
	hCursor : HCURSOR;
	hbrBackground : HBRUSH;
	lpszMenuName : *CHAR;
	lpszClassName : *CHAR;
	hIconSm : HICON;
}

WNDCLASSEXW :: struct
{
	cbSize : UINT;
	style : UINT;
	lpfnWndProc : WNDPROC;
	cbClsExtra : s32;
	cbWndExtra : s32;
	hInstance : HINSTANCE;
	hIcon : HICON;
	hCursor : HCURSOR;
	hbrBackground : HBRUSH;
	lpszMenuName : *WCHAR;
	lpszClassName : *WCHAR;
	hIconSm : HICON;
}

#if UNICODE then WNDCLASSEX :: WNDCLASSEXW;
else             WNDCLASSEX :: WNDCLASSEXA;

RegisterClassA :: (lpWndClass : *WNDCLASSA) -> ATOM #foreign user32;
RegisterClassW :: (lpWndClass : *WNDCLASSW) -> ATOM #foreign user32;

#if UNICODE then RegisterClass :: RegisterClassW;
else             RegisterClass :: RegisterClassA;

RegisterClassExA :: (lpWndClass : *WNDCLASSEXA) -> ATOM #foreign user32;
RegisterClassExW :: (lpWndClass : *WNDCLASSEXW) -> ATOM #foreign user32;

#if UNICODE then RegisterClassEx :: RegisterClassExW;
else             RegisterClassEx :: RegisterClassExA;

CS_VREDRAW         :: 0x0001;
CS_HREDRAW         :: 0x0002;
CS_DBLCLKS         :: 0x0008;
CS_OWNDC           :: 0x0020;
CS_CLASSDC         :: 0x0040;
CS_PARENTDC        :: 0x0080;
CS_NOCLOSE         :: 0x0200;
CS_SAVEBITS        :: 0x0800;
CS_BYTEALIGNCLIENT :: 0x1000;
CS_BYTEALIGNWINDOW :: 0x2000;
CS_GLOBALCLASS     :: 0x4000;
CS_DROPSHADOW      :: 0x00020000;

WS_EX_ACCEPTFILES   :: 0x00000010;
WS_EX_APPWINDOW     :: 0x00040000;
WS_EX_CLIENTEDGE    :: 0x00000200;
WS_EX_COMPOSITED    :: 0x02000000;
WS_EX_CONTEXTHELP   :: 0x00000400;
WS_EX_CONTROLPARENT :: 0x00010000;
WS_EX_DLGMODALFRAME :: 0x00000001;
WS_EX_LAYERED       :: 0x00080000;
WS_EX_LAYOUTRTL     :: 0x00400000;
WS_EX_LEFT          :: 0x00000000;
WS_EX_LEFTSCROLLBAR :: 0x00004000;
WS_EX_LTRREADING    :: 0x00000000;
WS_EX_MDICHILD      :: 0x00000040;
WS_EX_NOACTIVATE    :: 0x08000000;
WS_EX_NOINHERITLAYOUT     :: 0x00100000;
WS_EX_NOPARENTNOTIFY      :: 0x00000004;
WS_EX_NOREDIRECTIONBITMAP :: 0x00200000;
WS_EX_OVERLAPPEDWINDOW    :: WS_EX_WINDOWEDGE | WS_EX_CLIENTEDGE;
WS_EX_PALETTEWINDOW       :: WS_EX_WINDOWEDGE | WS_EX_TOOLWINDOW | WS_EX_TOPMOST;
WS_EX_RIGHT          :: 0x00001000;
WS_EX_RIGHTSCROLLBAR :: 0x00000000;
WS_EX_RTLREADING     :: 0x00002000;
WS_EX_STATICEDGE     :: 0x00020000;
WS_EX_TOOLWINDOW     :: 0x00000080;
WS_EX_TOPMOST        :: 0x00000008;
WS_EX_TRANSPARENT    :: 0x00000020;
WS_EX_WINDOWEDGE     :: 0x00000100;

WS_OVERLAPPED   :: 0x00000000;
WS_TILED        :: 0x00000000;
WS_TABSTOP      :: 0x00010000;
WS_MAXIMIZEBOX  :: 0x00010000;
WS_MINIMIZEBOX  :: 0x00020000;
WS_GROUP        :: 0x00020000;
WS_SIZEBOX      :: 0x00040000;
WS_THICKFRAME   :: 0x00040000;
WS_SYSMENU      :: 0x00080000;
WS_HSCROLL      :: 0x00100000;
WS_VSCROLL      :: 0x00200000;
WS_DLGFRAME     :: 0x00400000;
WS_BORDER       :: 0x00800000;
WS_CAPTION      :: 0x00C00000;
WS_MAXIMIZE     :: 0x01000000;
WS_CLIPCHILDREN :: 0x02000000;
WS_CLIPSIBLINGS :: 0x04000000;
WS_DISABLED     :: 0x08000000;
WS_VISIBLE      :: 0x10000000;
WS_ICONIC       :: 0x20000000;
WS_MINIMIZE     :: 0x20000000;
WS_CHILD        :: 0x40000000;
WS_CHILDWINDOW  :: 0x40000000;
WS_POPUP        :: 0x80000000;
WS_OVERLAPPEDWINDOW :: WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
WS_POPUPWINDOW      :: WS_POPUP | WS_BORDER | WS_SYSMENU;
WS_TILEDWINDOW      :: WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;

SIZE_RESTORED  :: 0;
SIZE_MINIMIZED :: 1;
SIZE_MAXIMIZED :: 2;
SIZE_MAXSHOW   :: 3;
SIZE_MAXHIDE   :: 4;

PIXELFORMATDESCRIPTOR :: struct
{
	nSize           : WORD;
	nVersion        : WORD;
	dwFlags         : DWORD;
	iPixelType      : BYTE;
	cColorBits      : BYTE;
	cRedBits        : BYTE;
	cRedShift       : BYTE;
	cGreenBits      : BYTE;
	cGreenShift     : BYTE;
	cBlueBits       : BYTE;
	cBlueShift      : BYTE;
	cAlphaBits      : BYTE;
	cAlphaShift     : BYTE;
	cAccumBits      : BYTE;
	cAccumRedBits   : BYTE;
	cAccumGreenBits : BYTE;
	cAccumBlueBits  : BYTE;
	cAccumAlphaBits : BYTE;
	cDepthBits      : BYTE;
	cStencilBits    : BYTE;
	cAuxBuffers     : BYTE;
	iLayerType      : BYTE;
	bReserved       : BYTE;
	dwLayerMask     : DWORD;
	dwVisibleMask   : DWORD;
	dwDamageMask    : DWORD;
}

PFD_DOUBLEBUFFER        :: 0x00000001;
PFD_STEREO              :: 0x00000002;
PFD_DRAW_TO_WINDOW      :: 0x00000004;
PFD_DRAW_TO_BITMAP      :: 0x00000008;
PFD_SUPPORT_GDI         :: 0x00000010;
PFD_SUPPORT_OPENGL      :: 0x00000020;
PFD_GENERIC_FORMAT      :: 0x00000040;
PFD_NEED_PALETTE        :: 0x00000080;
PFD_NEED_SYSTEM_PALETTE :: 0x00000100;
PFD_SWAP_EXCHANGE       :: 0x00000200;
PFD_SWAP_COPY           :: 0x00000400;
PFD_SWAP_LAYER_BUFFERS  :: 0x00000800;
PFD_GENERIC_ACCELERATED :: 0x00001000;

PFD_DEPTH_DONTCARE        :: 0x20000000;
PFD_DOUBLEBUFFER_DONTCARE :: 0x40000000;
PFD_STEREO_DONTCARE       :: 0x80000000;

PFD_TYPE_RGBA       :: 0;
PFD_TYPE_COLORINDEX :: 1;

MSG :: struct
{
	hwnd     : HWND;
	message  : UINT;
	wParam   : WPARAM;
	lParam   : LPARAM;
	time     : DWORD;
	pt       : POINT;
	lPrivate : DWORD;
}

// Clipboard
OpenClipboard :: (hWndNewOwner : HWND) -> BOOL #foreign user32;
CloseClipboard :: () -> BOOL #foreign user32;
EmptyClipboard :: () -> BOOL #foreign user32;
GetClipboardData :: (uFormat : UINT) -> HANDLE #foreign user32;
SetClipboardData :: (uFormat : UINT, hMem : HANDLE) -> HANDLE #foreign user32;

CF_BITMAP          : UINT : 2;
CF_DIB             : UINT : 8;
CF_DIBVS           : UINT : 17;
CF_DIF             : UINT : 5;
CF_DSPBITMAP       : UINT : 0x0082;
CF_DSPENHMETAFILE  : UINT : 0x008e;
CF_DSPMETAFILEPICT : UINT : 0x0083;
CF_DSPTEXT         : UINT : 0x0081;
CF_ENHMETAFILE     : UINT : 14;
CF_GDIOBJFIRST     : UINT : 0x0300;
CF_GDIOBJLAST      : UINT : 0x03ff;
CF_HDROP           : UINT : 15;
CF_LOCALE          : UINT : 16;
CF_METAFILEPICT    : UINT : 3;
CF_OEMTEXT         : UINT : 7;
CF_OWNERDISPLAY    : UINT : 0x0080;
CF_PALETTE         : UINT : 9;
CF_PENDATA         : UINT : 10;
CF_PRIVATEFIRST    : UINT : 0x0200;
CF_PRIVATELAST     : UINT : 0x02ff;
CF_RIFF            : UINT : 11;
CF_SYLK            : UINT : 4;
CF_TEXT            : UINT : 1;
CF_TIFF            : UINT : 6;
CF_UNICODETEXT     : UINT : 13;
CF_WAVE            : UINT : 12;

WM_NULL    :: 0x0000;
WM_CREATE  :: 0x0001;
WM_DESTROY :: 0x0002;
WM_MOVE    :: 0x0003;

WM_SIZE            :: 0x0005;
WM_SETFOCUS        :: 0x0007;
WM_KILLFOCUS       :: 0x0008;
WM_ENABLE          :: 0x000A;
WM_SETREDRAW       :: 0x000B;
WM_SETTEXT         :: 0x000C;
WM_GETTEXT         :: 0x000D;
WM_GETTEXTLENGTH   :: 0x000E;
WM_PAINT           :: 0x000F;
WM_CLOSE           :: 0x0010;
WM_QUERYENDSESSION :: 0x0011;
WM_QUERYOPEN       :: 0x0013;
WM_ENDSESSION      :: 0x0016;
WM_QUIT            :: 0x0012;
WM_ERASEBKGND      :: 0x0014;
WM_SYSCOLORCHANGE  :: 0x0015;
WM_SHOWWINDOW      :: 0x0018;
WM_WININICHANGE    :: 0x001A;
WM_SETTINGCHANGE   :: WM_WININICHANGE;
WM_DEVMODECHANGE   :: 0x001B;
WM_ACTIVATEAPP     :: 0x001C;
WM_FONTCHANGE      :: 0x001D;
WM_TIMECHANGE      :: 0x001E;
WM_CANCELMODE      :: 0x001F;
WM_SETCURSOR       :: 0x0020;
WM_MOUSEACTIVATE   :: 0x0021;
WM_CHILDACTIVATE   :: 0x0022;
WM_QUEUESYNC       :: 0x0023;
WM_GETMINMAXINFO   :: 0x0024;

WM_NOTIFY                 :: 0x004E;
WM_INPUTLANGCHANGEREQUEST :: 0x0050;
WM_INPUTLANGCHANGE        :: 0x0051;
WM_TCARD                  :: 0x0052;
WM_HELP                   :: 0x0053;
WM_USERCHANGED            :: 0x0054;
WM_NOTIFYFORMAT           :: 0x0055;
WM_CONTEXTMENU            :: 0x007B;
WM_STYLECHANGING          :: 0x007C;
WM_STYLECHANGED           :: 0x007D;
WM_DISPLAYCHANGE          :: 0x007E;
WM_GETICON                :: 0x007F;
WM_SETICON                :: 0x0080;
WM_NCCREATE               :: 0x0081;
WM_NCDESTROY              :: 0x0082;
WM_NCCALCSIZE             :: 0x0083;
WM_NCHITTEST              :: 0x0084;
WM_NCPAINT                :: 0x0085;
WM_NCACTIVATE             :: 0x0086;
WM_GETDLGCODE             :: 0x0087;
WM_SYNCPAINT              :: 0x0088;
WM_NCMOUSEMOVE            :: 0x00A0;
WM_NCLBUTTONDOWN          :: 0x00A1;
WM_NCLBUTTONUP            :: 0x00A2;
WM_NCLBUTTONDBLCLK        :: 0x00A3;
WM_NCRBUTTONDOWN          :: 0x00A4;
WM_NCRBUTTONUP            :: 0x00A5;
WM_NCRBUTTONDBLCLK        :: 0x00A6;
WM_NCMBUTTONDOWN          :: 0x00A7;
WM_NCMBUTTONUP            :: 0x00A8;
WM_NCMBUTTONDBLCLK        :: 0x00A9;
WM_NCXBUTTONDOWN          :: 0x00AB;
WM_NCXBUTTONUP            :: 0x00AC;
WM_NCXBUTTONDBLCLK        :: 0x00AD;
WM_INPUT_DEVICE_CHANGE    :: 0x00FE;
WM_INPUT                  :: 0x00FF;
WM_KEYFIRST               :: 0x0100;
WM_KEYDOWN                :: 0x0100;
WM_KEYUP                  :: 0x0101;
WM_CHAR                   :: 0x0102;
WM_DEADCHAR               :: 0x0103;
WM_SYSKEYDOWN             :: 0x0104;
WM_SYSKEYUP               :: 0x0105;
WM_SYSCHAR                :: 0x0106;
WM_SYSDEADCHAR            :: 0x0107;
WM_UNICHAR                :: 0x0109;
WM_KEYLAST                :: 0x0109;
UNICODE_NOCHAR            :: 0xFFFF;
WM_IME_STARTCOMPOSITION   :: 0x010D;
WM_IME_ENDCOMPOSITION     :: 0x010E;
WM_IME_COMPOSITION        :: 0x010F;
WM_IME_KEYLAST            :: 0x010F;
WM_INITDIALOG             :: 0x0110;
WM_COMMAND                :: 0x0111;
WM_SYSCOMMAND             :: 0x0112;
WM_TIMER                  :: 0x0113;
WM_HSCROLL                :: 0x0114;
WM_VSCROLL                :: 0x0115;
WM_INITMENU               :: 0x0116;
WM_INITMENUPOPUP          :: 0x0117;
WM_GESTURE                :: 0x0119;
WM_GESTURENOTIFY          :: 0x011A;
WM_MENUSELECT             :: 0x011F;
WM_MENUCHAR               :: 0x0120;
WM_ENTERIDLE              :: 0x0121;
WM_MENURBUTTONUP          :: 0x0122;
WM_MENUDRAG               :: 0x0123;
WM_MENUGETOBJECT          :: 0x0124;
WM_UNINITMENUPOPUP        :: 0x0125;
WM_MENUCOMMAND            :: 0x0126;
WM_CHANGEUISTATE          :: 0x0127;
WM_UPDATEUISTATE          :: 0x0128;
WM_QUERYUISTATE           :: 0x0129;

WM_CTLCOLORMSGBOX    :: 0x0132;
WM_CTLCOLOREDIT      :: 0x0133;
WM_CTLCOLORLISTBOX   :: 0x0134;
WM_CTLCOLORBTN       :: 0x0135;
WM_CTLCOLORDLG       :: 0x0136;
WM_CTLCOLORSCROLLBAR :: 0x0137;
WM_CTLCOLORSTATIC    :: 0x0138;
MN_GETHMENU          :: 0x01E1;
WM_MOUSEFIRST        :: 0x0200;
WM_MOUSEMOVE         :: 0x0200;
WM_LBUTTONDOWN       :: 0x0201;
WM_LBUTTONUP         :: 0x0202;
WM_LBUTTONDBLCLK     :: 0x0203;
WM_RBUTTONDOWN       :: 0x0204;
WM_RBUTTONUP         :: 0x0205;
WM_RBUTTONDBLCLK     :: 0x0206;
WM_MBUTTONDOWN       :: 0x0207;
WM_MBUTTONUP         :: 0x0208;
WM_MBUTTONDBLCLK     :: 0x0209;
WM_MOUSEWHEEL        :: 0x020A;
WM_XBUTTONDOWN       :: 0x020B;
WM_XBUTTONUP         :: 0x020C;
WM_XBUTTONDBLCLK     :: 0x020D;
WM_MOUSEHWHEEL       :: 0x020E;
WM_MOUSELAST         :: 0x020E;

WM_EXITSIZEMOVE :: 0x0232;
WM_DPICHANGED   :: 0x02E0;

KF_EXTENDED :: 256;
KF_DLGMODE  :: 2048;
KF_MENUMODE :: 4096;
KF_ALTDOWN  :: 8192;
KF_REPEAT   :: 16384;
KF_UP       :: 32768;

VK_LBUTTON :: 0x01;
VK_RBUTTON :: 0x02;
VK_CANCEL :: 0x03;
VK_MBUTTON :: 0x04;
VK_XBUTTON1 :: 0x05;
VK_XBUTTON2 :: 0x06;
VK_BACK :: 0x08;
VK_TAB :: 0x09;
VK_CLEAR :: 0x0C;
VK_RETURN :: 0x0D;
VK_SHIFT :: 0x10;
VK_CONTROL :: 0x11;
VK_MENU :: 0x12;
VK_PAUSE :: 0x13;
VK_CAPITAL :: 0x14;
VK_KANA :: 0x15;
VK_HANGUEL :: 0x15;
VK_HANGUL :: 0x15;
VK_IME_ON :: 0x16;
VK_JUNJA :: 0x17;
VK_FINAL :: 0x18;
VK_HANJA :: 0x19;
VK_KANJI :: 0x19;
VK_IME_OFF :: 0x1A;
VK_ESCAPE :: 0x1B;
VK_CONVERT :: 0x1C;
VK_NONCONVERT :: 0x1D;
VK_ACCEPT :: 0x1E;
VK_MODECHANGE :: 0x1F;
VK_SPACE :: 0x20;
VK_PRIOR :: 0x21;
VK_NEXT :: 0x22;
VK_END :: 0x23;
VK_HOME :: 0x24;
VK_LEFT  :: 0x25;
VK_UP    :: 0x26;
VK_RIGHT :: 0x27;
VK_DOWN  :: 0x28;
VK_SELECT :: 0x29;
VK_PRINT :: 0x2A;
VK_EXECUTE :: 0x2B;
VK_SNAPSHOT :: 0x2C;
VK_INSERT :: 0x2D;
VK_DELETE :: 0x2E;
VK_HELP :: 0x2F;
VK_LWIN :: 0x5B;
VK_RWIN :: 0x5C;
VK_APPS :: 0x5D;
VK_SLEEP :: 0x5F;
VK_NUMPAD0 :: 0x60;
VK_NUMPAD1 :: 0x61;
VK_NUMPAD2 :: 0x62;
VK_NUMPAD3 :: 0x63;
VK_NUMPAD4 :: 0x64;
VK_NUMPAD5 :: 0x65;
VK_NUMPAD6 :: 0x66;
VK_NUMPAD7 :: 0x67;
VK_NUMPAD8 :: 0x68;
VK_NUMPAD9 :: 0x69;
VK_MULTIPLY  :: 0x6A;
VK_ADD       :: 0x6B;
VK_SEPARATOR :: 0x6C;
VK_SUBTRACT  :: 0x6D;
VK_DECIMAL   :: 0x6E;
VK_DIVIDE    :: 0x6F;
VK_F1  :: 0x70;
VK_F2  :: 0x71;
VK_F3  :: 0x72;
VK_F4  :: 0x73;
VK_F5  :: 0x74;
VK_F6  :: 0x75;
VK_F7  :: 0x76;
VK_F8  :: 0x77;
VK_F9  :: 0x78;
VK_F10 :: 0x79;
VK_F11 :: 0x7A;
VK_F12 :: 0x7B;
VK_F13 :: 0x7C;
VK_F14 :: 0x7D;
VK_F15 :: 0x7E;
VK_F16 :: 0x7F;
VK_F17 :: 0x80;
VK_F18 :: 0x81;
VK_F19 :: 0x82;
VK_F20 :: 0x83;
VK_F21 :: 0x84;
VK_F22 :: 0x85;
VK_F23 :: 0x86;
VK_F24 :: 0x87;
VK_NUMLOCK :: 0x90;
VK_SCROLL :: 0x91;
VK_LSHIFT   :: 0xA0;
VK_RSHIFT   :: 0xA1;
VK_LCONTROL :: 0xA2;
VK_RCONTROL :: 0xA3;
VK_LMENU    :: 0xA4;
VK_RMENU    :: 0xA5;
VK_BROWSER_BACK      :: 0xA6;
VK_BROWSER_FORWARD   :: 0xA7;
VK_BROWSER_REFRESH   :: 0xA8;
VK_BROWSER_STOP      :: 0xA9;
VK_BROWSER_SEARCH    :: 0xAA;
VK_BROWSER_FAVORITES :: 0xAB;
VK_BROWSER_HOME      :: 0xAC;
VK_VOLUME_MUTE :: 0xAD;
VK_VOLUME_DOWN :: 0xAE;
VK_VOLUME_UP   :: 0xAF;
VK_MEDIA_NEXT_TRACK :: 0xB0;
VK_MEDIA_PREV_TRACK :: 0xB1;
VK_MEDIA_STOP       :: 0xB2;
VK_MEDIA_PLAY_PAUSE :: 0xB3;
VK_LAUNCH_MAIL         :: 0xB4;
VK_LAUNCH_MEDIA_SELECT :: 0xB5;
VK_LAUNCH_APP1         :: 0xB6;
VK_LAUNCH_APP2         :: 0xB7;
VK_OEM_1 :: 0xBA;
VK_OEM_PLUS :: 0xBB;
VK_OEM_COMMA :: 0xBC;
VK_OEM_MINUS :: 0xBD;
VK_OEM_PERIOD :: 0xBE;
VK_OEM_2 :: 0xBF;
VK_OEM_3 :: 0xC0;
VK_OEM_4 :: 0xDB;
VK_OEM_5 :: 0xDC;
VK_OEM_6 :: 0xDD;
VK_OEM_7 :: 0xDE;
VK_OEM_8 :: 0xDF;
VK_OEM_102 :: 0xE2;
VK_PROCESSKEY :: 0xE5;
VK_PACKET :: 0xE7;
VK_ATTN :: 0xF6;
VK_CRSEL :: 0xF7;
VK_EXSEL :: 0xF8;
VK_EREOF :: 0xF9;
VK_PLAY :: 0xFA;
VK_ZOOM :: 0xFB;
VK_NONAME :: 0xFC;
VK_PA1 :: 0xFD;
VK_OEM_CLEAR :: 0xFE;

RAWINPUTDEVICE :: struct
{
	usUsagePage : USHORT;
	usUsage : USHORT;
	dwFlags : DWORD;
	hwndTarget : HWND;
}

RIDEV_REMOVE       :: 0x00000001;
RIDEV_EXCLUDE      :: 0x00000010;
RIDEV_PAGEONLY     :: 0x00000020;
RIDEV_NOLEGACY     :: 0x00000030;
RIDEV_INPUTSINK    :: 0x00000100;
RIDEV_CAPTUREMOUSE :: 0x00000200;
RIDEV_NOHOTKEYS    :: 0x00000200;
RIDEV_APPKEYS      :: 0x00000400;
RIDEV_EXINPUTSINK  :: 0x00001000;
RIDEV_DEVNOTIFY    :: 0x00002000;

RegisterRawInputDevices :: (pRawInputDevices : *RAWINPUTDEVICE, uiNumDevices : UINT, cbSize : UINT) -> BOOL #foreign user32;

RAWINPUT :: struct
{
	header : RAWINPUTHEADER;
	data : union
	{
		mouse : RAWMOUSE;
		keyboard : RAWKEYBOARD;
		hid : RAWHID;
	};
}

HRAWINPUT :: HANDLE;

RAWINPUTHEADER :: struct
{
	dwType : DWORD;
	dwSize : DWORD;
	hDevice : HANDLE;
	wParam : WPARAM;
}

RIM_TYPEMOUSE    :: 0;
RIM_TYPEKEYBOARD :: 1;
RIM_TYPEHID      :: 2;

RAWMOUSE :: struct
{
	usFlags : USHORT;
	union
	{
		ulButtons : ULONG;
		struct
		{
			usButtonFlags : USHORT;
			usButtonData  : USHORT;
		};
	};
	ulRawButtons : ULONG;
	lLastX : LONG;
	lLastY : LONG;
	ulExtraInformation : ULONG;
}

MOUSE_MOVE_RELATIVE      :: 0x00;
MOUSE_MOVE_ABSOLUTE      :: 0x01;
MOUSE_VIRTUAL_DESKTOP    :: 0x02;
MOUSE_ATTRIBUTES_CHANGED :: 0x04;
MOUSE_MOVE_NOCOALESCE    :: 0x08;

RI_MOUSE_BUTTON_1_DOWN      :: 0x0001;
RI_MOUSE_LEFT_BUTTON_DOWN   :: RI_MOUSE_BUTTON_1_DOWN;
RI_MOUSE_BUTTON_1_UP        :: 0x0002;
RI_MOUSE_LEFT_BUTTON_UP     :: RI_MOUSE_BUTTON_1_UP;
RI_MOUSE_BUTTON_2_DOWN      :: 0x0004;
RI_MOUSE_RIGHT_BUTTON_DOWN  :: RI_MOUSE_BUTTON_2_DOWN;
RI_MOUSE_BUTTON_2_UP        :: 0x0008;
RI_MOUSE_RIGHT_BUTTON_UP    :: RI_MOUSE_BUTTON_2_UP;
RI_MOUSE_BUTTON_3_DOWN      :: 0x0010;
RI_MOUSE_MIDDLE_BUTTON_DOWN :: RI_MOUSE_BUTTON_3_DOWN;
RI_MOUSE_BUTTON_3_UP        :: 0x0020;
RI_MOUSE_MIDDLE_BUTTON_UP   :: RI_MOUSE_BUTTON_3_UP;
RI_MOUSE_BUTTON_4_DOWN      :: 0x0040;
RI_MOUSE_BUTTON_4_UP        :: 0x0080;
RI_MOUSE_BUTTON_5_DOWN      :: 0x0100;
RI_MOUSE_BUTTON_5_UP        :: 0x0200;
RI_MOUSE_WHEEL              :: 0x0400;
RI_MOUSE_HWHEEL             :: 0x0800;

RAWKEYBOARD :: struct
{
	MakeCode : USHORT;
	Flags : USHORT;
	Reserved : USHORT;
	VKey : USHORT;
	Message : UINT;
	ExtraInformation : ULONG;
}

RI_KEY_MAKE  :: 0;
RI_KEY_BREAK :: 1;
RI_KEY_E0    :: 2;
RI_KEY_E1    :: 4;

RAWHID :: struct
{
	dwSizeHid : DWORD;
	dwCount   : DWORD;
	bRawData  : [1]BYTE;
}

GetRawInputData :: (hRawInput : HRAWINPUT, uiCommand : UINT, pData : *VOID, pcbSize : *UINT, cbSizeHeader : UINT) -> UINT #foreign user32;

RID_HEADER :: 0x10000005;
RID_INPUT  :: 0x10000003;

#scope_file

user32 :: #foreign_system_library "user32";
gdi32  :: #foreign_system_library "gdi32";
