#scope_module

#import "Runtime";
mem  :: #import "Memory";
math :: #import "Math";
using linalg :: #import "Linalg";
algo :: #import "Algorithm";
hash :: #import "Hash";

array :: #import "Containers/Array";
storage :: #import "Containers/Storage";
for_expansion :: storage.for_expansion;
map :: #import "Containers/Hash_Map";
for_expansion :: map.for_expansion;

input  :: #import "Input";
imdraw :: #import "ImDraw";

#scope_export

UI_Context :: struct
{
	mouse_position : linalg.Vec2f;
	mouse_wheel    : linalg.Vec2f;
	viewport_size  : linalg.Vec2i;

	controls : storage.Storage (Control, 20);
	controls_by_id : map.Hash_Map (Id, *Control);
	occluders : [..]Occluder;
	mouse_hovered_occluder : Id;
	current_occluder : Id;
	frame_index : u64;
}

Id :: u32;

#add_context ui_context : *UI_Context;

Control :: struct
{
	id : Id;
	rect : math.Rectf;
	state : State;
	last_frame_index : u64;
}

Occluder :: struct
{
	id : Id;
	last_frame_index : u64;
	rect : math.Rectf;
	controls_to_draw : [..]*Control;
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
	array.init (*ui.occluders, 50, mem.HEAP_ALLOC);
}

terminate :: ()
{
	check_init ();
	storage.reset (*ui.controls);
	map.reset (*ui.controls_by_id);
	context.ui_context = mem.free (ui, mem.HEAP_ALLOC);
}

draw_control :: (ctrl : Control)
{
	color : math.RGBA;
	color.value = ctrl.id;
	color.a = 255;
	imdraw.draw_rect (ctrl.rect, color, corner_radius = 10);
	if ctrl.state == .HOVERED
		imdraw.draw_rect_outline (ctrl.rect, math.RGBA_WHITE, 2);
	else if ctrl.state == .DOWN
		imdraw.draw_rect_outline (ctrl.rect, .{ 100, 100, 100, 255 }, 2);
	else if ctrl.state == .RELEASED
		imdraw.draw_rect_outline (ctrl.rect, .{ 255, 0, 0, 255 }, 2);
}

draw_occluder :: (occl : Occluder)
{
	color : math.RGBA;
	color.value = occl.id;
	color.a = 255;
	imdraw.draw_rect (occl.rect, color, corner_radius = 10);

	for occl.controls_to_draw
		draw_control (it);
}

begin :: ()
{
	check_init ();

	ui.frame_index += 1;
}

end :: ()
{
	check_init ();

	// Remove unused controls
	for ui.controls
	{
		if it.last_frame_index != ui.frame_index
		{
			remove it;
			map.remove_at (*ui.controls_by_id, it.id);
		}
	}

	// Remove unused occluders
	for * ui.occluders
	{
		if it.last_frame_index != ui.frame_index
		{
			array.reset (*it.controls_to_draw);
			remove it;
		}
	}

	// Find occluding window
	ui.mouse_hovered_occluder = 0;
	for < ui.occluders
	{
		if math.contains (it.rect, ui.mouse_position)
		{
			ui.mouse_hovered_occluder = it.id;
			break;
		}
	}

	for ui.occluders
		draw_occluder (it);
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

find_or_create_control :: (id : Id) -> *Control #must
{
	check_init ();

	ctrl := map.get (*ui.controls_by_id, id);
	if !ctrl
	{
		ctrl = storage.find_free_slot (*ui.controls);
		ctrl.id = id;
		map.insert (*ui.controls_by_id, id, ctrl);
	}

	return ctrl;
}

declare_control :: (rect : math.Rectf, location : Source_Code_Location) -> State
{
	check_init ();

	occluder := find_occluder (ui.current_occluder);

	id := get_id (location);
	ctrl := find_or_create_control (id);
	if occluder
		ctrl.rect = math.move (rect, math.rect_position (occluder.rect));
	else
		ctrl.rect = rect;
	ctrl.last_frame_index = ui.frame_index;

	ctrl.state = State.INACTIVE;
	if math.contains (ctrl.rect, ui.mouse_position)
	&& (ui.mouse_hovered_occluder == 0 || ui.mouse_hovered_occluder == ui.current_occluder)
	{
		if input.is_mouse_button_down (.LEFT)
			ctrl.state = .DOWN;
		else if input.is_mouse_button_released (.LEFT)
			ctrl.state = .RELEASED;
		else
			ctrl.state = .HOVERED;
	}

	if ui.current_occluder
		array.push (*occluder.controls_to_draw, ctrl);
	else
		draw_control (ctrl);

	return ctrl.state;
}

find_occluder :: (id : Id) -> *Occluder, index : s64
{
	check_init ();

	for * ui.occluders
	{
		if it.id == id
			return it, it_index;
	}

	return null, -1;
}

begin_occlusion :: (rect : math.Rectf, location : Source_Code_Location)
{
	check_init ();

	id := get_id (location);

	occluder := find_occluder (id);
	if !occluder
	{
		occluder = array.push (*ui.occluders);
		occluder.id = id;
		array.init (*occluder.controls_to_draw, 50, mem.HEAP_ALLOC);
	}
	array.clear (*occluder.controls_to_draw);

	occluder.rect = rect;
	occluder.last_frame_index = ui.frame_index;
	ui.current_occluder = id;
}

end_occlusion :: ()
{
	check_init ();
	ui.current_occluder = 0;
}

raise_occluder :: (id : Id)
{
	check_init ();

	_, index := find_occluder (id);
	assert (index != -1);

	array.push (*ui.occluders, ui.occluders[index]);
	array.ordered_remove_at (*ui.occluders, index);
}
