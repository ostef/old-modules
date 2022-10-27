#module_parameters (LOG_PAGE_ALLOCATIONS := false);

#scope_module

#import "Runtime";
mem   :: #import "Memory";
math  :: #import "Math";
array :: #import "Containers/Array";
log   :: #import "Log";
list  :: #import "Containers/List";
for_expansion :: list.for_expansion;

#scope_export

Slot_Info :: struct
{
	version    : u32;
	page_index : s32;
	slot_index : s32;
}

// @Todo (stefan): Automatically calculate items_per_page based
// on cache line size and size of .
Storage :: struct (T : Type, items_per_page : s32)
{
	Slot :: struct
	{
		prev     : *~s32 Slot;
		next     : *~s32 Slot;
		occupied : bool;
		version  : u32;
	}

	Page :: struct
	{
		// @Note (stefan): I would like to use relative pointers
		// to use less memory, but Pages are allocated on the heap.
		prev  : *Page;
		next  : *Page;
		index : s32;
		count : s32;
		items : [items_per_page]T = ---;
		slots : [items_per_page]Slot;
		free_slots     : *Slot;
		occupied_slots : *Slot;
	}

	count : s64;
	all_pages  : [..]*Page;
	free_pages : *Page;
	full_pages : *Page;
	allocator : Allocator;
}

equals :: inline (a : Slot_Info, b : Slot_Info) -> bool #must
{
	return a.version == b.version && a.page_index == b.page_index && a.slot_index == b.slot_index;
}

operator == :: inline (a : Slot_Info, b : Slot_Info) -> bool #must
{
	return equals (a, b);
}

init :: inline (storage : *Storage, allocator := context.allocator)
{
	storage.count = 0;
	storage.free_pages = null;
	storage.full_pages = null;
	storage.allocator  = allocator;
	array.init (*storage.all_pages, 10, allocator);
}

reset :: inline (using storage : *Storage)
{
	for page : all_pages
		mem.free (page, allocator);

	array.reset (*all_pages);
	count = 0;
	free_pages = null;
	full_pages = null;
}

clear_page :: inline (using storage : *Storage, page : *storage.Page)
{
	for * slot, si : page.slots
	{
		slot.occupied = false;

		if si != 0
			slot.prev = *page.slots[si - 1];
		else
			slot.prev = null;

		if si != items_per_page - 1
			slot.next = *page.slots[si + 1];
		else
			slot.next = null;
	}

	page.count = 0;
	page.free_slots = *page.slots[0];
	page.occupied_slots = null;
}

find_free_slot :: (using storage : *Storage, $initialize := true) -> *storage.T #must, info : Slot_Info, is_new_page : bool
{
	is_new_page := false;

	page := free_pages;
	if !page
	{
		#if LOG_PAGE_ALLOCATIONS
			log.message ("Allocating new page for %.", type_of (<<storage));

		is_new_page = true;
		page = list.push_front (*free_pages, mem.alloc (Page));
		array.push (*all_pages, page);
		page.index = cast (s32) (all_pages.count - 1);
		clear_page (storage, page);
	}

	assert (page.count < items_per_page, "Page is full even though it is in the free pages list.");
	assert (page.free_slots != null, "Could not find free slot even though the page is in the free pages list.");

	slot := list.pop_front (*page.free_slots);
	assert (!slot.occupied, "Expected slot to be free but it was occupied.");
	list.push_front (*page.occupied_slots, slot);

	// If there are no more free slots, add the page to the full pages list
	if !page.free_slots
	{
		page = list.pop_front (*free_pages);
		list.push_front (*full_pages, page);
	}

	slot.occupied = true;
	slot.version += 1;
	page.count += 1;

	count += 1;
	info : Slot_Info;
	info.version = slot.version;
	info.page_index = page.index;
	info.slot_index = cast (s32) (slot - page.slots.data);
	item := *page.items[info.slot_index];

	#if initialize
		mem.init (item);

	return item, info, is_new_page;
}

insert :: (using storage : *Storage, item : storage.T) -> info : Slot_Info, *storage.T
{
	ptr, info := find_free_slot (storage, initialize = false);
	<<ptr = item;

	return info, ptr;
}

