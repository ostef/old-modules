#import "Runtime";
mem :: #import "Memory";
fmt :: #import "Fmt";
str :: #import "String";
list :: #import "Containers/List";
for_expansion :: list.for_expansion;

Node :: struct
{
	val : string;
	prev : *Node;
	next : *Node;
}

main :: ()
{
	container : *Node;
	p1 := list.push_front (*container, mem.HEAP_ALLOC);
	p1.val = "Hello";
	p2 := list.push_front (*container, mem.HEAP_ALLOC);
	assert (p2 != p1);
	p2.val = "Sailor";
	p3 := list.push_front (*container, mem.HEAP_ALLOC);
	assert (p3 != p2);
	assert (p3 != p1);
	p3.val = "!";
	p3 = list.pop_front (*container);
	assert (container.val == "Sailor");
	assert (container.next.val == "Hello");
}
