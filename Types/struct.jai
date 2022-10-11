is_struct_or_union :: inline (type : Type) -> bool #must { return is_struct_or_union (cast (*Type_Info) type); }
is_struct_or_union :: inline (val : Any) -> bool #must { return is_struct_or_union (val.type); }
is_struct_or_union :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .STRUCT;
}

is_struct :: inline (type : Type) -> bool #must { return is_struct (cast (*Type_Info) type); }
is_struct :: inline (val : Any) -> bool #must { return is_struct (val.type); }
is_struct :: inline (info : *Type_Info) -> bool #must
{
	if !is_struct_or_union (info)
		return false;

	return !is_union (info);
}

is_union :: inline (type : Type) -> bool #must { return is_union (cast (*Type_Info) type); }
is_union :: inline (val : Any) -> bool #must { return is_union (val.type); }
is_union :: inline (info : *Type_Info) -> bool #must
{
	if !is_struct_or_union (info)
		return false;

	return (cast (*Type_Info_Struct) info).textual_flags & .UNION == .UNION;
}

struct_has_member :: inline (type : Type, name : string) -> bool #must { return struct_has_member (cast (*Type_Info) type, name); }
struct_has_member :: inline (info : *Type_Info, name : string) -> bool #must
{
	if !is_struct (info)
		return false;

	info_struct := cast (*Type_Info_Struct) info;
	for member : info_struct.members
	{
		if member.name == name
			return true;
	}

	return false;
}

get_struct_member_type :: inline (type : Type, name : string) -> *Type_Info #must { return get_struct_member_type (cast (*Type_Info) type, name); }
get_struct_member_type :: inline (info : *Type_Info, name : string) -> *Type_Info #must
{
	if !is_struct (info)
		return null;

	info_struct := cast (*Type_Info_Struct) info;
	for member : info_struct.members
	{
		if member.name == name
			return member.type;
	}

	return null;
}
