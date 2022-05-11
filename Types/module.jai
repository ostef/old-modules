#import "Runtime";

#load "pointer.jai";
#load "array.jai";
#load "struct.jai";
#load "variant.jai";

is_string :: inline (type : Type) -> bool #must { return is_string (cast (*Type_Info) type); }
is_string :: inline (val : Any)   -> bool #must { return is_string (val.type); }
is_string :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .STRING;
}

is_boolean :: inline (type : Type) -> bool #must { return is_boolean (cast (*Type_Info) type); }
is_boolean :: inline (val : Any)   -> bool #must { return is_boolean (val.type); }
is_boolean :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .BOOL;
}

is_integer :: inline (type : Type) -> bool #must { return is_integer (cast (*Type_Info) type); }
is_integer :: inline (val : Any) -> bool #must { return is_integer (val.type); }
is_integer :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .INTEGER;
}

is_float :: inline (type : Type) -> bool #must { return is_float (cast (*Type_Info) type); }
is_float :: inline (val : Any) -> bool #must { return is_float (val.type); }
is_float :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .FLOAT;
}

is_numeric :: inline (type : Type) -> bool #must { return is_numeric (cast (*Type_Info) type); }
is_numeric :: inline (val : Any) -> bool #must { return is_numeric (val.type); }
is_numeric :: inline (info : *Type_Info) -> bool #must
{
	if !info || (info.type != .FLOAT && info.type != .INTEGER)
		return false;
	return true;
}

is_signed :: inline (type : Type) -> bool #must { return is_signed (cast (*Type_Info) type); }
is_signed :: inline (val : Any) -> bool #must { return is_signed (val.type); }
is_signed :: inline (info : *Type_Info) -> bool #must
{
	if !info || (info.type != .INTEGER && info.type != .FLOAT)
		return false;
	if info.type == .INTEGER
		return (cast (*Type_Info_Integer) info).signed;
	return true;
}

is_unsigned :: inline (type : Type) -> bool #must { return is_unsigned (cast (*Type_Info) type); }
is_unsigned :: inline (val : Any) -> bool #must { return is_unsigned (val.type); }
is_unsigned :: inline (info : *Type_Info) -> bool #must
{
	if !info || info.type != .INTEGER
		return false;
	return !(cast (*Type_Info_Integer) info).signed;
}

is_procedure :: inline (type : Type) -> bool #must { return is_procedure (cast (*Type_Info) type); }
is_procedure :: inline (val : $T)  -> bool #must { return is_procedure (type_info (T)); }
is_procedure :: inline (val : Any) -> bool #must { return is_procedure (val.type); }
is_procedure :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .PROCEDURE;
}

is_enum :: inline (type : Type) -> bool #must { return is_enum (cast (*Type_Info) type); }
is_enum :: inline (val : $T)  -> bool #must { return is_enum (type_info (T)); }
is_enum :: inline (val : Any) -> bool #must { return is_enum (val.type); }
is_enum :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .ENUM && !flagged ((cast (*Type_Info_Enum) info).enum_type_flags, .FLAGS);
}

is_enum_flags :: inline (type : Type) -> bool #must { return is_enum_flags (cast (*Type_Info) type); }
is_enum_flags :: inline (val : $T)  -> bool #must { return is_enum_flags (type_info (T)); }
is_enum_flags :: inline (val : Any) -> bool #must { return is_enum_flags (val.type); }
is_enum_flags :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .ENUM && flagged ((cast (*Type_Info_Enum) info).enum_type_flags, .FLAGS);
}

has_member :: inline (type : Type, name : string) -> bool #must { return has_member (cast (*Type_Info) type, name); }
has_member :: inline (info : *Type_Info, name : string) -> bool #must
{
	return array_has_member (info, name) || struct_has_member (info, name);
}

get_member_type :: inline (type : Type, name : string) -> *Type_Info #must { return get_member_type (cast (*Type_Info) type, name); }
get_member_type :: inline (info : *Type_Info, name : string) -> *Type_Info #must
{
	result := get_array_member_type (info, name);
	if result
		return result;
	return get_struct_member_type (info, name);
}
