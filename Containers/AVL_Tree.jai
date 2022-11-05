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
	compare_values :: (left, right) => ifx left < right then -1 else ifx left > right then 1 else 0;
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

rotate_left :: inline (using tree : *AVL_Tree, parent : *tree.Node) -> new_parent : *tree.Node
{
	node := parent.right;

	parent.right = node.left;
	if parent.right
		parent.right.parent = parent;

	node.parent = parent.parent;
	if parent == root
		root = node;
	else if is_left_child (parent)
		parent.parent.left = node;
	else
		parent.parent.right = node;

	node.left = parent;
	node.left.parent = node;

	return node;
}

rotate_right :: inline (using tree : *AVL_Tree, parent : *tree.Node) -> new_parent : *tree.Node
{
	node := parent.left;

	parent.left = node.right;
	if parent.left
		parent.left.parent = parent;

	node.parent = parent.parent;
	if parent == root
		root = node;
	else if is_left_child (parent)
		parent.parent.left = node;
	else
		parent.parent.right = node;

	node.right = parent;
	node.right.parent = node;

	return node;
}

#scope_export

insert :: (using tree : *AVL_Tree, value : tree.T) -> *tree.T, already_present : bool
{
	fix_left_imbalance :: (using tree : *AVL_Tree, parent : *tree.Node) -> *tree.Node
	{
		assert (parent.left != null, "Parent has no left child.");
		if parent.left.balance_factor == parent.balance_factor
		{
			parent = rotate_right (tree, parent);
			parent.balance_factor = 0;
			parent.right.balance_factor = 0;
		}
		else
		{
			old_bf := parent.left.right.balance_factor;
			rotate_left (tree, parent.left);
			parent = rotate_right (tree, parent);
			
			parent.balance_factor = 0;
			if old_bf ==
			{
			case -1;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 1;
			case 1;
				parent.left.balance_factor = -1;
				parent.right.balance_factor = 0;
			case 0;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 0;
			}
		}

		return parent;
	}

	fix_right_imbalance :: (using tree : *AVL_Tree, parent : *tree.Node) -> *tree.Node
	{
		assert (parent.right != null, "Parent has no right child.");
		if parent.right.balance_factor == parent.balance_factor
		{
			parent = rotate_left (tree, parent);
			parent.balance_factor = 0;
			parent.left.balance_factor = 0;
		}
		else
		{
			old_bf := parent.right.left.balance_factor;
			rotate_right (tree, parent.right);
			parent = rotate_left (tree, parent);
			
			parent.balance_factor = 0;
			if old_bf ==
			{
			case -1;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 1;
			case 1;
				parent.left.balance_factor = -1;
				parent.right.balance_factor = 0;
			case 0;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 0;
			}
		}

		return parent;
	}

	curr := root;
	parent : *Node;
	comp_result : int;

	while curr
	{
		parent = curr;

		comp_result = compare_values (value, curr.value);
		if comp_result < 0
			curr = curr.left;
		else if comp_result > 0
			curr = curr.right;
		else
			return *curr.value, true;
	}

	node := mem.alloc (Node, allocator, initialize = false);
	node.value = value;
	node.balance_factor = 0;
	node.parent = parent;
	node.left = null;
	node.right = null;

	if !parent
		root = node;
	else if comp_result < 0
		parent.left = node;
	else
		parent.right = node;

	count += 1;

	while parent
	{
		if is_left_child (node)
		{
			if parent.balance_factor ==
			{
			case 1;
				parent.balance_factor = 0;

				break;
			case 0;
				parent.balance_factor = -1;

			case -1;
				fix_left_imbalance (tree, parent);

				break;
			}
		}
		else
		{
			if parent.balance_factor ==
			{
			case -1;
				parent.balance_factor = 0;

				break;
			case 0;
				parent.balance_factor = 1;

			case 1;
				fix_right_imbalance (tree, parent);

				break;
			}
		}

		node = parent;
		parent = node.parent;
	}

	return *node.value, false;
}

erase :: (using tree : *AVL_Tree, ptr : *tree.T)
{
	fix_left_imbalance :: (using tree : *AVL_Tree, parent : *tree.Node) -> *tree.Node
	{
		assert (parent.left != null, "Parent has no left child.");
		if parent.left.balance_factor ==
		{
		case -1;
			parent = rotate_right (tree, parent);
			parent.balance_factor = 0;
			parent.right.balance_factor = 0;
		
		case 0;
			parent = rotate_right (tree, parent);
			parent.balance_factor = 1;
			parent.right.balance_factor = -1;
	
		case 1;
			old_bf := parent.left.right.balance_factor;
			rotate_left (tree, parent.left);
			parent = rotate_right (tree, parent);
			
			parent.balance_factor = 0;
			if old_bf ==
			{
			case -1;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 1;
			case 1;
				parent.left.balance_factor = -1;
				parent.right.balance_factor = 0;
			case 0;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 0;
			}
		}

		return parent;
	}

	fix_right_imbalance :: (using tree : *AVL_Tree, parent : *tree.Node) -> *tree.Node
	{
		assert (parent.right != null, "Parent has no right child.");
		if parent.right.balance_factor ==
		{
		case 1;
			parent = rotate_left (tree, parent);
			parent.balance_factor = 0;
			parent.left.balance_factor = 0;
		
		case 0;
			parent = rotate_left (tree, parent);
			parent.balance_factor = -1;
			parent.left.balance_factor = 1;
	
		case -1;
			old_bf := parent.right.left.balance_factor;
			rotate_right (tree, parent.right);
			parent = rotate_left (tree, parent);
			
			parent.balance_factor = 0;
			if old_bf ==
			{
			case -1;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 1;
			case 1;
				parent.left.balance_factor = -1;
				parent.right.balance_factor = 0;
			case 0;
				parent.left.balance_factor = 0;
				parent.right.balance_factor = 0;
			}
		}

		return parent;
	}

	node := get_node (tree, ptr);

	target : *Node;
	if !node.left || !node.right
	{
		target = node;
	}
	else
	{
		target = successor (node);
		node.value = target.value;
	}

	node = target;
	parent := node.parent;
	while parent
	{
		if is_left_child (node)
		{
			if parent.balance_factor ==
			{
			case -1;
				parent.balance_factor = 0;
			
			case 0;
				parent.balance_factor = 1;

				break;
			
			case 1;
				parent = fix_right_imbalance (tree, parent);
				if parent.balance_factor == -1
					break;
			}
		}
		else
		{
			if parent.balance_factor ==
			{
			case 1;
				parent.balance_factor = 0;
			
			case 0;
				parent.balance_factor = -1;

				break;
			
			case -1;
				parent = fix_left_imbalance (tree, parent);
				if parent.balance_factor == 1
					break;
			}
		}

		node = parent;
		parent = node.parent;
	}

	// Replace target node with its child
	child := ifx target.right then target.right else target.left;

	if child
		child.parent = target.parent;
	
	if !target.parent
		root = child;
	else if is_left_child (target)
		target.parent.left = child;
	else
		target.parent.right = child;
	
	mem.free (target, allocator);
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
