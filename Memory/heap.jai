HEAP_ALLOC :: Allocator.{ heap_allocator_proc, null };

heap_allocator_proc :: (mode : Allocator_Mode, size : s64, old_size : s64, old_ptr : *void, allocator_data : *void) -> *void
{
	if #complete mode ==
	{
	case .ALLOCATE;
		return heap_alloc (size);
	case .RESIZE;
		return heap_realloc (old_ptr, size);
	case .FREE;
		heap_free (old_ptr);
	}
	return null;
}
