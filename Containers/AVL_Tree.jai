#scope_module

#import "Runtime";
mem :: #import "Memory";
fmt :: #import "Fmt";

#scope_export

AVL_Node :: struct (T : Type, Relative_Pointer_Type := void)
{
	parent : *~Relative_Pointer_Type AVL_Node (T, Relative_Pointer_Type);
	left   : *~Relative_Pointer_Type AVL_Node (T, Relative_Pointer_Type);
	right  : *~Relative_Pointer_Type AVL_Node (T, Relative_Pointer_Type);
	balance_factor : s8;
	value : T;
}

AVL_Tree :: struct (T : Type, comp_func : (T, T) -> int = null, Relative_Pointer_Type := void)
{
	Node :: AVL_Node (T, Relative_Pointer_Type);

	root : *Node;
	count : s64;
	allocator : Allocator;

#if comp_func
	compare_values :: comp_func;
else
	compare_values :: (left, right) => left - right;
}

init :: (tree : *AVL_Tree, allocator := context.allocator)
{
	tree.root = null;
	tree.count = 0;
	tree.allocator = allocator;
}

reset :: (using tree : *AVL_Tree)
{
	node := leftmost (root);
	while node
	{
		next := successor (node);
		erase (tree, *node.value);
		node = next;
	}
}

clear :: reset;

is_right_child :: inline (using node : *AVL_Node) -> bool #must
{
	return node.parent != null && node == parent.right;
}

is_left_child :: inline (using node : *AVL_Node) -> bool #must
{
	return node.parent != null && node == parent.left;
}

rightmost :: inline (using node : *$T/AVL_Node) -> *T #must
{
	result := node;
	while result && result.right
		result = result.right;
	
	return result;
}

leftmost :: inline (using node : *$T/AVL_Node) -> *T #must
{
	result := node;
	while result && result.left
		result = result.left;
	
	return result;
}

successor :: inline (using node : *$T/AVL_Node) -> *T #must
{
	if right
		return leftmost (right);
	
	result := node;
	while result && result.parent && is_right_child (result)
		result = result.parent;
	
	if !result
		return null;

	return result.parent;
}

predecessor :: inline (using node : *$T/AVL_Node) -> *T #must
{
	if left
		return rightmost (left);
	
	result := node;
	while result && result.parent && is_left_child (result)
		result = result.parent;
	
	if !result
		return null;

	return result.parent;
}

#scope_module

get_node :: inline (tree : *AVL_Tree, val : *tree.T) -> *tree.Node
{
	ptr := cast (*void) val;
	ptr -= offset_of (tree.Node, "value");

	return cast (*tree.Node) ptr;
}

rotate_left :: inline (using tree : *AVL_Tree, parent : *tree.Node, $update_balance_factor := true) -> new_parent : *tree.Node
{
	node := parent.right;

	parent.right = node.left;
	if parent.right
		parent.right.parent = parent;

	node.parent = parent.parent;
	if !node.parent
		root = node;
	else if is_left_child (parent)
		node.parent.left = node;
	else
		node.parent.right = node;

	node.left = parent;
	node.left.parent = node;

	#if update_balance_factor
	{	
		if node.balance_factor == 0
		{
			parent.balance_factor = 1;
			node.balance_factor = -1;
		}
		else
		{
			parent.balance_factor = 0;
			node.balance_factor = 0;
		}
	}

	return node;
}

rotate_right :: inline (using tree : *AVL_Tree, parent : *tree.Node, $update_balance_factor := true) -> new_parent : *tree.Node
{
	node := parent.left;

	parent.left = node.right;
	if parent.left
		parent.left.parent = parent;

	node.parent = parent.parent;
	if !node.parent
		root = node;
	else if is_left_child (parent)
		node.parent.left = node;
	else
		node.parent.right = node;

	node.right = parent;
	node.right.parent = node;

	#if update_balance_factor
	{
		if node.balance_factor == 0
		{
			parent.balance_factor = -1;
			node.balance_factor = 1;
		}
		else
		{
			parent.balance_factor = 0;
			node.balance_factor = 0;
		}
	}

	return node;
}

rotate_right_left :: inline (using tree : *AVL_Tree, parent : *tree.Node) -> *tree.Node
{
	node := parent.right;
	node2 := node.left;
	rotate_right (tree, node, update_balance_factor = false);
	rotate_left (tree, parent, update_balance_factor = false);

	if node2.balance_factor == 0
	{
		parent.balance_factor = 0;
		node.balance_factor = 0;
	}
	else if node2.balance_factor > 0
	{
		parent.balance_factor = -1;
		node.balance_factor = 0;
	}
	else
	{
		parent.balance_factor = 0;
		node.balance_factor = 1;
	}

	node2.balance_factor = 0;

	return node2;
}

rotate_left_right :: inline (using tree : *AVL_Tree, parent : *tree.Node) -> *tree.Node
{
	node := parent.left;
	node2 := node.right;
	rotate_left (tree, node, update_balance_factor = false);
	rotate_right (tree, parent, update_balance_factor = false);

	if node2.balance_factor == 0
	{
		parent.balance_factor = 0;
		node.balance_factor = 0;
	}
	else if node2.balance_factor > 0
	{
		parent.balance_factor = 1;
		node.balance_factor = 0;
	}
	else
	{
		parent.balance_factor = 0;
		node.balance_factor = -1;
	}

	node2.balance_factor = 0;

	return node2;
}

#scope_export

