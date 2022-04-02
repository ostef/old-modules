// @Note (stefan): Memory allocated with heap functions is MEMORY_ALLOCATION_ALIGNMENT
// bytes aligned, which is defined to be 16 bytes in Win32/kernel32.jai.

heap_alloc :: inline (size : s64) -> *void #must
{
	heap := win32.GetProcessHeap ();
	assert (heap != null, "GetProcessHeap returned null: %", win32.get_last_error_string ());
	return win32.HeapAlloc (heap, 0, xx size);
}

heap_realloc :: inline (ptr : *void, new_size : s64) -> *void #must
{
	heap := win32.GetProcessHeap ();
	assert (heap != null, "GetProcessHeap returned null: %", win32.get_last_error_string ());
	return win32.HeapReAlloc (heap, 0, ptr, xx new_size);
}

heap_free :: inline (ptr : *void)
{
	heap := win32.GetProcessHeap ();
	assert (heap != null, "GetProcessHeap returned null: %", win32.get_last_error_string ());
	win32.HeapFree (heap, 0, xx ptr);
}
