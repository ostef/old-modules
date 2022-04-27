#import "Runtime";
mem :: #import "Memory";
fmt :: #import "Fmt";
str :: #import "String";
storage :: #import "Containers/Storage";
for_expansion :: storage.for_expansion;

main :: ()
{
	container : storage.Storage (string, 10);
	storage.init (*container, mem.HEAP_ALLOC);
	val1, info1 := storage.find_free_slot (*container);
	fmt.println ("info1: {:!}", info1);
	assert (val1 != null);
	<<val1 = "Hello";
	val2, info2 := storage.find_free_slot (*container);
	fmt.println ("info2: {:!}", info2);
	assert (val2 != val1);
	<<val2 = "Sailor";
	val3, info3 := storage.find_free_slot (*container);
	fmt.println ("info3: {:!}", info3);
	assert (val3 != val2);
	assert (val3 != val1);
	<<val3 = "!";
	assert (container.count == 3);
	for container
		assert (it == "Hello" || it == "Sailor" || it == "!");
}
