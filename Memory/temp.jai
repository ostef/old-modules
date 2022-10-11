TEMP_ALLOC :: Allocator.{ temporary_allocator_proc, null };

temporary_allocator_proc :: (mode : Allocator_Mode, size : s64, old_size : s64, old_ptr : *void, allocator_data : *void) -> *void
{
	storage : *Temporary_Storage = ---;
	if allocator_data
		storage = cast (*Temporary_Storage) allocator_data;
	else
		storage = context.temporary_storage;
	
	return inline arena.allocator_proc (mode, size, old_size, old_ptr, storage);
}

reset_temporary_storage :: inline (storage := context.temporary_storage)
{
	arena.reset (storage);
}

Temporary_Storage_State :: arena.State;

get_temporary_storage_state :: inline (storage := context.temporary_storage) -> Temporary_Storage_State #must
{
	return arena.get_state (storage);
}

set_temporary_storage_state :: inline (state : Temporary_Storage_State, storage := context.temporary_storage)
{
	arena.set_state (state, storage);
}

temporary_block :: (storage := context.temporary_storage) #expand
{
	state := get_temporary_storage_state (storage);
	`defer set_temporary_storage_state (state, storage);
}
