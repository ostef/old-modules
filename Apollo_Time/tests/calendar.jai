#import "Runtime";
time :: #import "Apollo_Time";
strbuild :: #import "String/Builder";

main :: ()
{
	my_birth_day : time.Calendar_Time;
	{
		using my_birth_day;
		
		year = 2002;
		month = 2;
		day_of_month = 27;
		day_of_week = 4;
		hour = 10;
		minute = 32;
		second = 2;
		time_zone = .LOCAL;
	}

	my_birth_day = time.to_calendar (time.to_apollo (my_birth_day), my_birth_day.time_zone);

	{
		using my_birth_day;
		
		assert (year == 2002, "Expected 2002, got %", year);
		assert (month == 2, "Expected 2, got %", month);
		assert (day_of_month == 27, "Expected 27, got %", day_of_month);
		assert (day_of_week == 4, "Expected 4, got %", day_of_week);
		assert (hour == 10, "Expected 10, got %", hour);
		assert (minute == 32, "Expected 32, got %", minute);
		assert (second == 2, "Expected 2, got %", second);
		assert (time_zone == .LOCAL, "Expected LOCAL, got %", time_zone);
	}

	builder : strbuild.Builder;
	strbuild.init (*builder);
	
	time.format (*builder, my_birth_day, "Hello Sailor! My birth day is {DD} {d} {MM} {yy}, {HR:02}:{mn:02}:{sc:02} !");

	str := strbuild.build (builder);

	assert (str == "Hello Sailor! My birth day is Thursday 28 March 2002, 10:32:02 !", "Got '%'", str);

	str = time.format (my_birth_day, "Hello Sailor! My birth day is {DD} {d} {MM} {yy}, {HR:02}:{mn:02}:{sc:02} !");

	assert (str == "Hello Sailor! My birth day is Thursday 28 March 2002, 10:32:02 !", "Got '%'", str);
}
