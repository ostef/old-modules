TRAP_ALLOC :: Allocator.{ trap_allocator_proc, null };

trap_allocator_proc :: (mode : Allocator_Mode, size : s64, old_size : s64, old_ptr : *void, allocator_data : *void) -> *void
{
	panic ("Allocation trap");
	return null;
}

alloc :: inline (size : s64, allocator := context.allocator) -> *void #must
{
	assert (allocator.proc != null, "Allocator is null.");
	if size <= 0
		return null;
	return allocator.proc (.ALLOCATE, size, 0, null, allocator.data);
}

alloc :: inline ($T : Type, count : s64, allocator := context.allocator, $initialize := false) -> []T #must
{
	assert (allocator.proc != null, "Allocator is null.");
	result : []T = ---;
	result.data = cast (*T) alloc (size_of (T) * count, allocator);
	if !result.data
		return .[];
	result.count = count;
	init (result);

	return result;
}

alloc :: inline ($T : Type, allocator := context.allocator, $initialize := true) -> *T #must
{
	assert (allocator.proc != null, "Allocator is null.");
	result := cast (*T) alloc (size_of (T), allocator);
	if !result
		return null;
	#if initialize
		init (result);

	return result;
}

realloc :: inline (ptr : *void, old_size : s64, new_size : s64, allocator := context.allocator) -> *void #must
{
	assert (allocator.proc != null, "Allocator is null.");
	if new_size == old_size
		return ptr;
	if new_size <= 0
		return free (ptr, allocator);
	if !ptr
		return alloc (new_size, allocator);
	return allocator.proc (.RESIZE, new_size, old_size, ptr, allocator.data);
}

free :: inline (ptr : *void, allocator := context.allocator) -> *void
{
	assert (allocator.proc != null, "Allocator is null.");
	if ptr
		allocator.proc (.FREE, 0, 0, ptr, allocator.data);
	return null;
}

free :: inline (str : string, allocator := context.allocator) -> string
{
	assert (allocator.proc != null, "Allocator is null.");
	free (str.data, allocator);
	return "";
}

free :: inline (array : []$T, allocator := context.allocator) -> []T
{
	assert (allocator.proc != null, "Allocator is null.");
	free (array.data, allocator);
	return .[];
}
