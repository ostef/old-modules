#import "Basic";
#import "File";
#import "File_Utilities";
#import "String";
bdgen :: #import "Bindings_Generator";

#if OS != .WINDOWS
	#assert false "Only Windows is supported for now.";

CPP_SOURCE_PATH :: "source";

TYPES_TO_OMIT :: string.[
	"Vec2",
	"Vec3",
	"Vec4",
	"Mat3",
	"Mat4"
];

ALWAYS_COMPILE_CPP_SOURCE :: false;
COMPILE_DEBUG :: true;

#run
{
	#import "Compiler";

	set_build_options_dc (.{do_output = false});

	if !file_exists ("win/Im3d.dll") || !file_exists ("win/Im3d.lib") || ALWAYS_COMPILE_CPP_SOURCE
	{
		if !compile_cpp_source ()
		{
			compiler_set_workspace_status (.FAILED);
			return;
		}
	}

	if !generate_bindings ()
	{
		compiler_set_workspace_status (.FAILED);
		return;
	}
}

compile_cpp_source :: () -> bool
{
	#import "BuildCpp";

	src_files : [..]string;
	array_add (*src_files, tprint ("%/im3d.cpp", CPP_SOURCE_PATH));

	success := true;
	#if OS == .WINDOWS
	{
		make_directory_if_it_does_not_exist ("win");
		success &&= build_cpp_dynamic_lib ("win/Im3d", ..src_files, extra = .["/DIM3D_API=__declspec(dllexport)"], debug = COMPILE_DEBUG);
		success &&= build_cpp_static_lib ("win/Im3d", ..src_files, extra = .["/DIM3D_API=__declspec(dllexport)"], debug = COMPILE_DEBUG);
	}

	return success;
}

generate_bindings :: () -> bool
{
	#if OS == .WINDOWS
		output_filename := "win32.jai";

	opts : bdgen.Generate_Bindings_Options;

	#if OS == .WINDOWS
		array_add (*opts.libpaths, "win");
	
	array_add (*opts.libnames, "Im3d");
	array_add (*opts.system_include_paths, bdgen.GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
	array_add (*opts.include_paths, CPP_SOURCE_PATH);
	array_add (*opts.source_files, tprint ("%/im3d.h", CPP_SOURCE_PATH));
	array_add (*opts.source_files, tprint ("%/im3d_math.h", CPP_SOURCE_PATH));
	array_add (*opts.extra_clang_arguments, "-x", "c++");
	array_add (*opts.flatten_namespaces, "Im3d");
	opts.auto_detect_enum_prefixes = false;
	opts.generate_compile_time_struct_checks = false;
	opts.generate_printf_wrappers = false;	// @Todo (stefan): I'd like to generate printf wrappers that use Fmt
	opts.strip_flags |= .INLINED_FUNCTIONS;

	opts.visitor = visitor;
	//opts.get_func_args_for_printing = get_func_args_for_printing;

	return bdgen.generate_bindings (opts, output_filename);
}

// This is a function that is called for each declaration, so the user
// fine tune how to bindings are generated.
// For Im3d:
// - Remove m_ prefix to struct members
visitor :: (decl : *bdgen.Declaration, parent_decl : *bdgen.Declaration) -> bdgen.Declaration_Visit_Result
{
	if !parent_decl || parent_decl.name == "Im3d"
	{
		if array_find (TYPES_TO_OMIT, decl.name)
		{
			print ("Omitting decl %\n", decl.name);
			decl.decl_flags |= .OMIT_FROM_OUTPUT;

			return .STOP;
		}
	}

	if decl.kind == .STRUCT
	{
		decl_struct := cast (*bdgen.Struct) decl;
		for decl_struct.declarations
		{
			// @Hack: omit struct literals, because they can produce compile errors
			if it.expression && it.expression.kind == .STRUCT_LITERAL
				it.expression = null;

			if begins_with (it.name, "m_")
				it.output_name = advance (it.name, "m_".count);
		}
	}

	return .RECURSE;
}
