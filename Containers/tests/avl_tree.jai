#import "Runtime";
mem :: #import "Memory";
fmt :: #import "Fmt";
avl :: #import "Containers/AVL_Tree";
array :: #import "Containers/Array";
strbuild :: #import "String/Builder";

for_expansion :: avl.for_expansion;

list_as_string :: (tree : avl.AVL_Tree) -> string #must
{
	builder : strbuild.Builder;
	strbuild.init (*builder);

	for tree
	{
		if it_index != 0
			strbuild.append (*builder, " ");
		strbuild.append_fmt (*builder, "%", it);
	}

	return strbuild.build (builder);
}

ensure_equals :: inline (tree : avl.AVL_Tree, s : string)
{
	as_str := list_as_string (tree);
	assert (as_str == s, "Expected %, got %", s, as_str);
}

ensure_sorted :: (tree : avl.AVL_Tree)
{
	prev : int = ---;
	for tree
	{
		if it_index != 0
			assert (tree.compare_values (prev, it) < 0);

		prev = it;
	}
}

ensure_no_loop_in_tree :: (tree : avl.AVL_Tree)
{
	nodes : [..]*tree.Node;
	array.init (*nodes, tree.count, mem.TEMP_ALLOC);

	node := avl.leftmost (tree.root);
	while node
	{
		if array.find_first (nodes, node) != -1
		{
			panic ("Loop in AVL tree! Node value is %, parent is %, left is %, right is %, node is {:!}.",
				node.value,
				ifx node.parent then node.parent.value else 0,
				ifx node.left then node.left.value else 0,
				ifx node.right then node.right.value else 0,
				<<node
			);
		}

		array.push (*nodes, node);

		node = avl.successor (node);
	}
}

test_insert_erase :: ()
{
	tree : avl.AVL_Tree (int);
	avl.init (*tree);
	
	avl.insert (*tree, 10);
	ensure_sorted (tree);
	avl.insert (*tree, 20);
	ensure_sorted (tree);
	avl.insert (*tree, 30);

	ensure_no_loop_in_tree (tree);
	ensure_sorted (tree);
	ensure_equals (tree, "10 20 30");

	avl.insert (*tree, 40);
	avl.insert (*tree, 7);
	avl.insert (*tree, 9);
	avl.insert (*tree, 8);
	avl.insert (*tree, 6);
	
	ptr := avl.insert (*tree, 22);
	ptr2 := avl.insert (*tree, 22);
	assert (ptr == ptr2);

	ensure_no_loop_in_tree (tree);
	ensure_sorted (tree);
	ensure_equals (tree, "6 7 8 9 10 20 22 30 40");

	avl.erase (*tree, 10);

	ensure_equals (tree, "6 7 8 9 20 22 30 40");

	avl.erase (*tree, 1);

	ensure_equals (tree, "6 7 8 9 20 22 30 40");

	avl.erase (*tree, 6);
	avl.erase (*tree, 7);
	avl.erase (*tree, 20);
	avl.erase (*tree, 30);

	ensure_equals (tree, "8 9 22 40");
}

test_find :: ()
{
	str :: #import "String";

	Key_Value :: struct (Key : Type, Value : Type)
	{
		key : Key;
		value : Value;
	}

	compare :: (a : Key_Value (string, int), b : Key_Value (string, int)) -> int #must
	{
		return str.compare (a.key, b.key);
	}
	
	compare_key :: (a : string, b : Key_Value (string, int)) -> int #must
	{
		return str.compare (a, b.key);
	}

	tree : avl.AVL_Tree (Key_Value (string, int), compare);
	avl.init (*tree);

	avl.insert (*tree, .{"Stefan",20});
	avl.insert (*tree, .{"Maxime",26});
	avl.insert (*tree, .{"Louis",21});
	avl.insert (*tree, .{"Paul",23});

	ptr := avl.find (tree, "Stefan", compare_key);
	assert (ptr != null);
	assert (ptr.value == 20);
}

main :: ()
{
	test_insert_erase ();
	test_find ();
}
