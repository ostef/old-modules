// When importing a module A from a module B, the module is searched first
// in the same directory as B. Then it is searched in the module
// directory D provided in the build options, from which the module
// B was imported. Then, all other module directories are searched
// in the same order as the compiler would.
// If the module name is prefixed by :, then the module A is
// searched exclusively in the directory D.
// If the module is imported from the main program, all of the above
// is not applied, and when the module name is not prefixed by anything,
// the default searching behaviour is applied.
// If the module name is prefixed by a name N then a :, the
// module A is searched in the directory mapped to the name N in
// the metaprogram. If there is no mapping of N, then the remapping fails.

// Import related compiler options:
// -import_dir [MOUNT_NAME:]DIRECTORY_PATH => add a directory in which to
// search for modules. Map that directory to the name MOUNT_NAME,
// if present (used when importing modules in the form "Mount_Name:Module_Name")

find_module_path :: (base : string) -> string, is_file : bool, exists : bool
{
	module_path := base;
	attrs, err := fs.get_file_attributes (module_path);
	if err == .OK
		return module_path, !flagged (attrs, .DIRECTORY), true;
	else if !str.ends_with (module_path, ".jai")
	{
		module_path = path.join (mem.HEAP_ALLOC, module_path, ".jai");
		attrs, err := fs.get_file_attributes (module_path);
		if err == .OK
			return module_path, !flagged (attrs, .DIRECTORY), true;
	}
	return base, false, false;
}

handle_failed_import :: (import : *jaic.Message_Failed_Import)
{
	if import.status == .NOT_FOUND
		return;
	module_path : string;
	is_file, exists : bool;
	mount_name, module_name : string;
	module_name = import.target_module_name;
	colon_index := str.find_first (import.target_module_name, #char ":");
	if colon_index != -1
	{
		mount_name = str.slice (module_name, colon_index);
		module_name = str.advance (module_name, colon_index + 1);
		base_dir, has_mapping := map.get (g_module_search_map, mount_name);
		if has_mapping
		{
			mounted_path := path.join (mem.HEAP_ALLOC, base_dir, module_name);
			module_path = fs.get_full_filename (module_path, mem.HEAP_ALLOC);
			module_path, is_file, exists = find_module_path (mounted_path);
		}
		else
			fmt.println ("Could not provide import for {:'} because the mount point {:'} does not exist.", import.target_module_name, mount_name);
	}
	else
	{
		for g_module_search_dirs
		{
			full_path := path.join (mem.HEAP_ALLOC, it, import.target_module_name);
			full_path = fs.get_full_filename (full_path, mem.HEAP_ALLOC);
			if exists
				break;
			module_path, is_file, exists = find_module_path (full_path);
		}
	}
	if exists
	{
		if is_file
		{
			fmt.println ("Remapped import {:'} to file {:'}.", import.target_module_name, module_path);
			jaic.provide_import (import.workspace, import, .PATH_TO_FILE, module_path);
		}
		else
		{
			fmt.println ("Remapped import {:'} to directory {:'}.", import.target_module_name, module_path);
			jaic.provide_import (import.workspace, import, .PATH_TO_DIRECTORY, module_path);
		}
	}
	else if module_path
		fmt.println ("Remapped import {:'} to {:'}, but the module does not exist!", import.target_module_name, module_path);
}
