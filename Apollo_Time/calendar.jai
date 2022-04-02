Time_Zone :: enum s32
{
	LOCAL :: 0;
	UTC   :: 1;
}

Calendar_Time :: struct
{
	year : s32;
	month_starting_at_0 : s8;
	day_of_month_starting_at_0 : s8;
	day_of_week_starting_at_0 : s8;
	hour : s8;
	minute : s8;
	second : s8;
	millisecond : s16;
	time_zone : Time_Zone;

	#place month_starting_at_0;
	month : s8;
	#place day_of_month_starting_at_0;
	day_of_month : s8;
	#place day_of_week_starting_at_0;
	day_of_week: s8;
}

to_string :: inline (time : Calendar_Time, allocator : Allocator) -> string #must
{
	fmt :: #import "Fmt";

	MONTH_NAMES :: string.[ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];

	return fmt.format (
		allocator,
		"% % %, {:02}:{:02}:{:02}",
		time.day_of_month + 1,
		MONTH_NAMES[math.clamp (time.month, 0, 11)],
		time.year,
		time.hour,
		time.minute,
		time.second
	);
}
