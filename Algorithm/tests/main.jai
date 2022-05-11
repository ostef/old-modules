#import "Runtime";
algo :: #import "Algorithm";
fmt  :: #import "Fmt";

main :: ()
{
	a : [10]int;
	a[0] = 10;
	a[1] = 4;
	a[2] = 7;
	a[3] = 1;
	a[4] = 9;
	a[5] = 5;
	a[6] = 6;
	a[7] = 2;
	a[8] = 3;
	a[9] = 8;
	fmt.println (a);
	algo.qsort (a);
	fmt.println (a);
}
