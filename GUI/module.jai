#scope_module

#import "Runtime";
mem  :: #import "Memory";
fmt  :: #import "Fmt";
math :: #import "Math";
using linalg :: #import "Linalg";
algo :: #import "Algorithm";
hash :: #import "Hash";

array :: #import "Containers/Array";
storage :: #import "Containers/Storage";
for_expansion :: storage.for_expansion;
map :: #import "Containers/Hash_Map";
for_expansion :: map.for_expansion;

render :: #import "Render_Core";
imdraw :: #import "ImDraw";
font   :: #import "Font";
input  :: #import "Input";

#scope_export

#load "widgets/widgets.jai";

UI_Context :: struct
{
	mouse_position : linalg.Vec2f;
	mouse_wheel    : linalg.Vec2f;
	viewport_size  : linalg.Vec2i;
	delta_time     : f32;

	interacted_this_frame : bool;
	mouse_interacting_control : *Control;
	mouse_focused_control_this_frame : *Control;

	controls : storage.Storage (Control, 20);
	controls_by_id : map.Hash_Map (Id, *Control);
	clipping_stack : [..]math.Rectf;

	occlusion_layers : [..]Occlusion_Layer;
	#place occlusion_layers;
	occlusion_layers_bottommost_to_topmost : [..]Occlusion_Layer;

	mouse_focused_occluder : *Occluder;

	current_occlusion_layer : s64;
	current_occluder : *Occluder;

	frame_index : u64;

	renderer : imdraw.Command_Renderer;
}

#add_context ui_context : *UI_Context;

Id :: u32;

Focus_State :: enum_flags u8
{
	NONE     :: 0x00;
	FOCUSED  :: 0x01;
	PRESSED  :: 0x02;
	DOUBLE_PRESSED :: 0x04;
	DOWN     :: 0x08;
	RELEASED :: 0x10;
}

Control :: struct
{
	State_Flags :: enum_flags u8
	{
		NONE     :: 0x00;
		FOCUSED  :: 0x01;
		HOT      :: 0x02;
		INTERACTING :: 0x04;
		DISABLED :: 0x08;
	}

	Flags :: enum_flags u16
	{
		NONE       :: 0x00;
		FOCUSABLE  :: 0x01;	// If not set then interaction is ignored

		// An interaction is the action of changing the active status
		INTERACT_ON_PRESSED  :: 0x1000;
		INTERACT_ON_HELD     :: 0x2000;
		INTERACT_ON_RELEASED :: 0x4000;
		// Useful for scrollbars and sliders
		CONTINUE_INTERACTION_WHEN_UNFOCUSED :: 0x8000;
		DEFAULT_INTERACTION :: INTERACT_ON_RELEASED;
		INTERACTION_FLAGS   ::
			INTERACT_ON_PRESSED
			| INTERACT_ON_HELD
			| INTERACT_ON_RELEASED
			| CONTINUE_INTERACTION_WHEN_UNFOCUSED;
	}

	id : Id;

	last_frame_index : u64;
	flags : Flags;
	focus_state : Focus_State;
	prev_state_flags : State_Flags;
	state_flags : State_Flags;
	state_time : f32;
	relative_mouse_position_when_started_interacting : linalg.Vec2f;

	rect : math.Rectf;
	clipped_rect : math.Rectf;
}

Occlusion_Layer :: struct
{
	name : string;
	occluders : storage.Storage (Occluder, 20);
	occluders_by_id : map.Hash_Map (Id, *Occluder);
	occluders_bottommost_to_topmost : [..]*Occluder;
}

Occluder :: struct
{
	id : Id;
	index : s64;
	rect : math.Rectf;
	last_frame_index : u64;
	renderer : imdraw.Command_Renderer;
}

State :: enum
{
	INACTIVE :: 0;
	HOVERED  :: 1;
	DOWN     :: 2;
	RELEASED :: 3;
}

