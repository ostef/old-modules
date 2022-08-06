#import "Runtime";
fmt    :: #import "Fmt";
traits :: #import "Traits";

Trait :: struct
{
	This_Type :: struct {};

	get :: #type (this : This_Type) -> s64;
	set :: #type (this : *This_Type, val : s64);
}

// For dynamic dispatch, we can use non constant functions, and a
// data pointer. The use needs to manually generate a value of this
// struct, filling the data, get and set members.
// We could also make Dynamic_Trait a base struct, and we would
// have a #as member of type Dynamic_Trait to automatically cast to
// that type in the structs that implement the said trait.
// However, that means we have the cost of storing the function
// pointers for every struct that implements the trait, even
// if we don't use dynamic dispatch very much.
Dynamic_Trait :: struct
{
	data : *void;
	get : (this : Dynamic_Trait) -> s64;
	set : (this : *Dynamic_Trait, val : s64);
}

A :: struct
{
	val : s64;

	get :: (using this : A) -> s64
	{
		return val;
	}

	set :: (using this : *A, value : s64)
	{
		val = value;
	}
}

dynamic :: (a : *A) -> Dynamic_Trait #must
{
	result : Dynamic_Trait;
	result.data = a;
	result.get = (d : Dynamic_Trait) -> s64 { return a.get (cast (*A) d.data); };
	result.set = (d : *Dynamic_Trait, val : s64) { a.set (cast (*A) d.data, val); };

	return result;
}

B :: struct
{
	get :: (using this : *Trait.This_Type) {}
	set :: () {}
}

foo :: (t : $T)
#modify { return traits.implements (T, Trait); }
{
	fmt.println ("%.get returned %.", T, t.get (t));
}

main :: ()
{
	a : A;
	a.set (*a, 12);
	foo (a);

	d := dynamic (*a);
	d.set (*d, 69105);
	foo (d);
	
	assert (traits.implements (A, Trait));
	assert (traits.implements (Dynamic_Trait, Trait));
	assert (!traits.implements (B, Trait));
}
