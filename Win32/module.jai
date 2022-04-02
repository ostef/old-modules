#module_parameters (UNICODE := true);

#assert OS == .WINDOWS "The Win32 module should only be loaded on Windows!";

#load "kernel32.jai";
#load "shlwapi.jai";
#load "user32.jai";
#load "error.jai";

#scope_file

error_wide_buffer : [128]u16;
error_utf8_buffer : [512]u8;

#scope_export

get_last_error_string :: inline () -> string #must
{
	return get_error_string (GetLastError ());
}

get_error_string :: inline (error_code : DWORD) -> string #must
{
	wide_count := FormatMessageW (
		FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
		null,
		error_code,
		MAKELANGID (LANG_NEUTRAL, SUBLANG_DEFAULT),
		error_wide_buffer.data,
		error_wide_buffer.count,
		null
	);
	utf8_count := WideCharToMultiByte (
		CP_UTF8,
		0,
		error_wide_buffer.data,
		cast (INT) wide_count,
		cast (*CHAR) error_utf8_buffer.data,
		error_utf8_buffer.count,
		null,
		null
	);
	result : string = ---;
	result.data  = error_utf8_buffer.data;
	result.count = utf8_count;

	return result;
}

wide_to_utf8 :: (data : *u16, allocator : Allocator) -> string #must, success : bool
{
	result_length := WideCharToMultiByte (CP_UTF8, 0, data, -1, null, 0, null, null);
	if result_length <= 0
		return "", false;
	utf8_data := cast (*u8) allocator.proc (.ALLOCATE, result_length, 0, null, allocator.data);
	written := WideCharToMultiByte (CP_UTF8, 0, data, -1, cast (*s8) utf8_data, result_length, null, null);
	if written > 0
	{
		str : string = ---;
		str.data  = utf8_data;
		str.count = written - 1;

		return str, true;
	}

	return "", false;
}

utf8_to_wide :: (utf8_str : string, allocator : Allocator) -> wide_str : *u16 #must, length : s32
{
	if !utf8_str
	{
		wide_str := cast (*u16) allocator.proc (.ALLOCATE, size_of (u16), 0, null, allocator.data);
		wide_str[0] = 0;

		return wide_str, 0;
	}
	result_length := MultiByteToWideChar (CP_UTF8, 0, cast (*s8) utf8_str.data, cast (s32) utf8_str.count, null, 0);
	if result_length <= 0
		return null, 0;
	wide_str := cast (*u16) allocator.proc (.ALLOCATE, (result_length + 1) * size_of (u16), 0, null, allocator.data);
	written := MultiByteToWideChar (CP_UTF8, 0, cast (*s8) utf8_str.data, cast (s32) utf8_str.count, wide_str, result_length);
	if written > 0
	{
		wide_str[written] = 0;

		return wide_str, written;
	}

	return null, 0;
}

// https://docs.microsoft.com/en-us/windows/win32/winprog/windows-data-types

MAX_PATH :: 260;

VOID :: void;

ATOM    :: WORD;
BYTE    :: u8;
BOOL    :: s32;
BOOLEAN :: BYTE;
FLOAT   :: float;

CHAR  :: s8;
UCHAR :: u8;
WCHAR :: u16;
#if UNICODE then TCHAR :: WCHAR;
else             TCHAR :: CHAR;

HALF_PTR  :: s32;	// 4 bytes if Win64, else 2 bytes. Jai only supports x64 anyways (at least for now)
UHALF_PTR :: u32;	// See above.

WORD  :: u16;
DWORD :: u32;
QWORD :: u64;

DWORDLONG :: u64;
DWORD32   :: u32;
DWORD64   :: u64;
DWORD_PTR :: ULONG_PTR;

SHORT  :: s16;
USHORT :: u16;

INT     :: s32;
INT8    :: s8;
INT16   :: s16;
INT32   :: s32;
INT64   :: s64;
INT_PTR :: s64;		// 8 bytes if Win64, else 4 bytes. Jai only supports x64 anyways (at least for now)

