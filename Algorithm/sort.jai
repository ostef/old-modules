qsort :: inline (arr : []$T, compare : (T, T) -> int)
{
	helper :: (a : *T, n : s64, compare : (T, T) -> int)
	{
		if n < 2
			return;
		p := a[n / 2];
		i := 0;
		j := n -1;
		while true
		{
			while compare (a[i], p) < 0
				i += 1;
			while compare (p, a[j]) < 0
				j -= 1;
			if i >= j
				break;
			a[i], a[j] = swap (a[i], a[j]);
			i += 1;
			j -= 1;
		}
		helper (a, i, compare);
		helper (a + i, n - i, compare);
	}

	helper (arr.data, arr.count, compare);
}

qsort :: inline (arr : []$T)
{
	compare :: inline (a : T, b : T) -> int
	{
		if a < b
			return -1;
		if a > b
			return 1;
		return 0;
	}

	qsort (arr, compare);
}
