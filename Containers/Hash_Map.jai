#scope_module

#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
hash :: #import "Hash";

#scope_export

Hash_Map :: struct (
	TKey : Type,
	TVal : Type,
	hash_func : (TKey) -> u32 = null,
	comp_func : (TKey, TKey) -> bool = null,
	EXPAND_LIMIT := 70
)
{
	Entry :: struct
	{
		hash  : u32;
		key   : TKey;
		value : TVal;
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

	MIN_CAPACITY        :: 32;
	NEVER_OCCUPIED_HASH :: 0;
	REMOVED_HASH        :: 1;
	FIRST_OCCUPIED_HASH :: 2;
}

init :: inline (map : *Hash_Map, capacity : s64, allocator : Allocator)
{
	capacity = math.max (capacity, map.MIN_CAPACITY);
	capacity = next_power_of_two (capacity);

	map.count = 0;
	map.occupied = 0;
	map.allocated = capacity;
	map.allocator = allocator;
	map.entries = mem.alloc (map.Entry, capacity, allocator);
	for * map.entries
		it.hash = map.NEVER_OCCUPIED_HASH;
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

grow :: inline (map : *Hash_Map, additional_capacity : s64)
{
	if additional_capacity <= 0
		return;
	old_entries := map.entries;
	defer mem.free (old_entries, map.allocator);
	new_capacity := math.max (map.allocated + additional_capacity, map.MIN_CAPACITY);
	new_capacity = next_power_of_two (new_capacity);

	map.entries = mem.alloc (map.Entry, new_capacity, map.allocator);
	map.count = 0;
	map.occupied = 0;
	map.allocated = new_capacity;
	for entry : old_entries
	{
		if entry.hash >= map.FIRST_OCCUPIED_HASH
			insert (map, entry.key, entry.value);
	}
}

insert :: (map : *Hash_Map, key : map.TKey, $initialize := true) -> *map.TVal #must, was_present : bool
{
	if (map.occupied + 1) * 100 >= map.allocated * map.EXPAND_LIMIT
		grow (map, map.allocated);
	assert (map.occupied <= map.allocated);
	h := map.hash_key (key);
	if h < map.FIRST_OCCUPIED_HASH then h += map.FIRST_OCCUPIED_HASH;
	index := h & (map.allocated - 1);

	// Check if the key-value pair is already in the map
	while map.entries[index].hash
	{
		entry := *map.entries[index];
		if entry.hash == h && map.compare_keys (entry.key, key)
			return *entry.value, true;
		index += 1;
		if index >= map.allocated then index = 0;
	}

	map.occupied += 1;
	map.count    += 1;

	entry := *map.entries[index];
	entry.hash = h;
	entry.key  = key;
#if initialize then mem.init (*entry.value);

	return *entry.value, false;
}

insert :: inline (map : *Hash_Map, key : map.TKey, value : map.TVal) -> *map.TVal, was_present : bool
{
	ptr, was_present := insert (map, key);
	<<ptr = value;
	
	return ptr, was_present;
}

remove_at :: (map : *Hash_Map, key : map.TKey) -> found : bool, removed : map.TVal
{
	h := map.hash_key (key);
	if h < map.FIRST_OCCUPIED_HASH then h += map.FIRST_OCCUPIED_HASH;

	index := h & (map.allocated - 1);
	while map.entries[index].hash
	{
		entry := *map.entries[index];
		
		if entry.hash == h && map.compare_keys (entry.key, key)
		{
			entry.hash = map.REMOVED_HASH;
			map.count -= 1;

			return true, entry.value;
		}
		
		index += 1;
		if index >= map.allocated then index = 0;
	}

	return false, default (map.TVal);
}

set :: inline (map : *Hash_Map, key : map.TKey, value : map.TVal)
{
	ptr := get_ptr (map, key);
	if ptr then <<ptr = value;
}

get_ptr :: (map : Hash_Map, key : map.TKey) -> *map.TVal #must
{
	if map.count == 0 then return null;
	
	h := map.hash_key (key);
	if h < map.FIRST_OCCUPIED_HASH then h += map.FIRST_OCCUPIED_HASH;
	index := h & (map.allocated - 1);
	
	while map.entries[index].hash
	{
		entry := *map.entries[index];
		if entry.hash == h && map.compare_keys (entry.key, key)
			return *entry.value;
		index += 1;
		if index >= map.allocated then index = 0;
	}
	
	return null;
}

get :: inline (map : Hash_Map, key : map.TKey, fallback : map.TVal) -> map.TVal #must, found : bool
{
	ptr := get_ptr (map, key);
	if ptr then return <<ptr, true;

	return fallback, false;
}

get :: inline (map : Hash_Map, key : map.TKey) -> map.TVal #must, found : bool
{
	fallback : map.TVal;	// Default value
	ptr := get_ptr (map, key);
	if ptr then return <<ptr, true;

	return fallback, false;
}

for_expansion :: (map : *Hash_Map, body : Code, flags : For_Flags) #expand
{
	BY_POINTER :: (flags & .POINTER) == .POINTER;
	REVERSE    :: (flags & .REVERSE) == .REVERSE;

	for * <=REVERSE entry, i : map.entries
	{
		if entry.hash < map.FIRST_OCCUPIED_HASH then continue;

		`it_index := entry.key;
		#if BY_POINTER
			`it := *entry.value;
		else
			`it := entry.value;
		#insert (remove = { entry.hash = REMOVED_HASH; map.count -= 1; }) body;
	}
}

#scope_module

next_power_of_two :: inline (x : s64) -> s64 #must
{
	assert (x > 0, "Invalid x (got %, expected x > 0).", x);
	p := 1;
	while x > p
		p += p;
	return p;
}
