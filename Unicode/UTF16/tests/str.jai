utf16 :: #import "Unicode/UTF16";
for_expansion :: utf16.for_expansion;

main :: ()
{
	s : utf16.Str;
	codepoints := utf16.decode (s, context.allocator);
	for s
	{
	}
}
