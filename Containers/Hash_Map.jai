#scope_module

#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
hash :: #import "Hash";

#scope_export

// Hash_Map implementation, copied from jai/modules/Hash_Table.
// This uses linear probing for resolving hash collisions, meaning
// when we have a collision we iterate over the next slots until we
// find an emtpy one. This method of resolving hash collisions is
// quite sensitive to the quality of the hash functions. We do however
// search different paths for different hashes, like the hash table
// in jai/modules.
// Contrary to the original implementation, this map cannot have
// more than one entry with a given key.
// Functions:
//	- clear: Remove all the entries in the map, but keep any allocated
// memory.
//	- reset: Clear the map and free the allocated memory, resetting
// it to a valid state.
//	- grow: Grow the map by a factor of 2.
//	- insert: There are two versions of this one. The first inserts
// an element with a given key, and returns a pointer to it. If the entry
// is not new, it is returned as is.
// The second one inserts a key-value pair and assigns the given value in any case
// entry is added.
//	- remove_at: Remove a key-value pair.
//	- set: Set the value of the entry with the given key, if the
// key-value pair exists.
//	- get: Get the value mapped to the given key, or a fallback
// value if it does not exist.
//	- get_ptr: Get the pointer to the value mapped to the given
// key, or null if it does not exist.

Hash_Map :: struct (
	Key : Type,
	Val : Type,
	hash_func : (Key) -> u32 = null,
	comp_func : (Key, Key) -> bool = null,
	LOAD_FACTOR := 70
)
{
	#assert LOAD_FACTOR > 0 && LOAD_FACTOR < 100;

	Entry :: struct
	{
		hash  : u32;
		key   : Key;
		value : Val;
	}

	count     : s64;
	allocated : s64;
	occupied  : s64;
	entries   : []Entry;
	allocator : Allocator;

#if hash_func
	hash_key :: hash_func;
else
	hash_key :: (key) => hash.default (key);

#if comp_func
	compare_keys :: comp_func;
else
	compare_keys :: (left, right) => left == right;
}

MIN_CAPACITY        :: 32;
NEVER_OCCUPIED_HASH :: 0;
REMOVED_HASH        :: 1;
FIRST_OCCUPIED_HASH :: 2;

init :: inline (map : *Hash_Map, capacity : s64, allocator := context.allocator)
{
	capacity = math.max (capacity, MIN_CAPACITY);
	capacity = math.next_power_of_two (capacity);

	map.count = 0;
	map.occupied = 0;
	map.allocated = capacity;
	map.allocator = allocator;
	map.entries = mem.alloc (map.Entry, capacity, allocator);
	for * map.entries
		it.hash = NEVER_OCCUPIED_HASH;
}

reset :: inline (using map : *Hash_Map)
{
	mem.free (entries.data, allocator);
	entries.data = null;
	entries.count = 0;
	count = 0;
	occupied = 0;
	allocated = 0;
}

clear :: inline (using map : *Hash_Map)
{
	count = 0;
	occupied = 0;
	for * entries
		it.hash = NEVER_OCCUPIED_HASH;
}

grow :: inline (map : *Hash_Map)
{
	old_entries := map.entries;
	defer mem.free (old_entries, map.allocator);
	new_capacity := math.max (map.allocated * 2, MIN_CAPACITY);
	map.entries = mem.alloc (map.Entry, new_capacity, map.allocator);
	map.count = 0;
	map.occupied = 0;
	map.allocated = new_capacity;
	for entry : old_entries
		if entry.hash >= FIRST_OCCUPIED_HASH
			insert (map, entry.key, entry.value);
}

probe :: inline (map : Hash_Map, key : map.Key) -> h : u32, index : s64, is_present : bool
{
	mask := cast, trunc (u32) (map.allocated - 1);
	h := map.hash_key (key);
	if h < FIRST_OCCUPIED_HASH then h += FIRST_OCCUPIED_HASH;
	index := h & mask;
	// @Note (stefan): See initial_probe_increment in jai/modules/Hash_Table.jai
	increment := 1 + (h >> 27);
	while map.entries[index].hash
	{
		entry := *map.entries[index];
		if entry.hash == h && map.compare_keys (entry.key, key)
			return h, index, true;
		index += increment;
		index &= mask;
		increment += 1;
	}

	return h, index, false;
}

// If the entry is already present, it not modified and returned as-is
insert :: (map : *Hash_Map, key : map.Key, $initialize_if_new := true) -> *map.Val #must, is_present : bool
{
	if (map.occupied + 1) * 100 >= map.allocated * map.LOAD_FACTOR
		grow (map);
	assert (map.occupied <= map.allocated);
	h, index, is_present := probe (map, key);
	entry := *map.entries[index];
	if is_present
		return *entry.value, true;
	#if initialize_if_new then mem.init (*entry.value);
	entry.hash = h;
	entry.key  = key;
	map.occupied += 1;
	map.count    += 1;

	return *entry.value, false;
}

insert :: inline (map : *Hash_Map, key : map.Key, value : map.Val) -> *map.Val, is_present : bool
{
	ptr, is_present := insert (map, key);
	<<ptr = value;
	return ptr, is_present;
}

remove_at :: (map : *Hash_Map, key : map.Key) -> found : bool, removed : map.Val
{
	h, index, is_present := probe (map, key);
	if !is_present
		return false, default (map.Val);
	entry := *map.entries[index];
	entry.hash = REMOVED_HASH;
	map.count -= 1;

	return true, entry.value;
}

set :: inline (map : *Hash_Map, key : map.Key, value : map.Val)
{
	ptr := get_ptr (map, key);
	if ptr then <<ptr = value;
}

get_ptr :: (map : Hash_Map, key : map.Key) -> *map.Val #must
{
	if map.count == 0 then return null;
	h, index, is_present := probe (map, key);
	if is_present
		return *map.entries[index].value;
	return null;
}

get :: inline (map : Hash_Map, key : map.Key, fallback : map.Val) -> map.Val #must, found : bool
{
	ptr := get_ptr (map, key);
	if ptr then return <<ptr, true;
	return fallback, false;
}

get :: inline (map : Hash_Map, key : map.Key) -> map.Val #must, found : bool
{
	ptr := get_ptr (map, key);
	if ptr then return <<ptr, true;
	return default (map.Val), false;
}

for_expansion :: (map : *Hash_Map, body : Code, flags : For_Flags) #expand
{
	BY_POINTER :: (flags & .POINTER) == .POINTER;
	REVERSE    :: (flags & .REVERSE) == .REVERSE;

	for * <=REVERSE entry, i : map.entries
	{
		if entry.hash < FIRST_OCCUPIED_HASH then continue;

		`it_index := entry.key;
		#if BY_POINTER
			`it := *entry.value;
		else
			`it := entry.value;
		#insert (remove = { entry.hash = REMOVED_HASH; map.count -= 1; }) body;
	}
}