check_init :: () #expand
{
	`ui := context.ui_context;
	assert (ui != null, "No UI context.");
}

init :: ()
{
	assert (context.ui_context == null, "UI context is already initialized.");
	context.ui_context = mem.alloc (UI_Context, mem.HEAP_ALLOC);
	ui := context.ui_context;
	storage.init (*ui.controls, mem.HEAP_ALLOC);
	map.init (*ui.controls_by_id, 300, mem.HEAP_ALLOC);
	array.init (*ui.clipping_stack, 50, mem.HEAP_ALLOC);
	array.init (*ui.occlusion_layers, 50, mem.HEAP_ALLOC);
	imdraw.init (*ui.renderer, 5000, 1000, mem.HEAP_ALLOC);

	push_occlusion_layer ("Popups");
	push_occlusion_layer ("Windows");
}

terminate :: ()
{
	check_init ();

	for * layer : ui.occlusion_layers
	{
		for * layer.occluders
			cleanup (it);

		array.reset (*layer.occluders_bottommost_to_topmost);
		map.reset (*layer.occluders_by_id);
		storage.reset (*layer.occluders);
	}

	storage.reset (*ui.controls);
	map.reset (*ui.controls_by_id);
	array.reset (*ui.clipping_stack);
	imdraw.reset (*ui.renderer);

	mem.free (ui, mem.HEAP_ALLOC);
	context.ui_context = null;
}

// For expansion
draw_data :: (ctx : *UI_Context, body : Code, flags : For_Flags) #expand
{
	`it := *ctx.renderer;
	`it_index := 0;
	#insert body;
	for layer, layer_index : ctx.occlusion_layers_bottommost_to_topmost
	{
		for occl, occl_index : layer.occluders_bottommost_to_topmost
		{
			it = *occl.renderer;
			it_index += 1;
			#insert body;
		}
	}
}

#scope_file

init :: (layer : *Occlusion_Layer, name : string)
{
	layer.name = name;
	storage.init (*layer.occluders, mem.HEAP_ALLOC);
	map.init (*layer.occluders_by_id, 100, mem.HEAP_ALLOC);
	array.init (*layer.occluders_bottommost_to_topmost, 100, mem.HEAP_ALLOC);
}

#scope_export

push_occlusion_layer :: inline (name : string)
{
	check_init ();

	layer := array.push (*ui.occlusion_layers_bottommost_to_topmost);
	init (layer, name);
}

insert_occlusion_layer :: inline (name : string)
{
	check_init ();

	layer := array.insert_at (*ui.occlusion_layers_bottommost_to_topmost, ui.current_occlusion_layer);
	ui.current_occlusion_layer += 1;
	init (layer, name);
}

get_occlusion_layer :: (name : string) -> s64 #must
{
	check_init ();

	for ui.occlusion_layers_bottommost_to_topmost
	{
		if it.name == name
			return it_index;
	}

	return -1;
}

set_occlusion_layer :: inline (name : string) -> previous : s64
{
	check_init ();

	index := get_occlusion_layer (name);
	assert (index >= 0, "Occlusion layer '%' does not exist.", name);

	return set_occlusion_layer (index);
}

set_occlusion_layer :: inline (index : s64) -> previous : s64
{
	check_init ();

	assert (index >= 0 && index < ui.occlusion_layers.count, "Invalid occlusion layer index.");
	assert (ui.current_occluder == null, "Cannot change the occlusion layer in between begin_occlusion and end_occlusion calls.");
	previous := ui.current_occlusion_layer;
	ui.current_occlusion_layer = index;

	return previous;
}

get_renderer :: inline () -> *imdraw.Command_Renderer #must
{
	check_init ();
	if ui.current_occluder
		return *ui.current_occluder.renderer;
	return *ui.renderer;
}

begin :: ()
{
	check_init ();

	ui.frame_index += 1;
	ui.interacted_this_frame = false;
	ui.mouse_focused_control_this_frame = null;
	imdraw.clear (*ui.renderer);
}

end :: ()
{
	check_init ();

	assert (ui.clipping_stack.count == 0, "Called end but the clipping stack is not empty. % clipping rects were not popped.", ui.clipping_stack.count);

	// Remove controls that were not declared this frame
	for ui.controls
	{
		if it.last_frame_index != ui.frame_index
		{
			map.remove_at (*ui.controls_by_id, it.id);
			remove it;
		}
	}

	// Remove occluders that were not declared this frame
	for * layer : ui.occlusion_layers
	{
		removed_an_occluder := false;
		for layer.occluders_bottommost_to_topmost
		{
			if it.last_frame_index != ui.frame_index
			{
				cleanup (it);

				map.remove_at (*layer.occluders_by_id, it.id);
				storage.release_slot (*layer.occluders, it);
				// We can't do `remove it` because it does not keep the order
				array.remove_at (*layer.occluders_bottommost_to_topmost, it_index);
				removed_an_occluder = true;
			}
		}
		// Update occluders indices if we removed one
		if removed_an_occluder
		{
			for layer.occluders_bottommost_to_topmost
				it.index = it_index;
		}
	}

	// Reset mouse interaction
	if !ui.interacted_this_frame
	{
		ui.mouse_interacting_control = null;

		// Find occluder focused by the mouse, but only if a control isn't already interacting
		ui.mouse_focused_occluder = null;
		for < layer : ui.occlusion_layers_bottommost_to_topmost
		{
			for < layer.occluders_bottommost_to_topmost
			{
				if math.contains (it.rect, ui.mouse_position)
				{
					ui.mouse_focused_occluder = it;
					break layer;
				}
			}
		}
	}

	for :draw_data data : ui
		imdraw.draw_to_framebuffer (data);
}

set_mouse_interacting_control :: inline (ctrl : *Control)
{
	check_init ();
	ui.mouse_interacting_control = ctrl;
	ui.interacted_this_frame = true;
}

get_id :: (location : Source_Code_Location) -> Id #must
{
	combine_hashes :: inline (a : u32, b : u32) -> u32 #must
	{
		return a ^ (b + 0x9e3779b9 + (a << 6) + (a >> 2));
	}

	// @Speed (stefan): We could use the data pointer of the filename,
	// but I kinda want ids to be the same across runs of the program.
	// At least for now.
	path_hash := hash.default (location.fully_pathed_filename);
	line_hash := hash.default (location.line_number);
	char_hash := hash.default (location.character_number);
	h := combine_hashes (combine_hashes (path_hash, line_hash), char_hash);
	// The id 0 is reserved
	if h == 0
		h = 69105;

	return h;
}

get_focus_state :: (using ctrl : *Control) -> Focus_State #must
{
	check_init ();

	if ui.mouse_focused_control_this_frame
		return .NONE;
	if ui.mouse_focused_occluder && ui.mouse_focused_occluder != ui.current_occluder
		return .NONE;
	if ui.mouse_interacting_control && ui.mouse_interacting_control != ctrl
		return .NONE;
	if !flagged (flags, .FOCUSABLE)
		return .NONE;

	focused := math.contains (clipped_rect, ui.mouse_position);

	mouse_left_pressed  := input.is_mouse_button_pressed (.LEFT);
	mouse_left_down     := input.is_mouse_button_down (.LEFT);
	mouse_left_released := input.is_mouse_button_released (.LEFT);

	// If we were focused previously, and we don't want to stop the interaction
	// when we are unfocused, then continue focusing if interacting.
	if flagged (focus_state, .FOCUSED)
	&& flagged (flags, .CONTINUE_INTERACTION_WHEN_UNFOCUSED)
	{
		if flagged (flags, .INTERACT_ON_PRESSED) && mouse_left_pressed
			focused = true;
		if flagged (flags, .INTERACT_ON_HELD) && mouse_left_down
			focused = true;
		if flagged (flags, .INTERACT_ON_RELEASED) && mouse_left_released
			focused = true;
	}

	result : Focus_State;
	if focused
	{
		result |= .FOCUSED;
		if mouse_left_pressed
			result |= .PRESSED;
		if mouse_left_down
			result |= .DOWN;
		if mouse_left_released
			result |= .RELEASED;
	}

	return result;
}

find_or_create_control :: (id : Id) -> *Control #must, created_this_frame : bool
{
	check_init ();

	ctrl := map.get (*ui.controls_by_id, id);
	if !ctrl
	{
		ctrl = storage.find_free_slot (*ui.controls);
		ctrl.id = id;
		map.insert (*ui.controls_by_id, id, ctrl);

		return ctrl, true;
	}

	return ctrl, false;
}

declare_control :: (
	rect : math.Rectf,
	location : Source_Code_Location,
	flags : Control.Flags,
	id_offset : u32 = 0
) -> *Control, created_this_frame : bool
{
	check_init ();

	ctrl, created_this_frame := find_or_create_control (get_id (location) + id_offset);

	if ui.current_occluder
		ctrl.rect = math.move (rect, math.rect_position (ui.current_occluder.rect));
	else
		ctrl.rect = rect;

	if ui.clipping_stack.count > 0
		ctrl.clipped_rect = math.clip (ctrl.rect, array.top (ui.clipping_stack));
	else
		ctrl.clipped_rect = ctrl.rect;

	ctrl.last_frame_index = ui.frame_index;
	ctrl.flags = flags;
	ctrl.state_flags &= ~.HOT;
	ctrl.state_flags &= ~.INTERACTING;
	ctrl.state_flags &= ~.FOCUSED;

	is_disabled := false;	// @Todo
	// Update focus state
	if is_disabled
	{
		ctrl.focus_state = .NONE;
		ctrl.state_flags |= .DISABLED;
		ctrl.state_flags &= ~.INTERACTING;
	}
	else if flagged (ctrl.flags, .FOCUSABLE)
	{
		ctrl.focus_state = get_focus_state (ctrl);
		if flagged (ctrl.focus_state, .FOCUSED)
			ui.mouse_focused_control_this_frame = ctrl;

		if flagged (ctrl.flags, .INTERACT_ON_HELD)
		&& flagged (ctrl.focus_state, .PRESSED)
			ctrl.state_flags |= .HOT;
		if flagged (ctrl.flags, .INTERACT_ON_RELEASED)
		&& flagged (ctrl.focus_state, .DOWN)
			ctrl.state_flags |= .HOT;

		// We only want to interact if we were hot beforehand, or
		// if we were already interacting, for controls with which
		// we interact more than one frame.
		// The reason for that is because for controls that interact
		// on held, we don't want interaction to happen if the mouse
		// enters the control's rect while the left mouse button is down.
		if flagged (ctrl.prev_state_flags, .HOT) || flagged (ctrl.prev_state_flags, .INTERACTING)
		{
			if flagged (ctrl.flags, .INTERACT_ON_PRESSED)
			&& flagged (ctrl.focus_state, .PRESSED)
				ctrl.state_flags |= .INTERACTING;
			if flagged (ctrl.flags, .INTERACT_ON_HELD)
			&& flagged (ctrl.focus_state, .DOWN)
				ctrl.state_flags |= .INTERACTING;
			if flagged (ctrl.flags, .INTERACT_ON_RELEASED)
			&& flagged (ctrl.focus_state, .RELEASED)
				ctrl.state_flags |= .INTERACTING;
		}

		if flagged (ctrl.state_flags, .INTERACTING)
		{
			set_mouse_interacting_control (ctrl);
			// Update the relative mouse position if we started interacting
			if !flagged (ctrl.prev_state_flags, .INTERACTING)
				ctrl.relative_mouse_position_when_started_interacting = ui.mouse_position - math.rect_position (ctrl.rect);
		}
	}

	if ctrl.state_flags != ctrl.prev_state_flags
	{
		ctrl.prev_state_flags = ctrl.state_flags;
		ctrl.state_time = 0;
	}
	else
		ctrl.state_time += ui.delta_time;

	return ctrl, created_this_frame;
}

push_clipping_rect :: inline (rect : math.Rectf)
{
	check_init ();
	array.push (*ui.clipping_stack, rect);
}

pop_clipping_rect :: inline ()
{
	check_init ();
	array.pop (*ui.clipping_stack);
}

#scope_file

init :: (occluder : *Occluder)
{
	imdraw.init (*occluder.renderer, 1000, 100, mem.HEAP_ALLOC);
}

cleanup :: (occluder : *Occluder)
{
	imdraw.reset (*occluder.renderer);
}

#scope_export

find_or_create_occluder :: (id : Id) -> *Occluder #must, created_this_frame : bool
{
	check_init ();

	assert (ui.occlusion_layers.count > 0, "No occlusion layer. Use push_occlusion_layer to create a new layer.");
	layer := *ui.occlusion_layers[ui.current_occlusion_layer];
	occl := map.get (*layer.occluders_by_id, id);
	if !occl
	{
		occl = storage.find_free_slot (*layer.occluders);
		occl.id = id;
		init (occl);

		map.insert (*layer.occluders_by_id, id, occl);
		array.push (*layer.occluders_bottommost_to_topmost, occl);
		occl.index = layer.occluders_bottommost_to_topmost.count - 1;

		return occl, true;
	}

	return occl, false;
}

begin_occlusion :: (rect : math.Rectf, location : Source_Code_Location, set_rect_once : bool) -> *Occluder, created_this_frame : bool
{
	check_init ();

	assert (ui.current_occluder == null, "Cannot call begin_occlusion in between begin_occlusion and end_occlusion calls. Did you forget to call end_occlusion?");

	occluder, created_this_frame := find_or_create_occluder (get_id (location));
	if !set_rect_once || (set_rect_once && created_this_frame)
		occluder.rect = rect;
	occluder.last_frame_index = ui.frame_index;
	imdraw.clear (*occluder.renderer);
	push_clipping_rect (occluder.rect);

	ui.current_occluder = occluder;

	return occluder, created_this_frame;
}

end_occlusion :: ()
{
	check_init ();

	assert (ui.current_occluder != null, "Called end_occlusion but begin_occlusion was not called. Did you call end_occlusion twice?");
	ui.current_occluder = null;
	pop_clipping_rect ();
}

raise_occluder :: ()
{
	check_init ();

	assert (ui.current_occluder != null, "Cannot call raise_occluder outside begin_occlusion and end_occlusion calls.");

	layer := *ui.occlusion_layers[ui.current_occlusion_layer];

	// Don't do anything if we are already the topmost occluder
	if ui.current_occluder.index == layer.occluders_bottommost_to_topmost.count - 1
		return;

	// Update the index of the occluders that are above
	for i : ui.current_occluder.index + 1..layer.occluders_bottommost_to_topmost.count - 1
		layer.occluders_bottommost_to_topmost[i].index -= 1;

	array.push (*layer.occluders_bottommost_to_topmost, ui.current_occluder);
	array.ordered_remove_at (*layer.occluders_bottommost_to_topmost, ui.current_occluder.index);
	ui.current_occluder.index = layer.occluders_bottommost_to_topmost.count - 1;
}
