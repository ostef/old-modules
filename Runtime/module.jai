#module_parameters () (ENABLE_ASSERTS := true);

#scope_module

fmt :: #import "Fmt";
mem :: #import "Memory";

#scope_export

#load "assert.jai";

f32 :: float32;
f64 :: float64;

fill_default_context :: inline (ctx : *Context)
{
	ctx.assertion_failed = assertion_failed;
	ctx.allocator = mem.HEAP_ALLOC;
}

fill_default_context :: inline ()
{
	fill_default_context (*context);
}

default :: ($T : Type) -> T #must #expand
{
	val : T;
	return val;
}

flagged :: (val : $T, flag : T) -> bool #expand
{
	return (val & flag) == flag;
}

add_flag :: (val : $T, flag : T) -> T #expand
{
	return val | flag;
}

add_flag :: (val : *$T, flag : T) #expand
{
	<<val |= flag;
}

remove_flag :: (val : $T, flag : T) -> T #expand
{
	return val & ~flag;
}

remove_flag :: (val : *$T, flag : T) #expand
{
	<<val &= ~flag;
}
