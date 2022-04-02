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
	win32.QueryPerformanceCounter (*pc);
	win32.QueryPerformanceFrequency (*freq);
	a : Apollo_Time;
	a.low = cast, no_check (u64) pc;
	a *= FEMTOSECONDS;
	a /= freq;

	return a;
}

to_apollo :: inline (ft : win32.FILETIME) -> Apollo_Time #must
{
	// FILETIMEs are unsigned; let's not be hacky and try to treat them as signed,
	// because that matters at the edges of the range?

	// We can't use ConvertToApollo because it assumes signed, but we are taking
	// unsigned deltas. So we do our own #asm and use mul instead.

	// @Cleanup @Simplify: You know what, we could do this a different way, by just
	// adding the Apollo offset of Jan 1 1601, and it would just be 4 lines
	// like timespec_to_apollo is. Better, but, maybe slower unless we do good optimization
	// on operator +, etc??
	
	delta: u64;
	if ft.QuadPart >= FILETIME_APOLLO.QuadPart {
		delta = ft.QuadPart - FILETIME_APOLLO.QuadPart;
	} else {
		delta = FILETIME_APOLLO.QuadPart - ft.QuadPart;
	}

	apollo: Apollo_Time = ---;
	p := *apollo;

	#asm {
		result_high: gpr === d;
		result_low:  gpr === a;

		mov result_low, FILETIME_FACTOR;
		
		mul result_high, result_low, delta;
		
		mov [p + 0], result_low;
		mov [p + 8], result_high;
	}

	if ft.QuadPart < FILETIME_APOLLO.QuadPart {
		// Because we took delta in the opposite direction, negate the result.
		apollo = -apollo;
	}

	return apollo;
}

to_filetime :: inline (a : Apollo_Time) -> win32.FILETIME, bool
{
	result, ok := from_apollo (a, FILETIME_FACTOR);

	result1 := cast(u64) result;
	result += xx FILETIME_APOLLO.QuadPart;

	// @Incomplete: Check for overflow results due to the FILETIME_APOLLO add?
	
	ft: win32.FILETIME = ---;
	ft.QuadPart = cast(u64) result;
	return ft, ok;
}

to_calendar :: (at : Apollo_Time, time_zone := Time_Zone.UTC) -> Calendar_Time #must
{
	// :OSSpecific
	// @Incomplete: We would like to do this via our own code
	// that is cross-platform and guaranteed to be the same everywhere,
	// etc, but for now we are falling back
	// on OS-specific routines in order to get things going.
	// Since our own routine probably will not have failure modes (?), we are not for now
	// trying to detect and return failure.
	
	ft, success := to_filetime (at);
	if !success
		log.error ("Input Apollo_Time was out of range.");

	if time_zone == .LOCAL {
		ft_local: win32.FILETIME;
		success := win32.FileTimeToLocalFileTime (*ft, *ft_local);
		assert (success != 0);
		if success ft = ft_local;
	}
	
	st: win32.SYSTEMTIME;
	st_success := win32.FileTimeToSystemTime (*ft, *st);
	assert(st_success != 0);  // Under what conditions does this fail?  @Incomplete @Robustness.

	ct: Calendar_Time;
	ct.year = st.wYear;
	ct.month_starting_at_0 = cast, trunc (s8) math.max (0, st.wMonth - 1);  // @Temporary: Guarding against fails and getting a 0 back for st.wMonth then returning a negative number.
	ct.day_of_month_starting_at_0 = cast, trunc(s8) math.max (0, st.wDay-1);  // @Temporary
	ct.day_of_week_starting_at_0 = cast,trunc(s8) st.wDayOfWeek;
	ct.hour   = cast,trunc(s8) st.wHour;
	ct.minute = cast,trunc(s8) st.wMinute;
	ct.second = cast,trunc(s8) st.wSecond;
	ct.millisecond = cast,trunc(s16) st.wMilliseconds;

	ct.time_zone = time_zone;

	return ct;
}

to_apollo :: (ct : Calendar_Time) -> Apollo_Time #must
{
	// @Incomplete.  See :OSSpecific
	result: Apollo_Time = ---;

	st: win32.SYSTEMTIME;
	st.wYear      = xx,trunc ct.year;
	st.wMonth     = xx,trunc (ct.month\      _starting_at_0 + 1);
	st.wDay       = xx,trunc (ct.day_of_month_starting_at_0 + 1);
	st.wDayOfWeek = xx,trunc ct .day_of_week\_starting_at_0;
	st.wHour      = xx,trunc ct.hour;
	st.wMinute    = xx,trunc ct.minute;
	st.wSecond    = xx,trunc ct.second;
	st.wMilliseconds = xx,trunc ct.millisecond;
	
	ft: win32.FILETIME;
	success := win32.SystemTimeToFileTime(*st, *ft);
	assert(success != 0);  // @Temporary

	if ct.time_zone == .LOCAL {
		ft_local: win32.FILETIME;
		success := win32.LocalFileTimeToFileTime(*ft, *ft_local);
		if success ft = ft_local;
		assert(success != 0);
	}
	
	apollo := to_apollo(ft);
	return apollo;
}
