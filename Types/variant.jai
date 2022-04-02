is_variant :: inline (type : Type) -> bool #must { return is_variant (cast (*Type_Info) type); }
is_variant :: inline (val : Any) -> bool #must { return is_variant (val.type); }
is_variant :: inline (info : *Type_Info) -> bool #must
{
	return info != null && info.type == .VARIANT;
}

is_variant_of :: inline (type : Type, of : Type) -> bool #must { return is_variant_of (cast (*Type_Info) type, cast (*Type_Info) of); }
is_variant_of :: inline (info : *Type_Info, of : *Type_Info) -> bool #must
{
	if !of || !is_variant (info)
		return false;
	return (cast (*Type_Info_Variant) info).variant_of == of;
}

is_distinct_variant_of :: inline (type : Type, of : Type) -> bool #must { return is_distinct_variant_of (cast (*Type_Info) type, cast (*Type_Info) of); }
is_distinct_variant_of :: inline (info : *Type_Info, of : *Type_Info) -> bool #must
{
	if !is_variant_of (info, of)
		return false;
	return flagged ((cast (*Type_Info_Variant) info).variant_flags, .DISTINCT);
}

is_isa_variant_of :: inline (type : Type, of : Type) -> bool #must { return is_isa_variant_of (cast (*Type_Info) type, cast (*Type_Info) of); }
is_isa_variant_of :: inline (info : *Type_Info, of : *Type_Info) -> bool #must
{
	if !is_variant_of (info, of)
		return false;
	return flagged ((cast (*Type_Info_Variant) info).variant_flags, .ISA);
}
