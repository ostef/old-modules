Time_Zone :: enum s32
{
	LOCAL :: 0;
	UTC   :: 1;
}

Calendar_Time :: struct
{
	year : s32;
	month : s8;
	day_of_month : s8;
	day_of_week : s8;
	hour : s8;
	minute : s8;
	second : s8;
	millisecond : s16;
	time_zone : Time_Zone;

	#place month;
	month_starting_at_0 : s8;
	#place day_of_month;
	day_of_month_starting_at_0 : s8;
	#place day_of_week;
	day_of_week_starting_at_0 : s8;
}

Calendar_Names :: struct
{
	days : [7]string;
	short_days : [7]string;	// Usually three letter abbreviations
	months : [12]string;
	short_months : [12]string;	// Usually three letter abbreviations
}

ENGLISH_NAMES :: Calendar_Names.{
	days = .[ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ],
	short_days = .[ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" ],
	months = .[ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ],
	short_months = .[ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
};

FRENCH_NAMES :: Calendar_Names.{
	days = .[ "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" ],
	short_days = .[ "Dimanche", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam" ],
	months = .[ "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre" ],
	short_months = .[ "Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc" ]
};

FRENCH_ASCII_NAMES :: Calendar_Names.{
	days = .[ "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" ],
	short_days = .[ "Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam" ],
	months = .[ "Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre" ],
	short_months = .[ "Jan", "Fev", "Mar", "Avr", "Mai", "Jun", "Jul", "Aou", "Sep", "Oct", "Nov", "Dec" ]
};

// The arguments are passed to fmt.format in the following order:
//  0: time.year
//  1: time.month + 1
//  2: time.day_of_month + 1
//  3: time.hour
//  4: time.minute
//  5: time.second
//  6: time.millisecond
//  7: time.time_zone
//  8: names.months[time.month]
//  9: names.short_months[time.month]
// 10: names.days[time.day_of_week]
// 11: names.short_days[time.day_of_week]
format :: inline (time : Calendar_Time, fmt_str : string, allocator : Allocator, names := ENGLISH_NAMES) -> string #must
{
	fmt :: #import "Fmt";

	return fmt.format (
		allocator,
		fmt_str,
		time.year,
		time.month + 1,
		time.day_of_month + 1,
		time.hour,
		time.minute,
		time.second,
		time.millisecond,
		time.time_zone,
		names.months[math.clamp (time.month, 0, 11)],
		names.short_months[math.clamp (time.month, 0, 11)],
		names.days[math.clamp (time.day_of_week, 0, 6)],
		names.short_days[math.clamp (time.day_of_week, 0, 6)]
	);
}
