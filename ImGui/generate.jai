#import "Basic";
#import "File";
#import "File_Utilities";
#import "String";
bdgen :: #import "Bindings_Generator";

#if OS != .WINDOWS
	#assert false "Only Windows is supported for now.";

CPP_SOURCE_PATH :: "source";

TYPES_TO_OMIT :: string.[
	"ImVec2",
	"ImVec4",
	"ImColor",
	"ImVector",
	"ImDrawCallback"
];

ALWAYS_COMPILE_CPP_SOURCE :: false;
COMPILE_DEBUG :: true;
INCLUDE_DEMO  :: true;

g_begin_end_string_args : [..]*bdgen.Declaration;

#run
{
	#import "Compiler";

	set_build_options_dc (.{do_output = false});

	if !file_exists ("win/ImGui.dll") || !file_exists ("win/ImGui.lib") || ALWAYS_COMPILE_CPP_SOURCE
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
	array_add (*src_files, tprint ("%/imgui.cpp", CPP_SOURCE_PATH));
	array_add (*src_files, tprint ("%/imgui_widgets.cpp", CPP_SOURCE_PATH));
	array_add (*src_files, tprint ("%/imgui_draw.cpp", CPP_SOURCE_PATH));
	array_add (*src_files, tprint ("%/imgui_tables.cpp", CPP_SOURCE_PATH));
	#if INCLUDE_DEMO
		array_add (*src_files, tprint ("%/imgui_demo.cpp", CPP_SOURCE_PATH));
	
	success := true;
	#if OS == .WINDOWS
	{
		make_directory_if_it_does_not_exist ("win");
		success &&= build_cpp_dynamic_lib ("win/ImGui", ..src_files, extra = .["/DIMGUI_API=__declspec(dllexport)"], debug = COMPILE_DEBUG);
		// We set IMGUI_DISABLE_WIN32_DEFAULT_IME_FUNCTIONS. Otherwise all users of the ImGui module have to link against "imm32".
		success &&= build_cpp_static_lib ("win/ImGui", ..src_files, extra = .["/DIMGUI_API=__declspec(dllexport)", "/DIMGUI_DISABLE_WIN32_DEFAULT_IME_FUNCTIONS"], debug = COMPILE_DEBUG);
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
	
	array_add (*opts.libnames, "ImGui");
	array_add (*opts.system_include_paths, bdgen.GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
	array_add (*opts.include_paths, CPP_SOURCE_PATH);
	array_add (*opts.source_files, tprint ("%/imgui.h", CPP_SOURCE_PATH));
	array_add (*opts.extra_clang_arguments, "-x", "c++");
	array_add (*opts.flatten_namespaces, "ImGui");
	array_add (*opts.strip_prefixes, "ImGui");
	opts.auto_detect_enum_prefixes = false;
	opts.generate_compile_time_struct_checks = false;
	opts.generate_printf_wrappers = false;	// @Todo (stefan): I'd like to generate printf wrappers that use Fmt
	opts.strip_flags |= .INLINED_FUNCTIONS;

	opts.visitor = visitor;
	opts.get_func_args_for_printing = get_func_args_for_printing;

	return bdgen.generate_bindings (opts, output_filename);
}

// This is a function that is called for each declaration, so the user
// fine tune how to bindings are generated.
// For ImGui, we handle enum types and const char * function argument pairs that
// ends with _begin and _end.
visitor :: (decl : *bdgen.Declaration, parent_decl : *bdgen.Declaration) -> bdgen.Declaration_Visit_Result
{
	get_associated_enum_name :: (name : string) -> string
	{
		if name.count > 1 && name[name.count - 1] != #char "_"
			return tprint ("%_", name);
		
		return name;
	}

	// ImDrawCallback_ResetRenderState is a special value of ImDrawCallback, which
	// is a function pointer. This does not get generated correctly, so we ignore it.
	if decl.kind == .MACRO_DEFINITION && decl.name == "ImDrawCallback_ResetRenderState"
	{
		decl.decl_flags |= .OMIT_FROM_OUTPUT;
		return .STOP;
	}

	if !parent_decl
	{
		if array_find (TYPES_TO_OMIT, decl.name)
		{
			decl.decl_flags |= .OMIT_FROM_OUTPUT;

			return .STOP;
		}
	}

	// We want to generate the correct strongly typed enum,
	// so each time we have an argument or a struct member that
	// is a typedef, we search all the members we've compiled
	// so far to find the correct enum type
	if parent_decl
	&& (parent_decl.kind == .FUNCTION || parent_decl.kind == .STRUCT)
	&& decl.kind == .DECLARATION && decl.type.type_of_typedef
	{
		old_name := decl.type.type_of_typedef.name;
		if !old_name
			return .RECURSE;
		new_name := get_associated_enum_name (old_name);

		for context.compiler.global_scope.members
		{
			if it.kind != .ENUM || it.name != new_name
				continue;
	
			enum_decl := cast (*bdgen.Enum) it;
	
			// Don't output the integer typedef
			decl.type.type_of_typedef.decl_flags |= .OMIT_FROM_OUTPUT;
	
			// Make sure the enums like 'Focus_Flags_' get outputted as 'FocusFlags'
			if enum_decl.output_name.count > 2 && enum_decl.output_name[enum_decl.output_name.count - 1] == #char "_"
				enum_decl.output_name.count -= 1;
			
			// Swap in the enum for the typedef
			decl.type.type_of_typedef = null;
			decl.type.type_of_enum = enum_decl;

			decl.decl_flags |= .NEEDS_DEFAULT_ARGUMENT_CAST;

			break;
		}
	}

	if decl.kind ==
	{
	case .ENUM;
		// ImGui has lots of enums that should be enum flags. Luckily, they all end with "Flags_".
		if ends_with (decl.name, "Flags_")
		{
			enum_decl := cast (*bdgen.Enum) decl;
			enum_decl.flags |= .IS_ENUM_FLAGS;
			enum_decl.flags |= .VALUES_IN_HEX;
		}

	case .FUNCTION;
		func := cast (*bdgen.Function) decl;
		type := func.type.type_of_function;

		// ImGui also has functions with pairs of arguments like "text_begin" and "text_end"
		// for the pointers to the beginning and end of a string. We'll generate wrappers for
		// those function which take a jai string.
		//
		// Here we collect pointers to "_begin" arguments, and use them in
		// get_func_args_for_printing below.
		for type.arguments
		{
			if it_index == 0 || !ends_with (it.name, "_end")
				continue;
			basename := slice (it.name, 0, it.name.count - "_end".count);
			if !basename
				continue;
			
			// The first arg may appear as "text_begin" or just "text"
			name_with_begin := tprint ("%_begin", basename);
			prev_arg := type.arguments[it_index - 1];
			if prev_arg.name == basename || prev_arg.name == name_with_begin
			{
				array_add (*g_begin_end_string_args, prev_arg);
				func.decl_flags |= .NEEDS_ARGUMENT_WRAPPER;
			}
		}
	}

	return .RECURSE;
}

get_func_args_for_printing :: (func : *bdgen.Function, type : *bdgen.Function_Type, mode : bdgen.Arg_Print_Mode) -> []*bdgen.Declaration
{
	args : [..]*bdgen.Declaration;
	if func.decl_flags & .NEEDS_PRINTF_WRAPPER
		print ("Function % wants printf wrapper.\n", func.name);

	for type.arguments
	{
		if array_find (g_begin_end_string_args, it)
		{
			if mode ==
			{
			case .OUTER_WRAPPER;
				// For the outer wrapper, remove any "_begin" part of the argument, and
				// change its type to a jai string
				new_arg := New (bdgen.Declaration);
				<<new_arg = <<it;
				new_arg.type = context.compiler.type_def_jai_string;

				if ends_with (it.name, "_begin")
					new_arg.output_name = slice (it.name, 0, it.name.count - "_begin".count);

				array_add (*args, new_arg);

				it_index += 1;	// Skip the next arg since we merged the _begin and _end pairs

				continue;

			case .INNER_WRAPPER_CALL;
				basename := it.name;
				if ends_with (basename, "_begin")
					basename = slice (basename, 0, basename.count - "_begin".count);
				
				first_arg := New (bdgen.Declaration);
				<<first_arg = <<it;
				first_arg.output_name = tprint ("%.data", basename);
				array_add (*args, first_arg);

				second_arg := New (bdgen.Declaration);
				<<second_arg = <<it;
				second_arg.output_name = tprint ("%.data + %.count", basename, basename);
				array_add (*args, second_arg);

				it_index += 1;	// Skip the next arg since we already added the second one

				continue;
			}
		}

		array_add (*args, it);
	}

	return args;
}
