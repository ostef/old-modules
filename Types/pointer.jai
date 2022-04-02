is_pointer :: inline (type : Type) -> bool #must { return is_pointer (cast (*Type_Info) type); }
is_pointer :: inline (val : Any) -> bool #must { return is_pointer (val.type); }
is_pointer :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .POINTER;
}

is_pointer_to :: inline (type : Type, to : Type) -> bool #must { return is_pointer_to (cast (*Type_Info) type, cast (*Type_Info) to); }
is_pointer_to :: inline (info : *Type_Info, to : *Type_Info) -> bool #must
{
	if !to || !is_pointer (info)
		return false;
	return (cast (*Type_Info_Pointer) info).pointer_to == to;
}

is_relative_pointer :: inline (type : Type) -> bool #must { return is_relative_pointer (cast (*Type_Info) type); }
is_relative_pointer :: inline (val : Any) -> bool #must { return is_relative_pointer (val.type); }
is_relative_pointer :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .POINTER && (cast (*Type_Info_Pointer) info).relative_pointer_size != 0;
}

get_relative_pointer_type :: inline (size : s64) -> *Type_Info #must
{
	if size ==
	{
	case 1;
		return type_info (s8);
	case 2;
		return type_info (s16);
	case 4;
		return type_info (s32);
	case 8; #through;
	case 0;
		return type_info (s64);
	}
	return null;
}
