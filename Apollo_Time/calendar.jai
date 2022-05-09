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
	short_days = .[ "Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam" ],
	months = .[ "Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre" ],
	short_months = .[ "Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc" ]
};

FRENCH_ASCII_NAMES :: Calendar_Names.{
	days = .[ "Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi" ],
	short_days = .[ "Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam" ],
	months = .[ "Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre" ],
	short_months = .[ "Jan", "Fev", "Mar", "Avr", "Mai", "Jun", "Jul", "Aou", "Sep", "Oct", "Nov", "Dec" ]
};

// Usage:
// 		format (time, "{D} {d} {M} {Y}, {hr:02}:{mn:02} {AMPM}", allocator) => "Mon 10 Feb 2022, 10:04 AM"
// y : time.year % 100,
// yy : time.year,
// m : time.month + 1,
// M : names.short_months[time.month],
// MM : names.months[time.month],
// d : time.day_of_month + 1,
// D : names.short_days[time.day_of_week],
// DD : names.days[time.day_of_week],
// ampm : am/pm,
// AMPM : AM/PM,
// hr : time.hour as 12h clock,
// HR : time.hour as 24h clock,
// mn : time.minute,
// sc : time.second,
// ms : time.millisecond,
// tz : time.time_zone
format :: (time : Calendar_Time, fmt_str : string, allocator : Allocator, names := ENGLISH_NAMES) -> string #must
{
	fmt :: #import "Fmt";
	str :: #import "String";
	builder :: #import "String/Builder";

	FMT_STRINGS :: string.[ "y", "yy", "m", "M", "MM", "d", "D", "DD", "ampm", "AMPM", "hr", "HR", "mn", "sc", "ms", "tz" ];

	new_fmt_str : string;
	{
		state := mem.get_temporary_storage_state ();
		b : builder.Builder;
		builder.init (*b, mem.TEMP_ALLOC);
		i := 0;
		while i < fmt_str.count
		#no_abc
		{
			if fmt_str[i] == #char "{"
			{
				builder.append_byte (*b, fmt_str[i]);
				i += 1;
				s := str.advance (fmt_str, i);
				for FMT_STRINGS
				{
					if str.starts_with (s, it) && (s.count == it.count || s[it.count] == #char ":" || s[it.count] == #char "}")
					{
						builder.append_s64 (*b, it_index);
						i += it.count;
						break;
					}
				}
			}
			else
			{
				builder.append_byte (*b, fmt_str[i]);
				i += 1;
			}
		}
		mem.set_temporary_storage_state (state);
		new_fmt_str = builder.build (b, mem.TEMP_ALLOC);
	}

	return fmt.format (
		allocator,
		new_fmt_str,
		time.year % 100,
		time.year,
		time.month + 1,
		names.short_months[math.clamp (time.month, 0, 11)],
		names.months[math.clamp (time.month, 0, 11)],
		time.day_of_month + 1,
		names.short_days[math.clamp (time.day_of_week, 0, 6)],
		names.days[math.clamp (time.day_of_week, 0, 6)],
		ifx time.hour > 12 then "pm" else "am",
		ifx time.hour > 12 then "PM" else "AM",
		ifx time.hour > 12 then time.hour - 12 else time.hour,
		time.hour,
		time.minute,
		time.second,
		time.millisecond,
		time.time_zone
	);
}
