#import "Runtime";
mem     :: #import "Memory";
str     :: #import "String";
builder :: #import "String/Builder";
fmt     :: #import "Fmt";

main :: ()
{
	b : builder.Builder;
	builder.init (*b, mem.HEAP_ALLOC);
	builder.append_bool (*b, true);
	builder.append_newline (*b);
	builder.append_bool (*b, false);
	builder.append_newline (*b);
	builder.append (*b, "Hello Sailor! ");
	builder.append_fmt (*b, "There are % leaves in the pile!", 69105);
	s := builder.build_and_reset (*b, mem.HEAP_ALLOC);
	fmt.println (s);
}
