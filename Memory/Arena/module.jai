#module_parameters (LOG_PAGE_ALLOCATIONS := false);

#scope_module

#import "Runtime";
log :: #import "Log";
mem :: #import "Memory";
math :: #import "Math";

#scope_export

// A memory arena allocator follows the pattern of bulk deallocations, very much like
// the temporary allocator (the temporary storage is actually a memory arena, which is
// why we make Memory_Arena an alias of Temporary_Storage). See the how_to about the
// temporary storage for why this allocation pattern is very useful and can be a substitute
// for traditional garbage collection. Though I would consider this a garbage collection
// mecanism, that `assumes` the memory is not used anymore instead of making sure it
// is not used anymore through expensive design and algorithms. Also it is less expensive
// than heap allocations, so using the temporary storage is not even a tradeoff thing,
// it's just not usable for all cases.

Memory_Arena :: Temporary_Storage;

to_allocator :: inline (arena : *Memory_Arena) -> Allocator #must
{
	result : Allocator = ---;
	result.proc = allocator_proc;
	result.data = arena;

	return result;
}

// By default, disable overflow by giving overflow_allocator a default value of { null, null } 
init :: inline (arena : *Memory_Arena, size : s64, allocator : Allocator, overflow_allocator := Allocator.{ null, null })
{
	mem.init (arena);
	arena.data = mem.alloc (size, allocator);
	if !arena.data then return;
	arena.size = size;
	arena.overflow_allocator = overflow_allocator;
	arena.original_data = arena.data;
	arena.original_size = size;
}

reset :: inline (arena : *Memory_Arena, allocator := Allocator.{ null, null })
{
	if !arena then return;
	free_pages (arena);
	if allocator.proc != null
		mem.free (arena.data, allocator);
	arena.data = null;
	arena.original_data = null;;
	arena.size = 0;
	arena.original_size = 0;;
	arena.occupied = 0;
}

allocator_proc :: (mode : Allocator_Mode, size : s64, old_size : s64, old_ptr : *void, allocator_data : *void) -> *void
{
	ALIGNMENT :: 8;

	arena := cast (*Memory_Arena) allocator_data;
	assert (arena != null, "Memory arena is null.");
	if #complete mode ==
	{
	case .FREE;
		return null;

	case .RESIZE; #through;
	case .ALLOCATE;
		aligned_size := (size + ALIGNMENT - 1) & ~(ALIGNMENT - 1);
		if arena.occupied + aligned_size > arena.size
		{
			if !add_page (arena, aligned_size)
			{
				log.error ("Could not allocate new page for arena %.", arena);
				return null;
			}
		}
		result := arena.data + arena.occupied;
		arena.occupied += xx aligned_size;
		arena.high_water_mark = math.max (arena.high_water_mark, arena.occupied);
		if mode == .RESIZE
			mem.copy (result, old_ptr, math.min (old_size, size));

		return result;
	}

	return null;
}

State :: struct
{
	page : *Memory_Arena.Overflow_Page;
	occupied : s64;
}

get_state :: inline (arena : *Memory_Arena) -> State #must
{
	if !arena then return .{};
	state : State = ---;
	state.occupied = arena.occupied;
	state.page = arena.overflow_pages;

	return state;
}

set_state :: inline (state : State, arena : *Memory_Arena)
{
	if !arena then return;
	free_pages (arena, state.page);

	if state.page
	{
		arena.data = cast (*u8) state.page + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
		arena.size = state.page.size;
	}
	else
	{
		arena.data = arena.original_data;
		arena.size = arena.original_size;
	}
	arena.occupied = state.occupied;
}

#scope_file

ALIGNED_OVERFLOW_PAGE_ALLOCATION :: 32;

add_page :: inline (arena : *Memory_Arena, min_size : s64) -> bool
{
	data_size := arena.original_size - ALIGNED_OVERFLOW_PAGE_ALLOCATION;
	data_size = math.max (data_size, min_size);
	total_size := data_size + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
	#if LOG_PAGE_ALLOCATIONS
	{
		if arena == context.temporary_storage
			log.message ("Allocating new page of % bytes for temporary storage.", data_size);
		else
			log.message ("Allocating new page of % bytes for arena %.", data_size, arena);
	}
	assert (arena.overflow_allocator.proc != null, "Overflow allocator was null.");
	ptr := mem.alloc (total_size, arena.overflow_allocator);
	if !ptr
		return false;

	page := cast (*Memory_Arena.Overflow_Page) ptr;
	page.next = arena.overflow_pages;
	page.allocator = arena.overflow_allocator;
	page.size = data_size;

	arena.overflow_pages = page;
	arena.data = ptr + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
	arena.size = data_size;
	arena.occupied = 0;
	
	return true;
}

free_pages :: inline (arena : *Memory_Arena, page : *Memory_Arena.Overflow_Page = null)
{
	current := arena.overflow_pages;
	while current && current != page
	{
		next := current.next;
		mem.free (current, current.allocator);
		current = next;
	}
	arena.overflow_pages = current;
	if arena.overflow_pages
		arena.data = (cast (*void) arena.overflow_pages) + ALIGNED_OVERFLOW_PAGE_ALLOCATION;
	else
		arena.data = arena.original_data;
}