UINT     :: u32;
UINT8    :: u8;
UINT16   :: u16;
UINT32   :: u32;
UINT64   :: u64;
UINT_PTR :: u64;	// See above.

LONG     :: s32;
LONGLONG :: s64;
LONG32   :: s32;
LONG64   :: s64;
LONG_PTR :: s64;	// 8 bytes if Win64, else 4 bytes. Jai only supports x64 anyways (at least for now)

ULONG     :: u32;
ULONGLONG :: u64;
ULONG32   :: u32;
ULONG64   :: u64;
ULONG_PTR :: u64;	// See above.

SIZE_T  :: ULONG_PTR;
SSIZE_T :: LONG_PTR;

LPARAM :: LONG_PTR;
WPARAM :: UINT_PTR;
LRESULT :: LONG_PTR;

UNICODE_STRING :: struct
{
	Length        : USHORT;
	MaximumLength : USHORT;
	Buffer        : *WCHAR;
}

LANGID   :: WORD;
LCID     :: DWORD;
LCTYPE   :: DWORD;
LGRPID   :: DWORD;
COLORREF :: DWORD;
USN      :: LONGLONG;

LARGE_INTEGER :: union
{
	struct
	{
		LowPart  : DWORD;
		HighPart : LONG;
	};
	
	QuadPart : LONGLONG;
}

POINT :: struct
{
	x, y : LONG;
}

RECT :: struct
{
	left, top, right, bottom : LONG;
}

INVALID_HANDLE_VALUE :: cast (HANDLE) -1;

SYSTEMTIME :: struct
{
	wYear         : u16;
	wMonth        : u16;
	wDayOfWeek    : u16;
	wDay          : u16;
	wHour         : u16;
	wMinute       : u16;
	wSecond       : u16;
	wMilliseconds : u16;
}

FILETIME :: struct
{
	dwLowDateTime  : u32;
	dwHighDateTime : u32;

	#place dwLowDateTime;
	QuadPart : u64 = --- #align 4;
}

TIME_ZONE_INFORMATION :: struct
{
	Bias : LONG;
	StandardName : [32]WCHAR;
	StandardDate : SYSTEMTIME;
	StandardBias : LONG;
	DaylightName : [32]WCHAR;
	DaylightDate : SYSTEMTIME;
	DaylightBias : LONG;
}

// Handle types
HANDLE       :: *VOID;
HACCEL       :: HANDLE;
HBITMAP      :: HANDLE;
HBRUSH       :: HANDLE;
HCOLORSPACE  :: HANDLE;
HCONV        :: HANDLE;
HCONVLIST    :: HANDLE;
HCURSOR      :: HICON;
HDC          :: HANDLE;
HDDEDATA     :: HANDLE;
HDESK        :: HANDLE;
HDROP        :: HANDLE;
HDWP         :: HANDLE;
HENHMETAFILE :: HANDLE;
HFILE        :: INT;
HFONT        :: HANDLE;
HGDIOBJ      :: HANDLE;
HGLOBAL      :: HANDLE;
HHOOK        :: HANDLE;
HICON        :: HANDLE;
HINSTANCE    :: HANDLE;
HKEY         :: HANDLE;
HKL          :: HANDLE;
HLOCAL       :: HANDLE;
HMENU        :: HANDLE;
HMETAFILE    :: HANDLE;
HMODULE      :: HINSTANCE;
HMONITOR     :: HANDLE;		// In WinDef.h this is only defined if WINVER >= 0x0500
HPALETTE     :: HANDLE;
HPEN         :: HANDLE;
HRESULT      :: LONG;
HRGN         :: HANDLE;
HRSRC        :: HANDLE;
HSZ          :: HANDLE;
HWINSTA      :: HANDLE;
HWND         :: HANDLE;
SC_HANDLE    :: HANDLE;
SC_LOCK      :: *VOID;
SERVICE_STATUS_HANDLE :: HANDLE;
