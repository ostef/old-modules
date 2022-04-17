#import "Runtime";
mem   :: #import "Memory";
array :: #import "Containers/Array";
fmt   :: #import "Fmt";
log   :: #import "Log";
math  :: #import "Math";
str   :: #import "String";
fs    :: #import "File_System";
ps    :: #import "Process";
for_expansion :: fs.for_expansion;
jaic  :: #import "Compiler";
path  :: #import "Path";

Test_Entry :: struct
{
	module_name : string;
	filename : string;
	name : string;
	workspace : Workspace;
	compilation_success : bool;
}

build :: ()
{
	fill_default_context ();
	context.temporary_storage.overflow_allocator = mem.HEAP_ALLOC;
	test_only : [..]string;
	array.init (*test_only, 20, mem.HEAP_ALLOC);
	tests : [..]Test_Entry;
	array.init (*tests, 20, mem.HEAP_ALLOC);
	user := jaic.compiler_get_command_line_arguments ();
	i := 0;
	while i < user.count
	{
		defer i += 1;
		arg := user[i];
		if arg ==
		{
		case "-module";
			i += 1;
			if i < user.count
				array.push (*test_only, user[i]);
		}
	}
	// Don't log temporary storage page allocation messages
	context.logger = null;
	// Find all tests
	for info : fs.file_search (".")
	{
		if flagged (info.attributes, .DIRECTORY) && info.name == "tests"
		{
			search := fs.file_search (info.full_name, mem.HEAP_ALLOC, flags = .VISIT_FILES);
			for info : search
			{
				if str.ends_with (info.name, ".jai")
				{
					module_name := path.get_basename (path.get_parent_dir (path.get_parent_dir (info.full_name)));
					if test_only.count != 0 && array.find_first (test_only, module_name) == -1
						continue;
					test := array.push (*tests);
					test.module_name = module_name;
					test.filename = info.full_name;
					test.name = path.remove_extension (path.get_basename (test.filename));
				}
			}
			continue;
		}
	}
	context.logger = context.default_logger;
	for * test : tests
	{
		workspace_name := path.join (mem.HEAP_ALLOC, test.module_name, test.name);
		fmt.println ("Creating workspace %", workspace_name);
		test.workspace = jaic.compiler_create_workspace (workspace_name);
		options := jaic.get_build_options (test.workspace);
		options.text_output_flags = 0;
		options.dead_code_elimination = .NONE;
		options.output_type = .EXECUTABLE;
		options.output_executable_name = test.name;
		options.output_path = path.join (mem.HEAP_ALLOC, path.get_parent_dir (test.filename), "/");
		options.intermediate_path = path.join (mem.HEAP_ALLOC, path.get_parent_dir (test.filename), ".build/");
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
	for test : tests
	{
		if !test.compilation_success
			continue;
		test_filename := path.join (mem.TEMP_ALLOC, path.get_parent_dir (test.filename), test.name);
		exit_code, out_str, err_str := ps.run_command (
			test_filename,
			working_directory = path.get_parent_dir (test.filename),
			output = .CAPTURE
		);
		if exit_code != 0
		{
			fmt.println ("Test %/% failed.", test.module_name, test.name);
			if out_str
			{
				fmt.println (" => STDOUT");
				fmt.println (out_str);
			}
			if err_str
			{
				fmt.println (" => STDERR");
				fmt.println (err_str);
			}
		}
	}

	jaic.set_build_options_dc (.{ do_output = false, write_added_strings = false });
}

#run build ();

// Import everything so we know everything compiles
map     :: #import "Containers/Hash_Map";
list    :: #import "Containers/List";
storage :: #import "Containers/Storage";
hash    :: #import "Hash";
io      :: #import "IO";
linalg  :: #import "Linalg";
arena   :: #import "Memory/Arena";
strconv :: #import "String/Convert";
types   :: #import "Types";
unicode :: #import "Unicode";
utf8    :: #import "Unicode/UTF8";
utf16   :: #import "Unicode/UTF16";
int128  :: #import "Math/Int128";
rand    :: #import "Math/Random";
noise   :: #import "Math/Noise";
gl      :: #import "GL";
input   :: #import "Input";
window  :: #import "Window";
stbi    :: #import "stb/image";
img     :: #import "Image";
render  :: #import "Render_Core";
font    :: #import "Font";
imdraw  :: #import "ImDraw";
