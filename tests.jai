#import "Runtime";
mem   :: #import "Memory";
array :: #import "Containers/Array";
fmt   :: #import "Fmt";
log   :: #import "Log";
math  :: #import "Math";
str   :: #import "String";
os    :: #import "OS";
for_expansion :: os.for_expansion;
jaic :: #import "Compiler";

Test_Entry :: struct
{
	module_name : string;
	filename : string;
	name : string;
	workspace : Workspace;
	compilation_success : bool;
}

// @Cleanup (stefan): Put this either in String, OS, or a Path module that we don't have yet.
remove_extension :: inline (filename : string) -> string #must
{
	slash_index := str.find_last (filename, #char "/");
	dot_index := str.find_last (filename, #char ".");
	if dot_index == -1 || dot_index < slash_index
		return filename;
	return str.slice (filename, dot_index);
}

get_basename :: inline (filename : string) -> string #must
{
	slash_index := str.find_last (filename, #char "/");
	if slash_index == -1
		return "";
	return str.advance (filename, slash_index + 1);
}

get_parent_dir :: inline (filename : string) -> string #must
{
	slash_index := str.find_last (filename, #char "/");
	if slash_index == -1
		return "";
	return str.slice (filename, slash_index);
}

build :: ()
{
	fill_default_context ();
	tests : [..]Test_Entry;
	array.init (*tests, 20, mem.HEAP_ALLOC);
	context.logger = null;
	// Find all tests
	for info : os.file_search (".")
	{
		if flagged (info.attributes, .DIRECTORY) && info.name == "tests"
		{
			search := os.file_search (info.full_name, mem.HEAP_ALLOC, flags = .VISIT_FILES);
			for info : search
			{
				if str.ends_with (info.name, ".jai")
				{
					test := array.push (*tests);
					test.module_name = get_basename (get_parent_dir (get_parent_dir (info.full_name)));
					test.filename = info.full_name;
					test.name = remove_extension (get_basename (test.filename));
				}
			}
			continue;
		}
	}
	context.logger = context.default_logger;
	for * test : tests
	{
		//if test.module_name == "Fmt" || test.module_name == "Linalg"
		//	continue;
		workspace_name := str.join (mem.HEAP_ALLOC, test.module_name, "/", test.name);
		fmt.println ("Creating workspace %", workspace_name);
		test.workspace = jaic.compiler_create_workspace (workspace_name);
		options := jaic.get_build_options (test.workspace);
		options.text_output_flags = 0;
		options.dead_code_elimination = .NONE;
		options.output_type = .EXECUTABLE;
		options.output_executable_name = test.name;
		options.output_path = str.join (mem.HEAP_ALLOC, test.module_name, "/tests/");
		options.intermediate_path = str.join (mem.HEAP_ALLOC, test.module_name, "/tests/.build/");
		options.import_path = .[ ".", "c:/jai/modules/" ];
		jaic.set_build_options (options, test.workspace);
		jaic.compiler_begin_intercept (test.workspace);
		jaic.add_build_file (test.filename, test.workspace);
		while true
		{
			msg := jaic.compiler_wait_for_message ();
			if msg.kind == .COMPLETE
			{
				test.compilation_success = (cast (*jaic.Message_Complete) msg).error_code == .NONE;
				break;
			}
		}
		jaic.compiler_end_intercept (test.workspace);
		if !test.compilation_success
			log.error ("Failed to compile workspace '%'.", workspace_name);
	}

	jaic.set_build_options_dc (.{ do_output = false, write_added_strings = false });
}

#run build ();
