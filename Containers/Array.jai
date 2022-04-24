#scope_module

#import "Runtime";
mem :: #import "Memory";

#scope_export

make :: inline ($T : Type, capacity : s64, allocator : Allocator) -> [..]T #must
{
	result : [..]T;
	init (*result, capacity, allocator);
	return result;
}

make :: inline ($T : Type, allocator : Allocator, elems : ..Any) -> [..]T #must
{
	result : [..]T;
	init (*result, allocator, ..elems);
	return result;
}

init :: inline (arr : *[..]$T, capacity : s64, allocator : Allocator)
{
	assert (capacity >= 0);
	arr.data = mem.alloc (size_of (T) * capacity, allocator);
	arr.count = 0;
	arr.allocated = capacity;
	arr.allocator = allocator;
}

init :: inline (arr : *[..]$T, allocator : Allocator, elems : ..T)
{
	mem.init (arr, elems.count, allocator);
	for elems
		push (*reuslt, it);
}

reset :: inline (arr : *[..]$T)
{
	mem.free (arr.data, arr.allocator);
	arr.data = null;
	arr.count = 0;
	arr.allocated = 0;
}

clear :: inline (arr : *[..]$T)
{
	arr.count = 0;
}

grow :: inline (arr : *[..]$T, additional_capacity : s64)
{
	if additional_capacity <= 0
		return;
	new_capacity := arr.allocated + additional_capacity;
	new_data := mem.realloc (arr.data, size_of (T) * arr.allocated, size_of (T) * new_capacity, arr.allocator);
	arr.data = new_data;
	arr.allocated = new_capacity;
}

push :: inline (arr : *[..]$T, $initialize := true) -> *T #must
{
	if arr.count >= arr.allocated
		grow (arr, arr.allocated + 8);
	ptr := *arr.data[arr.count];
	#if initialize
		mem.init (ptr);
	arr.count += 1;

	return ptr;
}

push :: inline (arr : *[..]$T, elem : T) -> *T
{
	ptr := push (arr, initialize = false);
	<<ptr = elem;

	return ptr;
}

pop :: inline (arr : *[..]$T) -> T
{
	assert (arr.count > 0, "Array is empty.");
	arr.count -= 1;

	return arr.data[arr.count];
}

insert_at :: inline (arr : *[..]$T, at : s64, $initialize := true) -> *T #must
{
	assert (at >= 0 && at <= arr.count, "Index % is out of range [0, %].", at, arr.count);
	ptr := *arr.data[at];
	if at < arr.count
		push (arr, arr.data[at]);
	#if initialize
		mem.init (ptr);

	return ptr;
}

insert_at :: inline (arr : *[..]$T, at : s64, elem : T) -> *T
{
	ptr := insert_at (arr, at, initialize = false);
	<<ptr = elem;

	return ptr;
}

remove_at :: inline (arr : *[..]$T, at : s64) -> T
{
	assert (at >= 0 && at < arr.count, "Index % is out of range [0, %).", at, arr.count);
	result := arr.data[at];
	arr.data[at] = arr.data[arr.count - 1];
	arr.count -= 1;

	return result;
}

ordered_insert_at :: inline (arr : *[..]$T, at : s64, $initialize := true) -> *T #must
{
	assert (at >= 0 && at <= arr.count, "Index % is out of range [0, %].", at, arr.count);
	if arr.count == arr.allocated
		grow (arr, arr.allocated + 8);
	arr.count += 1;
	for < i : arr.count - 1..at + 1
		arr.data[i] = arr.data[i - 1];
	ptr := *arr.data[at];
	#if initialize
		mem.init (ptr);
	
	return ptr;
}

ordered_insert_at :: inline (arr : *[..]$T, at : s64, elem : T) -> *T
{
	ptr := ordered_insert_at (arr, at, initialize = false);
	<<ptr = elem;
	return ptr;
}

ordered_remove_at :: inline (arr : *[..]$T, at : s64) -> T
{
	assert (at >= 0 && at < arr.count, "Index % is out of range [0, %).", at, arr.count);
	removed := arr.data[at];
	for i : at..arr.count - 2
		arr.data[i] = arr.data[i + 1];
	arr.count -= 1;
	return at;
}

top :: inline (arr : []$T) -> T #must
{
	return arr[arr.count - 1];
}

find_first :: inline (arr : []$T, val : T) -> s64 #must
#no_context
#no_abc
{
	for i : 0..arr.count - 1
		if arr[i] == val
			return i;
	return -1;
}

find_last :: inline (arr : []$T, val : T) -> s64 #must
#no_context
#no_abc
{
	for < i : arr.count - 1..0
		if arr[i] == val
			return i;
	return -1;
}

get_index :: inline (arr : []$T, ptr : *T) -> s64 #must
#no_context
{
	contextless_assert (ptr > arr.data && ptr < arr.data + arr.count, "ptr does not point to an element in the array.");
	return ptr - arr.data;
}

equals :: inline (a : []$T, b : []T) -> bool #must
{
	if a.count != b.count
		return false;
	for i : 0..a.count - 1
		if a[i] != b[i]
			return false;
	return true;
}
