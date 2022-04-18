#scope_file

win32 :: #import "Win32";

FILETIME_APOLLO :: win32.FILETIME.{ QuadPart = 0x19d_30e0_99a4_7380 };
FILETIME_FACTOR :: 100_000_000;

#scope_export

current_consensus :: inline () -> Apollo_Time #must
{
	now : win32.FILETIME;
	win32.GetSystemTimePreciseAsFileTime (*now);
	return to_apollo (now);
}

current_monotonic :: inline () -> Apollo_Time #must
{
	pc, freq : s64;
	ok := win32.QueryPerformanceCounter (*pc);
	assert (ok != 0);
	ok = win32.QueryPerformanceFrequency (*freq);
	assert (ok != 0 && freq != 0);
	a : Apollo_Time;
	a.low = cast, no_check (u64) pc;
	a *= FEMTOSECONDS;
	a /= freq;

	return a;
}

to_apollo :: inline (ft : win32.FILETIME) -> Apollo_Time #must
{	
	delta : u64;
	if ft.QuadPart >= FILETIME_APOLLO.QuadPart
		delta = ft.QuadPart - FILETIME_APOLLO.QuadPart;
	else
		delta = FILETIME_APOLLO.QuadPart - ft.QuadPart;
	apollo := make_s128 (FILETIME_FACTOR);
	apollo.as_u128 *= delta;
	// Because we took delta in the opposite direction, negate the result.
	if ft.QuadPart < FILETIME_APOLLO.QuadPart
		apollo = -apollo;

	return apollo;
}

to_filetime :: inline (a : Apollo_Time) -> win32.FILETIME
{
	result := a / FILETIME_FACTOR;
	result += make_s128 (cast (s64) FILETIME_APOLLO.QuadPart);
	ft : win32.FILETIME = ---;
	ft.QuadPart = cast (u64) to_s64 (result);

	return ft;
}

to_calendar :: (at : Apollo_Time, time_zone := Time_Zone.UTC) -> Calendar_Time #must
{
	ft := to_filetime (at);
	if time_zone == .LOCAL
	{
		ft_local : win32.FILETIME;
		success := win32.FileTimeToLocalFileTime (*ft, *ft_local);
		assert (success != 0);
		ft = ft_local;
	}

	st : win32.SYSTEMTIME;
	st_success := win32.FileTimeToSystemTime (*ft, *st);
	assert (st_success != 0);
	ct : Calendar_Time;
	ct.year = st.wYear;
	ct.month = cast, trunc (s8) math.max (0, st.wMonth - 1);
	ct.day_of_month = cast, trunc (s8) math.max (0, st.wDay - 1);
	ct.day_of_week = cast, trunc (s8) st.wDayOfWeek;
	ct.hour   = cast, trunc (s8) st.wHour;
	ct.minute = cast, trunc (s8) st.wMinute;
	ct.second = cast, trunc (s8) st.wSecond;
	ct.millisecond = cast, trunc (s16) st.wMilliseconds;
	ct.time_zone = time_zone;

	return ct;
}

to_apollo :: (ct : Calendar_Time) -> Apollo_Time #must
{
	st : win32.SYSTEMTIME;
	st.wYear      = xx, trunc ct.year;
	st.wMonth     = xx, trunc (ct.month + 1);
	st.wDay       = xx, trunc (ct.day_of_month + 1);
	st.wDayOfWeek = xx, trunc ct .day_of_week;
	st.wHour      = xx, trunc ct.hour;
	st.wMinute    = xx, trunc ct.minute;
	st.wSecond    = xx, trunc ct.second;
	st.wMilliseconds = xx, trunc ct.millisecond;

	ft : win32.FILETIME;
	success := win32.SystemTimeToFileTime (*st, *ft);
	assert(success != 0);
	if ct.time_zone == .LOCAL
	{
		ft_local : win32.FILETIME;
		success := win32.LocalFileTimeToFileTime (*ft, *ft_local);
		assert(success != 0);
		ft = ft_local;
	}

	return to_apollo (ft);
}
