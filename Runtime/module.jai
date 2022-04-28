#module_parameters () (ENABLE_ASSERTS := true);

#scope_module

fmt :: #import "Fmt";
mem :: #import "Memory";
str :: #import "String";

#scope_export

#load "assert.jai";

f32 :: float32;
f64 :: float64;

#scope_file

g_cmd_line_args : []string;

#scope_export

get_cmd_line_args :: inline () -> []string #must
{
	if g_cmd_line_args.data
		return g_cmd_line_args;
	g_cmd_line_args = mem.alloc (string, __command_line_arguments.count, mem.HEAP_ALLOC);
	for arg, i : __command_line_arguments
		g_cmd_line_args[i] = str.make (arg, str.length (arg));
	return g_cmd_line_args;
}

offset_of :: ($T : Type, member : string) -> s64 #must #expand
{
	#insert -> string
	{
		builder :: #import "String/Builder";
		
		code : builder.Builder;
		builder.init (*code, mem.HEAP_ALLOC);
		builder.append_line (*code, "base : T = ---;");
		builder.append_line (*code, "return cast (*u8) *base.% - cast (*u8) *base;", member);
		return builder.build (code, mem.HEAP_ALLOC);
	};
}

fill_default_context :: inline (ctx : *Context)
#no_context
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

swap :: (a : $T, b : T) -> b : T, a : T #expand
{
	return b, a;
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