release_slot :: (using storage : *Storage, info : Slot_Info)
{
	page := all_pages[info.page_index];
	page_was_full := page.free_slots == null;
	assert (page.slots[info.slot_index].occupied, "Releasing unoccupied slot % in page %.", info.slot_index, info.page_index);
	
	slot := *page.slots[info.slot_index];
	slot.occupied = false;
	
	list.pop (*page.occupied_slots, slot);
	list.push_front (*page.free_slots, slot);
	page.count -= 1;
	
	// Add the page to the free pages list if it was full previously
	if page_was_full
	{
		if full_pages == page
			full_pages = page.next;
	
		if page.prev
			page.prev.next = page.next;
	
		if page.next
			page.next.prev = page.prev;
	
		page.prev = null;
		page.next = free_pages;
		free_pages = page;
	}
	
	count -= 1;
}

release_slot :: inline (using storage : *Storage, item : *storage.T) -> bool
{
	valid, info, occupied := get_Slot_Info;
	if !valid || !occupied
		return false;
	
	release_slot (storage, info);

	return true;
}

release_all :: (using storage : *Storage)
{
	if count == 0 || pages.count == 0
		return;
	
	for page, i : pages
	{
		if i != 0
			page.prev = pages[i - 1];
		else
			page.prev = null;
	
		if i != pages.count - 1
			page.next = pages[i + 1];
		else
			page.next = null;
	
		clear_page (storage, page);
	}
	
	free_pages = pages[0];
	full_pages = null;
}

get_slot_info :: (using storage : Storage, item : *storage.T) -> valid : bool, info : Slot_Info, occupied : bool
{
	info : Slot_Info;
	for page : all_pages
	{
		slot_index := array.get_index (page.items, item);
		if slot_index != -1
		{
			info.version = page.slots[slot_index].version;
			info.page_index = page.index;
			info.slot_index = cast (s32) slot_index;

			return true, info, page.slots[slot_index].occupied;
		}
	}

	return false, info, false;
}

is_valid :: inline (using storage : Storage, info : Slot_Info) -> bool
{
	if info.slot_index < 0 && info.slot_index >= items_per_page
		return false;
	
	if info.page_index < 0 || info.page_index >= all_pages.count
		return false;
	
	slot := *all_pages[info.page_index].slots[info.slot_index];
	if !slot.occupied || slot.version != info.version
		return false;
	
	return true;
}

get_item :: inline (using storage : Storage, info : Slot_Info) -> *storage.T #must
{
	assert (info.slot_index >= 0 && info.slot_index < items_per_page, "Invalid slot index.");
	assert (info.page_index >= 0 && info.page_index < all_pages.count, "Invalid page index.");
	slot := *all_pages[info.page_index].slots[info.slot_index];
	assert (slot.occupied, "Slot is not occupied.");
	assert (slot.version == info.version, "Slot has different version (requested %, got %).", info.version, slot.version);
	
	return *all_pages[info.page_index].items[info.slot_index];
}

operator [] :: inline (using storage : Storage, slot : Slot_Info) -> *storage.T #must
{
	return get_item (storage, slot);
}

for_expansion :: (storage : *Storage, body : Code, flags : For_Flags) #expand
{
	BY_POINTER :: (flags & .POINTER) == .POINTER;
	REVERSE    :: (flags & .REVERSE) == .REVERSE;

	#assert !REVERSE "Storage is an unordered data structure. Iterating in reverse does not make much sense.";
	`it_index : Slot_Info;
	
	for page, pi : storage.all_pages
	{
		for slot, _ : page.occupied_slots
		{
			it_index.version    = slot.version;
			it_index.page_index = cast (s32) pi;
			it_index.slot_index = cast (s32) (slot - page.slots.data);
	
			#if BY_POINTER
				`it := *page.items[it_index.slot_index];
			else
				`it := page.items[it_index.slot_index];
	
			#insert (
				break = break page,
				remove = release_slot (storage, it_index)
			) body;
		}
	}
}
