utf8 :: #import "Unicode/UTF8";
for_expansion :: utf8.for_expansion;

main :: ()
{
	s := utf8.make_str ("Hello Sailor!");
	codepoints := utf8.decode (s, context.allocator);
	for s
	{
	}
}
