#scope_module

#import "Runtime";
fmt :: #import "Fmt";

#scope_export

implements :: inline (type : Type, trait_type : Type) -> bool #must
{
	info := cast (*Type_Info_Struct) type;
	trait_info := cast (*Type_Info_Struct) trait_type;
	assert (info.type == .STRUCT && trait_info.type == .STRUCT);

	return implements (info, trait_info);
}

implements :: (info : *Type_Info_Struct, trait_info : *Type_Info_Struct) -> bool #must
{
	compare_types :: (
		first : *Type_Info, first_base : *Type_Info,
		second : *Type_Info, second_base : *Type_Info
	) -> bool #must
	{
		if first == first_base
			return second == second_base;

		if first.type != second.type
			return false;

		if first.type ==
		{
		case .POINTER;
			first_pointer := cast (*Type_Info_Pointer) first;
			second_pointer := cast (*Type_Info_Pointer) second;
			
			if first_pointer.relative_pointer_size != second_pointer.relative_pointer_size
				return false;
			
			return compare_types (first_pointer.pointer_to, first_base, second_pointer.pointer_to, second_base);

		case .ARRAY;
			first_array := cast (*Type_Info_Array) first;
			second_array := cast (*Type_Info_Array) second;
			
			if first_array.array_type != second_array.array_type
			|| first_array.array_count != second_array.array_count
			|| first_array.relative_pointer_size != second_array.relative_pointer_size
				return false;
			
			return compare_types (first_array.element_type, first_base, second_array.element_type, second_base);

		case .PROCEDURE;
			first_proc := cast (*Type_Info_Procedure) first;
			second_proc := cast (*Type_Info_Procedure) second;

			if first_proc.argument_types.count != second_proc.argument_types.count
				return false;
			
			for i : 0..first_proc.argument_types.count - 1
			{
				if !compare_types (
					first_proc.argument_types[i], first_base,
					second_proc.argument_types[i], second_base
				)
					return false;
			}

			return true;

		case;
			return first == second;
		}
	}

	// Find This_Type struct
	this_type : *Type_Info_Struct;	// Can be null
	for trait_info.members
	{
		if it.name == "This_Type"
		{
			assert (it.offset_into_constant_storage != -1, "Trait % has member This_Type but it is not constant. This_Type should be a constant empty struct.", trait_info.name);
			assert (it.type.type == .TYPE, "Trait % has member This_Type but it is not an empty struct.", trait_info.name);

			this_type = <<cast (**Type_Info_Struct) (trait_info.constant_storage_buffer + it.offset_into_constant_storage);
			assert (this_type.type == .STRUCT && this_type.members.count == 0, "Trait % has member This_Type but it is not an empty struct.", trait_info.name);

			break;
		}
	}

	// Ensure we implement all procedures
	for trait_info.members
	{
		if it.type.type != .TYPE || it.offset_into_constant_storage == -1
			continue;

		proc_name := it.name;
		proc_type := <<cast (**Type_Info_Procedure) (trait_info.constant_storage_buffer + it.offset_into_constant_storage);
		if proc_type.type != .PROCEDURE
			continue;

		implemented := false;
		for info.members
		{
			if it.name == proc_name
			{
				implemented = compare_types (proc_type, this_type, it.type, info);
				break;
			}
		}

		if !implemented
			return false;
	}

	return true;
}
