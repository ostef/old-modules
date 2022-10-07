make_array :: inline (data : *$T, count : s64) -> []T #must
#no_context
{
	result : []T = ---;
	result.data = data;
	result.count = count;
	return result;
}

slice :: inline (arr : []$T, start : s64, count : s64) -> []T #must
#no_context
{
	contextless_assert (start >= 0 && count >= 0, "Invalid parameters.");
	contextless_assert (start + count <= arr.count, "Invalid slice range.");
	result : []T = ---;
	result.data = arr.data + start;
	result.count = count;

	return result;
}

slice :: inline (arr : []$T, count : s64) -> []T #must
#no_context
{
	return slice (arr, 0, count);
}

advance :: inline (arr : []$T, count := 1) -> []T #must
#no_context
{
	if count > arr.count then count = arr.count;
	result := arr;
	result.data  += count;
	result.count -= count;

	return result;
}

advance :: inline (arr : *[]$T, count := 1)
#no_context
{
	count = math.clamp (count, 0, arr.count);
	arr.data  += count;
	arr.count -= count;
}

clone :: inline (arr : []$T, allocator := context.allocator) -> []T #must
{
	result : []T = ---;
	result.data = alloc (size_of (T) * arr.count, allocator);
	copy (result.data, src.data, size_of (T) * arr.count);
	result.count = arr.count;

	return result;
}

copy :: inline (dst : []$T, src : []T) -> s64
#no_context
{
	n := math.min (dst.count, src.count);
	copy (dst.data, src.data, n * size_of (T));

	return n;
}

copy :: inline (dst : *[]$T, src : []T)
#no_context
{
	n := math.min (dst.count, src.count);
	copy (dst.data, src.data, n * size_of (T));
	dst.count = n;
}

set :: inline (dst : []$T, value : T)
#no_context
#no_abc
{
	for i : 0..dst.count - 1
		dst[i] = value;
}
