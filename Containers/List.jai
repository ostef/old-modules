#scope_module

mem :: #import "Memory";

#scope_export

push :: inline (list : **$T, allocator : Allocator, $initialize := true) -> *T
#modify { return is_list (T); }
{
	node := mem.alloc (T, allocator, initialize);
	push (list, node);
	return node;
}

push :: inline (list : **$T, node : *T)
#modify { return is_list (T); }
{
	should_replace := !(<<list) || !(<<list).prev;
	node.prev = null;
	node.next = null;
	if (<<list)
		insert_before (<<list, node);
	if should_replace then <<list = node;
}

pop :: inline (list : **$T, node : *T)
#modify { return is_list (T); }
{
	prev := node.prev;
	next := node.next;
	unlink (node);
	if node == <<list
	{
		if next then <<list = next;
		else         <<list = prev;
	}
}

push_front :: push;

pop_front :: inline (list : **$T, allocator : Allocator)
#modify { return is_list (T); }
{
	mem.free (pop_front (list), allocator);
}

pop_front :: inline (list : **$T) -> *T #must
#modify { return is_list (T); }
{
	node := <<list;
	pop (list, node);
	return node;
}

insert_before :: inline (before : *$T, allocator : Allocator, $initialize := true) -> *T #must
#modify { return is_list (T); }
{
	node := mem.alloc (T, allocator, initialize);
	insert_before (before, node);
	return node;
}

insert_before :: inline (before : *$T, node : *T)
#modify { return is_list (T); }
{
	node.prev = before.prev;
	node.next = before;
	if node.prev
		node.prev.next = node;
	node.next.prev = node;
}

insert_after :: inline (after : *$T, allocator : Allocator, $initialize := true) -> *T #must
#modify { return is_list (T); }
{
	node := mem.alloc (T, allocator, initialize);
	insert_after (after, node);
	return node;
}

insert_after :: inline (after : *$T, node : *T)
#modify { return is_list (T); }
{
	node.prev = after;
	node.next = after.next;
	node.prev.next = node;
	if node.next
		node.next.prev = node;
}

unlink :: inline (node : *$T)
#modify { return is_list (T); }
{
	if node.prev
		node.prev.next = node.next;
	if node.next
		node.next.prev = node.prev;
	node.prev = null;
	node.next = null;
}

is_list :: inline (type : Type) -> bool #must
{
	return is_list (cast (*Type_Info) type);
}

is_list :: inline (info : *Type_Info) -> bool #must
{
	types :: #import "Types";

	return types.is_struct (info)
		&& types.is_pointer_to (types.get_member_type (info, "prev"), info)
		&& types.is_pointer_to (types.get_member_type (info, "next"), info);
}

// This for_expansion does not allow for element removal, because
// for this you would need a pointer to the list. See mutable_iter for that.
for_expansion :: (list : *$T, body : Code, flags : For_Flags) #expand
#modify { return is_list (T); }
{
	`it := list;
	`it_index := 0;
	while it
	{
		next := it.next;
		defer { it = next; it_index += 1; }
		#insert (
			remove = #assert false "Cannot remove an element because we only have a pointer to the first node, node the list itself. You can still use the pop routine to remove an element while iterating."
		) body;
	}
}
