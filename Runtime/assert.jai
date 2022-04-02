#add_context panicking : bool;

contextless_panic :: inline (msg := "", location := #caller_location)
#no_context
{
	write_location (location);
	write_string (": Panic");
	if msg
	{
		write_string (": ");
		write_string (msg);
		write_string ("\n");
	}
	else
		write_string ("!\n");
	write_string ("Breaking into the debugger, if attached.\n");
	debug_break ();
}

contextless_assert :: inline (assertion : bool, msg := "", location := #caller_location)
#no_context
{
	if !assertion
	{
		write_location (location);
		write_string (": Assertion failed");
		if msg
		{
			write_string (": ");
			write_string (msg);
			write_string ("\n");
		}
		else
			write_string ("!\n");
		write_string ("Breaking into the debugger, if attached.\n");
		debug_break ();
	}
}

always_panic :: inline (fmt_str := "", args : ..Any, location := #caller_location)
{
	if !context.panicking
	{
		context.panicking = true;
		msg := fmt.format (mem.HEAP_ALLOC, fmt_str, ..args);
		defer no_inline mem.free (msg, mem.HEAP_ALLOC);
		context.assertion_failed (location, msg);
		context.panicking = false;
	}
}

always_assert :: inline (assertion : bool, fmt_str := "", args : ..Any, location := #caller_location)
{
	if !assertion && !context.handling_assertion_failure
	{
		context.handling_assertion_failure = true;
		msg := fmt.format (mem.HEAP_ALLOC, fmt_str, ..args);
		defer no_inline mem.free (msg, mem.HEAP_ALLOC);
		context.assertion_failed (location, msg);
		context.handling_assertion_failure = false;
	}
}

panic :: (fmt_str := "", args : ..Any, location := #caller_location) #expand
{
	#if ENABLE_ASSERTS
		always_panic (fmt_str, ..args, location);
}

// @Note (stefan): We take a Code instead of a bool so we choose whether or not the expression gets
// evaluated ourselves. The expression we want to assert might take a long time to execute, so we
// need to be able to not evaluate the expression when assertions are disabled, otherwise we won't get
// much of a performance boost in release builds.
assert :: (assertion_expr : Code, fmt_str := "", args : ..Any, location := #caller_location) #expand
{
	#if ENABLE_ASSERTS
		always_assert (#insert assertion_expr, fmt_str, ..args, location);
}

assertion_failed :: (location : Source_Code_Location, msg : string)
{
	write_stack_trace :: (node : *Stack_Trace_Node)
	{
		while node
		{
			// There are two different line numbers available.
			// node.info.location has a line number, but this is the location of
			// the start of the procedure. That may be useful in some cases, but often
			// what we really want is the line number of the procedure call, which is
			// stored in node.line_number. That's what we print in this case.
			if node.info
			{
				write_string (node.info.location.fully_pathed_filename);
				write_string (":");
				write_nonnegative_number (node.line_number);
				write_string (": ");
				if node.info.name
					write_string (node.info.name);
				else
					write_string ("(anonymous procedure)");
				write_string ("\n");
			}
			node = node.next;
		}
	}

	write_location (location);
	if context.panicking
		write_string (": Panic");
	else
		write_string (": Assertion failed");

	if msg
	{
		write_string (": ");
		write_string (msg);
		write_string ("\n");
	}
	else
		write_string ("!\n");

	if context.stack_trace
	{
		write_string ("\nStack trace:\n");
		write_stack_trace (context.stack_trace);
	}
	else
		write_string ("Breaking into the debugger, if attached.\n");
	debug_break ();
}

#scope_file

write_location :: inline (loc : Source_Code_Location)
#no_context
{
	write_string (loc.fully_pathed_filename);
	write_string (":");
	write_number (loc.line_number);
	write_string (",");
	write_number (loc.character_number);
}

#scope_export
