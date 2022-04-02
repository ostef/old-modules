HEAP_ALLOC :: Allocator.{ heap_allocator_proc, null };

heap_allocator_proc :: (mode : Allocator_Mode, size : s64, old_size : s64, old_ptr : *void, allocator_data : *void) -> *void
{
	if #complete mode ==
	{
	case .ALLOCATE;
		return os.heap_alloc (size);
	case .RESIZE;
		return os.heap_realloc (old_ptr, size);
	case .FREE;
		os.heap_free (old_ptr);
	}
	return null;
}
