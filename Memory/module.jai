#scope_module

#import "Runtime";
arena :: #import "Memory/Arena";
math  :: #import "Math";

#scope_export

#load "array.jai";
#load "alloc.jai";
#load "heap.jai";
#load "temp.jai";
#if OS == .WINDOWS then #load "win32.jai";

init :: inline (ptr : *$T)
{
	initializer :: initializer_of (T);
	#if initializer
		initializer (ptr);
	else
		set (ptr, 0, size_of (T));
}

init :: inline (arr : []$T)
#no_abc
{
	initializer :: initializer_of (T);
	#if initializer
	{
		for i : 0..arr.count - 1
			initializer (*arr[i]);
	}
	else
		set (arr.data, 0, size_of (T) * arr.count);
}

clone :: inline (ptr : *void, size : s64, allocator := context.allocator) -> *void #must
{
	result := alloc (size, allocator);
	
	return copy (result, ptr, size);
}

copy :: inline (dst : *void, src : *void, size : s64) -> *void
#no_context
{
	memcpy (dst, src, size);
	
	return dst;
}

set :: inline (dst : *void, value : u8, size : s64) -> *void
#no_context
{
	memset (dst, value, size);
	
	return dst;
}

compare :: memcmp;

equals :: inline (a : *void, b : *void, size : s64) -> bool #must
{
	return compare (a, b, size) == 0;
}

equals :: inline (a : $T, b : T) -> bool #must
{
	return compare (*a, *b, size_of (T)) == 0;
}
