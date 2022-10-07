#import "Runtime";
mem :: #import "Memory";
str :: #import "String";
map :: #import "Containers/Hash_Map";
for_expansion :: map.for_expansion;

main :: ()
{
	ages : map.Hash_Map (string, int);
	map.init (*ages, 10);
	defer map.reset (*ages);
	ptr, was_present := map.insert (*ages, "Stéfan", 20);
	assert (!was_present);
	ptr, was_present = map.insert (*ages, "Hello Sailor", 10);
	assert (!was_present);
	ptr = map.get_ptr (*ages, "No bitches?");
	assert (ptr == null);
	for val, key : ages
	{
		if key == "Stéfan"
			assert (val == 20);
		else if key == "Hello Sailor"
			assert (val == 10);
		else
			panic ("Unexpected key %.", key);
	}
	ok, val := map.remove_at (*ages, "Stéfan");
	assert (ok);
	assert (val == 20);
	ptr, was_present = map.insert (*ages, "Hello Sailor", 69105);
	assert (was_present);
	for val, key : ages
	{
		if key == "Hello Sailor"
			assert (val == 69105);
		else
			panic ("Unexpected key %.", key);
	}
}
