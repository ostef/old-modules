#import "Runtime";
mem :: #import "Memory";
fmt :: #import "Fmt";
str :: #import "String";
storage :: #import "Containers/Storage";
for_expansion :: storage.for_expansion;

main :: ()
{
	// We want a small page size so we can test adding and removing pages
	container : storage.Storage (string, 2);
	storage.init (*container);
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
	for container
	{
		if it == "Sailor"
			remove it;
	}
	assert (container.count == 2);
	for container
		assert (it == "Hello" || it == "!");
}
