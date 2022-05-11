#import "Runtime";
utf8 :: #import "Unicode/UTF8";
for_expansion :: utf8.for_expansion;

main :: ()
{
	s := utf8.make_str ("Hello Sailor!");
	assert (s.as_string == "Hello Sailor!");
	codepoints := utf8.decode (s, context.allocator);
	last_index := -1;
	for codepoint, i : utf8.make_str ("Hello Sailor!")
	{
		last_index = i;
	}
	assert (last_index == "Hello Sailor!".count - 1, "last_index was %", last_index);
}
