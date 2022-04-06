#scope_module

#import "Runtime";
jaic  :: #import "Compiler";
fmt   :: #import "Fmt";
mem   :: #import "Memory";
array :: #import "Containers/Array";
map   :: #import "Containers/Hash_Map";
for_expansion :: map.for_expansion;
str   :: #import "String";
fs    :: #import "File_System";
path  :: #import "Path";

#scope_export

#load "import.jai";

module_search_map : map.Hash_Map (string, string);
module_search_dirs : [..]string;
procedures_to_run : [..]*jaic.Code_Procedure_Header;

run_after_typechecking :: inline (header : *jaic.Code_Procedure_Header)
{
	procedures_to_run.allocator = mem.HEAP_ALLOC;
	array.push (*procedures_to_run, header);
}

handle_compiler_message :: (msg : *jaic.Message)
{
	if msg.kind ==
	{
	case .TYPECHECKED;
		typechecked := cast (*jaic.Message_Typechecked) msg;
		for header : typechecked.procedure_headers
			for header.expression.notes
				if it.text == "Run_After_Typechecking"
					run_after_typechecking (header.expression);

	case .IMPORT;
		import := cast (*jaic.Message_Import) msg;
		//fmt.println ("Message import: %", <<import);

	case .FAILED_IMPORT;
		import := cast (*jaic.Message_Failed_Import) msg;
		if import.import_code
		{
			at_file := import.import_code.location.enclosing_load.fully_pathed_filename;
			at_line := import.import_code.location.l0;
			at_char := import.import_code.location.c0;
			//fmt.println ("%:%,%: Message failed import: %", at_file, at_line, at_char, <<import);
		}
		handle_failed_import (cast (*jaic.Message_Failed_Import) msg);

	case .PHASE;
		phase := cast (*jaic.Message_Phase) msg;
		if phase.phase == .TYPECHECKED_ALL_WE_CAN
		{
			for procedures_to_run
				jaic.add_build_string (fmt.format (mem.HEAP_ALLOC, "#run % ();\t// Run after typechecking", it.name), msg.workspace);
			array.clear (*procedures_to_run);
		}
	}
}

parse_arguments :: (options : *jaic.Build_Options)
{
	map.init (*module_search_map, 10, mem.HEAP_ALLOC);
	array.init (*module_search_dirs, 10, mem.HEAP_ALLOC);
	user, system := jaic.compiler_get_command_line_arguments ();
	i := 0;
	while i < system.count
	{
		defer i += 1;
		arg := system[i];
		if arg ==
		{
		case "-release";
			set_optimization_level (options, 2, 0);
			options.stack_trace = false;

		case "-import_dir";
			dir : string;
			i += 1;
			if i < system.count
				dir = system[i];
			if dir
			{
				fullpath := fs.get_full_filename (dir, mem.HEAP_ALLOC);
				if array.find_first (module_search_dirs, fullpath) == -1
					array.push (*module_search_dirs, fullpath);
			}
		}
	}
	i = 0;
	while i < user.count
	{
		defer i += 1;
		arg := user[i];
		if arg ==
		{
		case "-mount_import";
			mount, dir : string;
			i += 1;
			if i < user.count
				mount = user[i];
			i += 1;
			if i < user.count
				dir = user[i];
			if mount && dir
			{
				fullpath := fs.get_full_filename (dir, mem.HEAP_ALLOC);
				map.insert (*module_search_map, mount, fullpath);
				if array.find_first (module_search_dirs, fullpath) == -1
					array.push (*module_search_dirs, fullpath);
			}

		case "-import_dir";
			dir : string;
			i += 1;
			if i < user.count
				dir = user[i];
			if dir
			{
				fullpath := fs.get_full_filename (dir, mem.HEAP_ALLOC);
				if array.find_first (module_search_dirs, fullpath) == -1
					array.push (*module_search_dirs, fullpath);
			}
		}
	}
	options.import_path = module_search_dirs;
}

build :: ()
{
	w := jaic.compiler_create_workspace ("Main");
	options := jaic.get_build_options (w);
	parse_arguments (*options);
	files, run_strings := jaic.compiler_get_source_files ();
	if files.count > 0
		options.output_executable_name = path.get_basename (path.remove_extension (files[0]));
	jaic.set_build_options (options, w);
	//jaic.remap_import (w, "*", "*", "");	// Block all imports so we can handle them ourselves
	jaic.compiler_begin_intercept (w);
	for files
		jaic.add_build_file (it, w);
	for run_strings
		jaic.add_build_string (fmt.format (mem.HEAP_ALLOC, "#run %;\n", it), w);
	while true
	{
		msg := jaic.compiler_wait_for_message ();
		handle_compiler_message (msg);
		if msg.workspace == w && msg.kind == .COMPLETE
			break;
	}
	jaic.compiler_end_intercept (w);
	jaic.set_build_options_dc (.{ do_output = false, write_added_strings = false });
}

set_optimization_level :: (using build_options: *jaic.Build_Options, opt_level: int, size_level: int) {
	if opt_level == 0 {
		// @Note we probably dont need to do anything here since we only really need to not optimize in DEBUG
		// (RELEASE with all opts turned off would essentially be the same as DEBUG build...)

		optimization_level = .DEBUG;

		dummy: jaic.Llvm_Options;   // This now contains the default values.
		llvm_options = dummy;  // Should have a way to just invoke default-value setter instead!
		
		return;
	}

	optimization_level = .RELEASE;

	// Bounds check stuff.
	{
		array_bounds_check = .OFF;
		cast_bounds_check  = .OFF;
		math_bounds_check  = .OFF;
		null_pointer_check = .OFF;
	}
	
	// default init; user can toggle specifics post-call
	// (Also overridden below, conditionally).
	{
		enable_bytecode_inliner = false;  // Disabled for now, but, we will turn this on by default later on.

		// This is a bit goofy because we are setting this regardless of
		// the value of build_options.backend, but whatevs.
		using build_options.llvm_options;

		disable_inlining = false;

		disable_frame_pointer_omission = false;
		enable_tail_calls              = true;
		enable_loop_unrolling          = true;
		enable_slp_vectorization  = (opt_level > 1 && size_level < 2);
		enable_loop_vectorization = (opt_level > 1 && size_level < 2);
		reroll_loops    = false;

		verify_input    = false;
		verify_output   = false;

		merge_functions = false;

		enable_split_modules = false; // turn off parallel module building to get the best code optimization + inlining

		if (opt_level > 3) opt_level = 3;
		if (opt_level < 0) opt_level = 0;
		code_gen_optimization_level = cast(u8) opt_level;

		if (size_level > 2) size_level = 2;
		if (size_level < 0) size_level = 0;
		code_gen_size_level = cast(u8) size_level;

	}
}
