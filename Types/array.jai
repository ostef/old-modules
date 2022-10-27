is_array :: inline (type : Type) -> bool #must { return is_array (cast (*Type_Info) type); }
is_array :: inline (val : Any) -> bool #must { return is_array (val.type); }
is_array :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .ARRAY;
}

is_fixed_array :: inline (type : Type) -> bool #must { return is_fixed_array (cast (*Type_Info) type); }
is_fixed_array :: inline (val : Any) -> bool #must { return is_fixed_array (val.type); }
is_fixed_array :: inline (info : *Type_Info) -> bool #must
{
	if !is_array (info)
		return false;
	
	return (cast (*Type_Info_Array) info).array_type == .FIXED;
}

is_array_view :: inline (type : Type) -> bool #must { return is_array_view (cast (*Type_Info) type); }
is_array_view :: inline (val : Any) -> bool #must { return is_array_view (val.type); }
is_array_view :: inline (info : *Type_Info) -> bool #must
{
	if !is_array (info)
		return false;
	
	return (cast (*Type_Info_Array) info).array_type == .VIEW;
}

is_resizable_array :: inline (type : Type) -> bool #must { return is_resizable_array (cast (*Type_Info) type); }
is_resizable_array :: inline (val : Any) -> bool #must { return is_resizable_array (val.type); }
is_resizable_array :: inline (info : *Type_Info) -> bool #must
{
	if !is_array (info)
		return false;
	
	return (cast (*Type_Info_Array) info).array_type == .RESIZABLE;
}

is_array_of :: inline (type : Type, of : Type) -> bool #must { return is_array_of (cast (*Type_Info) type, cast (*Type_Info) of); }
is_array_of :: inline (info : *Type_Info, of : *Type_Info) -> bool #must
{
	if !of || !is_array (info)
		return false;
	
	return (cast (*Type_Info_Array) info).element_type == of;
}

array_has_member :: inline (type : Type, name : string) -> bool #must { return array_has_member (cast (*Type_Info) type, name); }
array_has_member :: inline (info : *Type_Info, name : string) -> bool #must
{
	if !is_array (info)
		return false;
	
	info_array := cast (*Type_Info_Array) info;
	if #complete info_array.array_type ==
	{
	case .RESIZABLE;
		if name == "allocated" || name == "allocator"
			return true;
	
		#through;
	
	case .FIXED; #through;
	case .VIEW;
		if name == "count" || name == "data"
			return true;
	}
	
	return false;
}

get_array_member_type :: inline (type : Type, name : string) -> *Type_Info #must { return get_array_member_type (cast (*Type_Info) type, name); }
get_array_member_type :: inline (info : *Type_Info, name : string) -> *Type_Info #must
{
	if !is_array (info)
		return null;
	
	info_array := cast (*Type_Info_Array) info;
	if #complete info_array.array_type ==
	{
	case .RESIZABLE;
		if name == "allocated"
			return get_relative_pointer_type (info_array.relative_pointer_size);
	
		if name == "allocator"
			return type_info (Allocator);
	
		#through;
	
	case .FIXED; #through;
	case .VIEW;
		if name == "count"
			return get_relative_pointer_type (info_array.relative_pointer_size);

		// We can't handle the 'data' member correctly, because we would need
		// to return a type info that we can't access!
	}
	
	return null;
}