insert :: (using tree : *AVL_Tree, value : tree.T) -> *tree.T, already_present : bool
{
	bst_insert :: inline (using tree : *AVL_Tree, value : tree.T) -> *tree.Node, already_present : bool
	{
		parent : *Node;
		curr := root;
		comp_result : int = ---;
		while curr
		{
			parent = curr;
			comp_result = compare_values (value, curr.value);
			if comp_result < 0
				curr = curr.left;
			else if comp_result > 0
				curr = curr.right;
			else
				return curr, true;
		}

		node := mem.alloc (Node, allocator, initialize = false);
		node.balance_factor = 0;
		node.value = value;

		if parent
		{
			if comp_result < 0
				parent.left = node;
			else
				parent.right = node;
		}
		else
			root = node;
		
		node.parent = parent;
		node.left = null;
		node.right = null;

		return node, false;
	}

	rebalance :: inline (using tree : *AVL_Tree, node : *tree.Node)
	{
		parent := node.parent;
		while parent
		{
			if is_right_child (node)
			{
				if parent.balance_factor > 0
				{
					if node.balance_factor < 0
						rotate_right_left (tree, parent);
					else
						rotate_left (tree, parent);
					
					break;
				}
				else if parent.balance_factor < 0
				{
					parent.balance_factor = 0;

					break;
				}
				else
				{
					parent.balance_factor = 1;
					node = parent;
					parent = node.parent;

					continue;
				}
			}
			else
			{
				if parent.balance_factor < 0
				{
					if node.balance_factor > 0
						rotate_left_right (tree, parent);
					else
						rotate_right (tree, parent);

					break;
				}
				else if parent.balance_factor > 0
				{
					parent.balance_factor = 0;

					break;
				}
				else
				{
					parent.balance_factor = -1;
					node = parent;
					parent = node.parent;

					continue;
				}
			}
		}
	}

	node, already_present := bst_insert (tree, value);
	if already_present
		return *node.value, true;

	rebalance (tree, node);

	count += 1;

	return *node.value, false;
}

erase :: (using tree : *AVL_Tree, ptr : *tree.T)
{
	bst_erase :: inline (using tree : *AVL_Tree, node : *tree.Node) -> *tree.Node
	{
		replacement : *Node;

		if !node.left && !node.right
			replacement = null;
		else if !node.right || !node.left
			replacement = ifx node.right then node.right else node.left;
		else
		{
			replacement = successor (node);

			if replacement != node.right
				bst_erase (tree, replacement);

			replacement.left = node.left;
			if replacement.left
				replacement.left.parent = replacement;
			
			replacement.right = node.right;
			if replacement.right
				replacement.right.parent = replacement;
		}

		if !node.parent
			root = replacement;
		else if node.parent.left == node
			node.parent.left = replacement;
		else if node.parent.right == node
			node.parent.right = replacement;
		
		if replacement
			replacement.parent = node.parent;
		
		return replacement;
	}

	retrace :: inline (using tree : *AVL_Tree, node : *tree.Node)
	{
		parent := node.parent;
		while parent
		{
			if is_left_child (node)
			{
				if parent.balance_factor > 0
				{
					balance_factor := parent.right.balance_factor;
					if balance_factor < 0
						rotate_right_left (tree, parent);
					else
						rotate_left (tree, parent);
	
					if balance_factor == 0
						break;
					
					node = parent;
					parent = node.parent;
				}
				else if parent.balance_factor < 0
				{
					node.balance_factor = 0;
					node = parent;
					parent = node.parent;

					continue;
				}
				else
				{
					parent.balance_factor = 1;

					break;
				}
			}
			else
			{
				if parent.balance_factor < 0
				{
					balance_factor := parent.left.balance_factor;
					if balance_factor < 0
						rotate_left_right (tree, parent);
					else
						rotate_right (tree, parent);
	
					if balance_factor == 0
						break;
					
					node = parent;
					parent = node.parent;
				}
				else if parent.balance_factor < 0
				{
					node.balance_factor = 0;
					node = parent;
					parent = node.parent;

					continue;
				}
				else
				{
					parent.balance_factor = -1;

					break;
				}
			}
		}
	}

	node := get_node (tree, ptr);
	replacement := bst_erase (tree, node);
	if replacement
		retrace (tree, replacement);
	
	mem.free (node);
	count -= 1;
}

erase :: inline (tree : *AVL_Tree, value : tree.T) -> bool
{
	ptr := find (tree, value);
	if ptr
	{
		erase (tree, ptr);

		return true;
	}

	return false;
}

find :: inline (tree : AVL_Tree, value : tree.T) -> *tree.T #must
{
	return find (tree, value, tree.compare_values);
}

find :: (tree : AVL_Tree, key : $T, compare_func : (T, tree.T) -> int) -> *tree.T #must
{
	node := tree.root;
	while node
	{
		comp := compare_func (key, node.value);
		if comp < 0
			node = node.left;
		else if comp > 0
			node = node.right;
		else
			return *node.value;
	}

	return null;
}

for_expansion :: (tree : *AVL_Tree, body : Code, flags : For_Flags) #expand
{
	BY_POINTER :: (flags & .POINTER) == .POINTER;
	REVERSE    :: (flags & .REVERSE) == .REVERSE;

	`it_index := 0;

	#if REVERSE
		node := rightmost (tree.root);
	else
		node := leftmost (tree.root);
	
	while node
	{
		defer
		{
			it_index += 1;

			#if REVERSE
				node = predecessor (node);
			else
				node = successor (node);
		}

		#if BY_POINTER
			`it := *node.value;
		else
			`it := node.value;

		#insert body;	// @Todo: remove
	}
}
