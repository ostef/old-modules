//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



IMGUI_VERSION :: "1.89 WIP";
IMGUI_VERSION_NUM :: 18802;

IMGUI_PAYLOAD_TYPE_COLOR_3F :: "_COL3F";
IMGUI_PAYLOAD_TYPE_COLOR_4F :: "_COL4F";

IM_UNICODE_CODEPOINT_INVALID :: 0xFFFD;

IM_UNICODE_CODEPOINT_MAX :: 0xFFFF;

IM_COL32_R_SHIFT :: 0;
IM_COL32_G_SHIFT :: 8;
IM_COL32_B_SHIFT :: 16;
IM_COL32_A_SHIFT :: 24;
IM_COL32_A_MASK :: 0xFF000000;

IM_DRAWLIST_TEX_LINES_WIDTH_MAX :: 63;

ImDrawListSharedData :: struct {}

ImFontBuilderIO :: struct {}

Context :: struct {}

NavInput :: s32;

ImTextureID :: *void;

ImDrawIdx :: u16;

// Scalar data types
ID :: u32;
ImS8 :: s8;
ImU8 :: u8;
ImS16 :: s16;
ImU16 :: u16;
ImS32 :: s32;
ImU32 :: u32;
ImS64 :: s64;
ImU64 :: u64;

// Character types
// (we generally use UTF-8 encoded string in the API. This is storage specifically for a decoded character used for keyboard input and display)
ImWchar16 :: u16;
ImWchar32 :: u32;

ImWchar :: ImWchar16;

// Callback and functions types
InputTextCallback :: #type (data: *InputTextCallbackData) -> s32 #c_call;
SizeCallback :: #type (data: *SizeCallbackData) -> void #c_call;
MemAllocFunc :: #type (sz: size_t, user_data: *void) -> *void #c_call;
MemFreeFunc :: #type (ptr: *void, user_data: *void) -> void #c_call;
//-----------------------------------------------------------------------------
// [SECTION] Dear ImGui end-user API functions
// (Note that ImGui:: being a namespace, you can add extra ImGui:: functions in your own separate file. Please don't modify imgui source files!)
//-----------------------------------------------------------------------------

// Context creation and access
// - Each context create its own ImFontAtlas by default. You may instance one yourself and pass it to CreateContext() to share a font atlas between contexts.
// - DLL users: heaps and globals are not shared across DLL boundaries! You will need to call SetCurrentContext() + SetAllocatorFunctions()
//   for each static/DLL boundary you are calling from. Read "Context and Memory Allocators" section of imgui.cpp for details.
CreateContext :: (shared_font_atlas: *ImFontAtlas = null) -> *Context #foreign imgui "?CreateContext@ImGui@@YAPEAUImGuiContext@@PEAUImFontAtlas@@@Z";
DestroyContext :: (ctx: *Context = null) -> void #foreign imgui "?DestroyContext@ImGui@@YAXPEAUImGuiContext@@@Z";
GetCurrentContext :: () -> *Context #foreign imgui "?GetCurrentContext@ImGui@@YAPEAUImGuiContext@@XZ";
SetCurrentContext :: (ctx: *Context) -> void #foreign imgui "?SetCurrentContext@ImGui@@YAXPEAUImGuiContext@@@Z";

// Main
GetIO :: () -> *IO #foreign imgui "?GetIO@ImGui@@YAAEAUImGuiIO@@XZ";
GetStyle :: () -> *Style #foreign imgui "?GetStyle@ImGui@@YAAEAUImGuiStyle@@XZ";
NewFrame :: () -> void #foreign imgui "?NewFrame@ImGui@@YAXXZ";
EndFrame :: () -> void #foreign imgui "?EndFrame@ImGui@@YAXXZ";
Render :: () -> void #foreign imgui "?Render@ImGui@@YAXXZ";
GetDrawData :: () -> *ImDrawData #foreign imgui "?GetDrawData@ImGui@@YAPEAUImDrawData@@XZ";

// Demo, Debug, Information
ShowDemoWindow :: (p_open: *bool = null) -> void #foreign imgui "?ShowDemoWindow@ImGui@@YAXPEA_N@Z";
ShowMetricsWindow :: (p_open: *bool = null) -> void #foreign imgui "?ShowMetricsWindow@ImGui@@YAXPEA_N@Z";
ShowDebugLogWindow :: (p_open: *bool = null) -> void #foreign imgui "?ShowDebugLogWindow@ImGui@@YAXPEA_N@Z";
ShowStackToolWindow :: (p_open: *bool = null) -> void #foreign imgui "?ShowStackToolWindow@ImGui@@YAXPEA_N@Z";
ShowAboutWindow :: (p_open: *bool = null) -> void #foreign imgui "?ShowAboutWindow@ImGui@@YAXPEA_N@Z";
ShowStyleEditor :: (ref: *Style = null) -> void #foreign imgui "?ShowStyleEditor@ImGui@@YAXPEAUImGuiStyle@@@Z";
ShowStyleSelector :: (label: *u8) -> bool #foreign imgui "?ShowStyleSelector@ImGui@@YA_NPEBD@Z";
ShowFontSelector :: (label: *u8) -> void #foreign imgui "?ShowFontSelector@ImGui@@YAXPEBD@Z";
ShowUserGuide :: () -> void #foreign imgui "?ShowUserGuide@ImGui@@YAXXZ";
GetVersion :: () -> *u8 #foreign imgui "?GetVersion@ImGui@@YAPEBDXZ";

// Styles
StyleColorsDark :: (dst: *Style = null) -> void #foreign imgui "?StyleColorsDark@ImGui@@YAXPEAUImGuiStyle@@@Z";
StyleColorsLight :: (dst: *Style = null) -> void #foreign imgui "?StyleColorsLight@ImGui@@YAXPEAUImGuiStyle@@@Z";
StyleColorsClassic :: (dst: *Style = null) -> void #foreign imgui "?StyleColorsClassic@ImGui@@YAXPEAUImGuiStyle@@@Z";

// Windows
// - Begin() = push window to the stack and start appending to it. End() = pop window from the stack.
// - Passing 'bool* p_open != NULL' shows a window-closing widget in the upper-right corner of the window,
//   which clicking will set the boolean to false when clicked.
// - You may append multiple times to the same window during the same frame by calling Begin()/End() pairs multiple times.
//   Some information such as 'flags' or 'p_open' will only be considered by the first call to Begin().
// - Begin() return false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting
//   anything to the window. Always call a matching End() for each Begin() call, regardless of its return value!
//   [Important: due to legacy reason, this is inconsistent with most other functions such as BeginMenu/EndMenu,
//    BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding BeginXXX function
//    returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
// - Note that the bottom of window stack always contains a window called "Debug".
Begin :: (name: *u8, p_open: *bool = null, flags: WindowFlags = .None) -> bool #foreign imgui "?Begin@ImGui@@YA_NPEBDPEA_NH@Z";
End :: () -> void #foreign imgui "?End@ImGui@@YAXXZ";

// Child Windows
// - Use child windows to begin into a self-contained independent scrolling/clipping regions within a host window. Child windows can embed their own child.
// - For each independent axis of 'size': ==0.0f: use remaining host window size / >0.0f: fixed size / <0.0f: use remaining window size minus abs(size) / Each axis can use a different mode, e.g. ImVec2(0,400).
// - BeginChild() returns false to indicate the window is collapsed or fully clipped, so you may early out and omit submitting anything to the window.
//   Always call a matching EndChild() for each BeginChild() call, regardless of its return value.
//   [Important: due to legacy reason, this is inconsistent with most other functions such as BeginMenu/EndMenu,
//    BeginPopup/EndPopup, etc. where the EndXXX call should only be called if the corresponding BeginXXX function
//    returned true. Begin and BeginChild are the only odd ones out. Will be fixed in a future update.]
BeginChild :: (str_id: *u8, size: *ImVec2, border := false, flags: WindowFlags = .None) -> bool #foreign imgui "?BeginChild@ImGui@@YA_NPEBDAEBUImVec2@@_NH@Z";
BeginChild :: (str_id: *u8, size: ImVec2 = ImVec2.{0, 0}, border := false, flags: WindowFlags = .None) -> bool #no_context {
    return BeginChild(str_id, *size, border, flags);
}
BeginChild :: (id: ID, size: *ImVec2, border := false, flags: WindowFlags = .None) -> bool #foreign imgui "?BeginChild@ImGui@@YA_NIAEBUImVec2@@_NH@Z";
BeginChild :: (id: ID, size: ImVec2 = ImVec2.{0, 0}, border := false, flags: WindowFlags = .None) -> bool #no_context {
    return BeginChild(id, *size, border, flags);
}
EndChild :: () -> void #foreign imgui "?EndChild@ImGui@@YAXXZ";

// Windows Utilities
// - 'current window' = the window we are appending into while inside a Begin()/End() block. 'next window' = next window we will Begin() into.
IsWindowAppearing :: () -> bool #foreign imgui "?IsWindowAppearing@ImGui@@YA_NXZ";
IsWindowCollapsed :: () -> bool #foreign imgui "?IsWindowCollapsed@ImGui@@YA_NXZ";
IsWindowFocused :: (flags: FocusedFlags = .None) -> bool #foreign imgui "?IsWindowFocused@ImGui@@YA_NH@Z";
IsWindowHovered :: (flags: HoveredFlags = .None) -> bool #foreign imgui "?IsWindowHovered@ImGui@@YA_NH@Z";
GetWindowDrawList :: () -> *ImDrawList #foreign imgui "?GetWindowDrawList@ImGui@@YAPEAUImDrawList@@XZ";
GetWindowDpiScale :: () -> float #foreign imgui "?GetWindowDpiScale@ImGui@@YAMXZ";
GetWindowPos :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetWindowPos@ImGui@@YA?AUImVec2@@XZ";
GetWindowSize :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetWindowSize@ImGui@@YA?AUImVec2@@XZ";
GetWindowWidth :: () -> float #foreign imgui "?GetWindowWidth@ImGui@@YAMXZ";
GetWindowHeight :: () -> float #foreign imgui "?GetWindowHeight@ImGui@@YAMXZ";
GetWindowViewport :: () -> *Viewport #foreign imgui "?GetWindowViewport@ImGui@@YAPEAUImGuiViewport@@XZ";

// Window manipulation
// - Prefer using SetNextXXX functions (before Begin) rather that SetXXX functions (after Begin).
SetNextWindowPos :: (pos: *ImVec2, cond: Cond = .None, pivot: *ImVec2) -> void #foreign imgui "?SetNextWindowPos@ImGui@@YAXAEBUImVec2@@H0@Z";
SetNextWindowPos :: (pos: ImVec2, cond: Cond = .None, pivot: ImVec2 = ImVec2.{0, 0}) #no_context {
    SetNextWindowPos(*pos, cond, *pivot);
}
SetNextWindowSize :: (size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "?SetNextWindowSize@ImGui@@YAXAEBUImVec2@@H@Z";
SetNextWindowSize :: (size: ImVec2, cond: Cond = .None) #no_context {
    SetNextWindowSize(*size, cond);
}
SetNextWindowSizeConstraints :: (size_min: *ImVec2, size_max: *ImVec2, custom_callback: SizeCallback = null, custom_callback_data: *void = null) -> void #foreign imgui "?SetNextWindowSizeConstraints@ImGui@@YAXAEBUImVec2@@0P6AXPEAUImGuiSizeCallbackData@@@ZPEAX@Z";
SetNextWindowSizeConstraints :: (size_min: ImVec2, size_max: ImVec2, custom_callback: SizeCallback = null, custom_callback_data: *void = null) #no_context {
    SetNextWindowSizeConstraints(*size_min, *size_max, custom_callback, custom_callback_data);
}
SetNextWindowContentSize :: (size: *ImVec2) -> void #foreign imgui "?SetNextWindowContentSize@ImGui@@YAXAEBUImVec2@@@Z";
SetNextWindowContentSize :: (size: ImVec2) #no_context {
    SetNextWindowContentSize(*size);
}
SetNextWindowCollapsed :: (collapsed: bool, cond: Cond = .None) -> void #foreign imgui "?SetNextWindowCollapsed@ImGui@@YAX_NH@Z";
SetNextWindowFocus :: () -> void #foreign imgui "?SetNextWindowFocus@ImGui@@YAXXZ";
SetNextWindowBgAlpha :: (alpha: float) -> void #foreign imgui "?SetNextWindowBgAlpha@ImGui@@YAXM@Z";
SetNextWindowViewport :: (viewport_id: ID) -> void #foreign imgui "?SetNextWindowViewport@ImGui@@YAXI@Z";
SetWindowPos :: (pos: *ImVec2, cond: Cond = .None) -> void #foreign imgui "?SetWindowPos@ImGui@@YAXAEBUImVec2@@H@Z";
SetWindowPos :: (pos: ImVec2, cond: Cond = .None) #no_context {
    SetWindowPos(*pos, cond);
}
SetWindowSize :: (size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "?SetWindowSize@ImGui@@YAXAEBUImVec2@@H@Z";
SetWindowSize :: (size: ImVec2, cond: Cond = .None) #no_context {
    SetWindowSize(*size, cond);
}
SetWindowCollapsed :: (collapsed: bool, cond: Cond = .None) -> void #foreign imgui "?SetWindowCollapsed@ImGui@@YAX_NH@Z";
SetWindowFocus :: () -> void #foreign imgui "?SetWindowFocus@ImGui@@YAXXZ";
SetWindowFontScale :: (scale: float) -> void #foreign imgui "?SetWindowFontScale@ImGui@@YAXM@Z";
SetWindowPos :: (name: *u8, pos: *ImVec2, cond: Cond = .None) -> void #foreign imgui "?SetWindowPos@ImGui@@YAXPEBDAEBUImVec2@@H@Z";
SetWindowPos :: (name: *u8, pos: ImVec2, cond: Cond = .None) #no_context {
    SetWindowPos(name, *pos, cond);
}
SetWindowSize :: (name: *u8, size: *ImVec2, cond: Cond = .None) -> void #foreign imgui "?SetWindowSize@ImGui@@YAXPEBDAEBUImVec2@@H@Z";
SetWindowSize :: (name: *u8, size: ImVec2, cond: Cond = .None) #no_context {
    SetWindowSize(name, *size, cond);
}
SetWindowCollapsed :: (name: *u8, collapsed: bool, cond: Cond = .None) -> void #foreign imgui "?SetWindowCollapsed@ImGui@@YAXPEBD_NH@Z";
SetWindowFocus :: (name: *u8) -> void #foreign imgui "?SetWindowFocus@ImGui@@YAXPEBD@Z";

// Content region
// - Retrieve available space from a given point. GetContentRegionAvail() is frequently useful.
// - Those functions are bound to be redesigned (they are confusing, incomplete and the Min/Max return values are in local window coordinates which increases confusion)
GetContentRegionAvail :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetContentRegionAvail@ImGui@@YA?AUImVec2@@XZ";
GetContentRegionMax :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetContentRegionMax@ImGui@@YA?AUImVec2@@XZ";
GetWindowContentRegionMin :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetWindowContentRegionMin@ImGui@@YA?AUImVec2@@XZ";
GetWindowContentRegionMax :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetWindowContentRegionMax@ImGui@@YA?AUImVec2@@XZ";

// Windows Scrolling
GetScrollX :: () -> float #foreign imgui "?GetScrollX@ImGui@@YAMXZ";
GetScrollY :: () -> float #foreign imgui "?GetScrollY@ImGui@@YAMXZ";
SetScrollX :: (scroll_x: float) -> void #foreign imgui "?SetScrollX@ImGui@@YAXM@Z";
SetScrollY :: (scroll_y: float) -> void #foreign imgui "?SetScrollY@ImGui@@YAXM@Z";
GetScrollMaxX :: () -> float #foreign imgui "?GetScrollMaxX@ImGui@@YAMXZ";
GetScrollMaxY :: () -> float #foreign imgui "?GetScrollMaxY@ImGui@@YAMXZ";
SetScrollHereX :: (center_x_ratio: float = 0.5) -> void #foreign imgui "?SetScrollHereX@ImGui@@YAXM@Z";
SetScrollHereY :: (center_y_ratio: float = 0.5) -> void #foreign imgui "?SetScrollHereY@ImGui@@YAXM@Z";
SetScrollFromPosX :: (local_x: float, center_x_ratio: float = 0.5) -> void #foreign imgui "?SetScrollFromPosX@ImGui@@YAXMM@Z";
SetScrollFromPosY :: (local_y: float, center_y_ratio: float = 0.5) -> void #foreign imgui "?SetScrollFromPosY@ImGui@@YAXMM@Z";

// Parameters stacks (shared)
PushFont :: (font: *ImFont) -> void #foreign imgui "?PushFont@ImGui@@YAXPEAUImFont@@@Z";
PopFont :: () -> void #foreign imgui "?PopFont@ImGui@@YAXXZ";
PushStyleColor :: (idx: Col, col: ImU32) -> void #foreign imgui "?PushStyleColor@ImGui@@YAXHI@Z";
PushStyleColor :: (idx: Col, col: *ImVec4) -> void #foreign imgui "?PushStyleColor@ImGui@@YAXHAEBUImVec4@@@Z";
PushStyleColor :: (idx: Col, col: ImVec4) #no_context {
    PushStyleColor(idx, *col);
}
PopStyleColor :: (count: s32 = 1) -> void #foreign imgui "?PopStyleColor@ImGui@@YAXH@Z";
PushStyleVar :: (idx: StyleVar, val: float) -> void #foreign imgui "?PushStyleVar@ImGui@@YAXHM@Z";
PushStyleVar :: (idx: StyleVar, val: *ImVec2) -> void #foreign imgui "?PushStyleVar@ImGui@@YAXHAEBUImVec2@@@Z";
PushStyleVar :: (idx: StyleVar, val: ImVec2) #no_context {
    PushStyleVar(idx, *val);
}
PopStyleVar :: (count: s32 = 1) -> void #foreign imgui "?PopStyleVar@ImGui@@YAXH@Z";
PushAllowKeyboardFocus :: (allow_keyboard_focus: bool) -> void #foreign imgui "?PushAllowKeyboardFocus@ImGui@@YAX_N@Z";
PopAllowKeyboardFocus :: () -> void #foreign imgui "?PopAllowKeyboardFocus@ImGui@@YAXXZ";
PushButtonRepeat :: (repeat: bool) -> void #foreign imgui "?PushButtonRepeat@ImGui@@YAX_N@Z";
PopButtonRepeat :: () -> void #foreign imgui "?PopButtonRepeat@ImGui@@YAXXZ";

// Parameters stacks (current window)
PushItemWidth :: (item_width: float) -> void #foreign imgui "?PushItemWidth@ImGui@@YAXM@Z";
PopItemWidth :: () -> void #foreign imgui "?PopItemWidth@ImGui@@YAXXZ";
SetNextItemWidth :: (item_width: float) -> void #foreign imgui "?SetNextItemWidth@ImGui@@YAXM@Z";
CalcItemWidth :: () -> float #foreign imgui "?CalcItemWidth@ImGui@@YAMXZ";
PushTextWrapPos :: (wrap_local_pos_x: float = 0.0) -> void #foreign imgui "?PushTextWrapPos@ImGui@@YAXM@Z";
PopTextWrapPos :: () -> void #foreign imgui "?PopTextWrapPos@ImGui@@YAXXZ";

// Style read access
// - Use the style editor (ShowStyleEditor() function) to interactively see what the colors are)
GetFont :: () -> *ImFont #foreign imgui "?GetFont@ImGui@@YAPEAUImFont@@XZ";
GetFontSize :: () -> float #foreign imgui "?GetFontSize@ImGui@@YAMXZ";
GetFontTexUvWhitePixel :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetFontTexUvWhitePixel@ImGui@@YA?AUImVec2@@XZ";
GetColorU32 :: (idx: Col, alpha_mul: float = 1.0) -> ImU32 #foreign imgui "?GetColorU32@ImGui@@YAIHM@Z";
GetColorU32 :: (col: *ImVec4) -> ImU32 #foreign imgui "?GetColorU32@ImGui@@YAIAEBUImVec4@@@Z";
GetColorU32 :: (col: ImVec4) -> ImU32 #no_context {
    return GetColorU32(*col);
}
GetColorU32 :: (col: ImU32) -> ImU32 #foreign imgui "?GetColorU32@ImGui@@YAII@Z";
GetStyleColorVec4 :: (idx: Col) -> *ImVec4 #foreign imgui "?GetStyleColorVec4@ImGui@@YAAEBUImVec4@@H@Z";

// Cursor / Layout
// - By "cursor" we mean the current output position.
// - The typical widget behavior is to output themselves at the current cursor position, then move the cursor one line down.
// - You can call SameLine() between widgets to undo the last carriage return and output at the right of the preceding widget.
// - Attention! We currently have inconsistencies between window-local and absolute positions we will aim to fix with future API:
//    Window-local coordinates:   SameLine(), GetCursorPos(), SetCursorPos(), GetCursorStartPos(), GetContentRegionMax(), GetWindowContentRegion*(), PushTextWrapPos()
//    Absolute coordinate:        GetCursorScreenPos(), SetCursorScreenPos(), all ImDrawList:: functions.
Separator :: () -> void #foreign imgui "?Separator@ImGui@@YAXXZ";
SameLine :: (offset_from_start_x: float = 0.0, spacing: float = -1.0) -> void #foreign imgui "?SameLine@ImGui@@YAXMM@Z";
NewLine :: () -> void #foreign imgui "?NewLine@ImGui@@YAXXZ";
Spacing :: () -> void #foreign imgui "?Spacing@ImGui@@YAXXZ";
Dummy :: (size: *ImVec2) -> void #foreign imgui "?Dummy@ImGui@@YAXAEBUImVec2@@@Z";
Dummy :: (size: ImVec2) #no_context {
    Dummy(*size);
}
Indent :: (indent_w: float = 0.0) -> void #foreign imgui "?Indent@ImGui@@YAXM@Z";
Unindent :: (indent_w: float = 0.0) -> void #foreign imgui "?Unindent@ImGui@@YAXM@Z";
BeginGroup :: () -> void #foreign imgui "?BeginGroup@ImGui@@YAXXZ";
EndGroup :: () -> void #foreign imgui "?EndGroup@ImGui@@YAXXZ";
GetCursorPos :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetCursorPos@ImGui@@YA?AUImVec2@@XZ";
GetCursorPosX :: () -> float #foreign imgui "?GetCursorPosX@ImGui@@YAMXZ";
GetCursorPosY :: () -> float #foreign imgui "?GetCursorPosY@ImGui@@YAMXZ";
SetCursorPos :: (local_pos: *ImVec2) -> void #foreign imgui "?SetCursorPos@ImGui@@YAXAEBUImVec2@@@Z";
SetCursorPos :: (local_pos: ImVec2) #no_context {
    SetCursorPos(*local_pos);
}
SetCursorPosX :: (local_x: float) -> void #foreign imgui "?SetCursorPosX@ImGui@@YAXM@Z";
SetCursorPosY :: (local_y: float) -> void #foreign imgui "?SetCursorPosY@ImGui@@YAXM@Z";
GetCursorStartPos :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetCursorStartPos@ImGui@@YA?AUImVec2@@XZ";
GetCursorScreenPos :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetCursorScreenPos@ImGui@@YA?AUImVec2@@XZ";
SetCursorScreenPos :: (pos: *ImVec2) -> void #foreign imgui "?SetCursorScreenPos@ImGui@@YAXAEBUImVec2@@@Z";
SetCursorScreenPos :: (pos: ImVec2) #no_context {
    SetCursorScreenPos(*pos);
}
AlignTextToFramePadding :: () -> void #foreign imgui "?AlignTextToFramePadding@ImGui@@YAXXZ";
GetTextLineHeight :: () -> float #foreign imgui "?GetTextLineHeight@ImGui@@YAMXZ";
GetTextLineHeightWithSpacing :: () -> float #foreign imgui "?GetTextLineHeightWithSpacing@ImGui@@YAMXZ";
GetFrameHeight :: () -> float #foreign imgui "?GetFrameHeight@ImGui@@YAMXZ";
GetFrameHeightWithSpacing :: () -> float #foreign imgui "?GetFrameHeightWithSpacing@ImGui@@YAMXZ";

// ID stack/scopes
// Read the FAQ (docs/FAQ.md or http://dearimgui.org/faq) for more details about how ID are handled in dear imgui.
// - Those questions are answered and impacted by understanding of the ID stack system:
//   - "Q: Why is my widget not reacting when I click on it?"
//   - "Q: How can I have widgets with an empty label?"
//   - "Q: How can I have multiple widgets with the same label?"
// - Short version: ID are hashes of the entire ID stack. If you are creating widgets in a loop you most likely
//   want to push a unique identifier (e.g. object pointer, loop index) to uniquely differentiate them.
// - You can also use the "Label##foobar" syntax within widget label to distinguish them from each others.
// - In this header file we use the "label"/"name" terminology to denote a string that will be displayed + used as an ID,
//   whereas "str_id" denote a string that is only used as an ID and not normally displayed.
PushID :: (str_id: *u8) -> void #foreign imgui "?PushID@ImGui@@YAXPEBD@Z";
PushID :: (str_id_begin: *u8, str_id_end: *u8) -> void #foreign imgui "?PushID@ImGui@@YAXPEBD0@Z";
PushID :: (str_id: string) #no_context {
    PushID(str_id.data, str_id.data + str_id.count);
}
PushID :: (ptr_id: *void) -> void #foreign imgui "?PushID@ImGui@@YAXPEBX@Z";
PushID :: (int_id: s32) -> void #foreign imgui "?PushID@ImGui@@YAXH@Z";
PopID :: () -> void #foreign imgui "?PopID@ImGui@@YAXXZ";
GetID :: (str_id: *u8) -> ID #foreign imgui "?GetID@ImGui@@YAIPEBD@Z";
GetID :: (str_id_begin: *u8, str_id_end: *u8) -> ID #foreign imgui "?GetID@ImGui@@YAIPEBD0@Z";
GetID :: (str_id: string) -> ID #no_context {
    return GetID(str_id.data, str_id.data + str_id.count);
}
GetID :: (ptr_id: *void) -> ID #foreign imgui "?GetID@ImGui@@YAIPEBX@Z";

// Widgets: Text
TextUnformatted :: (text: *u8, text_end: *u8 = null) -> void #foreign imgui "?TextUnformatted@ImGui@@YAXPEBD0@Z";
TextUnformatted :: (text: string) #no_context {
    TextUnformatted(text.data, text.data + text.count);
}
Text :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "?Text@ImGui@@YAXPEBDZZ";

TextColored :: (col: *ImVec4, fmt: *u8, __args: ..Any) -> void #foreign imgui "?TextColored@ImGui@@YAXAEBUImVec4@@PEBDZZ";

TextDisabled :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "?TextDisabled@ImGui@@YAXPEBDZZ";

TextWrapped :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "?TextWrapped@ImGui@@YAXPEBDZZ";

LabelText :: (label: *u8, fmt: *u8, __args: ..Any) -> void #foreign imgui "?LabelText@ImGui@@YAXPEBD0ZZ";

BulletText :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "?BulletText@ImGui@@YAXPEBDZZ";

// Widgets: Main
// - Most widgets return true when the value has been changed or when pressed/selected
// - You may also use one of the many IsItemXXX functions (e.g. IsItemActive, IsItemHovered, etc.) to query widget state.
Button :: (label: *u8, size: *ImVec2) -> bool #foreign imgui "?Button@ImGui@@YA_NPEBDAEBUImVec2@@@Z";
Button :: (label: *u8, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return Button(label, *size);
}
SmallButton :: (label: *u8) -> bool #foreign imgui "?SmallButton@ImGui@@YA_NPEBD@Z";
InvisibleButton :: (str_id: *u8, size: *ImVec2, flags: ButtonFlags = .None) -> bool #foreign imgui "?InvisibleButton@ImGui@@YA_NPEBDAEBUImVec2@@H@Z";
InvisibleButton :: (str_id: *u8, size: ImVec2, flags: ButtonFlags = .None) -> bool #no_context {
    return InvisibleButton(str_id, *size, flags);
}
ArrowButton :: (str_id: *u8, dir: Dir) -> bool #foreign imgui "?ArrowButton@ImGui@@YA_NPEBDH@Z";
Image :: (user_texture_id: ImTextureID, size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, tint_col: *ImVec4, border_col: *ImVec4) -> void #foreign imgui "?Image@ImGui@@YAXPEAXAEBUImVec2@@11AEBUImVec4@@2@Z";
Image :: (user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2.{0, 0}, uv1: ImVec2 = ImVec2.{1, 1}, tint_col: ImVec4 = ImVec4.{1, 1, 1, 1}, border_col: ImVec4 = ImVec4.{0, 0, 0, 0}) #no_context {
    Image(user_texture_id, *size, *uv0, *uv1, *tint_col, *border_col);
}
ImageButton :: (user_texture_id: ImTextureID, size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, frame_padding: s32 = -1, bg_col: *ImVec4, tint_col: *ImVec4) -> bool #foreign imgui "?ImageButton@ImGui@@YA_NPEAXAEBUImVec2@@11HAEBUImVec4@@2@Z";
ImageButton :: (user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2.{0, 0}, uv1: ImVec2 = ImVec2.{1, 1}, frame_padding: s32 = -1, bg_col: ImVec4 = ImVec4.{0, 0, 0, 0}, tint_col: ImVec4 = ImVec4.{1, 1, 1, 1}) -> bool #no_context {
    return ImageButton(user_texture_id, *size, *uv0, *uv1, frame_padding, *bg_col, *tint_col);
}
Checkbox :: (label: *u8, v: *bool) -> bool #foreign imgui "?Checkbox@ImGui@@YA_NPEBDPEA_N@Z";
CheckboxFlags :: (label: *u8, flags: *s32, flags_value: s32) -> bool #foreign imgui "?CheckboxFlags@ImGui@@YA_NPEBDPEAHH@Z";
CheckboxFlags :: (label: *u8, flags: *u32, flags_value: u32) -> bool #foreign imgui "?CheckboxFlags@ImGui@@YA_NPEBDPEAII@Z";
RadioButton :: (label: *u8, active: bool) -> bool #foreign imgui "?RadioButton@ImGui@@YA_NPEBD_N@Z";
RadioButton :: (label: *u8, v: *s32, v_button: s32) -> bool #foreign imgui "?RadioButton@ImGui@@YA_NPEBDPEAHH@Z";
ProgressBar :: (fraction: float, size_arg: *ImVec2, overlay: *u8 = null) -> void #foreign imgui "?ProgressBar@ImGui@@YAXMAEBUImVec2@@PEBD@Z";
ProgressBar :: (fraction: float, size_arg: ImVec2 = ImVec2.{-FLOAT32_MIN, 0}, overlay: *u8 = null) #no_context {
    ProgressBar(fraction, *size_arg, overlay);
}
Bullet :: () -> void #foreign imgui "?Bullet@ImGui@@YAXXZ";

// Widgets: Combo Box
// - The BeginCombo()/EndCombo() api allows you to manage your contents and selection state however you want it, by creating e.g. Selectable() items.
// - The old Combo() api are helpers over BeginCombo()/EndCombo() which are kept available for convenience purpose. This is analogous to how ListBox are created.
BeginCombo :: (label: *u8, preview_value: *u8, flags: ComboFlags = .None) -> bool #foreign imgui "?BeginCombo@ImGui@@YA_NPEBD0H@Z";
EndCombo :: () -> void #foreign imgui "?EndCombo@ImGui@@YAXXZ";
Combo :: (label: *u8, current_item: *s32, items: **u8, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "?Combo@ImGui@@YA_NPEBDPEAHQEBQEBDHH@Z";
Combo :: (label: *u8, current_item: *s32, items_separated_by_zeros: *u8, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "?Combo@ImGui@@YA_NPEBDPEAH0H@Z";
Combo :: (label: *u8, current_item: *s32, items_getter: #type (data: *void, idx: s32, out_text: **u8) -> bool #c_call, data: *void, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui "?Combo@ImGui@@YA_NPEBDPEAHP6A_NPEAXHPEAPEBD@Z2HH@Z";

// Widgets: Drag Sliders
// - CTRL+Click on any drag box to turn them into an input box. Manually input values aren't clamped by default and can go off-bounds. Use ImGuiSliderFlags_AlwaysClamp to always clamp.
// - For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, note that a 'float v[X]' function argument is the same as 'float* v',
//   the array syntax is just a way to document the number of elements that are expected to be accessible. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
// - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
// - Format string may also be set to NULL or use the default format ("%f" or "%d").
// - Speed are per-pixel of mouse movement (v_speed=0.2f: mouse needs to move by 5 pixels to increase value by 1). For gamepad/keyboard navigation, minimum speed is Max(v_speed, minimum_step_at_given_precision).
// - Use v_min < v_max to clamp edits to given limits. Note that CTRL+Click manual input can override those limits if ImGuiSliderFlags_AlwaysClamp is not used.
// - Use v_max = FLT_MAX / INT_MAX etc to avoid clamping to a maximum, same with v_min = -FLT_MAX / INT_MIN to avoid clamping to a minimum.
// - We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
// - Legacy: Pre-1.78 there are DragXXX() function signatures that takes a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
//   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
DragFloat :: (label: *u8, v: *float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?DragFloat@ImGui@@YA_NPEBDPEAMMMM0H@Z";
DragFloat2 :: (label: *u8, v: *[2] float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?DragFloat2@ImGui@@YA_NPEBDQEAMMMM0H@Z";
DragFloat3 :: (label: *u8, v: *[3] float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?DragFloat3@ImGui@@YA_NPEBDQEAMMMM0H@Z";
DragFloat4 :: (label: *u8, v: *[4] float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?DragFloat4@ImGui@@YA_NPEBDQEAMMMM0H@Z";
DragFloatRange2 :: (label: *u8, v_current_min: *float, v_current_max: *float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: *u8 = "%.3f", format_max: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?DragFloatRange2@ImGui@@YA_NPEBDPEAM1MMM00H@Z";
DragInt :: (label: *u8, v: *s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?DragInt@ImGui@@YA_NPEBDPEAHMHH0H@Z";
DragInt2 :: (label: *u8, v: *[2] s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?DragInt2@ImGui@@YA_NPEBDQEAHMHH0H@Z";
DragInt3 :: (label: *u8, v: *[3] s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?DragInt3@ImGui@@YA_NPEBDQEAHMHH0H@Z";
DragInt4 :: (label: *u8, v: *[4] s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?DragInt4@ImGui@@YA_NPEBDQEAHMHH0H@Z";
DragIntRange2 :: (label: *u8, v_current_min: *s32, v_current_max: *s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: *u8 = "%d", format_max: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?DragIntRange2@ImGui@@YA_NPEBDPEAH1MHH00H@Z";
DragScalar :: (label: *u8, data_type: DataType, p_data: *void, v_speed: float = 1.0, p_min: *void = null, p_max: *void = null, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?DragScalar@ImGui@@YA_NPEBDHPEAXMPEBX20H@Z";
DragScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, v_speed: float = 1.0, p_min: *void = null, p_max: *void = null, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?DragScalarN@ImGui@@YA_NPEBDHPEAXHMPEBX20H@Z";

// Widgets: Regular Sliders
// - CTRL+Click on any slider to turn them into an input box. Manually input values aren't clamped by default and can go off-bounds. Use ImGuiSliderFlags_AlwaysClamp to always clamp.
// - Adjust format string to decorate the value with a prefix, a suffix, or adapt the editing and display precision e.g. "%.3f" -> 1.234; "%5.2f secs" -> 01.23 secs; "Biscuit: %.0f" -> Biscuit: 1; etc.
// - Format string may also be set to NULL or use the default format ("%f" or "%d").
// - Legacy: Pre-1.78 there are SliderXXX() function signatures that takes a final `float power=1.0f' argument instead of the `ImGuiSliderFlags flags=0' argument.
//   If you get a warning converting a float to ImGuiSliderFlags, read https://github.com/ocornut/imgui/issues/3361
SliderFloat :: (label: *u8, v: *float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderFloat@ImGui@@YA_NPEBDPEAMMM0H@Z";
SliderFloat2 :: (label: *u8, v: *[2] float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderFloat2@ImGui@@YA_NPEBDQEAMMM0H@Z";
SliderFloat3 :: (label: *u8, v: *[3] float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderFloat3@ImGui@@YA_NPEBDQEAMMM0H@Z";
SliderFloat4 :: (label: *u8, v: *[4] float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderFloat4@ImGui@@YA_NPEBDQEAMMM0H@Z";
SliderAngle :: (label: *u8, v_rad: *float, v_degrees_min: float = -360.0, v_degrees_max: float = +360.0, format: *u8 = "%.0f deg", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderAngle@ImGui@@YA_NPEBDPEAMMM0H@Z";
SliderInt :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderInt@ImGui@@YA_NPEBDPEAHHH0H@Z";
SliderInt2 :: (label: *u8, v: *[2] s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderInt2@ImGui@@YA_NPEBDQEAHHH0H@Z";
SliderInt3 :: (label: *u8, v: *[3] s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderInt3@ImGui@@YA_NPEBDQEAHHH0H@Z";
SliderInt4 :: (label: *u8, v: *[4] s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?SliderInt4@ImGui@@YA_NPEBDQEAHHH0H@Z";
SliderScalar :: (label: *u8, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?SliderScalar@ImGui@@YA_NPEBDHPEAXPEBX20H@Z";
SliderScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?SliderScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20H@Z";
VSliderFloat :: (label: *u8, size: *ImVec2, v: *float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #foreign imgui "?VSliderFloat@ImGui@@YA_NPEBDAEBUImVec2@@PEAMMM0H@Z";
VSliderFloat :: (label: *u8, size: ImVec2, v: *float, v_min: float, v_max: float, format: *u8 = "%.3f", flags: SliderFlags = .None) -> bool #no_context {
    return VSliderFloat(label, *size, v, v_min, v_max, format, flags);
}
VSliderInt :: (label: *u8, size: *ImVec2, v: *s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #foreign imgui "?VSliderInt@ImGui@@YA_NPEBDAEBUImVec2@@PEAHHH0H@Z";
VSliderInt :: (label: *u8, size: ImVec2, v: *s32, v_min: s32, v_max: s32, format: *u8 = "%d", flags: SliderFlags = .None) -> bool #no_context {
    return VSliderInt(label, *size, v, v_min, v_max, format, flags);
}
VSliderScalar :: (label: *u8, size: *ImVec2, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #foreign imgui "?VSliderScalar@ImGui@@YA_NPEBDAEBUImVec2@@HPEAXPEBX30H@Z";
VSliderScalar :: (label: *u8, size: ImVec2, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8 = null, flags: SliderFlags = .None) -> bool #no_context {
    return VSliderScalar(label, *size, data_type, p_data, p_min, p_max, format, flags);
}

// Widgets: Input with Keyboard
// - If you want to use InputText() with std::string or any custom dynamic string type, see misc/cpp/imgui_stdlib.h and comments in imgui_demo.cpp.
// - Most of the ImGuiInputTextFlags flags are only useful for InputText() and not for InputFloatX, InputIntX, InputDouble etc.
InputText :: (label: *u8, buf: *u8, buf_size: size_t, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "?InputText@ImGui@@YA_NPEBDPEAD_KHP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
InputTextMultiline :: (label: *u8, buf: *u8, buf_size: size_t, size: *ImVec2, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "?InputTextMultiline@ImGui@@YA_NPEBDPEAD_KAEBUImVec2@@HP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
InputTextMultiline :: (label: *u8, buf: *u8, buf_size: size_t, size: ImVec2 = ImVec2.{0, 0}, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #no_context {
    return InputTextMultiline(label, buf, buf_size, *size, flags, callback, user_data);
}
InputTextWithHint :: (label: *u8, hint: *u8, buf: *u8, buf_size: size_t, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui "?InputTextWithHint@ImGui@@YA_NPEBD0PEAD_KHP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
InputFloat :: (label: *u8, v: *float, step: float = 0.0, step_fast: float = 0.0, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "?InputFloat@ImGui@@YA_NPEBDPEAMMM0H@Z";
InputFloat2 :: (label: *u8, v: *[2] float, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "?InputFloat2@ImGui@@YA_NPEBDQEAM0H@Z";
InputFloat3 :: (label: *u8, v: *[3] float, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "?InputFloat3@ImGui@@YA_NPEBDQEAM0H@Z";
InputFloat4 :: (label: *u8, v: *[4] float, format: *u8 = "%.3f", flags: InputTextFlags = .None) -> bool #foreign imgui "?InputFloat4@ImGui@@YA_NPEBDQEAM0H@Z";
InputInt :: (label: *u8, v: *s32, step: s32 = 1, step_fast: s32 = 100, flags: InputTextFlags = .None) -> bool #foreign imgui "?InputInt@ImGui@@YA_NPEBDPEAHHHH@Z";
InputInt2 :: (label: *u8, v: *[2] s32, flags: InputTextFlags = .None) -> bool #foreign imgui "?InputInt2@ImGui@@YA_NPEBDQEAHH@Z";
InputInt3 :: (label: *u8, v: *[3] s32, flags: InputTextFlags = .None) -> bool #foreign imgui "?InputInt3@ImGui@@YA_NPEBDQEAHH@Z";
InputInt4 :: (label: *u8, v: *[4] s32, flags: InputTextFlags = .None) -> bool #foreign imgui "?InputInt4@ImGui@@YA_NPEBDQEAHH@Z";
InputDouble :: (label: *u8, v: *float64, step: float64 = 0.0, step_fast: float64 = 0.0, format: *u8 = "%.6f", flags: InputTextFlags = .None) -> bool #foreign imgui "?InputDouble@ImGui@@YA_NPEBDPEANNN0H@Z";
InputScalar :: (label: *u8, data_type: DataType, p_data: *void, p_step: *void = null, p_step_fast: *void = null, format: *u8 = null, flags: InputTextFlags = .None) -> bool #foreign imgui "?InputScalar@ImGui@@YA_NPEBDHPEAXPEBX20H@Z";
InputScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_step: *void = null, p_step_fast: *void = null, format: *u8 = null, flags: InputTextFlags = .None) -> bool #foreign imgui "?InputScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20H@Z";

// Widgets: Color Editor/Picker (tip: the ColorEdit* functions have a little color square that can be left-clicked to open a picker, and right-clicked to open an option menu.)
// - Note that in C++ a 'float v[X]' function argument is the _same_ as 'float* v', the array syntax is just a way to document the number of elements that are expected to be accessible.
// - You can pass the address of a first float element out of a contiguous structure, e.g. &myvector.x
ColorEdit3 :: (label: *u8, col: *[3] float, flags: ColorEditFlags = .None) -> bool #foreign imgui "?ColorEdit3@ImGui@@YA_NPEBDQEAMH@Z";
ColorEdit4 :: (label: *u8, col: *[4] float, flags: ColorEditFlags = .None) -> bool #foreign imgui "?ColorEdit4@ImGui@@YA_NPEBDQEAMH@Z";
ColorPicker3 :: (label: *u8, col: *[3] float, flags: ColorEditFlags = .None) -> bool #foreign imgui "?ColorPicker3@ImGui@@YA_NPEBDQEAMH@Z";
ColorPicker4 :: (label: *u8, col: *[4] float, flags: ColorEditFlags = .None, ref_col: *float = null) -> bool #foreign imgui "?ColorPicker4@ImGui@@YA_NPEBDQEAMHPEBM@Z";
ColorButton :: (desc_id: *u8, col: *ImVec4, flags: ColorEditFlags = .None, size: *ImVec2) -> bool #foreign imgui "?ColorButton@ImGui@@YA_NPEBDAEBUImVec4@@HAEBUImVec2@@@Z";
ColorButton :: (desc_id: *u8, col: ImVec4, flags: ColorEditFlags = .None, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return ColorButton(desc_id, *col, flags, *size);
}
SetColorEditOptions :: (flags: ColorEditFlags) -> void #foreign imgui "?SetColorEditOptions@ImGui@@YAXH@Z";

// Widgets: Trees
// - TreeNode functions return true when the node is open, in which case you need to also call TreePop() when you are finished displaying the tree node contents.
TreeNode :: (label: *u8) -> bool #foreign imgui "?TreeNode@ImGui@@YA_NPEBD@Z";
TreeNode :: (str_id: *u8, fmt: *u8, __args: ..Any) -> bool #foreign imgui "?TreeNode@ImGui@@YA_NPEBD0ZZ";
TreeNode :: (ptr_id: *void, fmt: *u8, __args: ..Any) -> bool #foreign imgui "?TreeNode@ImGui@@YA_NPEBXPEBDZZ";

TreeNodeEx :: (label: *u8, flags: TreeNodeFlags = .None) -> bool #foreign imgui "?TreeNodeEx@ImGui@@YA_NPEBDH@Z";
TreeNodeEx :: (str_id: *u8, flags: TreeNodeFlags, fmt: *u8, __args: ..Any) -> bool #foreign imgui "?TreeNodeEx@ImGui@@YA_NPEBDH0ZZ";
TreeNodeEx :: (ptr_id: *void, flags: TreeNodeFlags, fmt: *u8, __args: ..Any) -> bool #foreign imgui "?TreeNodeEx@ImGui@@YA_NPEBXHPEBDZZ";

TreePush :: (str_id: *u8) -> void #foreign imgui "?TreePush@ImGui@@YAXPEBD@Z";
TreePush :: (ptr_id: *void = null) -> void #foreign imgui "?TreePush@ImGui@@YAXPEBX@Z";
TreePop :: () -> void #foreign imgui "?TreePop@ImGui@@YAXXZ";
GetTreeNodeToLabelSpacing :: () -> float #foreign imgui "?GetTreeNodeToLabelSpacing@ImGui@@YAMXZ";
CollapsingHeader :: (label: *u8, flags: TreeNodeFlags = .None) -> bool #foreign imgui "?CollapsingHeader@ImGui@@YA_NPEBDH@Z";
CollapsingHeader :: (label: *u8, p_visible: *bool, flags: TreeNodeFlags = .None) -> bool #foreign imgui "?CollapsingHeader@ImGui@@YA_NPEBDPEA_NH@Z";
SetNextItemOpen :: (is_open: bool, cond: Cond = .None) -> void #foreign imgui "?SetNextItemOpen@ImGui@@YAX_NH@Z";

// Widgets: Selectables
// - A selectable highlights when hovered, and can display another color when selected.
// - Neighbors selectable extend their highlight bounds in order to leave no gap between them. This is so a series of selected Selectable appear contiguous.
Selectable :: (label: *u8, selected := false, flags: SelectableFlags = .None, size: *ImVec2) -> bool #foreign imgui "?Selectable@ImGui@@YA_NPEBD_NHAEBUImVec2@@@Z";
Selectable :: (label: *u8, selected := false, flags: SelectableFlags = .None, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return Selectable(label, selected, flags, *size);
}
Selectable :: (label: *u8, p_selected: *bool, flags: SelectableFlags = .None, size: *ImVec2) -> bool #foreign imgui "?Selectable@ImGui@@YA_NPEBDPEA_NHAEBUImVec2@@@Z";
Selectable :: (label: *u8, p_selected: *bool, flags: SelectableFlags = .None, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return Selectable(label, p_selected, flags, *size);
}

// Widgets: List Boxes
// - This is essentially a thin wrapper to using BeginChild/EndChild with some stylistic changes.
// - The BeginListBox()/EndListBox() api allows you to manage your contents and selection state however you want it, by creating e.g. Selectable() or any items.
// - The simplified/old ListBox() api are helpers over BeginListBox()/EndListBox() which are kept available for convenience purpose. This is analoguous to how Combos are created.
// - Choose frame width:   size.x > 0.0f: custom  /  size.x < 0.0f or -FLT_MIN: right-align   /  size.x = 0.0f (default): use current ItemWidth
// - Choose frame height:  size.y > 0.0f: custom  /  size.y < 0.0f or -FLT_MIN: bottom-align  /  size.y = 0.0f (default): arbitrary default height which can fit ~7 items
BeginListBox :: (label: *u8, size: *ImVec2) -> bool #foreign imgui "?BeginListBox@ImGui@@YA_NPEBDAEBUImVec2@@@Z";
BeginListBox :: (label: *u8, size: ImVec2 = ImVec2.{0, 0}) -> bool #no_context {
    return BeginListBox(label, *size);
}
EndListBox :: () -> void #foreign imgui "?EndListBox@ImGui@@YAXXZ";
ListBox :: (label: *u8, current_item: *s32, items: **u8, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui "?ListBox@ImGui@@YA_NPEBDPEAHQEBQEBDHH@Z";
ListBox :: (label: *u8, current_item: *s32, items_getter: #type (data: *void, idx: s32, out_text: **u8) -> bool #c_call, data: *void, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui "?ListBox@ImGui@@YA_NPEBDPEAHP6A_NPEAXHPEAPEBD@Z2HH@Z";

// Widgets: Data Plotting
// - Consider using ImPlot (https://github.com/epezent/implot) which is much better!
PlotLines :: (label: *u8, values: *float, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}, stride: s32 = 4) -> void #foreign imgui "?PlotLines@ImGui@@YAXPEBDPEBMHH0MMUImVec2@@H@Z";
PlotLines :: (label: *u8, values_getter: #type (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}) -> void #foreign imgui "?PlotLines@ImGui@@YAXPEBDP6AMPEAXH@Z1HH0MMUImVec2@@@Z";
PlotHistogram :: (label: *u8, values: *float, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}, stride: s32 = 4) -> void #foreign imgui "?PlotHistogram@ImGui@@YAXPEBDPEBMHH0MMUImVec2@@H@Z";
PlotHistogram :: (label: *u8, values_getter: #type (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32 = 0, overlay_text: *u8 = null, scale_min: float = FLOAT32_MAX, scale_max: float = FLOAT32_MAX, graph_size: ImVec2 = ImVec2.{0, 0}) -> void #foreign imgui "?PlotHistogram@ImGui@@YAXPEBDP6AMPEAXH@Z1HH0MMUImVec2@@@Z";

// Widgets: Value() Helpers.
// - Those are merely shortcut to calling Text() with a format string. Output single value in "name: value" format (tip: freely declare more in your code to handle your types. you can add functions to the ImGui namespace)
Value :: (prefix: *u8, b: bool) -> void #foreign imgui "?Value@ImGui@@YAXPEBD_N@Z";
Value :: (prefix: *u8, v: s32) -> void #foreign imgui "?Value@ImGui@@YAXPEBDH@Z";
Value :: (prefix: *u8, v: u32) -> void #foreign imgui "?Value@ImGui@@YAXPEBDI@Z";
Value :: (prefix: *u8, v: float, float_format: *u8 = null) -> void #foreign imgui "?Value@ImGui@@YAXPEBDM0@Z";

// Widgets: Menus
// - Use BeginMenuBar() on a window ImGuiWindowFlags_MenuBar to append to its menu bar.
// - Use BeginMainMenuBar() to create a menu bar at the top of the screen and append to it.
// - Use BeginMenu() to create a menu. You can call BeginMenu() multiple time with the same identifier to append more items to it.
// - Not that MenuItem() keyboardshortcuts are displayed as a convenience but _not processed_ by Dear ImGui at the moment.
BeginMenuBar :: () -> bool #foreign imgui "?BeginMenuBar@ImGui@@YA_NXZ";
EndMenuBar :: () -> void #foreign imgui "?EndMenuBar@ImGui@@YAXXZ";
BeginMainMenuBar :: () -> bool #foreign imgui "?BeginMainMenuBar@ImGui@@YA_NXZ";
EndMainMenuBar :: () -> void #foreign imgui "?EndMainMenuBar@ImGui@@YAXXZ";
BeginMenu :: (label: *u8, enabled := true) -> bool #foreign imgui "?BeginMenu@ImGui@@YA_NPEBD_N@Z";
EndMenu :: () -> void #foreign imgui "?EndMenu@ImGui@@YAXXZ";
MenuItem :: (label: *u8, shortcut: *u8 = null, selected := false, enabled := true) -> bool #foreign imgui "?MenuItem@ImGui@@YA_NPEBD0_N1@Z";
MenuItem :: (label: *u8, shortcut: *u8, p_selected: *bool, enabled := true) -> bool #foreign imgui "?MenuItem@ImGui@@YA_NPEBD0PEA_N_N@Z";

// Tooltips
// - Tooltip are windows following the mouse. They do not take focus away.
BeginTooltip :: () -> void #foreign imgui "?BeginTooltip@ImGui@@YAXXZ";
EndTooltip :: () -> void #foreign imgui "?EndTooltip@ImGui@@YAXXZ";
SetTooltip :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "?SetTooltip@ImGui@@YAXPEBDZZ";

// Popups: begin/end functions
//  - BeginPopup(): query popup state, if open start appending into the window. Call EndPopup() afterwards. ImGuiWindowFlags are forwarded to the window.
//  - BeginPopupModal(): block every interactions behind the window, cannot be closed by user, add a dimming background, has a title bar.
BeginPopup :: (str_id: *u8, flags: WindowFlags = .None) -> bool #foreign imgui "?BeginPopup@ImGui@@YA_NPEBDH@Z";
BeginPopupModal :: (name: *u8, p_open: *bool = null, flags: WindowFlags = .None) -> bool #foreign imgui "?BeginPopupModal@ImGui@@YA_NPEBDPEA_NH@Z";
EndPopup :: () -> void #foreign imgui "?EndPopup@ImGui@@YAXXZ";

// Popups: open/close functions
//  - OpenPopup(): set popup state to open. ImGuiPopupFlags are available for opening options.
//  - If not modal: they can be closed by clicking anywhere outside them, or by pressing ESCAPE.
//  - CloseCurrentPopup(): use inside the BeginPopup()/EndPopup() scope to close manually.
//  - CloseCurrentPopup() is called by default by Selectable()/MenuItem() when activated (FIXME: need some options).
//  - Use ImGuiPopupFlags_NoOpenOverExistingPopup to avoid opening a popup if there's already one at the same level. This is equivalent to e.g. testing for !IsAnyPopupOpen() prior to OpenPopup().
//  - Use IsWindowAppearing() after BeginPopup() to tell if a window just opened.
//  - IMPORTANT: Notice that for OpenPopupOnItemClick() we exceptionally default flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter
OpenPopup :: (str_id: *u8, popup_flags: PopupFlags = .None) -> void #foreign imgui "?OpenPopup@ImGui@@YAXPEBDH@Z";
OpenPopup :: (id: ID, popup_flags: PopupFlags = .None) -> void #foreign imgui "?OpenPopup@ImGui@@YAXIH@Z";
OpenPopupOnItemClick :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> void #foreign imgui "?OpenPopupOnItemClick@ImGui@@YAXPEBDH@Z";
CloseCurrentPopup :: () -> void #foreign imgui "?CloseCurrentPopup@ImGui@@YAXXZ";

// Popups: open+begin combined functions helpers
//  - Helpers to do OpenPopup+BeginPopup where the Open action is triggered by e.g. hovering an item and right-clicking.
//  - They are convenient to easily create context menus, hence the name.
//  - IMPORTANT: Notice that BeginPopupContextXXX takes ImGuiPopupFlags just like OpenPopup() and unlike BeginPopup(). For full consistency, we may add ImGuiWindowFlags to the BeginPopupContextXXX functions in the future.
//  - IMPORTANT: Notice that we exceptionally default their flags to 1 (== ImGuiPopupFlags_MouseButtonRight) for backward compatibility with older API taking 'int mouse_button = 1' parameter, so if you add other flags remember to re-add the ImGuiPopupFlags_MouseButtonRight.
BeginPopupContextItem :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> bool #foreign imgui "?BeginPopupContextItem@ImGui@@YA_NPEBDH@Z";
BeginPopupContextWindow :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> bool #foreign imgui "?BeginPopupContextWindow@ImGui@@YA_NPEBDH@Z";
BeginPopupContextVoid :: (str_id: *u8 = null, popup_flags: PopupFlags = .MouseButtonRight) -> bool #foreign imgui "?BeginPopupContextVoid@ImGui@@YA_NPEBDH@Z";

// Popups: query functions
//  - IsPopupOpen(): return true if the popup is open at the current BeginPopup() level of the popup stack.
//  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId: return true if any popup is open at the current BeginPopup() level of the popup stack.
//  - IsPopupOpen() with ImGuiPopupFlags_AnyPopupId + ImGuiPopupFlags_AnyPopupLevel: return true if any popup is open.
IsPopupOpen :: (str_id: *u8, flags: PopupFlags = .None) -> bool #foreign imgui "?IsPopupOpen@ImGui@@YA_NPEBDH@Z";

// Tables
// - Full-featured replacement for old Columns API.
// - See Demo->Tables for demo code. See top of imgui_tables.cpp for general commentary.
// - See ImGuiTableFlags_ and ImGuiTableColumnFlags_ enums for a description of available flags.
// The typical call flow is:
// - 1. Call BeginTable(), early out if returning false.
// - 2. Optionally call TableSetupColumn() to submit column name/flags/defaults.
// - 3. Optionally call TableSetupScrollFreeze() to request scroll freezing of columns/rows.
// - 4. Optionally call TableHeadersRow() to submit a header row. Names are pulled from TableSetupColumn() data.
// - 5. Populate contents:
//    - In most situations you can use TableNextRow() + TableSetColumnIndex(N) to start appending into a column.
//    - If you are using tables as a sort of grid, where every columns is holding the same type of contents,
//      you may prefer using TableNextColumn() instead of TableNextRow() + TableSetColumnIndex().
//      TableNextColumn() will automatically wrap-around into the next row if needed.
//    - IMPORTANT: Comparatively to the old Columns() API, we need to call TableNextColumn() for the first column!
//    - Summary of possible call flow:
//        --------------------------------------------------------------------------------------------------------
//        TableNextRow() -> TableSetColumnIndex(0) -> Text("Hello 0") -> TableSetColumnIndex(1) -> Text("Hello 1")  // OK
//        TableNextRow() -> TableNextColumn()      -> Text("Hello 0") -> TableNextColumn()      -> Text("Hello 1")  // OK
//                          TableNextColumn()      -> Text("Hello 0") -> TableNextColumn()      -> Text("Hello 1")  // OK: TableNextColumn() automatically gets to next row!
//        TableNextRow()                           -> Text("Hello 0")                                               // Not OK! Missing TableSetColumnIndex() or TableNextColumn()! Text will not appear!
//        --------------------------------------------------------------------------------------------------------
// - 5. Call EndTable()
BeginTable :: (str_id: *u8, column: s32, flags: TableFlags = .None, outer_size: *ImVec2, inner_width: float = 0.0) -> bool #foreign imgui "?BeginTable@ImGui@@YA_NPEBDHHAEBUImVec2@@M@Z";
BeginTable :: (str_id: *u8, column: s32, flags: TableFlags = .None, outer_size: ImVec2 = ImVec2.{0.0, 0.0}, inner_width: float = 0.0) -> bool #no_context {
    return BeginTable(str_id, column, flags, *outer_size, inner_width);
}
EndTable :: () -> void #foreign imgui "?EndTable@ImGui@@YAXXZ";
TableNextRow :: (row_flags: TableRowFlags = .None, min_row_height: float = 0.0) -> void #foreign imgui "?TableNextRow@ImGui@@YAXHM@Z";
TableNextColumn :: () -> bool #foreign imgui "?TableNextColumn@ImGui@@YA_NXZ";
TableSetColumnIndex :: (column_n: s32) -> bool #foreign imgui "?TableSetColumnIndex@ImGui@@YA_NH@Z";

// Tables: Headers & Columns declaration
// - Use TableSetupColumn() to specify label, resizing policy, default width/weight, id, various other flags etc.
// - Use TableHeadersRow() to create a header row and automatically submit a TableHeader() for each column.
//   Headers are required to perform: reordering, sorting, and opening the context menu.
//   The context menu can also be made available in columns body using ImGuiTableFlags_ContextMenuInBody.
// - You may manually submit headers using TableNextRow() + TableHeader() calls, but this is only useful in
//   some advanced use cases (e.g. adding custom widgets in header row).
// - Use TableSetupScrollFreeze() to lock columns/rows so they stay visible when scrolled.
TableSetupColumn :: (label: *u8, flags: TableColumnFlags = .None, init_width_or_weight: float = 0.0, user_id: ID = 0) -> void #foreign imgui "?TableSetupColumn@ImGui@@YAXPEBDHMI@Z";
TableSetupScrollFreeze :: (cols: s32, rows: s32) -> void #foreign imgui "?TableSetupScrollFreeze@ImGui@@YAXHH@Z";
TableHeadersRow :: () -> void #foreign imgui "?TableHeadersRow@ImGui@@YAXXZ";
TableHeader :: (label: *u8) -> void #foreign imgui "?TableHeader@ImGui@@YAXPEBD@Z";

// Tables: Sorting & Miscellaneous functions
// - Sorting: call TableGetSortSpecs() to retrieve latest sort specs for the table. NULL when not sorting.
//   When 'sort_specs->SpecsDirty == true' you should sort your data. It will be true when sorting specs have
//   changed since last call, or the first time. Make sure to set 'SpecsDirty = false' after sorting,
//   else you may wastefully sort your data every frame!
// - Functions args 'int column_n' treat the default value of -1 as the same as passing the current column index.
TableGetSortSpecs :: () -> *TableSortSpecs #foreign imgui "?TableGetSortSpecs@ImGui@@YAPEAUImGuiTableSortSpecs@@XZ";
TableGetColumnCount :: () -> s32 #foreign imgui "?TableGetColumnCount@ImGui@@YAHXZ";
TableGetColumnIndex :: () -> s32 #foreign imgui "?TableGetColumnIndex@ImGui@@YAHXZ";
TableGetRowIndex :: () -> s32 #foreign imgui "?TableGetRowIndex@ImGui@@YAHXZ";
TableGetColumnName :: (column_n: s32 = -1) -> *u8 #foreign imgui "?TableGetColumnName@ImGui@@YAPEBDH@Z";
TableGetColumnFlags :: (column_n: s32 = -1) -> TableColumnFlags #foreign imgui "?TableGetColumnFlags@ImGui@@YAHH@Z";
TableSetColumnEnabled :: (column_n: s32, v: bool) -> void #foreign imgui "?TableSetColumnEnabled@ImGui@@YAXH_N@Z";
TableSetBgColor :: (target: TableBgTarget, color: ImU32, column_n: s32 = -1) -> void #foreign imgui "?TableSetBgColor@ImGui@@YAXHIH@Z";

// Legacy Columns API (prefer using Tables!)
// - You can also use SameLine(pos_x) to mimic simplified columns.
Columns :: (count: s32 = 1, id: *u8 = null, border := true) -> void #foreign imgui "?Columns@ImGui@@YAXHPEBD_N@Z";
NextColumn :: () -> void #foreign imgui "?NextColumn@ImGui@@YAXXZ";
GetColumnIndex :: () -> s32 #foreign imgui "?GetColumnIndex@ImGui@@YAHXZ";
GetColumnWidth :: (column_index: s32 = -1) -> float #foreign imgui "?GetColumnWidth@ImGui@@YAMH@Z";
SetColumnWidth :: (column_index: s32, width: float) -> void #foreign imgui "?SetColumnWidth@ImGui@@YAXHM@Z";
GetColumnOffset :: (column_index: s32 = -1) -> float #foreign imgui "?GetColumnOffset@ImGui@@YAMH@Z";
SetColumnOffset :: (column_index: s32, offset_x: float) -> void #foreign imgui "?SetColumnOffset@ImGui@@YAXHM@Z";
GetColumnsCount :: () -> s32 #foreign imgui "?GetColumnsCount@ImGui@@YAHXZ";

// Tab Bars, Tabs
// Note: Tabs are automatically created by the docking system. Use this to create tab bars/tabs yourself without docking being involved.
BeginTabBar :: (str_id: *u8, flags: TabBarFlags = .None) -> bool #foreign imgui "?BeginTabBar@ImGui@@YA_NPEBDH@Z";
EndTabBar :: () -> void #foreign imgui "?EndTabBar@ImGui@@YAXXZ";
BeginTabItem :: (label: *u8, p_open: *bool = null, flags: TabItemFlags = .None) -> bool #foreign imgui "?BeginTabItem@ImGui@@YA_NPEBDPEA_NH@Z";
EndTabItem :: () -> void #foreign imgui "?EndTabItem@ImGui@@YAXXZ";
TabItemButton :: (label: *u8, flags: TabItemFlags = .None) -> bool #foreign imgui "?TabItemButton@ImGui@@YA_NPEBDH@Z";
SetTabItemClosed :: (tab_or_docked_window_label: *u8) -> void #foreign imgui "?SetTabItemClosed@ImGui@@YAXPEBD@Z";

// Docking
// [BETA API] Enable with io.ConfigFlags |= ImGuiConfigFlags_DockingEnable.
// Note: You can use most Docking facilities without calling any API. You DO NOT need to call DockSpace() to use Docking!
// - Drag from window title bar or their tab to dock/undock. Hold SHIFT to disable docking/undocking.
// - Drag from window menu button (upper-left button) to undock an entire node (all windows).
// - When io.ConfigDockingWithShift == true, you instead need to hold SHIFT to _enable_ docking/undocking.
// About dockspaces:
// - Use DockSpace() to create an explicit dock node _within_ an existing window. See Docking demo for details.
// - Use DockSpaceOverViewport() to create an explicit dock node covering the screen or a specific viewport.
//   This is often used with ImGuiDockNodeFlags_PassthruCentralNode.
// - Important: Dockspaces need to be submitted _before_ any window they can host. Submit it early in your frame!
// - Important: Dockspaces need to be kept alive if hidden, otherwise windows docked into it will be undocked.
//   e.g. if you have multiple tabs with a dockspace inside each tab: submit the non-visible dockspaces with ImGuiDockNodeFlags_KeepAliveOnly.
DockSpace :: (id: ID, size: *ImVec2, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #foreign imgui "?DockSpace@ImGui@@YAIIAEBUImVec2@@HPEBUImGuiWindowClass@@@Z";
DockSpace :: (id: ID, size: ImVec2 = ImVec2.{0, 0}, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #no_context {
    return DockSpace(id, *size, flags, window_class);
}
DockSpaceOverViewport :: (viewport: *Viewport = null, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #foreign imgui "?DockSpaceOverViewport@ImGui@@YAIPEBUImGuiViewport@@HPEBUImGuiWindowClass@@@Z";
SetNextWindowDockID :: (dock_id: ID, cond: Cond = .None) -> void #foreign imgui "?SetNextWindowDockID@ImGui@@YAXIH@Z";
SetNextWindowClass :: (window_class: *WindowClass) -> void #foreign imgui "?SetNextWindowClass@ImGui@@YAXPEBUImGuiWindowClass@@@Z";
GetWindowDockID :: () -> ID #foreign imgui "?GetWindowDockID@ImGui@@YAIXZ";
IsWindowDocked :: () -> bool #foreign imgui "?IsWindowDocked@ImGui@@YA_NXZ";

// Logging/Capture
// - All text output from the interface can be captured into tty/file/clipboard. By default, tree nodes are automatically opened during logging.
LogToTTY :: (auto_open_depth: s32 = -1) -> void #foreign imgui "?LogToTTY@ImGui@@YAXH@Z";
LogToFile :: (auto_open_depth: s32 = -1, filename: *u8 = null) -> void #foreign imgui "?LogToFile@ImGui@@YAXHPEBD@Z";
LogToClipboard :: (auto_open_depth: s32 = -1) -> void #foreign imgui "?LogToClipboard@ImGui@@YAXH@Z";
LogFinish :: () -> void #foreign imgui "?LogFinish@ImGui@@YAXXZ";
LogButtons :: () -> void #foreign imgui "?LogButtons@ImGui@@YAXXZ";
LogText :: (fmt: *u8, __args: ..Any) -> void #foreign imgui "?LogText@ImGui@@YAXPEBDZZ";

// Drag and Drop
// - On source items, call BeginDragDropSource(), if it returns true also call SetDragDropPayload() + EndDragDropSource().
// - On target candidates, call BeginDragDropTarget(), if it returns true also call AcceptDragDropPayload() + EndDragDropTarget().
// - If you stop calling BeginDragDropSource() the payload is preserved however it won't have a preview tooltip (we currently display a fallback "..." tooltip, see #1725)
// - An item can be both drag source and drop target.
BeginDragDropSource :: (flags: DragDropFlags = .None) -> bool #foreign imgui "?BeginDragDropSource@ImGui@@YA_NH@Z";
SetDragDropPayload :: (type: *u8, data: *void, sz: size_t, cond: Cond = .None) -> bool #foreign imgui "?SetDragDropPayload@ImGui@@YA_NPEBDPEBX_KH@Z";
EndDragDropSource :: () -> void #foreign imgui "?EndDragDropSource@ImGui@@YAXXZ";
BeginDragDropTarget :: () -> bool #foreign imgui "?BeginDragDropTarget@ImGui@@YA_NXZ";
AcceptDragDropPayload :: (type: *u8, flags: DragDropFlags = .None) -> *Payload #foreign imgui "?AcceptDragDropPayload@ImGui@@YAPEBUImGuiPayload@@PEBDH@Z";
EndDragDropTarget :: () -> void #foreign imgui "?EndDragDropTarget@ImGui@@YAXXZ";
GetDragDropPayload :: () -> *Payload #foreign imgui "?GetDragDropPayload@ImGui@@YAPEBUImGuiPayload@@XZ";

// Disabling [BETA API]
// - Disable all user interactions and dim items visuals (applying style.DisabledAlpha over current colors)
// - Those can be nested but it cannot be used to enable an already disabled section (a single BeginDisabled(true) in the stack is enough to keep everything disabled)
// - BeginDisabled(false) essentially does nothing useful but is provided to facilitate use of boolean expressions. If you can avoid calling BeginDisabled(False)/EndDisabled() best to avoid it.
BeginDisabled :: (disabled := true) -> void #foreign imgui "?BeginDisabled@ImGui@@YAX_N@Z";
EndDisabled :: () -> void #foreign imgui "?EndDisabled@ImGui@@YAXXZ";

// Clipping
// - Mouse hovering is affected by ImGui::PushClipRect() calls, unlike direct calls to ImDrawList::PushClipRect() which are render only.
PushClipRect :: (clip_rect_min: *ImVec2, clip_rect_max: *ImVec2, intersect_with_current_clip_rect: bool) -> void #foreign imgui "?PushClipRect@ImGui@@YAXAEBUImVec2@@0_N@Z";
PushClipRect :: (clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool) #no_context {
    PushClipRect(*clip_rect_min, *clip_rect_max, intersect_with_current_clip_rect);
}
PopClipRect :: () -> void #foreign imgui "?PopClipRect@ImGui@@YAXXZ";

// Focus, Activation
// - Prefer using "SetItemDefaultFocus()" over "if (IsWindowAppearing()) SetScrollHereY()" when applicable to signify "this is the default item"
SetItemDefaultFocus :: () -> void #foreign imgui "?SetItemDefaultFocus@ImGui@@YAXXZ";
SetKeyboardFocusHere :: (offset: s32 = 0) -> void #foreign imgui "?SetKeyboardFocusHere@ImGui@@YAXH@Z";

// Item/Widgets Utilities and Query Functions
// - Most of the functions are referring to the previous Item that has been submitted.
// - See Demo Window under "Widgets->Querying Status" for an interactive visualization of most of those functions.
IsItemHovered :: (flags: HoveredFlags = .None) -> bool #foreign imgui "?IsItemHovered@ImGui@@YA_NH@Z";
IsItemActive :: () -> bool #foreign imgui "?IsItemActive@ImGui@@YA_NXZ";
IsItemFocused :: () -> bool #foreign imgui "?IsItemFocused@ImGui@@YA_NXZ";
IsItemClicked :: (mouse_button: MouseButton = .Left) -> bool #foreign imgui "?IsItemClicked@ImGui@@YA_NH@Z";
IsItemVisible :: () -> bool #foreign imgui "?IsItemVisible@ImGui@@YA_NXZ";
IsItemEdited :: () -> bool #foreign imgui "?IsItemEdited@ImGui@@YA_NXZ";
IsItemActivated :: () -> bool #foreign imgui "?IsItemActivated@ImGui@@YA_NXZ";
IsItemDeactivated :: () -> bool #foreign imgui "?IsItemDeactivated@ImGui@@YA_NXZ";
IsItemDeactivatedAfterEdit :: () -> bool #foreign imgui "?IsItemDeactivatedAfterEdit@ImGui@@YA_NXZ";
IsItemToggledOpen :: () -> bool #foreign imgui "?IsItemToggledOpen@ImGui@@YA_NXZ";
IsAnyItemHovered :: () -> bool #foreign imgui "?IsAnyItemHovered@ImGui@@YA_NXZ";
IsAnyItemActive :: () -> bool #foreign imgui "?IsAnyItemActive@ImGui@@YA_NXZ";
IsAnyItemFocused :: () -> bool #foreign imgui "?IsAnyItemFocused@ImGui@@YA_NXZ";
GetItemRectMin :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetItemRectMin@ImGui@@YA?AUImVec2@@XZ";
GetItemRectMax :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetItemRectMax@ImGui@@YA?AUImVec2@@XZ";
GetItemRectSize :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetItemRectSize@ImGui@@YA?AUImVec2@@XZ";
SetItemAllowOverlap :: () -> void #foreign imgui "?SetItemAllowOverlap@ImGui@@YAXXZ";

// Viewports
// - Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
// - In 'docking' branch with multi-viewport enabled, we extend this concept to have multiple active viewports.
// - In the future we will extend this concept further to also represent Platform Monitor and support a "no main platform window" operation mode.
GetMainViewport :: () -> *Viewport #foreign imgui "?GetMainViewport@ImGui@@YAPEAUImGuiViewport@@XZ";

// Background/Foreground Draw Lists
GetBackgroundDrawList :: () -> *ImDrawList #foreign imgui "?GetBackgroundDrawList@ImGui@@YAPEAUImDrawList@@XZ";
GetForegroundDrawList :: () -> *ImDrawList #foreign imgui "?GetForegroundDrawList@ImGui@@YAPEAUImDrawList@@XZ";
GetBackgroundDrawList :: (viewport: *Viewport) -> *ImDrawList #foreign imgui "?GetBackgroundDrawList@ImGui@@YAPEAUImDrawList@@PEAUImGuiViewport@@@Z";
GetForegroundDrawList :: (viewport: *Viewport) -> *ImDrawList #foreign imgui "?GetForegroundDrawList@ImGui@@YAPEAUImDrawList@@PEAUImGuiViewport@@@Z";

// Miscellaneous Utilities
IsRectVisible :: (size: *ImVec2) -> bool #foreign imgui "?IsRectVisible@ImGui@@YA_NAEBUImVec2@@@Z";
IsRectVisible :: (size: ImVec2) -> bool #no_context {
    return IsRectVisible(*size);
}
IsRectVisible :: (rect_min: *ImVec2, rect_max: *ImVec2) -> bool #foreign imgui "?IsRectVisible@ImGui@@YA_NAEBUImVec2@@0@Z";
IsRectVisible :: (rect_min: ImVec2, rect_max: ImVec2) -> bool #no_context {
    return IsRectVisible(*rect_min, *rect_max);
}
GetTime :: () -> float64 #foreign imgui "?GetTime@ImGui@@YANXZ";
GetFrameCount :: () -> s32 #foreign imgui "?GetFrameCount@ImGui@@YAHXZ";
GetDrawListSharedData :: () -> *ImDrawListSharedData #foreign imgui "?GetDrawListSharedData@ImGui@@YAPEAUImDrawListSharedData@@XZ";
GetStyleColorName :: (idx: Col) -> *u8 #foreign imgui "?GetStyleColorName@ImGui@@YAPEBDH@Z";
SetStateStorage :: (storage: *Storage) -> void #foreign imgui "?SetStateStorage@ImGui@@YAXPEAUImGuiStorage@@@Z";
GetStateStorage :: () -> *Storage #foreign imgui "?GetStateStorage@ImGui@@YAPEAUImGuiStorage@@XZ";
BeginChildFrame :: (id: ID, size: *ImVec2, flags: WindowFlags = .None) -> bool #foreign imgui "?BeginChildFrame@ImGui@@YA_NIAEBUImVec2@@H@Z";
BeginChildFrame :: (id: ID, size: ImVec2, flags: WindowFlags = .None) -> bool #no_context {
    return BeginChildFrame(id, *size, flags);
}
EndChildFrame :: () -> void #foreign imgui "?EndChildFrame@ImGui@@YAXXZ";

// Text Utilities
CalcTextSize :: (text: *u8, text_end: *u8 = null, hide_text_after_double_hash := false, wrap_width: float = -1.0) -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?CalcTextSize@ImGui@@YA?AUImVec2@@PEBD0_NM@Z";
CalcTextSize :: (text: string, hide_text_after_double_hash := false, wrap_width: float = -1.0) -> ImVec2 #no_context {
    return CalcTextSize(text.data, text.data + text.count, hide_text_after_double_hash, wrap_width);
}

// Color Utilities
ColorConvertU32ToFloat4 :: (in: ImU32) -> ImVec4 #cpp_return_type_is_non_pod #foreign imgui "?ColorConvertU32ToFloat4@ImGui@@YA?AUImVec4@@I@Z";
ColorConvertFloat4ToU32 :: (in: *ImVec4) -> ImU32 #foreign imgui "?ColorConvertFloat4ToU32@ImGui@@YAIAEBUImVec4@@@Z";
ColorConvertFloat4ToU32 :: (in: ImVec4) -> ImU32 #no_context {
    return ColorConvertFloat4ToU32(*in);
}
ColorConvertRGBtoHSV :: (r: float, g: float, b: float, out_h: *float, out_s: *float, out_v: *float) -> void #foreign imgui "?ColorConvertRGBtoHSV@ImGui@@YAXMMMAEAM00@Z";
ColorConvertHSVtoRGB :: (h: float, s: float, v: float, out_r: *float, out_g: *float, out_b: *float) -> void #foreign imgui "?ColorConvertHSVtoRGB@ImGui@@YAXMMMAEAM00@Z";

// Inputs Utilities: Keyboard
// Without IMGUI_DISABLE_OBSOLETE_KEYIO: (legacy support)
//   - For 'ImGuiKey key' you can still use your legacy native/user indices according to how your backend/engine stored them in io.KeysDown[].
// With IMGUI_DISABLE_OBSOLETE_KEYIO: (this is the way forward)
//   - Any use of 'ImGuiKey' will assert when key < 512 will be passed, previously reserved as native/user keys indices
//   - GetKeyIndex() is pass-through and therefore deprecated (gone if IMGUI_DISABLE_OBSOLETE_KEYIO is defined)
IsKeyDown :: (key: Key) -> bool #foreign imgui "?IsKeyDown@ImGui@@YA_NH@Z";
IsKeyPressed :: (key: Key, repeat := true) -> bool #foreign imgui "?IsKeyPressed@ImGui@@YA_NH_N@Z";
IsKeyReleased :: (key: Key) -> bool #foreign imgui "?IsKeyReleased@ImGui@@YA_NH@Z";
GetKeyPressedAmount :: (key: Key, repeat_delay: float, rate: float) -> s32 #foreign imgui "?GetKeyPressedAmount@ImGui@@YAHHMM@Z";
GetKeyName :: (key: Key) -> *u8 #foreign imgui "?GetKeyName@ImGui@@YAPEBDH@Z";
SetNextFrameWantCaptureKeyboard :: (want_capture_keyboard: bool) -> void #foreign imgui "?SetNextFrameWantCaptureKeyboard@ImGui@@YAX_N@Z";

// Inputs Utilities: Mouse
// - To refer to a mouse button, you may use named enums in your code e.g. ImGuiMouseButton_Left, ImGuiMouseButton_Right.
// - You can also use regular integer: it is forever guaranteed that 0=Left, 1=Right, 2=Middle.
// - Dragging operations are only reported after mouse has moved a certain distance away from the initial clicking position (see 'lock_threshold' and 'io.MouseDraggingThreshold')
IsMouseDown :: (button: MouseButton) -> bool #foreign imgui "?IsMouseDown@ImGui@@YA_NH@Z";
IsMouseClicked :: (button: MouseButton, repeat := false) -> bool #foreign imgui "?IsMouseClicked@ImGui@@YA_NH_N@Z";
IsMouseReleased :: (button: MouseButton) -> bool #foreign imgui "?IsMouseReleased@ImGui@@YA_NH@Z";
IsMouseDoubleClicked :: (button: MouseButton) -> bool #foreign imgui "?IsMouseDoubleClicked@ImGui@@YA_NH@Z";
GetMouseClickedCount :: (button: MouseButton) -> s32 #foreign imgui "?GetMouseClickedCount@ImGui@@YAHH@Z";
IsMouseHoveringRect :: (r_min: *ImVec2, r_max: *ImVec2, clip := true) -> bool #foreign imgui "?IsMouseHoveringRect@ImGui@@YA_NAEBUImVec2@@0_N@Z";
IsMouseHoveringRect :: (r_min: ImVec2, r_max: ImVec2, clip := true) -> bool #no_context {
    return IsMouseHoveringRect(*r_min, *r_max, clip);
}
IsMousePosValid :: (mouse_pos: *ImVec2 = null) -> bool #foreign imgui "?IsMousePosValid@ImGui@@YA_NPEBUImVec2@@@Z";
IsAnyMouseDown :: () -> bool #foreign imgui "?IsAnyMouseDown@ImGui@@YA_NXZ";
GetMousePos :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetMousePos@ImGui@@YA?AUImVec2@@XZ";
GetMousePosOnOpeningCurrentPopup :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetMousePosOnOpeningCurrentPopup@ImGui@@YA?AUImVec2@@XZ";
IsMouseDragging :: (button: MouseButton, lock_threshold: float = -1.0) -> bool #foreign imgui "?IsMouseDragging@ImGui@@YA_NHM@Z";
GetMouseDragDelta :: (button: MouseButton = .Left, lock_threshold: float = -1.0) -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui "?GetMouseDragDelta@ImGui@@YA?AUImVec2@@HM@Z";
ResetMouseDragDelta :: (button: MouseButton = .Left) -> void #foreign imgui "?ResetMouseDragDelta@ImGui@@YAXH@Z";
GetMouseCursor :: () -> MouseCursor #foreign imgui "?GetMouseCursor@ImGui@@YAHXZ";
SetMouseCursor :: (cursor_type: MouseCursor) -> void #foreign imgui "?SetMouseCursor@ImGui@@YAXH@Z";
SetNextFrameWantCaptureMouse :: (want_capture_mouse: bool) -> void #foreign imgui "?SetNextFrameWantCaptureMouse@ImGui@@YAX_N@Z";

// Clipboard Utilities
// - Also see the LogToClipboard() function to capture GUI into clipboard, or easily output text data to the clipboard.
GetClipboardText :: () -> *u8 #foreign imgui "?GetClipboardText@ImGui@@YAPEBDXZ";
SetClipboardText :: (text: *u8) -> void #foreign imgui "?SetClipboardText@ImGui@@YAXPEBD@Z";

// Settings/.Ini Utilities
// - The disk functions are automatically called if io.IniFilename != NULL (default is "imgui.ini").
// - Set io.IniFilename to NULL to load/save manually. Read io.WantSaveIniSettings description about handling .ini saving manually.
// - Important: default value "imgui.ini" is relative to current working dir! Most apps will want to lock this to an absolute path (e.g. same path as executables).
LoadIniSettingsFromDisk :: (ini_filename: *u8) -> void #foreign imgui "?LoadIniSettingsFromDisk@ImGui@@YAXPEBD@Z";
LoadIniSettingsFromMemory :: (ini_data: *u8, ini_size: size_t = 0) -> void #foreign imgui "?LoadIniSettingsFromMemory@ImGui@@YAXPEBD_K@Z";
SaveIniSettingsToDisk :: (ini_filename: *u8) -> void #foreign imgui "?SaveIniSettingsToDisk@ImGui@@YAXPEBD@Z";
SaveIniSettingsToMemory :: (out_ini_size: *size_t = null) -> *u8 #foreign imgui "?SaveIniSettingsToMemory@ImGui@@YAPEBDPEA_K@Z";

// Debug Utilities
DebugTextEncoding :: (text: *u8) -> void #foreign imgui "?DebugTextEncoding@ImGui@@YAXPEBD@Z";
DebugCheckVersionAndDataLayout :: (version_str: *u8, sz_io: size_t, sz_style: size_t, sz_vec2: size_t, sz_vec4: size_t, sz_drawvert: size_t, sz_drawidx: size_t) -> bool #foreign imgui "?DebugCheckVersionAndDataLayout@ImGui@@YA_NPEBD_K11111@Z";

// Memory Allocators
// - Those functions are not reliant on the current context.
// - DLL users: heaps and globals are not shared across DLL boundaries! You will need to call SetCurrentContext() + SetAllocatorFunctions()
//   for each static/DLL boundary you are calling from. Read "Context and Memory Allocators" section of imgui.cpp for more details.
SetAllocatorFunctions :: (alloc_func: MemAllocFunc, free_func: MemFreeFunc, user_data: *void = null) -> void #foreign imgui "?SetAllocatorFunctions@ImGui@@YAXP6APEAX_KPEAX@ZP6AX11@Z1@Z";
GetAllocatorFunctions :: (p_alloc_func: *MemAllocFunc, p_free_func: *MemFreeFunc, p_user_data: **void) -> void #foreign imgui "?GetAllocatorFunctions@ImGui@@YAXPEAP6APEAX_KPEAX@ZPEAP6AX11@ZPEAPEAX@Z";
MemAlloc :: (size: size_t) -> *void #foreign imgui "?MemAlloc@ImGui@@YAPEAX_K@Z";
MemFree :: (ptr: *void) -> void #foreign imgui "?MemFree@ImGui@@YAXPEAX@Z";

// (Optional) Platform/OS interface for multi-viewport support
// Read comments around the ImGuiPlatformIO structure for more details.
// Note: You may use GetWindowViewport() to get the current viewport of the current window.
GetPlatformIO :: () -> *PlatformIO #foreign imgui "?GetPlatformIO@ImGui@@YAAEAUImGuiPlatformIO@@XZ";
UpdatePlatformWindows :: () -> void #foreign imgui "?UpdatePlatformWindows@ImGui@@YAXXZ";
RenderPlatformWindowsDefault :: (platform_render_arg: *void = null, renderer_render_arg: *void = null) -> void #foreign imgui "?RenderPlatformWindowsDefault@ImGui@@YAXPEAX0@Z";
DestroyPlatformWindows :: () -> void #foreign imgui "?DestroyPlatformWindows@ImGui@@YAXXZ";
FindViewportByID :: (id: ID) -> *Viewport #foreign imgui "?FindViewportByID@ImGui@@YAPEAUImGuiViewport@@I@Z";
FindViewportByPlatformHandle :: (platform_handle: *void) -> *Viewport #foreign imgui "?FindViewportByPlatformHandle@ImGui@@YAPEAUImGuiViewport@@PEAX@Z";

GetKeyIndex :: (key: Key) -> s32 #foreign imgui "?GetKeyIndex@ImGui@@YAHH@Z";

// OBSOLETED in 1.86 (from November 2021)
CalcListClipping :: (items_count: s32, items_height: float, out_items_display_start: *s32, out_items_display_end: *s32) -> void #foreign imgui "?CalcListClipping@ImGui@@YAXHMPEAH0@Z";

// OBSOLETED in 1.81 (from February 2021)
ListBoxHeader :: (label: *u8, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui "?ListBoxHeader@ImGui@@YA_NPEBDHH@Z";

// OBSOLETED in 1.78 (from June 2020)
// Old drag/sliders functions that took a 'float power = 1.0' argument instead of flags.
// For shared code, you can version check at compile-time with `#if IMGUI_VERSION_NUM >= 17704`.
DragScalar :: (label: *u8, data_type: DataType, p_data: *void, v_speed: float, p_min: *void, p_max: *void, format: *u8, power: float) -> bool #foreign imgui "?DragScalar@ImGui@@YA_NPEBDHPEAXMPEBX20M@Z";
DragScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, v_speed: float, p_min: *void, p_max: *void, format: *u8, power: float) -> bool #foreign imgui "?DragScalarN@ImGui@@YA_NPEBDHPEAXHMPEBX20M@Z";

SliderScalar :: (label: *u8, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8, power: float) -> bool #foreign imgui "?SliderScalar@ImGui@@YA_NPEBDHPEAXPEBX20M@Z";
SliderScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_min: *void, p_max: *void, format: *u8, power: float) -> bool #foreign imgui "?SliderScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20M@Z";

// Flags for ImGui::Begin()
WindowFlags :: enum_flags s32 {
    None                      :: 0x0;
    NoTitleBar                :: 0x1;
    NoResize                  :: 0x2;
    NoMove                    :: 0x4;
    NoScrollbar               :: 0x8;
    NoScrollWithMouse         :: 0x10;
    NoCollapse                :: 0x20;
    AlwaysAutoResize          :: 0x40;
    NoBackground              :: 0x80;
    NoSavedSettings           :: 0x100;
    NoMouseInputs             :: 0x200;
    MenuBar                   :: 0x400;
    HorizontalScrollbar       :: 0x800;
    NoFocusOnAppearing        :: 0x1000;
    NoBringToFrontOnFocus     :: 0x2000;
    AlwaysVerticalScrollbar   :: 0x4000;
    AlwaysHorizontalScrollbar :: 0x8000;
    AlwaysUseWindowPadding    :: 0x10000;
    NoNavInputs               :: 0x40000;
    NoNavFocus                :: 0x80000;
    UnsavedDocument           :: 0x100000;
    NoDocking                 :: 0x200000;

    NoNav                     :: 0xc0000;
    NoDecoration              :: 0x2b;
    NoInputs                  :: 0xc0200;

    NavFlattened              :: 0x800000;
    ChildWindow               :: 0x1000000;
    Tooltip                   :: 0x2000000;
    Popup                     :: 0x4000000;
    Modal                     :: 0x8000000;
    ChildMenu                 :: 0x10000000;
    DockNodeHost              :: 0x20000000;

    ImGuiWindowFlags_None                      :: None;
    ImGuiWindowFlags_NoTitleBar                :: NoTitleBar;
    ImGuiWindowFlags_NoResize                  :: NoResize;
    ImGuiWindowFlags_NoMove                    :: NoMove;
    ImGuiWindowFlags_NoScrollbar               :: NoScrollbar;
    ImGuiWindowFlags_NoScrollWithMouse         :: NoScrollWithMouse;
    ImGuiWindowFlags_NoCollapse                :: NoCollapse;
    ImGuiWindowFlags_AlwaysAutoResize          :: AlwaysAutoResize;
    ImGuiWindowFlags_NoBackground              :: NoBackground;
    ImGuiWindowFlags_NoSavedSettings           :: NoSavedSettings;
    ImGuiWindowFlags_NoMouseInputs             :: NoMouseInputs;
    ImGuiWindowFlags_MenuBar                   :: MenuBar;
    ImGuiWindowFlags_HorizontalScrollbar       :: HorizontalScrollbar;
    ImGuiWindowFlags_NoFocusOnAppearing        :: NoFocusOnAppearing;
    ImGuiWindowFlags_NoBringToFrontOnFocus     :: NoBringToFrontOnFocus;
    ImGuiWindowFlags_AlwaysVerticalScrollbar   :: AlwaysVerticalScrollbar;
    ImGuiWindowFlags_AlwaysHorizontalScrollbar :: AlwaysHorizontalScrollbar;
    ImGuiWindowFlags_AlwaysUseWindowPadding    :: AlwaysUseWindowPadding;
    ImGuiWindowFlags_NoNavInputs               :: NoNavInputs;
    ImGuiWindowFlags_NoNavFocus                :: NoNavFocus;
    ImGuiWindowFlags_UnsavedDocument           :: UnsavedDocument;
    ImGuiWindowFlags_NoDocking                 :: NoDocking;

    ImGuiWindowFlags_NoNav                     :: NoNav;
    ImGuiWindowFlags_NoDecoration              :: NoDecoration;
    ImGuiWindowFlags_NoInputs                  :: NoInputs;

    ImGuiWindowFlags_NavFlattened              :: NavFlattened;
    ImGuiWindowFlags_ChildWindow               :: ChildWindow;
    ImGuiWindowFlags_Tooltip                   :: Tooltip;
    ImGuiWindowFlags_Popup                     :: Popup;
    ImGuiWindowFlags_Modal                     :: Modal;
    ImGuiWindowFlags_ChildMenu                 :: ChildMenu;
    ImGuiWindowFlags_DockNodeHost              :: DockNodeHost;
}

// Flags for ImGui::InputText()
InputTextFlags :: enum_flags s32 {
    None                :: 0x0;
    CharsDecimal        :: 0x1;
    CharsHexadecimal    :: 0x2;
    CharsUppercase      :: 0x4;
    CharsNoBlank        :: 0x8;
    AutoSelectAll       :: 0x10;
    EnterReturnsTrue    :: 0x20;
    CallbackCompletion  :: 0x40;
    CallbackHistory     :: 0x80;
    CallbackAlways      :: 0x100;
    CallbackCharFilter  :: 0x200;
    AllowTabInput       :: 0x400;
    CtrlEnterForNewLine :: 0x800;
    NoHorizontalScroll  :: 0x1000;
    AlwaysOverwrite     :: 0x2000;
    ReadOnly            :: 0x4000;
    Password            :: 0x8000;
    NoUndoRedo          :: 0x10000;
    CharsScientific     :: 0x20000;
    CallbackResize      :: 0x40000;
    CallbackEdit        :: 0x80000;

    AlwaysInsertMode    :: 0x2000;

    ImGuiInputTextFlags_None                :: None;
    ImGuiInputTextFlags_CharsDecimal        :: CharsDecimal;
    ImGuiInputTextFlags_CharsHexadecimal    :: CharsHexadecimal;
    ImGuiInputTextFlags_CharsUppercase      :: CharsUppercase;
    ImGuiInputTextFlags_CharsNoBlank        :: CharsNoBlank;
    ImGuiInputTextFlags_AutoSelectAll       :: AutoSelectAll;
    ImGuiInputTextFlags_EnterReturnsTrue    :: EnterReturnsTrue;
    ImGuiInputTextFlags_CallbackCompletion  :: CallbackCompletion;
    ImGuiInputTextFlags_CallbackHistory     :: CallbackHistory;
    ImGuiInputTextFlags_CallbackAlways      :: CallbackAlways;
    ImGuiInputTextFlags_CallbackCharFilter  :: CallbackCharFilter;
    ImGuiInputTextFlags_AllowTabInput       :: AllowTabInput;
    ImGuiInputTextFlags_CtrlEnterForNewLine :: CtrlEnterForNewLine;
    ImGuiInputTextFlags_NoHorizontalScroll  :: NoHorizontalScroll;
    ImGuiInputTextFlags_AlwaysOverwrite     :: AlwaysOverwrite;
    ImGuiInputTextFlags_ReadOnly            :: ReadOnly;
    ImGuiInputTextFlags_Password            :: Password;
    ImGuiInputTextFlags_NoUndoRedo          :: NoUndoRedo;
    ImGuiInputTextFlags_CharsScientific     :: CharsScientific;
    ImGuiInputTextFlags_CallbackResize      :: CallbackResize;
    ImGuiInputTextFlags_CallbackEdit        :: CallbackEdit;

    ImGuiInputTextFlags_AlwaysInsertMode    :: AlwaysInsertMode;
}

// Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
TreeNodeFlags :: enum_flags s32 {
    None                 :: 0x0;
    Selected             :: 0x1;
    Framed               :: 0x2;
    AllowItemOverlap     :: 0x4;
    NoTreePushOnOpen     :: 0x8;
    NoAutoOpenOnLog      :: 0x10;
    DefaultOpen          :: 0x20;
    OpenOnDoubleClick    :: 0x40;
    OpenOnArrow          :: 0x80;
    Leaf                 :: 0x100;
    Bullet               :: 0x200;
    FramePadding         :: 0x400;
    SpanAvailWidth       :: 0x800;
    SpanFullWidth        :: 0x1000;
    NavLeftJumpsBackHere :: 0x2000;

    CollapsingHeader     :: 0x1a;

    ImGuiTreeNodeFlags_None                 :: None;
    ImGuiTreeNodeFlags_Selected             :: Selected;
    ImGuiTreeNodeFlags_Framed               :: Framed;
    ImGuiTreeNodeFlags_AllowItemOverlap     :: AllowItemOverlap;
    ImGuiTreeNodeFlags_NoTreePushOnOpen     :: NoTreePushOnOpen;
    ImGuiTreeNodeFlags_NoAutoOpenOnLog      :: NoAutoOpenOnLog;
    ImGuiTreeNodeFlags_DefaultOpen          :: DefaultOpen;
    ImGuiTreeNodeFlags_OpenOnDoubleClick    :: OpenOnDoubleClick;
    ImGuiTreeNodeFlags_OpenOnArrow          :: OpenOnArrow;
    ImGuiTreeNodeFlags_Leaf                 :: Leaf;
    ImGuiTreeNodeFlags_Bullet               :: Bullet;
    ImGuiTreeNodeFlags_FramePadding         :: FramePadding;
    ImGuiTreeNodeFlags_SpanAvailWidth       :: SpanAvailWidth;
    ImGuiTreeNodeFlags_SpanFullWidth        :: SpanFullWidth;
    ImGuiTreeNodeFlags_NavLeftJumpsBackHere :: NavLeftJumpsBackHere;

    ImGuiTreeNodeFlags_CollapsingHeader     :: CollapsingHeader;
}

// Flags for OpenPopup*(), BeginPopupContext*(), IsPopupOpen() functions.
// - To be backward compatible with older API which took an 'int mouse_button = 1' argument, we need to treat
//   small flags values as a mouse button index, so we encode the mouse button in the first few bits of the flags.
//   It is therefore guaranteed to be legal to pass a mouse button index in ImGuiPopupFlags.
// - For the same reason, we exceptionally default the ImGuiPopupFlags argument of BeginPopupContextXXX functions to 1 instead of 0.
//   IMPORTANT: because the default parameter is 1 (==ImGuiPopupFlags_MouseButtonRight), if you rely on the default parameter
//   and want to another another flag, you need to pass in the ImGuiPopupFlags_MouseButtonRight flag.
// - Multiple buttons currently cannot be combined/or-ed in those functions (we could allow it later).
PopupFlags :: enum_flags s32 {
    None                    :: 0x0;
    MouseButtonLeft         :: 0x0;
    MouseButtonRight        :: 0x1;
    MouseButtonMiddle       :: 0x2;
    MouseButtonMask_        :: 0x1f;
    MouseButtonDefault_     :: 0x1;
    NoOpenOverExistingPopup :: 0x20;
    NoOpenOverItems         :: 0x40;
    AnyPopupId              :: 0x80;
    AnyPopupLevel           :: 0x100;
    AnyPopup                :: 0x180;

    ImGuiPopupFlags_None                    :: None;
    ImGuiPopupFlags_MouseButtonLeft         :: MouseButtonLeft;
    ImGuiPopupFlags_MouseButtonRight        :: MouseButtonRight;
    ImGuiPopupFlags_MouseButtonMiddle       :: MouseButtonMiddle;
    ImGuiPopupFlags_MouseButtonMask_        :: MouseButtonMask_;
    ImGuiPopupFlags_MouseButtonDefault_     :: MouseButtonDefault_;
    ImGuiPopupFlags_NoOpenOverExistingPopup :: NoOpenOverExistingPopup;
    ImGuiPopupFlags_NoOpenOverItems         :: NoOpenOverItems;
    ImGuiPopupFlags_AnyPopupId              :: AnyPopupId;
    ImGuiPopupFlags_AnyPopupLevel           :: AnyPopupLevel;
    ImGuiPopupFlags_AnyPopup                :: AnyPopup;
}

// Flags for ImGui::Selectable()
SelectableFlags :: enum_flags s32 {
    None             :: 0x0;
    DontClosePopups  :: 0x1;
    SpanAllColumns   :: 0x2;
    AllowDoubleClick :: 0x4;
    Disabled         :: 0x8;
    AllowItemOverlap :: 0x10;

    ImGuiSelectableFlags_None             :: None;
    ImGuiSelectableFlags_DontClosePopups  :: DontClosePopups;
    ImGuiSelectableFlags_SpanAllColumns   :: SpanAllColumns;
    ImGuiSelectableFlags_AllowDoubleClick :: AllowDoubleClick;
    ImGuiSelectableFlags_Disabled         :: Disabled;
    ImGuiSelectableFlags_AllowItemOverlap :: AllowItemOverlap;
}

// Flags for ImGui::BeginCombo()
ComboFlags :: enum_flags s32 {
    None           :: 0x0;
    PopupAlignLeft :: 0x1;
    HeightSmall    :: 0x2;
    HeightRegular  :: 0x4;
    HeightLarge    :: 0x8;
    HeightLargest  :: 0x10;
    NoArrowButton  :: 0x20;
    NoPreview      :: 0x40;
    HeightMask_    :: 0x1e;

    ImGuiComboFlags_None           :: None;
    ImGuiComboFlags_PopupAlignLeft :: PopupAlignLeft;
    ImGuiComboFlags_HeightSmall    :: HeightSmall;
    ImGuiComboFlags_HeightRegular  :: HeightRegular;
    ImGuiComboFlags_HeightLarge    :: HeightLarge;
    ImGuiComboFlags_HeightLargest  :: HeightLargest;
    ImGuiComboFlags_NoArrowButton  :: NoArrowButton;
    ImGuiComboFlags_NoPreview      :: NoPreview;
    ImGuiComboFlags_HeightMask_    :: HeightMask_;
}

// Flags for ImGui::BeginTabBar()
TabBarFlags :: enum_flags s32 {
    None                         :: 0x0;
    Reorderable                  :: 0x1;
    AutoSelectNewTabs            :: 0x2;
    TabListPopupButton           :: 0x4;
    NoCloseWithMiddleMouseButton :: 0x8;
    NoTabListScrollingButtons    :: 0x10;
    NoTooltip                    :: 0x20;
    FittingPolicyResizeDown      :: 0x40;
    FittingPolicyScroll          :: 0x80;
    FittingPolicyMask_           :: 0xc0;
    FittingPolicyDefault_        :: 0x40;

    ImGuiTabBarFlags_None                         :: None;
    ImGuiTabBarFlags_Reorderable                  :: Reorderable;
    ImGuiTabBarFlags_AutoSelectNewTabs            :: AutoSelectNewTabs;
    ImGuiTabBarFlags_TabListPopupButton           :: TabListPopupButton;
    ImGuiTabBarFlags_NoCloseWithMiddleMouseButton :: NoCloseWithMiddleMouseButton;
    ImGuiTabBarFlags_NoTabListScrollingButtons    :: NoTabListScrollingButtons;
    ImGuiTabBarFlags_NoTooltip                    :: NoTooltip;
    ImGuiTabBarFlags_FittingPolicyResizeDown      :: FittingPolicyResizeDown;
    ImGuiTabBarFlags_FittingPolicyScroll          :: FittingPolicyScroll;
    ImGuiTabBarFlags_FittingPolicyMask_           :: FittingPolicyMask_;
    ImGuiTabBarFlags_FittingPolicyDefault_        :: FittingPolicyDefault_;
}

// Flags for ImGui::BeginTabItem()
TabItemFlags :: enum_flags s32 {
    None                         :: 0x0;
    UnsavedDocument              :: 0x1;
    SetSelected                  :: 0x2;
    NoCloseWithMiddleMouseButton :: 0x4;
    NoPushId                     :: 0x8;
    NoTooltip                    :: 0x10;
    NoReorder                    :: 0x20;
    Leading                      :: 0x40;
    Trailing                     :: 0x80;

    ImGuiTabItemFlags_None                         :: None;
    ImGuiTabItemFlags_UnsavedDocument              :: UnsavedDocument;
    ImGuiTabItemFlags_SetSelected                  :: SetSelected;
    ImGuiTabItemFlags_NoCloseWithMiddleMouseButton :: NoCloseWithMiddleMouseButton;
    ImGuiTabItemFlags_NoPushId                     :: NoPushId;
    ImGuiTabItemFlags_NoTooltip                    :: NoTooltip;
    ImGuiTabItemFlags_NoReorder                    :: NoReorder;
    ImGuiTabItemFlags_Leading                      :: Leading;
    ImGuiTabItemFlags_Trailing                     :: Trailing;
}

// Flags for ImGui::BeginTable()
// - Important! Sizing policies have complex and subtle side effects, much more so than you would expect.
//   Read comments/demos carefully + experiment with live demos to get acquainted with them.
// - The DEFAULT sizing policies are:
//    - Default to ImGuiTableFlags_SizingFixedFit    if ScrollX is on, or if host window has ImGuiWindowFlags_AlwaysAutoResize.
//    - Default to ImGuiTableFlags_SizingStretchSame if ScrollX is off.
// - When ScrollX is off:
//    - Table defaults to ImGuiTableFlags_SizingStretchSame -> all Columns defaults to ImGuiTableColumnFlags_WidthStretch with same weight.
//    - Columns sizing policy allowed: Stretch (default), Fixed/Auto.
//    - Fixed Columns (if any) will generally obtain their requested width (unless the table cannot fit them all).
//    - Stretch Columns will share the remaining width according to their respective weight.
//    - Mixed Fixed/Stretch columns is possible but has various side-effects on resizing behaviors.
//      The typical use of mixing sizing policies is: any number of LEADING Fixed columns, followed by one or two TRAILING Stretch columns.
//      (this is because the visible order of columns have subtle but necessary effects on how they react to manual resizing).
// - When ScrollX is on:
//    - Table defaults to ImGuiTableFlags_SizingFixedFit -> all Columns defaults to ImGuiTableColumnFlags_WidthFixed
//    - Columns sizing policy allowed: Fixed/Auto mostly.
//    - Fixed Columns can be enlarged as needed. Table will show an horizontal scrollbar if needed.
//    - When using auto-resizing (non-resizable) fixed columns, querying the content width to use item right-alignment e.g. SetNextItemWidth(-FLT_MIN) doesn't make sense, would create a feedback loop.
//    - Using Stretch columns OFTEN DOES NOT MAKE SENSE if ScrollX is on, UNLESS you have specified a value for 'inner_width' in BeginTable().
//      If you specify a value for 'inner_width' then effectively the scrolling space is known and Stretch or mixed Fixed/Stretch columns become meaningful again.
// - Read on documentation at the top of imgui_tables.cpp for details.
TableFlags :: enum_flags s32 {
    None                       :: 0x0;
    Resizable                  :: 0x1;
    Reorderable                :: 0x2;
    Hideable                   :: 0x4;
    Sortable                   :: 0x8;
    NoSavedSettings            :: 0x10;
    ContextMenuInBody          :: 0x20;

    RowBg                      :: 0x40;
    BordersInnerH              :: 0x80;
    BordersOuterH              :: 0x100;
    BordersInnerV              :: 0x200;
    BordersOuterV              :: 0x400;
    BordersH                   :: 0x180;
    BordersV                   :: 0x600;
    BordersInner               :: 0x280;
    BordersOuter               :: 0x500;
    Borders                    :: 0x780;
    NoBordersInBody            :: 0x800;
    NoBordersInBodyUntilResize :: 0x1000;

    SizingFixedFit             :: 0x2000;
    SizingFixedSame            :: 0x4000;
    SizingStretchProp          :: 0x6000;
    SizingStretchSame          :: 0x8000;

    NoHostExtendX              :: 0x10000;
    NoHostExtendY              :: 0x20000;
    NoKeepColumnsVisible       :: 0x40000;
    PreciseWidths              :: 0x80000;

    NoClip                     :: 0x100000;

    PadOuterX                  :: 0x200000;
    NoPadOuterX                :: 0x400000;
    NoPadInnerX                :: 0x800000;

    ScrollX                    :: 0x1000000;
    ScrollY                    :: 0x2000000;

    SortMulti                  :: 0x4000000;
    SortTristate               :: 0x8000000;

    SizingMask_                :: 0xe000;

    ImGuiTableFlags_None                       :: None;
    ImGuiTableFlags_Resizable                  :: Resizable;
    ImGuiTableFlags_Reorderable                :: Reorderable;
    ImGuiTableFlags_Hideable                   :: Hideable;
    ImGuiTableFlags_Sortable                   :: Sortable;
    ImGuiTableFlags_NoSavedSettings            :: NoSavedSettings;
    ImGuiTableFlags_ContextMenuInBody          :: ContextMenuInBody;

    ImGuiTableFlags_RowBg                      :: RowBg;
    ImGuiTableFlags_BordersInnerH              :: BordersInnerH;
    ImGuiTableFlags_BordersOuterH              :: BordersOuterH;
    ImGuiTableFlags_BordersInnerV              :: BordersInnerV;
    ImGuiTableFlags_BordersOuterV              :: BordersOuterV;
    ImGuiTableFlags_BordersH                   :: BordersH;
    ImGuiTableFlags_BordersV                   :: BordersV;
    ImGuiTableFlags_BordersInner               :: BordersInner;
    ImGuiTableFlags_BordersOuter               :: BordersOuter;
    ImGuiTableFlags_Borders                    :: Borders;
    ImGuiTableFlags_NoBordersInBody            :: NoBordersInBody;
    ImGuiTableFlags_NoBordersInBodyUntilResize :: NoBordersInBodyUntilResize;

    ImGuiTableFlags_SizingFixedFit             :: SizingFixedFit;
    ImGuiTableFlags_SizingFixedSame            :: SizingFixedSame;
    ImGuiTableFlags_SizingStretchProp          :: SizingStretchProp;
    ImGuiTableFlags_SizingStretchSame          :: SizingStretchSame;

    ImGuiTableFlags_NoHostExtendX              :: NoHostExtendX;
    ImGuiTableFlags_NoHostExtendY              :: NoHostExtendY;
    ImGuiTableFlags_NoKeepColumnsVisible       :: NoKeepColumnsVisible;
    ImGuiTableFlags_PreciseWidths              :: PreciseWidths;

    ImGuiTableFlags_NoClip                     :: NoClip;

    ImGuiTableFlags_PadOuterX                  :: PadOuterX;
    ImGuiTableFlags_NoPadOuterX                :: NoPadOuterX;
    ImGuiTableFlags_NoPadInnerX                :: NoPadInnerX;

    ImGuiTableFlags_ScrollX                    :: ScrollX;
    ImGuiTableFlags_ScrollY                    :: ScrollY;

    ImGuiTableFlags_SortMulti                  :: SortMulti;
    ImGuiTableFlags_SortTristate               :: SortTristate;

    ImGuiTableFlags_SizingMask_                :: SizingMask_;
}

// Flags for ImGui::TableSetupColumn()
TableColumnFlags :: enum_flags s32 {
    None                 :: 0x0;
    Disabled             :: 0x1;
    DefaultHide          :: 0x2;
    DefaultSort          :: 0x4;
    WidthStretch         :: 0x8;
    WidthFixed           :: 0x10;
    NoResize             :: 0x20;
    NoReorder            :: 0x40;
    NoHide               :: 0x80;
    NoClip               :: 0x100;
    NoSort               :: 0x200;
    NoSortAscending      :: 0x400;
    NoSortDescending     :: 0x800;
    NoHeaderLabel        :: 0x1000;
    NoHeaderWidth        :: 0x2000;
    PreferSortAscending  :: 0x4000;
    PreferSortDescending :: 0x8000;
    IndentEnable         :: 0x10000;
    IndentDisable        :: 0x20000;

    IsEnabled            :: 0x1000000;
    IsVisible            :: 0x2000000;
    IsSorted             :: 0x4000000;
    IsHovered            :: 0x8000000;

    WidthMask_           :: 0x18;
    IndentMask_          :: 0x30000;
    StatusMask_          :: 0xf000000;
    NoDirectResize_      :: 0x40000000;

    ImGuiTableColumnFlags_None                 :: None;
    ImGuiTableColumnFlags_Disabled             :: Disabled;
    ImGuiTableColumnFlags_DefaultHide          :: DefaultHide;
    ImGuiTableColumnFlags_DefaultSort          :: DefaultSort;
    ImGuiTableColumnFlags_WidthStretch         :: WidthStretch;
    ImGuiTableColumnFlags_WidthFixed           :: WidthFixed;
    ImGuiTableColumnFlags_NoResize             :: NoResize;
    ImGuiTableColumnFlags_NoReorder            :: NoReorder;
    ImGuiTableColumnFlags_NoHide               :: NoHide;
    ImGuiTableColumnFlags_NoClip               :: NoClip;
    ImGuiTableColumnFlags_NoSort               :: NoSort;
    ImGuiTableColumnFlags_NoSortAscending      :: NoSortAscending;
    ImGuiTableColumnFlags_NoSortDescending     :: NoSortDescending;
    ImGuiTableColumnFlags_NoHeaderLabel        :: NoHeaderLabel;
    ImGuiTableColumnFlags_NoHeaderWidth        :: NoHeaderWidth;
    ImGuiTableColumnFlags_PreferSortAscending  :: PreferSortAscending;
    ImGuiTableColumnFlags_PreferSortDescending :: PreferSortDescending;
    ImGuiTableColumnFlags_IndentEnable         :: IndentEnable;
    ImGuiTableColumnFlags_IndentDisable        :: IndentDisable;

    ImGuiTableColumnFlags_IsEnabled            :: IsEnabled;
    ImGuiTableColumnFlags_IsVisible            :: IsVisible;
    ImGuiTableColumnFlags_IsSorted             :: IsSorted;
    ImGuiTableColumnFlags_IsHovered            :: IsHovered;

    ImGuiTableColumnFlags_WidthMask_           :: WidthMask_;
    ImGuiTableColumnFlags_IndentMask_          :: IndentMask_;
    ImGuiTableColumnFlags_StatusMask_          :: StatusMask_;
    ImGuiTableColumnFlags_NoDirectResize_      :: NoDirectResize_;
}

// Flags for ImGui::TableNextRow()
TableRowFlags :: enum_flags s32 {
    None    :: 0x0;
    Headers :: 0x1;

    ImGuiTableRowFlags_None    :: None;
    ImGuiTableRowFlags_Headers :: Headers;
}

// Enum for ImGui::TableSetBgColor()
// Background colors are rendering in 3 layers:
//  - Layer 0: draw with RowBg0 color if set, otherwise draw with ColumnBg0 if set.
//  - Layer 1: draw with RowBg1 color if set, otherwise draw with ColumnBg1 if set.
//  - Layer 2: draw with CellBg color if set.
// The purpose of the two row/columns layers is to let you decide if a background color changes should override or blend with the existing color.
// When using ImGuiTableFlags_RowBg on the table, each row has the RowBg0 color automatically set for odd/even rows.
// If you set the color of RowBg0 target, your color will override the existing RowBg0 color.
// If you set the color of RowBg1 or ColumnBg1 target, your color will blend over the RowBg0 color.
TableBgTarget :: enum s32 {
    None   :: 0;
    RowBg0 :: 1;
    RowBg1 :: 2;
    CellBg :: 3;

    ImGuiTableBgTarget_None   :: None;
    ImGuiTableBgTarget_RowBg0 :: RowBg0;
    ImGuiTableBgTarget_RowBg1 :: RowBg1;
    ImGuiTableBgTarget_CellBg :: CellBg;
}

// Flags for ImGui::IsWindowFocused()
FocusedFlags :: enum_flags s32 {
    None                :: 0x0;
    ChildWindows        :: 0x1;
    RootWindow          :: 0x2;
    AnyWindow           :: 0x4;
    NoPopupHierarchy    :: 0x8;
    DockHierarchy       :: 0x10;
    RootAndChildWindows :: 0x3;

    ImGuiFocusedFlags_None                :: None;
    ImGuiFocusedFlags_ChildWindows        :: ChildWindows;
    ImGuiFocusedFlags_RootWindow          :: RootWindow;
    ImGuiFocusedFlags_AnyWindow           :: AnyWindow;
    ImGuiFocusedFlags_NoPopupHierarchy    :: NoPopupHierarchy;
    ImGuiFocusedFlags_DockHierarchy       :: DockHierarchy;
    ImGuiFocusedFlags_RootAndChildWindows :: RootAndChildWindows;
}

// Flags for ImGui::IsItemHovered(), ImGui::IsWindowHovered()
// Note: if you are trying to check whether your mouse should be dispatched to Dear ImGui or to your app, you should use 'io.WantCaptureMouse' instead! Please read the FAQ!
// Note: windows with the ImGuiWindowFlags_NoInputs flag are ignored by IsWindowHovered() calls.
HoveredFlags :: enum_flags s32 {
    None                         :: 0x0;
    ChildWindows                 :: 0x1;
    RootWindow                   :: 0x2;
    AnyWindow                    :: 0x4;
    NoPopupHierarchy             :: 0x8;
    DockHierarchy                :: 0x10;
    AllowWhenBlockedByPopup      :: 0x20;

    AllowWhenBlockedByActiveItem :: 0x80;
    AllowWhenOverlapped          :: 0x100;
    AllowWhenDisabled            :: 0x200;
    NoNavOverride                :: 0x400;
    RectOnly                     :: 0x1a0;
    RootAndChildWindows          :: 0x3;

    ImGuiHoveredFlags_None                         :: None;
    ImGuiHoveredFlags_ChildWindows                 :: ChildWindows;
    ImGuiHoveredFlags_RootWindow                   :: RootWindow;
    ImGuiHoveredFlags_AnyWindow                    :: AnyWindow;
    ImGuiHoveredFlags_NoPopupHierarchy             :: NoPopupHierarchy;
    ImGuiHoveredFlags_DockHierarchy                :: DockHierarchy;
    ImGuiHoveredFlags_AllowWhenBlockedByPopup      :: AllowWhenBlockedByPopup;

    ImGuiHoveredFlags_AllowWhenBlockedByActiveItem :: AllowWhenBlockedByActiveItem;
    ImGuiHoveredFlags_AllowWhenOverlapped          :: AllowWhenOverlapped;
    ImGuiHoveredFlags_AllowWhenDisabled            :: AllowWhenDisabled;
    ImGuiHoveredFlags_NoNavOverride                :: NoNavOverride;
    ImGuiHoveredFlags_RectOnly                     :: RectOnly;
    ImGuiHoveredFlags_RootAndChildWindows          :: RootAndChildWindows;
}

// Flags for ImGui::DockSpace(), shared/inherited by child nodes.
// (Some flags can be applied to individual nodes directly)
// FIXME-DOCK: Also see ImGuiDockNodeFlagsPrivate_ which may involve using the WIP and internal DockBuilder api.
DockNodeFlags :: enum_flags s32 {
    None                   :: 0x0;
    KeepAliveOnly          :: 0x1;

    NoDockingInCentralNode :: 0x4;
    PassthruCentralNode    :: 0x8;
    NoSplit                :: 0x10;
    NoResize               :: 0x20;
    AutoHideTabBar         :: 0x40;

    ImGuiDockNodeFlags_None                   :: None;
    ImGuiDockNodeFlags_KeepAliveOnly          :: KeepAliveOnly;

    ImGuiDockNodeFlags_NoDockingInCentralNode :: NoDockingInCentralNode;
    ImGuiDockNodeFlags_PassthruCentralNode    :: PassthruCentralNode;
    ImGuiDockNodeFlags_NoSplit                :: NoSplit;
    ImGuiDockNodeFlags_NoResize               :: NoResize;
    ImGuiDockNodeFlags_AutoHideTabBar         :: AutoHideTabBar;
}

// Flags for ImGui::BeginDragDropSource(), ImGui::AcceptDragDropPayload()
DragDropFlags :: enum_flags s32 {
    None                     :: 0x0;

    SourceNoPreviewTooltip   :: 0x1;
    SourceNoDisableHover     :: 0x2;
    SourceNoHoldToOpenOthers :: 0x4;
    SourceAllowNullID        :: 0x8;
    SourceExtern             :: 0x10;
    SourceAutoExpirePayload  :: 0x20;

    AcceptBeforeDelivery     :: 0x400;
    AcceptNoDrawDefaultRect  :: 0x800;
    AcceptNoPreviewTooltip   :: 0x1000;
    AcceptPeekOnly           :: 0xc00;

    ImGuiDragDropFlags_None                     :: None;

    ImGuiDragDropFlags_SourceNoPreviewTooltip   :: SourceNoPreviewTooltip;
    ImGuiDragDropFlags_SourceNoDisableHover     :: SourceNoDisableHover;
    ImGuiDragDropFlags_SourceNoHoldToOpenOthers :: SourceNoHoldToOpenOthers;
    ImGuiDragDropFlags_SourceAllowNullID        :: SourceAllowNullID;
    ImGuiDragDropFlags_SourceExtern             :: SourceExtern;
    ImGuiDragDropFlags_SourceAutoExpirePayload  :: SourceAutoExpirePayload;

    ImGuiDragDropFlags_AcceptBeforeDelivery     :: AcceptBeforeDelivery;
    ImGuiDragDropFlags_AcceptNoDrawDefaultRect  :: AcceptNoDrawDefaultRect;
    ImGuiDragDropFlags_AcceptNoPreviewTooltip   :: AcceptNoPreviewTooltip;
    ImGuiDragDropFlags_AcceptPeekOnly           :: AcceptPeekOnly;
}

// A primary data type
DataType :: enum s32 {
    S8     :: 0;
    U8     :: 1;
    S16    :: 2;
    U16    :: 3;
    S32    :: 4;
    U32    :: 5;
    S64    :: 6;
    U64    :: 7;
    Float  :: 8;
    Double :: 9;
    COUNT  :: 10;

    ImGuiDataType_S8     :: S8;
    ImGuiDataType_U8     :: U8;
    ImGuiDataType_S16    :: S16;
    ImGuiDataType_U16    :: U16;
    ImGuiDataType_S32    :: S32;
    ImGuiDataType_U32    :: U32;
    ImGuiDataType_S64    :: S64;
    ImGuiDataType_U64    :: U64;
    ImGuiDataType_Float  :: Float;
    ImGuiDataType_Double :: Double;
    ImGuiDataType_COUNT  :: COUNT;
}

// A cardinal direction
Dir :: enum s32 {
    None  :: -1;
    Left  :: 0;
    Right :: 1;
    Up    :: 2;
    Down  :: 3;
    COUNT :: 4;

    ImGuiDir_None  :: None;
    ImGuiDir_Left  :: Left;
    ImGuiDir_Right :: Right;
    ImGuiDir_Up    :: Up;
    ImGuiDir_Down  :: Down;
    ImGuiDir_COUNT :: COUNT;
}

// A sorting direction
SortDirection :: enum s32 {
    None       :: 0;
    Ascending  :: 1;
    Descending :: 2;

    ImGuiSortDirection_None       :: None;
    ImGuiSortDirection_Ascending  :: Ascending;
    ImGuiSortDirection_Descending :: Descending;
}

// Keys value 0 to 511 are left unused as legacy native/opaque key values (< 1.87)
// Keys value >= 512 are named keys (>= 1.87)
Key :: enum s32 {
    None               :: 0;
    Tab                :: 512;
    LeftArrow          :: 513;
    RightArrow         :: 514;
    UpArrow            :: 515;
    DownArrow          :: 516;
    PageUp             :: 517;
    PageDown           :: 518;
    Home               :: 519;
    End                :: 520;
    Insert             :: 521;
    Delete             :: 522;
    Backspace          :: 523;
    Space              :: 524;
    Enter              :: 525;
    Escape             :: 526;
    LeftCtrl           :: 527;
    LeftShift          :: 528;
    LeftAlt            :: 529;
    LeftSuper          :: 530;
    RightCtrl          :: 531;
    RightShift         :: 532;
    RightAlt           :: 533;
    RightSuper         :: 534;
    Menu               :: 535;
    _0                 :: 536;
    _1                 :: 537;
    _2                 :: 538;
    _3                 :: 539;
    _4                 :: 540;
    _5                 :: 541;
    _6                 :: 542;
    _7                 :: 543;
    _8                 :: 544;
    _9                 :: 545;
    A                  :: 546;
    B                  :: 547;
    C                  :: 548;
    D                  :: 549;
    E                  :: 550;
    F                  :: 551;
    G                  :: 552;
    H                  :: 553;
    I                  :: 554;
    J                  :: 555;
    K                  :: 556;
    L                  :: 557;
    M                  :: 558;
    N                  :: 559;
    O                  :: 560;
    P                  :: 561;
    Q                  :: 562;
    R                  :: 563;
    S                  :: 564;
    T                  :: 565;
    U                  :: 566;
    V                  :: 567;
    W                  :: 568;
    X                  :: 569;
    Y                  :: 570;
    Z                  :: 571;
    F1                 :: 572;
    F2                 :: 573;
    F3                 :: 574;
    F4                 :: 575;
    F5                 :: 576;
    F6                 :: 577;
    F7                 :: 578;
    F8                 :: 579;
    F9                 :: 580;
    F10                :: 581;
    F11                :: 582;
    F12                :: 583;
    Apostrophe         :: 584;
    Comma              :: 585;
    Minus              :: 586;
    Period             :: 587;
    Slash              :: 588;
    Semicolon          :: 589;
    Equal              :: 590;
    LeftBracket        :: 591;
    Backslash          :: 592;
    RightBracket       :: 593;
    GraveAccent        :: 594;
    CapsLock           :: 595;
    ScrollLock         :: 596;
    NumLock            :: 597;
    PrintScreen        :: 598;
    Pause              :: 599;
    Keypad0            :: 600;
    Keypad1            :: 601;
    Keypad2            :: 602;
    Keypad3            :: 603;
    Keypad4            :: 604;
    Keypad5            :: 605;
    Keypad6            :: 606;
    Keypad7            :: 607;
    Keypad8            :: 608;
    Keypad9            :: 609;
    KeypadDecimal      :: 610;
    KeypadDivide       :: 611;
    KeypadMultiply     :: 612;
    KeypadSubtract     :: 613;
    KeypadAdd          :: 614;
    KeypadEnter        :: 615;
    KeypadEqual        :: 616;

    GamepadStart       :: 617;
    GamepadBack        :: 618;
    GamepadFaceUp      :: 619;
    GamepadFaceDown    :: 620;
    GamepadFaceLeft    :: 621;
    GamepadFaceRight   :: 622;
    GamepadDpadUp      :: 623;
    GamepadDpadDown    :: 624;
    GamepadDpadLeft    :: 625;
    GamepadDpadRight   :: 626;
    GamepadL1          :: 627;
    GamepadR1          :: 628;
    GamepadL2          :: 629;
    GamepadR2          :: 630;
    GamepadL3          :: 631;
    GamepadR3          :: 632;
    GamepadLStickUp    :: 633;
    GamepadLStickDown  :: 634;
    GamepadLStickLeft  :: 635;
    GamepadLStickRight :: 636;
    GamepadRStickUp    :: 637;
    GamepadRStickDown  :: 638;
    GamepadRStickLeft  :: 639;
    GamepadRStickRight :: 640;

    ModCtrl            :: 641;
    ModShift           :: 642;
    ModAlt             :: 643;
    ModSuper           :: 644;

    COUNT              :: 645;

    NamedKey_BEGIN     :: 512;
    NamedKey_END       :: 645;
    NamedKey_COUNT     :: 133;

    KeysData_SIZE      :: 645;
    KeysData_OFFSET    :: 0;

    KeyPadEnter        :: 615;

    ImGuiKey_None               :: None;
    ImGuiKey_Tab                :: Tab;
    ImGuiKey_LeftArrow          :: LeftArrow;
    ImGuiKey_RightArrow         :: RightArrow;
    ImGuiKey_UpArrow            :: UpArrow;
    ImGuiKey_DownArrow          :: DownArrow;
    ImGuiKey_PageUp             :: PageUp;
    ImGuiKey_PageDown           :: PageDown;
    ImGuiKey_Home               :: Home;
    ImGuiKey_End                :: End;
    ImGuiKey_Insert             :: Insert;
    ImGuiKey_Delete             :: Delete;
    ImGuiKey_Backspace          :: Backspace;
    ImGuiKey_Space              :: Space;
    ImGuiKey_Enter              :: Enter;
    ImGuiKey_Escape             :: Escape;
    ImGuiKey_LeftCtrl           :: LeftCtrl;
    ImGuiKey_LeftShift          :: LeftShift;
    ImGuiKey_LeftAlt            :: LeftAlt;
    ImGuiKey_LeftSuper          :: LeftSuper;
    ImGuiKey_RightCtrl          :: RightCtrl;
    ImGuiKey_RightShift         :: RightShift;
    ImGuiKey_RightAlt           :: RightAlt;
    ImGuiKey_RightSuper         :: RightSuper;
    ImGuiKey_Menu               :: Menu;
    ImGuiKey_0                  :: _0;
    ImGuiKey_1                  :: _1;
    ImGuiKey_2                  :: _2;
    ImGuiKey_3                  :: _3;
    ImGuiKey_4                  :: _4;
    ImGuiKey_5                  :: _5;
    ImGuiKey_6                  :: _6;
    ImGuiKey_7                  :: _7;
    ImGuiKey_8                  :: _8;
    ImGuiKey_9                  :: _9;
    ImGuiKey_A                  :: A;
    ImGuiKey_B                  :: B;
    ImGuiKey_C                  :: C;
    ImGuiKey_D                  :: D;
    ImGuiKey_E                  :: E;
    ImGuiKey_F                  :: F;
    ImGuiKey_G                  :: G;
    ImGuiKey_H                  :: H;
    ImGuiKey_I                  :: I;
    ImGuiKey_J                  :: J;
    ImGuiKey_K                  :: K;
    ImGuiKey_L                  :: L;
    ImGuiKey_M                  :: M;
    ImGuiKey_N                  :: N;
    ImGuiKey_O                  :: O;
    ImGuiKey_P                  :: P;
    ImGuiKey_Q                  :: Q;
    ImGuiKey_R                  :: R;
    ImGuiKey_S                  :: S;
    ImGuiKey_T                  :: T;
    ImGuiKey_U                  :: U;
    ImGuiKey_V                  :: V;
    ImGuiKey_W                  :: W;
    ImGuiKey_X                  :: X;
    ImGuiKey_Y                  :: Y;
    ImGuiKey_Z                  :: Z;
    ImGuiKey_F1                 :: F1;
    ImGuiKey_F2                 :: F2;
    ImGuiKey_F3                 :: F3;
    ImGuiKey_F4                 :: F4;
    ImGuiKey_F5                 :: F5;
    ImGuiKey_F6                 :: F6;
    ImGuiKey_F7                 :: F7;
    ImGuiKey_F8                 :: F8;
    ImGuiKey_F9                 :: F9;
    ImGuiKey_F10                :: F10;
    ImGuiKey_F11                :: F11;
    ImGuiKey_F12                :: F12;
    ImGuiKey_Apostrophe         :: Apostrophe;
    ImGuiKey_Comma              :: Comma;
    ImGuiKey_Minus              :: Minus;
    ImGuiKey_Period             :: Period;
    ImGuiKey_Slash              :: Slash;
    ImGuiKey_Semicolon          :: Semicolon;
    ImGuiKey_Equal              :: Equal;
    ImGuiKey_LeftBracket        :: LeftBracket;
    ImGuiKey_Backslash          :: Backslash;
    ImGuiKey_RightBracket       :: RightBracket;
    ImGuiKey_GraveAccent        :: GraveAccent;
    ImGuiKey_CapsLock           :: CapsLock;
    ImGuiKey_ScrollLock         :: ScrollLock;
    ImGuiKey_NumLock            :: NumLock;
    ImGuiKey_PrintScreen        :: PrintScreen;
    ImGuiKey_Pause              :: Pause;
    ImGuiKey_Keypad0            :: Keypad0;
    ImGuiKey_Keypad1            :: Keypad1;
    ImGuiKey_Keypad2            :: Keypad2;
    ImGuiKey_Keypad3            :: Keypad3;
    ImGuiKey_Keypad4            :: Keypad4;
    ImGuiKey_Keypad5            :: Keypad5;
    ImGuiKey_Keypad6            :: Keypad6;
    ImGuiKey_Keypad7            :: Keypad7;
    ImGuiKey_Keypad8            :: Keypad8;
    ImGuiKey_Keypad9            :: Keypad9;
    ImGuiKey_KeypadDecimal      :: KeypadDecimal;
    ImGuiKey_KeypadDivide       :: KeypadDivide;
    ImGuiKey_KeypadMultiply     :: KeypadMultiply;
    ImGuiKey_KeypadSubtract     :: KeypadSubtract;
    ImGuiKey_KeypadAdd          :: KeypadAdd;
    ImGuiKey_KeypadEnter        :: KeypadEnter;
    ImGuiKey_KeypadEqual        :: KeypadEqual;

    ImGuiKey_GamepadStart       :: GamepadStart;
    ImGuiKey_GamepadBack        :: GamepadBack;
    ImGuiKey_GamepadFaceUp      :: GamepadFaceUp;
    ImGuiKey_GamepadFaceDown    :: GamepadFaceDown;
    ImGuiKey_GamepadFaceLeft    :: GamepadFaceLeft;
    ImGuiKey_GamepadFaceRight   :: GamepadFaceRight;
    ImGuiKey_GamepadDpadUp      :: GamepadDpadUp;
    ImGuiKey_GamepadDpadDown    :: GamepadDpadDown;
    ImGuiKey_GamepadDpadLeft    :: GamepadDpadLeft;
    ImGuiKey_GamepadDpadRight   :: GamepadDpadRight;
    ImGuiKey_GamepadL1          :: GamepadL1;
    ImGuiKey_GamepadR1          :: GamepadR1;
    ImGuiKey_GamepadL2          :: GamepadL2;
    ImGuiKey_GamepadR2          :: GamepadR2;
    ImGuiKey_GamepadL3          :: GamepadL3;
    ImGuiKey_GamepadR3          :: GamepadR3;
    ImGuiKey_GamepadLStickUp    :: GamepadLStickUp;
    ImGuiKey_GamepadLStickDown  :: GamepadLStickDown;
    ImGuiKey_GamepadLStickLeft  :: GamepadLStickLeft;
    ImGuiKey_GamepadLStickRight :: GamepadLStickRight;
    ImGuiKey_GamepadRStickUp    :: GamepadRStickUp;
    ImGuiKey_GamepadRStickDown  :: GamepadRStickDown;
    ImGuiKey_GamepadRStickLeft  :: GamepadRStickLeft;
    ImGuiKey_GamepadRStickRight :: GamepadRStickRight;

    ImGuiKey_ModCtrl            :: ModCtrl;
    ImGuiKey_ModShift           :: ModShift;
    ImGuiKey_ModAlt             :: ModAlt;
    ImGuiKey_ModSuper           :: ModSuper;

    ImGuiKey_COUNT              :: COUNT;

    ImGuiKey_NamedKey_BEGIN     :: NamedKey_BEGIN;
    ImGuiKey_NamedKey_END       :: NamedKey_END;
    ImGuiKey_NamedKey_COUNT     :: NamedKey_COUNT;

    ImGuiKey_KeysData_SIZE      :: KeysData_SIZE;
    ImGuiKey_KeysData_OFFSET    :: KeysData_OFFSET;

    ImGuiKey_KeyPadEnter        :: KeyPadEnter;
}

// Helper "flags" version of key-mods to store and compare multiple key-mods easily. Sometimes used for storage (e.g. io.KeyMods) but otherwise not much used in public API.
ModFlags :: enum_flags s32 {
    None  :: 0x0;
    Ctrl  :: 0x1;
    Shift :: 0x2;
    Alt   :: 0x4;
    Super :: 0x8;

    ImGuiModFlags_None  :: None;
    ImGuiModFlags_Ctrl  :: Ctrl;
    ImGuiModFlags_Shift :: Shift;
    ImGuiModFlags_Alt   :: Alt;
    ImGuiModFlags_Super :: Super;
}

// Gamepad/Keyboard navigation
// Since >= 1.87 backends you generally don't need to care about this enum since io.NavInputs[] is setup automatically. This might become private/internal some day.
// Keyboard: Set io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard to enable. NewFrame() will automatically fill io.NavInputs[] based on your io.AddKeyEvent() calls.
// Gamepad:  Set io.ConfigFlags |= ImGuiConfigFlags_NavEnableGamepad to enable. Backend: set ImGuiBackendFlags_HasGamepad and fill the io.NavInputs[] fields before calling NewFrame(). Note that io.NavInputs[] is cleared by EndFrame().
// Read instructions in imgui.cpp for more details. Download PNG/PSD at http://dearimgui.org/controls_sheets.
NavInput_ :: enum s32 {
    Activate    :: 0;
    Cancel      :: 1;
    Input       :: 2;
    Menu        :: 3;
    DpadLeft    :: 4;
    DpadRight   :: 5;
    DpadUp      :: 6;
    DpadDown    :: 7;
    LStickLeft  :: 8;
    LStickRight :: 9;
    LStickUp    :: 10;
    LStickDown  :: 11;
    FocusPrev   :: 12;
    FocusNext   :: 13;
    TweakSlow   :: 14;
    TweakFast   :: 15;

    KeyLeft_    :: 16;
    KeyRight_   :: 17;
    KeyUp_      :: 18;
    KeyDown_    :: 19;
    COUNT       :: 20;

    ImGuiNavInput_Activate    :: Activate;
    ImGuiNavInput_Cancel      :: Cancel;
    ImGuiNavInput_Input       :: Input;
    ImGuiNavInput_Menu        :: Menu;
    ImGuiNavInput_DpadLeft    :: DpadLeft;
    ImGuiNavInput_DpadRight   :: DpadRight;
    ImGuiNavInput_DpadUp      :: DpadUp;
    ImGuiNavInput_DpadDown    :: DpadDown;
    ImGuiNavInput_LStickLeft  :: LStickLeft;
    ImGuiNavInput_LStickRight :: LStickRight;
    ImGuiNavInput_LStickUp    :: LStickUp;
    ImGuiNavInput_LStickDown  :: LStickDown;
    ImGuiNavInput_FocusPrev   :: FocusPrev;
    ImGuiNavInput_FocusNext   :: FocusNext;
    ImGuiNavInput_TweakSlow   :: TweakSlow;
    ImGuiNavInput_TweakFast   :: TweakFast;

    ImGuiNavInput_KeyLeft_    :: KeyLeft_;
    ImGuiNavInput_KeyRight_   :: KeyRight_;
    ImGuiNavInput_KeyUp_      :: KeyUp_;
    ImGuiNavInput_KeyDown_    :: KeyDown_;
    ImGuiNavInput_COUNT       :: COUNT;
}

// Configuration flags stored in io.ConfigFlags. Set by user/application.
ConfigFlags :: enum_flags s32 {
    None                    :: 0x0;
    NavEnableKeyboard       :: 0x1;
    NavEnableGamepad        :: 0x2;
    NavEnableSetMousePos    :: 0x4;
    NavNoCaptureKeyboard    :: 0x8;
    NoMouse                 :: 0x10;
    NoMouseCursorChange     :: 0x20;

    DockingEnable           :: 0x40;

    ViewportsEnable         :: 0x400;
    DpiEnableScaleViewports :: 0x4000;
    DpiEnableScaleFonts     :: 0x8000;

    IsSRGB                  :: 0x100000;
    IsTouchScreen           :: 0x200000;

    ImGuiConfigFlags_None                    :: None;
    ImGuiConfigFlags_NavEnableKeyboard       :: NavEnableKeyboard;
    ImGuiConfigFlags_NavEnableGamepad        :: NavEnableGamepad;
    ImGuiConfigFlags_NavEnableSetMousePos    :: NavEnableSetMousePos;
    ImGuiConfigFlags_NavNoCaptureKeyboard    :: NavNoCaptureKeyboard;
    ImGuiConfigFlags_NoMouse                 :: NoMouse;
    ImGuiConfigFlags_NoMouseCursorChange     :: NoMouseCursorChange;

    ImGuiConfigFlags_DockingEnable           :: DockingEnable;

    ImGuiConfigFlags_ViewportsEnable         :: ViewportsEnable;
    ImGuiConfigFlags_DpiEnableScaleViewports :: DpiEnableScaleViewports;
    ImGuiConfigFlags_DpiEnableScaleFonts     :: DpiEnableScaleFonts;

    ImGuiConfigFlags_IsSRGB                  :: IsSRGB;
    ImGuiConfigFlags_IsTouchScreen           :: IsTouchScreen;
}

// Backend capabilities flags stored in io.BackendFlags. Set by imgui_impl_xxx or custom backend.
BackendFlags :: enum_flags s32 {
    None                    :: 0x0;
    HasGamepad              :: 0x1;
    HasMouseCursors         :: 0x2;
    HasSetMousePos          :: 0x4;
    RendererHasVtxOffset    :: 0x8;

    PlatformHasViewports    :: 0x400;
    HasMouseHoveredViewport :: 0x800;
    RendererHasViewports    :: 0x1000;

    ImGuiBackendFlags_None                    :: None;
    ImGuiBackendFlags_HasGamepad              :: HasGamepad;
    ImGuiBackendFlags_HasMouseCursors         :: HasMouseCursors;
    ImGuiBackendFlags_HasSetMousePos          :: HasSetMousePos;
    ImGuiBackendFlags_RendererHasVtxOffset    :: RendererHasVtxOffset;

    ImGuiBackendFlags_PlatformHasViewports    :: PlatformHasViewports;
    ImGuiBackendFlags_HasMouseHoveredViewport :: HasMouseHoveredViewport;
    ImGuiBackendFlags_RendererHasViewports    :: RendererHasViewports;
}

// Enumeration for PushStyleColor() / PopStyleColor()
Col :: enum s32 {
    Text                  :: 0;
    TextDisabled          :: 1;
    WindowBg              :: 2;
    ChildBg               :: 3;
    PopupBg               :: 4;
    Border                :: 5;
    BorderShadow          :: 6;
    FrameBg               :: 7;
    FrameBgHovered        :: 8;
    FrameBgActive         :: 9;
    TitleBg               :: 10;
    TitleBgActive         :: 11;
    TitleBgCollapsed      :: 12;
    MenuBarBg             :: 13;
    ScrollbarBg           :: 14;
    ScrollbarGrab         :: 15;
    ScrollbarGrabHovered  :: 16;
    ScrollbarGrabActive   :: 17;
    CheckMark             :: 18;
    SliderGrab            :: 19;
    SliderGrabActive      :: 20;
    Button                :: 21;
    ButtonHovered         :: 22;
    ButtonActive          :: 23;
    Header                :: 24;
    HeaderHovered         :: 25;
    HeaderActive          :: 26;
    Separator             :: 27;
    SeparatorHovered      :: 28;
    SeparatorActive       :: 29;
    ResizeGrip            :: 30;
    ResizeGripHovered     :: 31;
    ResizeGripActive      :: 32;
    Tab                   :: 33;
    TabHovered            :: 34;
    TabActive             :: 35;
    TabUnfocused          :: 36;
    TabUnfocusedActive    :: 37;
    DockingPreview        :: 38;
    DockingEmptyBg        :: 39;
    PlotLines             :: 40;
    PlotLinesHovered      :: 41;
    PlotHistogram         :: 42;
    PlotHistogramHovered  :: 43;
    TableHeaderBg         :: 44;
    TableBorderStrong     :: 45;
    TableBorderLight      :: 46;
    TableRowBg            :: 47;
    TableRowBgAlt         :: 48;
    TextSelectedBg        :: 49;
    DragDropTarget        :: 50;
    NavHighlight          :: 51;
    NavWindowingHighlight :: 52;
    NavWindowingDimBg     :: 53;
    ModalWindowDimBg      :: 54;
    COUNT                 :: 55;

    ImGuiCol_Text                  :: Text;
    ImGuiCol_TextDisabled          :: TextDisabled;
    ImGuiCol_WindowBg              :: WindowBg;
    ImGuiCol_ChildBg               :: ChildBg;
    ImGuiCol_PopupBg               :: PopupBg;
    ImGuiCol_Border                :: Border;
    ImGuiCol_BorderShadow          :: BorderShadow;
    ImGuiCol_FrameBg               :: FrameBg;
    ImGuiCol_FrameBgHovered        :: FrameBgHovered;
    ImGuiCol_FrameBgActive         :: FrameBgActive;
    ImGuiCol_TitleBg               :: TitleBg;
    ImGuiCol_TitleBgActive         :: TitleBgActive;
    ImGuiCol_TitleBgCollapsed      :: TitleBgCollapsed;
    ImGuiCol_MenuBarBg             :: MenuBarBg;
    ImGuiCol_ScrollbarBg           :: ScrollbarBg;
    ImGuiCol_ScrollbarGrab         :: ScrollbarGrab;
    ImGuiCol_ScrollbarGrabHovered  :: ScrollbarGrabHovered;
    ImGuiCol_ScrollbarGrabActive   :: ScrollbarGrabActive;
    ImGuiCol_CheckMark             :: CheckMark;
    ImGuiCol_SliderGrab            :: SliderGrab;
    ImGuiCol_SliderGrabActive      :: SliderGrabActive;
    ImGuiCol_Button                :: Button;
    ImGuiCol_ButtonHovered         :: ButtonHovered;
    ImGuiCol_ButtonActive          :: ButtonActive;
    ImGuiCol_Header                :: Header;
    ImGuiCol_HeaderHovered         :: HeaderHovered;
    ImGuiCol_HeaderActive          :: HeaderActive;
    ImGuiCol_Separator             :: Separator;
    ImGuiCol_SeparatorHovered      :: SeparatorHovered;
    ImGuiCol_SeparatorActive       :: SeparatorActive;
    ImGuiCol_ResizeGrip            :: ResizeGrip;
    ImGuiCol_ResizeGripHovered     :: ResizeGripHovered;
    ImGuiCol_ResizeGripActive      :: ResizeGripActive;
    ImGuiCol_Tab                   :: Tab;
    ImGuiCol_TabHovered            :: TabHovered;
    ImGuiCol_TabActive             :: TabActive;
    ImGuiCol_TabUnfocused          :: TabUnfocused;
    ImGuiCol_TabUnfocusedActive    :: TabUnfocusedActive;
    ImGuiCol_DockingPreview        :: DockingPreview;
    ImGuiCol_DockingEmptyBg        :: DockingEmptyBg;
    ImGuiCol_PlotLines             :: PlotLines;
    ImGuiCol_PlotLinesHovered      :: PlotLinesHovered;
    ImGuiCol_PlotHistogram         :: PlotHistogram;
    ImGuiCol_PlotHistogramHovered  :: PlotHistogramHovered;
    ImGuiCol_TableHeaderBg         :: TableHeaderBg;
    ImGuiCol_TableBorderStrong     :: TableBorderStrong;
    ImGuiCol_TableBorderLight      :: TableBorderLight;
    ImGuiCol_TableRowBg            :: TableRowBg;
    ImGuiCol_TableRowBgAlt         :: TableRowBgAlt;
    ImGuiCol_TextSelectedBg        :: TextSelectedBg;
    ImGuiCol_DragDropTarget        :: DragDropTarget;
    ImGuiCol_NavHighlight          :: NavHighlight;
    ImGuiCol_NavWindowingHighlight :: NavWindowingHighlight;
    ImGuiCol_NavWindowingDimBg     :: NavWindowingDimBg;
    ImGuiCol_ModalWindowDimBg      :: ModalWindowDimBg;
    ImGuiCol_COUNT                 :: COUNT;
}

// Enumeration for PushStyleVar() / PopStyleVar() to temporarily modify the ImGuiStyle structure.
// - The enum only refers to fields of ImGuiStyle which makes sense to be pushed/popped inside UI code.
//   During initialization or between frames, feel free to just poke into ImGuiStyle directly.
// - Tip: Use your programming IDE navigation facilities on the names in the _second column_ below to find the actual members and their description.
//   In Visual Studio IDE: CTRL+comma ("Edit.GoToAll") can follow symbols in comments, whereas CTRL+F12 ("Edit.GoToImplementation") cannot.
//   With Visual Assist installed: ALT+G ("VAssistX.GoToImplementation") can also follow symbols in comments.
// - When changing this enum, you need to update the associated internal table GStyleVarInfo[] accordingly. This is where we link enum values to members offset/type.
StyleVar :: enum s32 {
    Alpha               :: 0;
    DisabledAlpha       :: 1;
    WindowPadding       :: 2;
    WindowRounding      :: 3;
    WindowBorderSize    :: 4;
    WindowMinSize       :: 5;
    WindowTitleAlign    :: 6;
    ChildRounding       :: 7;
    ChildBorderSize     :: 8;
    PopupRounding       :: 9;
    PopupBorderSize     :: 10;
    FramePadding        :: 11;
    FrameRounding       :: 12;
    FrameBorderSize     :: 13;
    ItemSpacing         :: 14;
    ItemInnerSpacing    :: 15;
    IndentSpacing       :: 16;
    CellPadding         :: 17;
    ScrollbarSize       :: 18;
    ScrollbarRounding   :: 19;
    GrabMinSize         :: 20;
    GrabRounding        :: 21;
    TabRounding         :: 22;
    ButtonTextAlign     :: 23;
    SelectableTextAlign :: 24;
    COUNT               :: 25;

    ImGuiStyleVar_Alpha               :: Alpha;
    ImGuiStyleVar_DisabledAlpha       :: DisabledAlpha;
    ImGuiStyleVar_WindowPadding       :: WindowPadding;
    ImGuiStyleVar_WindowRounding      :: WindowRounding;
    ImGuiStyleVar_WindowBorderSize    :: WindowBorderSize;
    ImGuiStyleVar_WindowMinSize       :: WindowMinSize;
    ImGuiStyleVar_WindowTitleAlign    :: WindowTitleAlign;
    ImGuiStyleVar_ChildRounding       :: ChildRounding;
    ImGuiStyleVar_ChildBorderSize     :: ChildBorderSize;
    ImGuiStyleVar_PopupRounding       :: PopupRounding;
    ImGuiStyleVar_PopupBorderSize     :: PopupBorderSize;
    ImGuiStyleVar_FramePadding        :: FramePadding;
    ImGuiStyleVar_FrameRounding       :: FrameRounding;
    ImGuiStyleVar_FrameBorderSize     :: FrameBorderSize;
    ImGuiStyleVar_ItemSpacing         :: ItemSpacing;
    ImGuiStyleVar_ItemInnerSpacing    :: ItemInnerSpacing;
    ImGuiStyleVar_IndentSpacing       :: IndentSpacing;
    ImGuiStyleVar_CellPadding         :: CellPadding;
    ImGuiStyleVar_ScrollbarSize       :: ScrollbarSize;
    ImGuiStyleVar_ScrollbarRounding   :: ScrollbarRounding;
    ImGuiStyleVar_GrabMinSize         :: GrabMinSize;
    ImGuiStyleVar_GrabRounding        :: GrabRounding;
    ImGuiStyleVar_TabRounding         :: TabRounding;
    ImGuiStyleVar_ButtonTextAlign     :: ButtonTextAlign;
    ImGuiStyleVar_SelectableTextAlign :: SelectableTextAlign;
    ImGuiStyleVar_COUNT               :: COUNT;
}

// Flags for InvisibleButton() [extended in imgui_internal.h]
ButtonFlags :: enum_flags s32 {
    None                :: 0x0;
    MouseButtonLeft     :: 0x1;
    MouseButtonRight    :: 0x2;
    MouseButtonMiddle   :: 0x4;

    MouseButtonMask_    :: 0x7;
    MouseButtonDefault_ :: 0x1;

    ImGuiButtonFlags_None                :: None;
    ImGuiButtonFlags_MouseButtonLeft     :: MouseButtonLeft;
    ImGuiButtonFlags_MouseButtonRight    :: MouseButtonRight;
    ImGuiButtonFlags_MouseButtonMiddle   :: MouseButtonMiddle;

    ImGuiButtonFlags_MouseButtonMask_    :: MouseButtonMask_;
    ImGuiButtonFlags_MouseButtonDefault_ :: MouseButtonDefault_;
}

// Flags for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
ColorEditFlags :: enum_flags s32 {
    None             :: 0x0;
    NoAlpha          :: 0x2;
    NoPicker         :: 0x4;
    NoOptions        :: 0x8;
    NoSmallPreview   :: 0x10;
    NoInputs         :: 0x20;
    NoTooltip        :: 0x40;
    NoLabel          :: 0x80;
    NoSidePreview    :: 0x100;
    NoDragDrop       :: 0x200;
    NoBorder         :: 0x400;

    AlphaBar         :: 0x10000;
    AlphaPreview     :: 0x20000;
    AlphaPreviewHalf :: 0x40000;
    HDR              :: 0x80000;
    DisplayRGB       :: 0x100000;
    DisplayHSV       :: 0x200000;
    DisplayHex       :: 0x400000;
    Uint8            :: 0x800000;
    Float            :: 0x1000000;
    PickerHueBar     :: 0x2000000;
    PickerHueWheel   :: 0x4000000;
    InputRGB         :: 0x8000000;
    InputHSV         :: 0x10000000;

    DefaultOptions_  :: 0xa900000;

    DisplayMask_     :: 0x700000;
    DataTypeMask_    :: 0x1800000;
    PickerMask_      :: 0x6000000;
    InputMask_       :: 0x18000000;

    ImGuiColorEditFlags_None             :: None;
    ImGuiColorEditFlags_NoAlpha          :: NoAlpha;
    ImGuiColorEditFlags_NoPicker         :: NoPicker;
    ImGuiColorEditFlags_NoOptions        :: NoOptions;
    ImGuiColorEditFlags_NoSmallPreview   :: NoSmallPreview;
    ImGuiColorEditFlags_NoInputs         :: NoInputs;
    ImGuiColorEditFlags_NoTooltip        :: NoTooltip;
    ImGuiColorEditFlags_NoLabel          :: NoLabel;
    ImGuiColorEditFlags_NoSidePreview    :: NoSidePreview;
    ImGuiColorEditFlags_NoDragDrop       :: NoDragDrop;
    ImGuiColorEditFlags_NoBorder         :: NoBorder;

    ImGuiColorEditFlags_AlphaBar         :: AlphaBar;
    ImGuiColorEditFlags_AlphaPreview     :: AlphaPreview;
    ImGuiColorEditFlags_AlphaPreviewHalf :: AlphaPreviewHalf;
    ImGuiColorEditFlags_HDR              :: HDR;
    ImGuiColorEditFlags_DisplayRGB       :: DisplayRGB;
    ImGuiColorEditFlags_DisplayHSV       :: DisplayHSV;
    ImGuiColorEditFlags_DisplayHex       :: DisplayHex;
    ImGuiColorEditFlags_Uint8            :: Uint8;
    ImGuiColorEditFlags_Float            :: Float;
    ImGuiColorEditFlags_PickerHueBar     :: PickerHueBar;
    ImGuiColorEditFlags_PickerHueWheel   :: PickerHueWheel;
    ImGuiColorEditFlags_InputRGB         :: InputRGB;
    ImGuiColorEditFlags_InputHSV         :: InputHSV;

    ImGuiColorEditFlags_DefaultOptions_  :: DefaultOptions_;

    ImGuiColorEditFlags_DisplayMask_     :: DisplayMask_;
    ImGuiColorEditFlags_DataTypeMask_    :: DataTypeMask_;
    ImGuiColorEditFlags_PickerMask_      :: PickerMask_;
    ImGuiColorEditFlags_InputMask_       :: InputMask_;
}

// Flags for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
// We use the same sets of flags for DragXXX() and SliderXXX() functions as the features are the same and it makes it easier to swap them.
SliderFlags :: enum_flags s32 {
    None            :: 0x0;
    AlwaysClamp     :: 0x10;
    Logarithmic     :: 0x20;
    NoRoundToFormat :: 0x40;
    NoInput         :: 0x80;
    InvalidMask_    :: 0x7000000f;

    ClampOnInput    :: 0x10;

    ImGuiSliderFlags_None            :: None;
    ImGuiSliderFlags_AlwaysClamp     :: AlwaysClamp;
    ImGuiSliderFlags_Logarithmic     :: Logarithmic;
    ImGuiSliderFlags_NoRoundToFormat :: NoRoundToFormat;
    ImGuiSliderFlags_NoInput         :: NoInput;
    ImGuiSliderFlags_InvalidMask_    :: InvalidMask_;

    ImGuiSliderFlags_ClampOnInput    :: ClampOnInput;
}

// Identify a mouse button.
// Those values are guaranteed to be stable and we frequently use 0/1 directly. Named enums provided for convenience.
MouseButton :: enum s32 {
    Left   :: 0;
    Right  :: 1;
    Middle :: 2;
    COUNT  :: 5;

    ImGuiMouseButton_Left   :: Left;
    ImGuiMouseButton_Right  :: Right;
    ImGuiMouseButton_Middle :: Middle;
    ImGuiMouseButton_COUNT  :: COUNT;
}

// Enumeration for GetMouseCursor()
// User code may request backend to display given cursor by calling SetMouseCursor(), which is why we have some cursors that are marked unused here
MouseCursor :: enum s32 {
    None       :: -1;
    Arrow      :: 0;
    TextInput  :: 1;
    ResizeAll  :: 2;
    ResizeNS   :: 3;
    ResizeEW   :: 4;
    ResizeNESW :: 5;
    ResizeNWSE :: 6;
    Hand       :: 7;
    NotAllowed :: 8;
    COUNT      :: 9;

    ImGuiMouseCursor_None       :: None;
    ImGuiMouseCursor_Arrow      :: Arrow;
    ImGuiMouseCursor_TextInput  :: TextInput;
    ImGuiMouseCursor_ResizeAll  :: ResizeAll;
    ImGuiMouseCursor_ResizeNS   :: ResizeNS;
    ImGuiMouseCursor_ResizeEW   :: ResizeEW;
    ImGuiMouseCursor_ResizeNESW :: ResizeNESW;
    ImGuiMouseCursor_ResizeNWSE :: ResizeNWSE;
    ImGuiMouseCursor_Hand       :: Hand;
    ImGuiMouseCursor_NotAllowed :: NotAllowed;
    ImGuiMouseCursor_COUNT      :: COUNT;
}

// Enumeration for ImGui::SetWindow***(), SetNextWindow***(), SetNextItem***() functions
// Represent a condition.
// Important: Treat as a regular enum! Do NOT combine multiple values using binary operators! All the functions above treat 0 as a shortcut to ImGuiCond_Always.
Cond :: enum s32 {
    None         :: 0;
    Always       :: 1;
    Once         :: 2;
    FirstUseEver :: 4;
    Appearing    :: 8;

    ImGuiCond_None         :: None;
    ImGuiCond_Always       :: Always;
    ImGuiCond_Once         :: Once;
    ImGuiCond_FirstUseEver :: FirstUseEver;
    ImGuiCond_Appearing    :: Appearing;
}

//-----------------------------------------------------------------------------
// IM_MALLOC(), IM_FREE(), IM_NEW(), IM_PLACEMENT_NEW(), IM_DELETE()
// We call C++ constructor on own allocated memory via the placement "new(ptr) Type()" syntax.
// Defining a custom placement new() with a custom parameter allows us to bypass including <new> which on some platforms complains when user has disabled exceptions.
//-----------------------------------------------------------------------------
ImNewWrapper :: struct {
    __empty_struct_padding: u8; // C++ makes empty structs have length 1
}

//-----------------------------------------------------------------------------
// [SECTION] ImGuiStyle
//-----------------------------------------------------------------------------
// You may modify the ImGui::GetStyle() main instance during initialization and before NewFrame().
// During the frame, use ImGui::PushStyleVar(ImGuiStyleVar_XXXX)/PopStyleVar() to alter the main style values,
// and ImGui::PushStyleColor(ImGuiCol_XXX)/PopStyleColor() for colors.
//-----------------------------------------------------------------------------
Style :: struct {
    Alpha:                      float; // Global alpha applies to everything in Dear ImGui.
    DisabledAlpha:              float; // Additional alpha multiplier applied by BeginDisabled(). Multiply over current value of Alpha.
    WindowPadding:              ImVec2; // Padding within a window.
    WindowRounding:             float; // Radius of window corners rounding. Set to 0.0f to have rectangular windows. Large values tend to lead to variety of artifacts and are not recommended.
    WindowBorderSize:           float; // Thickness of border around windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    WindowMinSize:              ImVec2; // Minimum window size. This is a global setting. If you want to constraint individual windows, use SetNextWindowSizeConstraints().
    WindowTitleAlign:           ImVec2; // Alignment for title bar text. Defaults to (0.0f,0.5f) for left-aligned,vertically centered.
    WindowMenuButtonPosition:   Dir; // Side of the collapsing/docking button in the title bar (None/Left/Right). Defaults to ImGuiDir_Left.
    ChildRounding:              float; // Radius of child window corners rounding. Set to 0.0f to have rectangular windows.
    ChildBorderSize:            float; // Thickness of border around child windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    PopupRounding:              float; // Radius of popup window corners rounding. (Note that tooltip windows use WindowRounding)
    PopupBorderSize:            float; // Thickness of border around popup/tooltip windows. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    FramePadding:               ImVec2; // Padding within a framed rectangle (used by most widgets).
    FrameRounding:              float; // Radius of frame corners rounding. Set to 0.0f to have rectangular frame (used by most widgets).
    FrameBorderSize:            float; // Thickness of border around frames. Generally set to 0.0f or 1.0f. (Other values are not well tested and more CPU/GPU costly).
    ItemSpacing:                ImVec2; // Horizontal and vertical spacing between widgets/lines.
    ItemInnerSpacing:           ImVec2; // Horizontal and vertical spacing between within elements of a composed widget (e.g. a slider and its label).
    CellPadding:                ImVec2; // Padding within a table cell
    TouchExtraPadding:          ImVec2; // Expand reactive bounding box for touch-based system where touch position is not accurate enough. Unfortunately we don't sort widgets so priority on overlap will always be given to the first widget. So don't grow this too much!
    IndentSpacing:              float; // Horizontal indentation when e.g. entering a tree node. Generally == (FontSize + FramePadding.x*2).
    ColumnsMinSpacing:          float; // Minimum horizontal spacing between two columns. Preferably > (FramePadding.x + 1).
    ScrollbarSize:              float; // Width of the vertical scrollbar, Height of the horizontal scrollbar.
    ScrollbarRounding:          float; // Radius of grab corners for scrollbar.
    GrabMinSize:                float; // Minimum width/height of a grab box for slider/scrollbar.
    GrabRounding:               float; // Radius of grabs corners rounding. Set to 0.0f to have rectangular slider grabs.
    LogSliderDeadzone:          float; // The size in pixels of the dead-zone around zero on logarithmic sliders that cross zero.
    TabRounding:                float; // Radius of upper corners of a tab. Set to 0.0f to have rectangular tabs.
    TabBorderSize:              float; // Thickness of border around tabs.
    TabMinWidthForCloseButton:  float; // Minimum width for close button to appears on an unselected tab when hovered. Set to 0.0f to always show when hovering, set to FLT_MAX to never show close button unless selected.
    ColorButtonPosition:        Dir; // Side of the color button in the ColorEdit4 widget (left/right). Defaults to ImGuiDir_Right.
    ButtonTextAlign:            ImVec2; // Alignment of button text when button is larger than text. Defaults to (0.5f, 0.5f) (centered).
    SelectableTextAlign:        ImVec2; // Alignment of selectable text. Defaults to (0.0f, 0.0f) (top-left aligned). It's generally important to keep this left-aligned if you want to lay multiple items on a same line.
    DisplayWindowPadding:       ImVec2; // Window position are clamped to be visible within the display area or monitors by at least this amount. Only applies to regular windows.
    DisplaySafeAreaPadding:     ImVec2; // If you cannot see the edges of your screen (e.g. on a TV) increase the safe area padding. Apply to popups/tooltips as well regular windows. NB: Prefer configuring your TV sets correctly!
    MouseCursorScale:           float; // Scale software rendered mouse cursor (when io.MouseDrawCursor is enabled). We apply per-monitor DPI scaling over this scale. May be removed later.
    AntiAliasedLines:           bool; // Enable anti-aliased lines/borders. Disable if you are really tight on CPU/GPU. Latched at the beginning of the frame (copied to ImDrawList).
    AntiAliasedLinesUseTex:     bool; // Enable anti-aliased lines/borders using textures where possible. Require backend to render with bilinear filtering (NOT point/nearest filtering). Latched at the beginning of the frame (copied to ImDrawList).
    AntiAliasedFill:            bool; // Enable anti-aliased edges around filled shapes (rounded rectangles, circles, etc.). Disable if you are really tight on CPU/GPU. Latched at the beginning of the frame (copied to ImDrawList).
    CurveTessellationTol:       float; // Tessellation tolerance when using PathBezierCurveTo() without a specific number of segments. Decrease for highly tessellated curves (higher quality, more polygons), increase to reduce quality.
    CircleTessellationMaxError: float; // Maximum error (in pixels) allowed when using AddCircle()/AddCircleFilled() or drawing rounded corner rectangles with no explicit segment count specified. Decrease for higher quality but more geometry.
    Colors:                     [55] ImVec4;

    Constructor :: (this: *Style) -> void #cpp_method #foreign imgui "??0ImGuiStyle@@QEAA@XZ";
    ScaleAllSizes :: (this: *Style, scale_factor: float) -> void #cpp_method #foreign imgui "?ScaleAllSizes@ImGuiStyle@@QEAAXM@Z";
}

// [Internal] Storage used by IsKeyDown(), IsKeyPressed() etc functions.
// If prior to 1.87 you used io.KeysDownDuration[] (which was marked as internal), you should use GetKeyData(key)->DownDuration and not io.KeysData[key]->DownDuration.
KeyData :: struct {
    Down:             bool; // True for if key is down
    DownDuration:     float; // Duration the key has been down (<0.0f: not pressed, 0.0f: just pressed, >0.0f: time held)
    DownDurationPrev: float; // Last frame duration the key has been down
    AnalogValue:      float; // 0.0f..1.0f for gamepad values
}

IO :: struct {
    ConfigFlags_:                      ConfigFlags; // = 0              // See ImGuiConfigFlags_ enum. Set by user/application. Gamepad/keyboard navigation options, etc.
    BackendFlags_:                     BackendFlags; // = 0              // See ImGuiBackendFlags_ enum. Set by backend (imgui_impl_xxx files or custom backend) to communicate features supported by the backend.
    DisplaySize:                       ImVec2; // <unset>          // Main display size, in pixels (generally == GetMainViewport()->Size). May change every frame.
    DeltaTime:                         float; // = 1.0f/60.0f     // Time elapsed since last frame, in seconds. May change every frame.
    IniSavingRate:                     float; // = 5.0f           // Minimum time between saving positions/sizes to .ini file, in seconds.
    IniFilename:                       *u8; // = "imgui.ini"    // Path to .ini file (important: default "imgui.ini" is relative to current working dir!). Set NULL to disable automatic .ini loading/saving or if you want to manually call LoadIniSettingsXXX() / SaveIniSettingsXXX() functions.
    LogFilename:                       *u8; // = "imgui_log.txt"// Path to .log file (default parameter to ImGui::LogToFile when no file is specified).
    MouseDoubleClickTime:              float; // = 0.30f          // Time for a double-click, in seconds.
    MouseDoubleClickMaxDist:           float; // = 6.0f           // Distance threshold to stay in to validate a double-click, in pixels.
    MouseDragThreshold:                float; // = 6.0f           // Distance threshold before considering we are dragging.
    KeyRepeatDelay:                    float; // = 0.250f         // When holding a key/button, time before it starts repeating, in seconds (for buttons in Repeat mode, etc.).
    KeyRepeatRate:                     float; // = 0.050f         // When holding a key/button, rate at which it repeats, in seconds.
    UserData:                          *void; // = NULL           // Store your own data for retrieval by callbacks.

    Fonts:                             *ImFontAtlas; // <auto>           // Font atlas: load, rasterize and pack one or more fonts into a single texture.
    FontGlobalScale:                   float; // = 1.0f           // Global scale all fonts
    FontAllowUserScaling:              bool; // = false          // Allow user scaling text of individual window with CTRL+Wheel.
    FontDefault:                       *ImFont; // = NULL           // Font to use on NewFrame(). Use NULL to uses Fonts->Fonts[0].
    DisplayFramebufferScale:           ImVec2; // = (1, 1)         // For retina display or other situations where window coordinates are different from framebuffer coordinates. This generally ends up in ImDrawData::FramebufferScale.

    ConfigDockingNoSplit:              bool; // = false          // Simplified docking mode: disable window splitting, so docking is limited to merging multiple windows together into tab-bars.
    ConfigDockingWithShift:            bool; // = false          // Enable docking with holding Shift key (reduce visual noise, allows dropping in wider space)
    ConfigDockingAlwaysTabBar:         bool; // = false          // [BETA] [FIXME: This currently creates regression with auto-sizing and general overhead] Make every single floating window display within a docking node.
    ConfigDockingTransparentPayload:   bool; // = false          // [BETA] Make window or viewport transparent when docking and only display docking boxes on the target viewport. Useful if rendering of multiple viewport cannot be synced. Best used with ConfigViewportsNoAutoMerge.

    ConfigViewportsNoAutoMerge:        bool; // = false;         // Set to make all floating imgui windows always create their own viewport. Otherwise, they are merged into the main host viewports when overlapping it. May also set ImGuiViewportFlags_NoAutoMerge on individual viewport.
    ConfigViewportsNoTaskBarIcon:      bool; // = false          // Disable default OS task bar icon flag for secondary viewports. When a viewport doesn't want a task bar icon, ImGuiViewportFlags_NoTaskBarIcon will be set on it.
    ConfigViewportsNoDecoration:       bool; // = true           // Disable default OS window decoration flag for secondary viewports. When a viewport doesn't want window decorations, ImGuiViewportFlags_NoDecoration will be set on it. Enabling decoration can create subsequent issues at OS levels (e.g. minimum window size).
    ConfigViewportsNoDefaultParent:    bool; // = false          // Disable default OS parenting to main viewport for secondary viewports. By default, viewports are marked with ParentViewportId = <main_viewport>, expecting the platform backend to setup a parent/child relationship between the OS windows (some backend may ignore this). Set to true if you want the default to be 0, then all viewports will be top-level OS windows.

    MouseDrawCursor:                   bool; // = false          // Request ImGui to draw a mouse cursor for you (if you are on a platform without a mouse cursor). Cannot be easily renamed to 'io.ConfigXXX' because this is frequently used by backend implementations.
    ConfigMacOSXBehaviors:             bool; // = defined(__APPLE__) // OS X style: Text editing cursor movement using Alt instead of Ctrl, Shortcuts using Cmd/Super instead of Ctrl, Line/Text Start and End using Cmd+Arrows instead of Home/End, Double click selects by word instead of selecting whole text, Multi-selection in lists uses Cmd/Super instead of Ctrl.
    ConfigInputTrickleEventQueue:      bool; // = true           // Enable input queue trickling: some types of events submitted during the same frame (e.g. button down + up) will be spread over multiple frames, improving interactions with low framerates.
    ConfigInputTextCursorBlink:        bool; // = true           // Enable blinking cursor (optional as some users consider it to be distracting).
    ConfigInputTextEnterKeepActive:    bool; // = false          // [BETA] Pressing Enter will keep item active and select contents (single-line only).
    ConfigDragClickToInputText:        bool; // = false          // [BETA] Enable turning DragXXX widgets into text input with a simple mouse click-release (without moving). Not desirable on devices without a keyboard.
    ConfigWindowsResizeFromEdges:      bool; // = true           // Enable resizing of windows from their edges and from the lower-left corner. This requires (io.BackendFlags & ImGuiBackendFlags_HasMouseCursors) because it needs mouse cursor feedback. (This used to be a per-window ImGuiWindowFlags_ResizeFromAnySide flag)
    ConfigWindowsMoveFromTitleBarOnly: bool; // = false       // Enable allowing to move windows only when clicking on their title bar. Does not apply to windows without a title bar.
    ConfigMemoryCompactTimer:          float; // = 60.0f          // Timer (in seconds) to free transient windows/tables memory buffers when unused. Set to -1.0f to disable.

    BackendPlatformName:               *u8; // = NULL
    BackendRendererName:               *u8; // = NULL
    BackendPlatformUserData:           *void; // = NULL           // User data for platform backend
    BackendRendererUserData:           *void; // = NULL           // User data for renderer backend
    BackendLanguageUserData:           *void; // = NULL           // User data for non C++ programming language backend

    // Optional: Access OS clipboard
    // (default to use native Win32 clipboard on Windows, otherwise uses a private clipboard. Override to access OS clipboard on other architectures)
    GetClipboardTextFn:                #type (user_data: *void) -> *u8 #c_call;
    SetClipboardTextFn:                #type (user_data: *void, text: *u8) -> void #c_call;
    ClipboardUserData:                 *void;

    // Optional: Notify OS Input Method Editor of the screen position of your cursor for text input position (e.g. when using Japanese/Chinese IME on Windows)
    // (default to use native imm32 api on Windows)
    SetPlatformImeDataFn:              #type (viewport: *Viewport, data: *PlatformImeData) -> void #c_call;

    ImeWindowHandle:                   *void; // = NULL           // [Obsolete] Set ImGuiViewport::PlatformHandleRaw instead. Set this to your HWND to get automatic IME cursor positioning.

    // Input Functions
    AddKeyEvent :: (this: *IO, key: Key, down: bool) -> void #cpp_method #foreign imgui "?AddKeyEvent@ImGuiIO@@QEAAXH_N@Z";
    AddKeyAnalogEvent :: (this: *IO, key: Key, down: bool, v: float) -> void #cpp_method #foreign imgui "?AddKeyAnalogEvent@ImGuiIO@@QEAAXH_NM@Z";
    AddMousePosEvent :: (this: *IO, x: float, y: float) -> void #cpp_method #foreign imgui "?AddMousePosEvent@ImGuiIO@@QEAAXMM@Z";
    AddMouseButtonEvent :: (this: *IO, button: s32, down: bool) -> void #cpp_method #foreign imgui "?AddMouseButtonEvent@ImGuiIO@@QEAAXH_N@Z";
    AddMouseWheelEvent :: (this: *IO, wh_x: float, wh_y: float) -> void #cpp_method #foreign imgui "?AddMouseWheelEvent@ImGuiIO@@QEAAXMM@Z";
    AddMouseViewportEvent :: (this: *IO, id: ID) -> void #cpp_method #foreign imgui "?AddMouseViewportEvent@ImGuiIO@@QEAAXI@Z";
    AddFocusEvent :: (this: *IO, focused: bool) -> void #cpp_method #foreign imgui "?AddFocusEvent@ImGuiIO@@QEAAX_N@Z";
    AddInputCharacter :: (this: *IO, c: u32) -> void #cpp_method #foreign imgui "?AddInputCharacter@ImGuiIO@@QEAAXI@Z";
    AddInputCharacterUTF16 :: (this: *IO, c: ImWchar16) -> void #cpp_method #foreign imgui "?AddInputCharacterUTF16@ImGuiIO@@QEAAXG@Z";
    AddInputCharactersUTF8 :: (this: *IO, str: *u8) -> void #cpp_method #foreign imgui "?AddInputCharactersUTF8@ImGuiIO@@QEAAXPEBD@Z";

    SetKeyEventNativeData :: (this: *IO, key: Key, native_keycode: s32, native_scancode: s32, native_legacy_index: s32 = -1) -> void #cpp_method #foreign imgui "?SetKeyEventNativeData@ImGuiIO@@QEAAXHHHH@Z";
    SetAppAcceptingEvents :: (this: *IO, accepting_events: bool) -> void #cpp_method #foreign imgui "?SetAppAcceptingEvents@ImGuiIO@@QEAAX_N@Z";
    ClearInputCharacters :: (this: *IO) -> void #cpp_method #foreign imgui "?ClearInputCharacters@ImGuiIO@@QEAAXXZ";
    ClearInputKeys :: (this: *IO) -> void #cpp_method #foreign imgui "?ClearInputKeys@ImGuiIO@@QEAAXXZ";

    WantCaptureMouse:                  bool; // Set when Dear ImGui will use mouse inputs, in this case do not dispatch them to your main game/application (either way, always pass on mouse inputs to imgui). (e.g. unclicked mouse is hovering over an imgui window, widget is active, mouse was clicked over an imgui window, etc.).
    WantCaptureKeyboard:               bool; // Set when Dear ImGui will use keyboard inputs, in this case do not dispatch them to your main game/application (either way, always pass keyboard inputs to imgui). (e.g. InputText active, or an imgui window is focused and navigation is enabled, etc.).
    WantTextInput:                     bool; // Mobile/console: when set, you may display an on-screen keyboard. This is set by Dear ImGui when it wants textual keyboard input to happen (e.g. when a InputText widget is active).
    WantSetMousePos:                   bool; // MousePos has been altered, backend should reposition mouse on next frame. Rarely used! Set only when ImGuiConfigFlags_NavEnableSetMousePos flag is enabled.
    WantSaveIniSettings:               bool; // When manual .ini load/save is active (io.IniFilename == NULL), this will be set to notify your application that you can call SaveIniSettingsToMemory() and save yourself. Important: clear io.WantSaveIniSettings yourself after saving!
    NavActive:                         bool; // Keyboard/Gamepad navigation is currently allowed (will handle ImGuiKey_NavXXX events) = a window is focused and it doesn't use the ImGuiWindowFlags_NoNavInputs flag.
    NavVisible:                        bool; // Keyboard/Gamepad navigation is visible and allowed (will handle ImGuiKey_NavXXX events).
    Framerate:                         float; // Rough estimate of application framerate, in frame per second. Solely for convenience. Rolling average estimation based on io.DeltaTime over 120 frames.
    MetricsRenderVertices:             s32; // Vertices output during last call to Render()
    MetricsRenderIndices:              s32; // Indices output during last call to Render() = number of triangles * 3
    MetricsRenderWindows:              s32; // Number of visible windows
    MetricsActiveWindows:              s32; // Number of active windows
    MetricsActiveAllocations:          s32; // Number of active allocations, updated by MemAlloc/MemFree based on current context. May be off if you have multiple imgui contexts.
    MouseDelta:                        ImVec2; // Mouse delta. Note that this is zero if either current or previous position are invalid (-FLT_MAX,-FLT_MAX), so a disappearing/reappearing mouse won't have a huge delta.

    KeyMap:                            [645] s32; // [LEGACY] Input: map of indices into the KeysDown[512] entries array which represent your "native" keyboard state. The first 512 are now unused and should be kept zero. Legacy backend will write into KeyMap[] using ImGuiKey_ indices which are always >512.
    KeysDown:                          [645] bool; // [LEGACY] Input: Keyboard keys that are pressed (ideally left in the "native" order your engine has access to keyboard keys, so you can use your own defines/enums for keys). This used to be [512] sized. It is now ImGuiKey_COUNT to allow legacy io.KeysDown[GetKeyIndex(...)] to work without an overflow.

    MousePos:                          ImVec2; // Mouse position, in pixels. Set to ImVec2(-FLT_MAX, -FLT_MAX) if mouse is unavailable (on another screen, etc.)
    MouseDown:                         [5] bool; // Mouse buttons: 0=left, 1=right, 2=middle + extras (ImGuiMouseButton_COUNT == 5). Dear ImGui mostly uses left and right buttons. Others buttons allows us to track if the mouse is being used by your application + available to user as a convenience via IsMouse** API.
    MouseWheel:                        float; // Mouse wheel Vertical: 1 unit scrolls about 5 lines text.
    MouseWheelH:                       float; // Mouse wheel Horizontal. Most users don't have a mouse with an horizontal wheel, may not be filled by all backends.
    MouseHoveredViewport:              ID; // (Optional) Modify using io.AddMouseViewportEvent(). With multi-viewports: viewport the OS mouse is hovering. If possible _IGNORING_ viewports with the ImGuiViewportFlags_NoInputs flag is much better (few backends can handle that). Set io.BackendFlags |= ImGuiBackendFlags_HasMouseHoveredViewport if you can provide this info. If you don't imgui will infer the value using the rectangles and last focused time of the viewports it knows about (ignoring other OS windows).
    KeyCtrl:                           bool; // Keyboard modifier down: Control
    KeyShift:                          bool; // Keyboard modifier down: Shift
    KeyAlt:                            bool; // Keyboard modifier down: Alt
    KeySuper:                          bool; // Keyboard modifier down: Cmd/Super/Windows
    NavInputs:                         [20] float; // Gamepad inputs. Cleared back to zero by EndFrame(). Keyboard keys will be auto-mapped and be written here by NewFrame().

    KeyMods:                           ModFlags; // Key mods flags (same as io.KeyCtrl/KeyShift/KeyAlt/KeySuper but merged into flags), updated by NewFrame()
    KeysData:                          [645] KeyData; // Key state for all known keys. Use IsKeyXXX() functions to access this.
    WantCaptureMouseUnlessPopupClose:  bool; // Alternative to WantCaptureMouse: (WantCaptureMouse == true && WantCaptureMouseUnlessPopupClose == false) when a click over void is expected to close a popup.
    MousePosPrev:                      ImVec2; // Previous mouse position (note that MouseDelta is not necessary == MousePos-MousePosPrev, in case either position is invalid)
    MouseClickedPos:                   [5] ImVec2; // Position at time of clicking
    MouseClickedTime:                  [5] float64; // Time of last click (used to figure out double-click)
    MouseClicked:                      [5] bool; // Mouse button went from !Down to Down (same as MouseClickedCount[x] != 0)
    MouseDoubleClicked:                [5] bool; // Has mouse button been double-clicked? (same as MouseClickedCount[x] == 2)
    MouseClickedCount:                 [5] ImU16; // == 0 (not clicked), == 1 (same as MouseClicked[]), == 2 (double-clicked), == 3 (triple-clicked) etc. when going from !Down to Down
    MouseClickedLastCount:             [5] ImU16; // Count successive number of clicks. Stays valid after mouse release. Reset after another click is done.
    MouseReleased:                     [5] bool; // Mouse button went from Down to !Down
    MouseDownOwned:                    [5] bool; // Track if button was clicked inside a dear imgui window or over void blocked by a popup. We don't request mouse capture from the application if click started outside ImGui bounds.
    MouseDownOwnedUnlessPopupClose:    [5] bool; // Track if button was clicked inside a dear imgui window.
    MouseDownDuration:                 [5] float; // Duration the mouse button has been down (0.0f == just clicked)
    MouseDownDurationPrev:             [5] float; // Previous time the mouse button has been down
    MouseDragMaxDistanceAbs:           [5] ImVec2; // Maximum distance, absolute, on each axis, of how much mouse has traveled from the clicking point
    MouseDragMaxDistanceSqr:           [5] float; // Squared maximum distance of how much mouse has traveled from the clicking point (used for moving thresholds)
    NavInputsDownDuration:             [20] float;
    NavInputsDownDurationPrev:         [20] float;
    PenPressure:                       float; // Touch/Pen pressure (0.0f to 1.0f, should be >0.0f only when MouseDown[0] == true). Helper storage currently unused by Dear ImGui.
    AppFocusLost:                      bool; // Only modify via AddFocusEvent()
    AppAcceptingEvents:                bool; // Only modify via SetAppAcceptingEvents()
    BackendUsingLegacyKeyArrays:       ImS8; // -1: unknown, 0: using AddKeyEvent(), 1: using legacy io.KeysDown[]
    BackendUsingLegacyNavInputArray:   bool; // 0: using AddKeyAnalogEvent(), 1: writing to legacy io.NavInputs[] directly
    InputQueueSurrogate:               ImWchar16; // For AddInputCharacterUTF16()
    InputQueueCharacters:              ImVector(ImWchar); // Queue of _characters_ input (obtained by platform backend). Fill using AddInputCharacter() helper.

    Constructor :: (this: *IO) -> void #cpp_method #foreign imgui "??0ImGuiIO@@QEAA@XZ";
}

// Shared state of InputText(), passed as an argument to your callback when a ImGuiInputTextFlags_Callback* flag is used.
// The callback function should return 0 by default.
// Callbacks (follow a flag name and see comments in ImGuiInputTextFlags_ declarations for more details)
// - ImGuiInputTextFlags_CallbackEdit:        Callback on buffer edit (note that InputText() already returns true on edit, the callback is useful mainly to manipulate the underlying buffer while focus is active)
// - ImGuiInputTextFlags_CallbackAlways:      Callback on each iteration
// - ImGuiInputTextFlags_CallbackCompletion:  Callback on pressing TAB
// - ImGuiInputTextFlags_CallbackHistory:     Callback on pressing Up/Down arrows
// - ImGuiInputTextFlags_CallbackCharFilter:  Callback on character inputs to replace or discard them. Modify 'EventChar' to replace or discard, or return 1 in callback to discard.
// - ImGuiInputTextFlags_CallbackResize:      Callback on buffer capacity changes request (beyond 'buf_size' parameter value), allowing the string to grow.
InputTextCallbackData :: struct {
    EventFlag:      InputTextFlags; // One ImGuiInputTextFlags_Callback*    // Read-only
    Flags:          InputTextFlags; // What user passed to InputText()      // Read-only
    UserData:       *void; // What user passed to InputText()      // Read-only

    EventChar:      ImWchar; // Character input                      // Read-write   // [CharFilter] Replace character with another one, or set to zero to drop. return 1 is equivalent to setting EventChar=0;
    EventKey:       Key; // Key pressed (Up/Down/TAB)            // Read-only    // [Completion,History]
    Buf:            *u8; // Text buffer                          // Read-write   // [Resize] Can replace pointer / [Completion,History,Always] Only write to pointed data, don't replace the actual pointer!
    BufTextLen:     s32; // Text length (in bytes)               // Read-write   // [Resize,Completion,History,Always] Exclude zero-terminator storage. In C land: == strlen(some_text), in C++ land: string.length()
    BufSize:        s32; // Buffer size (in bytes) = capacity+1  // Read-only    // [Resize,Completion,History,Always] Include zero-terminator storage. In C land == ARRAYSIZE(my_char_array), in C++ land: string.capacity()+1
    BufDirty:       bool; // Set if you modify Buf/BufTextLen!    // Write        // [Completion,History,Always]
    CursorPos:      s32; //                                      // Read-write   // [Completion,History,Always]
    SelectionStart: s32; //                                      // Read-write   // [Completion,History,Always] == to SelectionEnd when no selection)
    SelectionEnd:   s32; //                                      // Read-write   // [Completion,History,Always]

    // Helper functions for text manipulation.
    // Use those function to benefit from the CallbackResize behaviors. Calling those function reset the selection.
    Constructor :: (this: *InputTextCallbackData) -> void #cpp_method #foreign imgui "??0ImGuiInputTextCallbackData@@QEAA@XZ";
    DeleteChars :: (this: *InputTextCallbackData, pos: s32, bytes_count: s32) -> void #cpp_method #foreign imgui "?DeleteChars@ImGuiInputTextCallbackData@@QEAAXHH@Z";
    InsertChars :: (this: *InputTextCallbackData, pos: s32, text: *u8, text_end: *u8 = null) -> void #cpp_method #foreign imgui "?InsertChars@ImGuiInputTextCallbackData@@QEAAXHPEBD0@Z";
    InsertChars :: (this: *InputTextCallbackData, pos: s32, text: string) #no_context {
        InsertChars(this, pos, text.data, text.data + text.count);
    }
}

// Resizing callback data to apply custom constraint. As enabled by SetNextWindowSizeConstraints(). Callback is called during the next Begin().
// NB: For basic min/max size constraint on each axis you don't need to use the callback! The SetNextWindowSizeConstraints() parameters are enough.
SizeCallbackData :: struct {
    UserData:    *void; // Read-only.   What user passed to SetNextWindowSizeConstraints()
    Pos:         ImVec2; // Read-only.   Window position, for reference.
    CurrentSize: ImVec2; // Read-only.   Current window size.
    DesiredSize: ImVec2; // Read-write.  Desired size, based on user's mouse position. Write to this field to restrain resizing.
}

// [ALPHA] Rarely used / very advanced uses only. Use with SetNextWindowClass() and DockSpace() functions.
// Important: the content of this class is still highly WIP and likely to change and be refactored
// before we stabilize Docking features. Please be mindful if using this.
// Provide hints:
// - To the platform backend via altered viewport flags (enable/disable OS decoration, OS task bar icons, etc.)
// - To the platform backend for OS level parent/child relationships of viewport.
// - To the docking system for various options and filtering.
WindowClass :: struct {
    ClassId:                    ID; // User data. 0 = Default class (unclassed). Windows of different classes cannot be docked with each others.
    ParentViewportId:           ID; // Hint for the platform backend. -1: use default. 0: request platform backend to not parent the platform. != 0: request platform backend to create a parent<>child relationship between the platform windows. Not conforming backends are free to e.g. parent every viewport to the main viewport or not.
    ViewportFlagsOverrideSet:   ViewportFlags; // Viewport flags to set when a window of this class owns a viewport. This allows you to enforce OS decoration or task bar icon, override the defaults on a per-window basis.
    ViewportFlagsOverrideClear: ViewportFlags; // Viewport flags to clear when a window of this class owns a viewport. This allows you to enforce OS decoration or task bar icon, override the defaults on a per-window basis.
    TabItemFlagsOverrideSet:    TabItemFlags; // [EXPERIMENTAL] TabItem flags to set when a window of this class gets submitted into a dock node tab bar. May use with ImGuiTabItemFlags_Leading or ImGuiTabItemFlags_Trailing.
    DockNodeFlagsOverrideSet:   DockNodeFlags; // [EXPERIMENTAL] Dock node flags to set when a window of this class is hosted by a dock node (it doesn't have to be selected!)
    DockingAlwaysTabBar:        bool; // Set to true to enforce single floating windows of this class always having their own docking node (equivalent of setting the global io.ConfigDockingAlwaysTabBar)
    DockingAllowUnclassed:      bool; // Set to true to allow windows of this class to be docked/merged with an unclassed window. // FIXME-DOCK: Move to DockNodeFlags override?
}

// Data payload for Drag and Drop operations: AcceptDragDropPayload(), GetDragDropPayload()
Payload :: struct {
    Data:           *void; // Data (copied and owned by dear imgui)
    DataSize:       s32; // Data size

    SourceId:       ID; // Source item id
    SourceParentId: ID; // Source parent id (if available)
    DataFrameCount: s32; // Data timestamp
    DataType:       [33] u8; // Data type tag (short user-supplied string, 32 characters max)
    Preview:        bool; // Set when AcceptDragDropPayload() was called and mouse has been hovering the target item (nb: handle overlapping drag targets)
    Delivery:       bool; // Set when AcceptDragDropPayload() was called and mouse button is released over the target item.
}

// Sorting specification for one column of a table (sizeof == 12 bytes)
TableColumnSortSpecs :: struct {
    ColumnUserID:   ID; // User id of the column (if specified by a TableSetupColumn() call)
    ColumnIndex:    ImS16; // Index of the column
    SortOrder:      ImS16; // Index within parent ImGuiTableSortSpecs (always stored in order starting from 0, tables sorted on a single criteria will always have a 0 here)
    SortDirection_: SortDirection; // ImGuiSortDirection_Ascending or ImGuiSortDirection_Descending (you can use this or SortSign, whichever is more convenient for your sort function)
}

// Sorting specifications for a table (often handling sort specs for a single column, occasionally more)
// Obtained by calling TableGetSortSpecs().
// When 'SpecsDirty == true' you can sort your data. It will be true with sorting specs have changed since last call, or the first time.
// Make sure to set 'SpecsDirty = false' after sorting, else you may wastefully sort your data every frame!
TableSortSpecs :: struct {
    Specs:      *TableColumnSortSpecs; // Pointer to sort spec array.
    SpecsCount: s32; // Sort spec count. Most often 1. May be > 1 when ImGuiTableFlags_SortMulti is enabled. May be == 0 when ImGuiTableFlags_SortTristate is enabled.
    SpecsDirty: bool; // Set to true when specs have changed since last time! Use this to sort again, then clear the flag.
}

// Helper: Execute a block of code at maximum once a frame. Convenient if you want to quickly create an UI within deep-nested code that runs multiple times every frame.
// Usage: static ImGuiOnceUponAFrame oaf; if (oaf) ImGui::Text("This will be called only once per frame");
OnceUponAFrame :: struct {
    RefFrame: s32;
}

// Helper: Parse and apply text filters. In format "aaaaa[,bbbb][,ccccc]"
TextFilter :: struct {
    Constructor :: (this: *TextFilter, default_filter: *u8 = "") -> void #cpp_method #foreign imgui "??0ImGuiTextFilter@@QEAA@PEBD@Z";
    Draw :: (this: *TextFilter, label: *u8 = "Filter (inc,-exc)", width: float = 0.0) -> bool #cpp_method #foreign imgui "?Draw@ImGuiTextFilter@@QEAA_NPEBDM@Z";
    PassFilter :: (this: *TextFilter, text: *u8, text_end: *u8 = null) -> bool #cpp_method #foreign imgui "?PassFilter@ImGuiTextFilter@@QEBA_NPEBD0@Z";
    PassFilter :: (this: *TextFilter, text: string) -> bool #no_context {
        return PassFilter(this, text.data, text.data + text.count);
    }
    Build :: (this: *TextFilter) -> void #cpp_method #foreign imgui "?Build@ImGuiTextFilter@@QEAAXXZ";

    // [Internal]
    TextRange :: struct {
        b: *u8;
        e: *u8;

        split :: (this: *TextRange, separator: u8, out: *ImVector(TextRange)) -> void #cpp_method #foreign imgui "?split@ImGuiTextRange@ImGuiTextFilter@@QEBAXDPEAU?$ImVector@UImGuiTextRange@ImGuiTextFilter@@@@@Z";
    }

    InputBuf:  [256] u8;
    Filters:   ImVector(TextRange);
    CountGrep: s32;
}

// Helper: Growable text buffer for logging/accumulating text
// (this could be called 'ImGuiTextBuilder' / 'ImGuiStringBuilder')
TextBuffer :: struct {
    Buf: ImVector(u8);

    append :: (this: *TextBuffer, str: *u8, str_end: *u8 = null) -> void #cpp_method #foreign imgui "?append@ImGuiTextBuffer@@QEAAXPEBD0@Z";
    append :: (this: *TextBuffer, str: string) #no_context {
        append(this, str.data, str.data + str.count);
    }
    appendf :: (this: *TextBuffer, fmt: *u8, __args: ..Any) -> void #cpp_method #foreign imgui "?appendf@ImGuiTextBuffer@@QEAAXPEBDZZ";
}

// Helper: Key->Value storage
// Typically you don't have to worry about this since a storage is held within each Window.
// We use it to e.g. store collapse state for a tree (Int 0/1)
// This is optimized for efficient lookup (dichotomy into a contiguous buffer) and rare insertion (typically tied to user interactions aka max once a frame)
// You can use it as custom user storage for temporary values. Declare your own storage if, for example:
// - You want to manipulate the open/close state of a particular sub-tree in your interface (tree node uses Int 0/1 to store their state).
// - You want to store custom debug data easily without adding or editing structures in your code (probably not efficient, but convenient)
// Types are NOT stored, so it is up to you to make sure your Key don't collide with different types.
Storage :: struct {
    // [Internal]
    StoragePair :: struct {
        key: ID;
        union {
            val_i: s32;
            val_f: float;
            val_p: *void;
        }
    }

    Data: ImVector(StoragePair);

    GetInt :: (this: *Storage, key: ID, default_val: s32 = 0) -> s32 #cpp_method #foreign imgui "?GetInt@ImGuiStorage@@QEBAHIH@Z";
    SetInt :: (this: *Storage, key: ID, val: s32) -> void #cpp_method #foreign imgui "?SetInt@ImGuiStorage@@QEAAXIH@Z";
    GetBool :: (this: *Storage, key: ID, default_val := false) -> bool #cpp_method #foreign imgui "?GetBool@ImGuiStorage@@QEBA_NI_N@Z";
    SetBool :: (this: *Storage, key: ID, val: bool) -> void #cpp_method #foreign imgui "?SetBool@ImGuiStorage@@QEAAXI_N@Z";
    GetFloat :: (this: *Storage, key: ID, default_val: float = 0.0) -> float #cpp_method #foreign imgui "?GetFloat@ImGuiStorage@@QEBAMIM@Z";
    SetFloat :: (this: *Storage, key: ID, val: float) -> void #cpp_method #foreign imgui "?SetFloat@ImGuiStorage@@QEAAXIM@Z";
    GetVoidPtr :: (this: *Storage, key: ID) -> *void #cpp_method #foreign imgui "?GetVoidPtr@ImGuiStorage@@QEBAPEAXI@Z";
    SetVoidPtr :: (this: *Storage, key: ID, val: *void) -> void #cpp_method #foreign imgui "?SetVoidPtr@ImGuiStorage@@QEAAXIPEAX@Z";

    // - Get***Ref() functions finds pair, insert on demand if missing, return pointer. Useful if you intend to do Get+Set.
    // - References are only valid until a new value is added to the storage. Calling a Set***() function or a Get***Ref() function invalidates the pointer.
    // - A typical use case where this is convenient for quick hacking (e.g. add storage during a live Edit&Continue session if you can't modify existing struct)
    //      float* pvar = ImGui::GetFloatRef(key); ImGui::SliderFloat("var", pvar, 0, 100.0f); some_var += *pvar;
    GetIntRef :: (this: *Storage, key: ID, default_val: s32 = 0) -> *s32 #cpp_method #foreign imgui "?GetIntRef@ImGuiStorage@@QEAAPEAHIH@Z";
    GetBoolRef :: (this: *Storage, key: ID, default_val := false) -> *bool #cpp_method #foreign imgui "?GetBoolRef@ImGuiStorage@@QEAAPEA_NI_N@Z";
    GetFloatRef :: (this: *Storage, key: ID, default_val: float = 0.0) -> *float #cpp_method #foreign imgui "?GetFloatRef@ImGuiStorage@@QEAAPEAMIM@Z";
    GetVoidPtrRef :: (this: *Storage, key: ID, default_val: *void = null) -> **void #cpp_method #foreign imgui "?GetVoidPtrRef@ImGuiStorage@@QEAAPEAPEAXIPEAX@Z";

    // Use on your own storage if you know only integer are being stored (open/close all tree nodes)
    SetAllInt :: (this: *Storage, val: s32) -> void #cpp_method #foreign imgui "?SetAllInt@ImGuiStorage@@QEAAXH@Z";

    // For quicker full rebuild of a storage (instead of an incremental one), you may add all your contents and then sort once.
    BuildSortByKey :: (this: *Storage) -> void #cpp_method #foreign imgui "?BuildSortByKey@ImGuiStorage@@QEAAXXZ";
}

// Helper: Manually clip large list of items.
// If you have lots evenly spaced items and you have a random access to the list, you can perform coarse
// clipping based on visibility to only submit items that are in view.
// The clipper calculates the range of visible items and advance the cursor to compensate for the non-visible items we have skipped.
// (Dear ImGui already clip items based on their bounds but: it needs to first layout the item to do so, and generally
//  fetching/submitting your own data incurs additional cost. Coarse clipping using ImGuiListClipper allows you to easily
//  scale using lists with tens of thousands of items without a problem)
// Usage:
//   ImGuiListClipper clipper;
//   clipper.Begin(1000);         // We have 1000 elements, evenly spaced.
//   while (clipper.Step())
//       for (int i = clipper.DisplayStart; i < clipper.DisplayEnd; i++)
//           ImGui::Text("line number %d", i);
// Generally what happens is:
// - Clipper lets you process the first element (DisplayStart = 0, DisplayEnd = 1) regardless of it being visible or not.
// - User code submit that one element.
// - Clipper can measure the height of the first element
// - Clipper calculate the actual range of elements to display based on the current clipping rectangle, position the cursor before the first visible element.
// - User code submit visible elements.
// - The clipper also handles various subtleties related to keyboard/gamepad navigation, wrapping etc.
ListClipper :: struct {
    DisplayStart: s32; // First item to display, updated by each call to Step()
    DisplayEnd:   s32; // End of items to display (exclusive)
    ItemsCount:   s32; // [Internal] Number of items
    ItemsHeight:  float; // [Internal] Height of item after a first step and item submission can calculate it
    StartPosY:    float; // [Internal] Cursor position at the time of Begin() or after table frozen rows are all processed
    TempData:     *void; // [Internal] Internal data

    // items_count: Use INT_MAX if you don't know how many items you have (in which case the cursor won't be advanced in the final step)
    // items_height: Use -1.0f to be calculated automatically on first step. Otherwise pass in the distance between your items, typically GetTextLineHeightWithSpacing() or GetFrameHeightWithSpacing().
    Constructor :: (this: *ListClipper) -> void #cpp_method #foreign imgui "??0ImGuiListClipper@@QEAA@XZ";
    Destructor :: (this: *ListClipper) -> void #cpp_method #foreign imgui "??1ImGuiListClipper@@QEAA@XZ";
    Begin :: (this: *ListClipper, items_count: s32, items_height: float = -1.0) -> void #cpp_method #foreign imgui "?Begin@ImGuiListClipper@@QEAAXHM@Z";
    End :: (this: *ListClipper) -> void #cpp_method #foreign imgui "?End@ImGuiListClipper@@QEAAXXZ";
    Step :: (this: *ListClipper) -> bool #cpp_method #foreign imgui "?Step@ImGuiListClipper@@QEAA_NXZ";

    // Call ForceDisplayRangeByIndices() before first call to Step() if you need a range of items to be displayed regardless of visibility.
    ForceDisplayRangeByIndices :: (this: *ListClipper, item_min: s32, item_max: s32) -> void #cpp_method #foreign imgui "?ForceDisplayRangeByIndices@ImGuiListClipper@@QEAAXHH@Z";
}

// Typically, 1 command = 1 GPU draw call (unless command is a callback)
// - VtxOffset: When 'io.BackendFlags & ImGuiBackendFlags_RendererHasVtxOffset' is enabled,
//   this fields allow us to render meshes larger than 64K vertices while keeping 16-bit indices.
//   Backends made for <1.71. will typically ignore the VtxOffset fields.
// - The ClipRect/TextureId/VtxOffset fields must be contiguous as we memcmp() them together (this is asserted for).
ImDrawCmd :: struct {
    ClipRect:         ImVec4; // 4*4  // Clipping rectangle (x1, y1, x2, y2). Subtract ImDrawData->DisplayPos to get clipping rectangle in "viewport" coordinates
    TextureId:        ImTextureID; // 4-8  // User-provided texture ID. Set by user in ImfontAtlas::SetTexID() for fonts or passed to Image*() functions. Ignore if never using images or multiple fonts atlas.
    VtxOffset:        u32; // 4    // Start offset in vertex buffer. ImGuiBackendFlags_RendererHasVtxOffset: always 0, otherwise may be >0 to support meshes larger than 64K vertices with 16-bit indices.
    IdxOffset:        u32; // 4    // Start offset in index buffer.
    ElemCount:        u32; // 4    // Number of indices (multiple of 3) to be rendered as triangles. Vertices are stored in the callee ImDrawList's vtx_buffer[] array, indices in idx_buffer[].
    UserCallback:     ImDrawCallback; // 4-8  // If != NULL, call the function instead of rendering the vertices. clip_rect and texture_id will be set normally.
    UserCallbackData: *void; // 4-8  // The draw callback code can access this.
}

ImDrawVert :: struct {
    pos: ImVec2;
    uv:  ImVec2;
    col: ImU32;
}

// [Internal] For use by ImDrawList
ImDrawCmdHeader :: struct {
    ClipRect:  ImVec4;
    TextureId: ImTextureID;
    VtxOffset: u32;
}

// Forward declarations
ImDrawChannel :: struct {
    _CmdBuffer: ImVector(ImDrawCmd);
    _IdxBuffer: ImVector(ImDrawIdx);
}

// Split/Merge functions are used to split the draw list into different layers which can be drawn into out of order.
// This is used by the Columns/Tables API, so items of each column can be batched together in a same draw call.
ImDrawListSplitter :: struct {
    _Current:  s32; // Current channel number (0)
    _Count:    s32; // Number of active channels (1+)
    _Channels: ImVector(ImDrawChannel); // Draw channels (not resized down so _Count might be < Channels.Size)

    ClearFreeMemory :: (this: *ImDrawListSplitter) -> void #cpp_method #foreign imgui "?ClearFreeMemory@ImDrawListSplitter@@QEAAXXZ";
    Split :: (this: *ImDrawListSplitter, draw_list: *ImDrawList, count: s32) -> void #cpp_method #foreign imgui "?Split@ImDrawListSplitter@@QEAAXPEAUImDrawList@@H@Z";
    Merge :: (this: *ImDrawListSplitter, draw_list: *ImDrawList) -> void #cpp_method #foreign imgui "?Merge@ImDrawListSplitter@@QEAAXPEAUImDrawList@@@Z";
    SetCurrentChannel :: (this: *ImDrawListSplitter, draw_list: *ImDrawList, channel_idx: s32) -> void #cpp_method #foreign imgui "?SetCurrentChannel@ImDrawListSplitter@@QEAAXPEAUImDrawList@@H@Z";
}

// Flags for ImDrawList functions
// (Legacy: bit 0 must always correspond to ImDrawFlags_Closed to be backward compatible with old API using a bool. Bits 1..3 must be unused)
ImDrawFlags :: enum_flags s32 {
    None                    :: 0x0;
    Closed                  :: 0x1;
    RoundCornersTopLeft     :: 0x10;
    RoundCornersTopRight    :: 0x20;
    RoundCornersBottomLeft  :: 0x40;
    RoundCornersBottomRight :: 0x80;
    RoundCornersNone        :: 0x100;
    RoundCornersTop         :: 0x30;
    RoundCornersBottom      :: 0xc0;
    RoundCornersLeft        :: 0x50;
    RoundCornersRight       :: 0xa0;
    RoundCornersAll         :: 0xf0;
    RoundCornersDefault_    :: 0xf0;
    RoundCornersMask_       :: 0x1f0;

    ImDrawFlags_None                    :: None;
    ImDrawFlags_Closed                  :: Closed;
    ImDrawFlags_RoundCornersTopLeft     :: RoundCornersTopLeft;
    ImDrawFlags_RoundCornersTopRight    :: RoundCornersTopRight;
    ImDrawFlags_RoundCornersBottomLeft  :: RoundCornersBottomLeft;
    ImDrawFlags_RoundCornersBottomRight :: RoundCornersBottomRight;
    ImDrawFlags_RoundCornersNone        :: RoundCornersNone;
    ImDrawFlags_RoundCornersTop         :: RoundCornersTop;
    ImDrawFlags_RoundCornersBottom      :: RoundCornersBottom;
    ImDrawFlags_RoundCornersLeft        :: RoundCornersLeft;
    ImDrawFlags_RoundCornersRight       :: RoundCornersRight;
    ImDrawFlags_RoundCornersAll         :: RoundCornersAll;
    ImDrawFlags_RoundCornersDefault_    :: RoundCornersDefault_;
    ImDrawFlags_RoundCornersMask_       :: RoundCornersMask_;
}

// Flags for ImDrawList instance. Those are set automatically by ImGui:: functions from ImGuiIO settings, and generally not manipulated directly.
// It is however possible to temporarily alter flags between calls to ImDrawList:: functions.
ImDrawListFlags :: enum_flags s32 {
    None                   :: 0x0;
    AntiAliasedLines       :: 0x1;
    AntiAliasedLinesUseTex :: 0x2;
    AntiAliasedFill        :: 0x4;
    AllowVtxOffset         :: 0x8;

    ImDrawListFlags_None                   :: None;
    ImDrawListFlags_AntiAliasedLines       :: AntiAliasedLines;
    ImDrawListFlags_AntiAliasedLinesUseTex :: AntiAliasedLinesUseTex;
    ImDrawListFlags_AntiAliasedFill        :: AntiAliasedFill;
    ImDrawListFlags_AllowVtxOffset         :: AllowVtxOffset;
}

// Draw command list
// This is the low-level list of polygons that ImGui:: functions are filling. At the end of the frame,
// all command lists are passed to your ImGuiIO::RenderDrawListFn function for rendering.
// Each dear imgui window contains its own ImDrawList. You can use ImGui::GetWindowDrawList() to
// access the current window draw list and draw custom primitives.
// You can interleave normal ImGui:: calls and adding primitives to the current draw list.
// In single viewport mode, top-left is == GetMainViewport()->Pos (generally 0,0), bottom-right is == GetMainViewport()->Pos+Size (generally io.DisplaySize).
// You are totally free to apply whatever transformation matrix to want to the data (depending on the use of the transformation you may want to apply it to ClipRect as well!)
// Important: Primitives are always added to the list and not culled (culling is done at higher-level by ImGui:: functions), if you use this API a lot consider coarse culling your drawn objects.
ImDrawList :: struct {
    CmdBuffer:       ImVector(ImDrawCmd); // Draw commands. Typically 1 command = 1 GPU draw call, unless the command is a callback.
    IdxBuffer:       ImVector(ImDrawIdx); // Index buffer. Each command consume ImDrawCmd::ElemCount of those
    VtxBuffer:       ImVector(ImDrawVert); // Vertex buffer.
    Flags:           ImDrawListFlags; // Flags, you may poke into these to adjust anti-aliasing settings per-primitive.

    _VtxCurrentIdx:  u32; // [Internal] generally == VtxBuffer.Size unless we are past 64K vertices, in which case this gets reset to 0.
    _Data:           *ImDrawListSharedData; // Pointer to shared draw data (you can use ImGui::GetDrawListSharedData() to get the one from current ImGui context)
    _OwnerName:      *u8; // Pointer to owner window's name for debugging
    _VtxWritePtr:    *ImDrawVert; // [Internal] point within VtxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    _IdxWritePtr:    *ImDrawIdx; // [Internal] point within IdxBuffer.Data after each add command (to avoid using the ImVector<> operators too much)
    _ClipRectStack:  ImVector(ImVec4); // [Internal]
    _TextureIdStack: ImVector(ImTextureID); // [Internal]
    _Path:           ImVector(ImVec2); // [Internal] current path building
    _CmdHeader:      ImDrawCmdHeader; // [Internal] template of active commands. Fields should match those of CmdBuffer.back().
    _Splitter:       ImDrawListSplitter; // [Internal] for channels api (note: prefer using your own persistent instance of ImDrawListSplitter!)
    _FringeScale:    float; // [Internal] anti-alias fringe is scaled by this value, this helps to keep things sharp while zooming at vertex buffer content

    PushClipRect :: (this: *ImDrawList, clip_rect_min: *ImVec2, clip_rect_max: *ImVec2, intersect_with_current_clip_rect := false) -> void #cpp_method #foreign imgui "?PushClipRect@ImDrawList@@QEAAXAEBUImVec2@@0_N@Z";
    PushClipRect :: (this: *ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect := false) #no_context {
        PushClipRect(this, *clip_rect_min, *clip_rect_max, intersect_with_current_clip_rect);
    }
    PushClipRectFullScreen :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?PushClipRectFullScreen@ImDrawList@@QEAAXXZ";
    PopClipRect :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?PopClipRect@ImDrawList@@QEAAXXZ";
    PushTextureID :: (this: *ImDrawList, texture_id: ImTextureID) -> void #cpp_method #foreign imgui "?PushTextureID@ImDrawList@@QEAAXPEAX@Z";
    PopTextureID :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?PopTextureID@ImDrawList@@QEAAXXZ";

    // Primitives
    // - Filled shapes must always use clockwise winding order. The anti-aliasing fringe depends on it. Counter-clockwise shapes will have "inward" anti-aliasing.
    // - For rectangular primitives, "p_min" and "p_max" represent the upper-left and lower-right corners.
    // - For circle primitives, use "num_segments == 0" to automatically calculate tessellation (preferred).
    //   In older versions (until Dear ImGui 1.77) the AddCircle functions defaulted to num_segments == 12.
    //   In future versions we will use textures to provide cheaper and higher-quality circles.
    //   Use AddNgon() and AddNgonFilled() functions if you need to guaranteed a specific number of sides.
    AddLine :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, col: ImU32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "?AddLine@ImDrawList@@QEAAXAEBUImVec2@@0IM@Z";
    AddLine :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, col: ImU32, thickness: float = 1.0) #no_context {
        AddLine(this, *p1, *p2, col, thickness);
    }
    AddRect :: (this: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None, thickness: float = 1.0) -> void #cpp_method #foreign imgui "?AddRect@ImDrawList@@QEAAXAEBUImVec2@@0IMHM@Z";
    AddRect :: (this: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None, thickness: float = 1.0) #no_context {
        AddRect(this, *p_min, *p_max, col, rounding, flags, thickness);
    }
    AddRectFilled :: (this: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None) -> void #cpp_method #foreign imgui "?AddRectFilled@ImDrawList@@QEAAXAEBUImVec2@@0IMH@Z";
    AddRectFilled :: (this: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col: ImU32, rounding: float = 0.0, flags: ImDrawFlags = .None) #no_context {
        AddRectFilled(this, *p_min, *p_max, col, rounding, flags);
    }
    AddRectFilledMultiColor :: (this: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col_upr_left: ImU32, col_upr_right: ImU32, col_bot_right: ImU32, col_bot_left: ImU32) -> void #cpp_method #foreign imgui "?AddRectFilledMultiColor@ImDrawList@@QEAAXAEBUImVec2@@0IIII@Z";
    AddRectFilledMultiColor :: (this: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col_upr_left: ImU32, col_upr_right: ImU32, col_bot_right: ImU32, col_bot_left: ImU32) #no_context {
        AddRectFilledMultiColor(this, *p_min, *p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
    }
    AddQuad :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: ImU32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "?AddQuad@ImDrawList@@QEAAXAEBUImVec2@@000IM@Z";
    AddQuad :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: float = 1.0) #no_context {
        AddQuad(this, *p1, *p2, *p3, *p4, col, thickness);
    }
    AddQuadFilled :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "?AddQuadFilled@ImDrawList@@QEAAXAEBUImVec2@@000I@Z";
    AddQuadFilled :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32) #no_context {
        AddQuadFilled(this, *p1, *p2, *p3, *p4, col);
    }
    AddTriangle :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: ImU32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "?AddTriangle@ImDrawList@@QEAAXAEBUImVec2@@00IM@Z";
    AddTriangle :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: float = 1.0) #no_context {
        AddTriangle(this, *p1, *p2, *p3, col, thickness);
    }
    AddTriangleFilled :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "?AddTriangleFilled@ImDrawList@@QEAAXAEBUImVec2@@00I@Z";
    AddTriangleFilled :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32) #no_context {
        AddTriangleFilled(this, *p1, *p2, *p3, col);
    }
    AddCircle :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32 = 0, thickness: float = 1.0) -> void #cpp_method #foreign imgui "?AddCircle@ImDrawList@@QEAAXAEBUImVec2@@MIHM@Z";
    AddCircle :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32 = 0, thickness: float = 1.0) #no_context {
        AddCircle(this, *center, radius, col, num_segments, thickness);
    }
    AddCircleFilled :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "?AddCircleFilled@ImDrawList@@QEAAXAEBUImVec2@@MIH@Z";
    AddCircleFilled :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32 = 0) #no_context {
        AddCircleFilled(this, *center, radius, col, num_segments);
    }
    AddNgon :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32, thickness: float = 1.0) -> void #cpp_method #foreign imgui "?AddNgon@ImDrawList@@QEAAXAEBUImVec2@@MIHM@Z";
    AddNgon :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32, thickness: float = 1.0) #no_context {
        AddNgon(this, *center, radius, col, num_segments, thickness);
    }
    AddNgonFilled :: (this: *ImDrawList, center: *ImVec2, radius: float, col: ImU32, num_segments: s32) -> void #cpp_method #foreign imgui "?AddNgonFilled@ImDrawList@@QEAAXAEBUImVec2@@MIH@Z";
    AddNgonFilled :: (this: *ImDrawList, center: ImVec2, radius: float, col: ImU32, num_segments: s32) #no_context {
        AddNgonFilled(this, *center, radius, col, num_segments);
    }
    AddText :: (this: *ImDrawList, pos: *ImVec2, col: ImU32, text_begin: *u8, text_end: *u8 = null) -> void #cpp_method #foreign imgui "?AddText@ImDrawList@@QEAAXAEBUImVec2@@IPEBD1@Z";
    AddText :: (this: *ImDrawList, pos: ImVec2, col: ImU32, text: string) #no_context {
        AddText(this, *pos, col, text.data, text.data + text.count);
    }
    AddText :: (this: *ImDrawList, font: *ImFont, font_size: float, pos: *ImVec2, col: ImU32, text_begin: *u8, text_end: *u8 = null, wrap_width: float = 0.0, cpu_fine_clip_rect: *ImVec4 = null) -> void #cpp_method #foreign imgui "?AddText@ImDrawList@@QEAAXPEBUImFont@@MAEBUImVec2@@IPEBD2MPEBUImVec4@@@Z";
    AddText :: (this: *ImDrawList, font: *ImFont, font_size: float, pos: ImVec2, col: ImU32, text: string, wrap_width: float = 0.0, cpu_fine_clip_rect: *ImVec4 = null) #no_context {
        AddText(this, font, font_size, *pos, col, text.data, text.data + text.count, wrap_width, cpu_fine_clip_rect);
    }
    AddPolyline :: (this: *ImDrawList, points: *ImVec2, num_points: s32, col: ImU32, flags: ImDrawFlags, thickness: float) -> void #cpp_method #foreign imgui "?AddPolyline@ImDrawList@@QEAAXPEBUImVec2@@HIHM@Z";
    AddConvexPolyFilled :: (this: *ImDrawList, points: *ImVec2, num_points: s32, col: ImU32) -> void #cpp_method #foreign imgui "?AddConvexPolyFilled@ImDrawList@@QEAAXPEBUImVec2@@HI@Z";
    AddBezierCubic :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "?AddBezierCubic@ImDrawList@@QEAAXAEBUImVec2@@000IMH@Z";
    AddBezierCubic :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) #no_context {
        AddBezierCubic(this, *p1, *p2, *p3, *p4, col, thickness, num_segments);
    }
    AddBezierQuadratic :: (this: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "?AddBezierQuadratic@ImDrawList@@QEAAXAEBUImVec2@@00IMH@Z";
    AddBezierQuadratic :: (this: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: ImU32, thickness: float, num_segments: s32 = 0) #no_context {
        AddBezierQuadratic(this, *p1, *p2, *p3, col, thickness, num_segments);
    }

    // Image primitives
    // - Read FAQ to understand what ImTextureID is.
    // - "p_min" and "p_max" represent the upper-left and lower-right corners of the rectangle.
    // - "uv_min" and "uv_max" represent the normalized texture coordinates to use for those corners. Using (0,0)->(1,1) texture coordinates will generally display the entire texture.
    AddImage :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: *ImVec2, p_max: *ImVec2, uv_min: *ImVec2, uv_max: *ImVec2, col: ImU32 = 4294967295) -> void #cpp_method #foreign imgui "?AddImage@ImDrawList@@QEAAXPEAXAEBUImVec2@@111I@Z";
    AddImage :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2 = ImVec2.{0, 0}, uv_max: ImVec2 = ImVec2.{1, 1}, col: ImU32 = 4294967295) #no_context {
        AddImage(this, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col);
    }
    AddImageQuad :: (this: *ImDrawList, user_texture_id: ImTextureID, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, uv1: *ImVec2, uv2: *ImVec2, uv3: *ImVec2, uv4: *ImVec2, col: ImU32 = 4294967295) -> void #cpp_method #foreign imgui "?AddImageQuad@ImDrawList@@QEAAXPEAXAEBUImVec2@@1111111I@Z";
    AddImageQuad :: (this: *ImDrawList, user_texture_id: ImTextureID, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, uv1: ImVec2 = ImVec2.{0, 0}, uv2: ImVec2 = ImVec2.{1, 0}, uv3: ImVec2 = ImVec2.{1, 1}, uv4: ImVec2 = ImVec2.{0, 1}, col: ImU32 = 4294967295) #no_context {
        AddImageQuad(this, user_texture_id, *p1, *p2, *p3, *p4, *uv1, *uv2, *uv3, *uv4, col);
    }
    AddImageRounded :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: *ImVec2, p_max: *ImVec2, uv_min: *ImVec2, uv_max: *ImVec2, col: ImU32, rounding: float, flags: ImDrawFlags = .None) -> void #cpp_method #foreign imgui "?AddImageRounded@ImDrawList@@QEAAXPEAXAEBUImVec2@@111IMH@Z";
    AddImageRounded :: (this: *ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: ImU32, rounding: float, flags: ImDrawFlags = .None) #no_context {
        AddImageRounded(this, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col, rounding, flags);
    }

    PathArcTo :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "?PathArcTo@ImDrawList@@QEAAXAEBUImVec2@@MMMH@Z";
    PathArcTo :: (this: *ImDrawList, center: ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32 = 0) #no_context {
        PathArcTo(this, *center, radius, a_min, a_max, num_segments);
    }
    PathArcToFast :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min_of_12: s32, a_max_of_12: s32) -> void #cpp_method #foreign imgui "?PathArcToFast@ImDrawList@@QEAAXAEBUImVec2@@MHH@Z";
    PathArcToFast :: (this: *ImDrawList, center: ImVec2, radius: float, a_min_of_12: s32, a_max_of_12: s32) #no_context {
        PathArcToFast(this, *center, radius, a_min_of_12, a_max_of_12);
    }
    PathBezierCubicCurveTo :: (this: *ImDrawList, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "?PathBezierCubicCurveTo@ImDrawList@@QEAAXAEBUImVec2@@00H@Z";
    PathBezierCubicCurveTo :: (this: *ImDrawList, p2: ImVec2, p3: ImVec2, p4: ImVec2, num_segments: s32 = 0) #no_context {
        PathBezierCubicCurveTo(this, *p2, *p3, *p4, num_segments);
    }
    PathBezierQuadraticCurveTo :: (this: *ImDrawList, p2: *ImVec2, p3: *ImVec2, num_segments: s32 = 0) -> void #cpp_method #foreign imgui "?PathBezierQuadraticCurveTo@ImDrawList@@QEAAXAEBUImVec2@@0H@Z";
    PathBezierQuadraticCurveTo :: (this: *ImDrawList, p2: ImVec2, p3: ImVec2, num_segments: s32 = 0) #no_context {
        PathBezierQuadraticCurveTo(this, *p2, *p3, num_segments);
    }
    PathRect :: (this: *ImDrawList, rect_min: *ImVec2, rect_max: *ImVec2, rounding: float = 0.0, flags: ImDrawFlags = .None) -> void #cpp_method #foreign imgui "?PathRect@ImDrawList@@QEAAXAEBUImVec2@@0MH@Z";
    PathRect :: (this: *ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: float = 0.0, flags: ImDrawFlags = .None) #no_context {
        PathRect(this, *rect_min, *rect_max, rounding, flags);
    }

    // Advanced
    AddCallback :: (this: *ImDrawList, callback: ImDrawCallback, callback_data: *void) -> void #cpp_method #foreign imgui "?AddCallback@ImDrawList@@QEAAXP6AXPEBU1@PEBUImDrawCmd@@@ZPEAX@Z";
    AddDrawCmd :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?AddDrawCmd@ImDrawList@@QEAAXXZ";
    CloneOutput :: (this: *ImDrawList) -> *ImDrawList #cpp_method #foreign imgui "?CloneOutput@ImDrawList@@QEBAPEAU1@XZ";

    // Advanced: Primitives allocations
    // - We render triangles (three vertices)
    // - All primitives needs to be reserved via PrimReserve() beforehand.
    PrimReserve :: (this: *ImDrawList, idx_count: s32, vtx_count: s32) -> void #cpp_method #foreign imgui "?PrimReserve@ImDrawList@@QEAAXHH@Z";
    PrimUnreserve :: (this: *ImDrawList, idx_count: s32, vtx_count: s32) -> void #cpp_method #foreign imgui "?PrimUnreserve@ImDrawList@@QEAAXHH@Z";
    PrimRect :: (this: *ImDrawList, a: *ImVec2, b: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "?PrimRect@ImDrawList@@QEAAXAEBUImVec2@@0I@Z";
    PrimRect :: (this: *ImDrawList, a: ImVec2, b: ImVec2, col: ImU32) #no_context {
        PrimRect(this, *a, *b, col);
    }
    PrimRectUV :: (this: *ImDrawList, a: *ImVec2, b: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "?PrimRectUV@ImDrawList@@QEAAXAEBUImVec2@@000I@Z";
    PrimRectUV :: (this: *ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: ImU32) #no_context {
        PrimRectUV(this, *a, *b, *uv_a, *uv_b, col);
    }
    PrimQuadUV :: (this: *ImDrawList, a: *ImVec2, b: *ImVec2, c: *ImVec2, d: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, uv_c: *ImVec2, uv_d: *ImVec2, col: ImU32) -> void #cpp_method #foreign imgui "?PrimQuadUV@ImDrawList@@QEAAXAEBUImVec2@@0000000I@Z";
    PrimQuadUV :: (this: *ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: ImU32) #no_context {
        PrimQuadUV(this, *a, *b, *c, *d, *uv_a, *uv_b, *uv_c, *uv_d, col);
    }

    // [Internal helpers]
    _ResetForNewFrame :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_ResetForNewFrame@ImDrawList@@QEAAXXZ";
    _ClearFreeMemory :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_ClearFreeMemory@ImDrawList@@QEAAXXZ";
    _PopUnusedDrawCmd :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_PopUnusedDrawCmd@ImDrawList@@QEAAXXZ";
    _TryMergeDrawCmds :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_TryMergeDrawCmds@ImDrawList@@QEAAXXZ";
    _OnChangedClipRect :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_OnChangedClipRect@ImDrawList@@QEAAXXZ";
    _OnChangedTextureID :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_OnChangedTextureID@ImDrawList@@QEAAXXZ";
    _OnChangedVtxOffset :: (this: *ImDrawList) -> void #cpp_method #foreign imgui "?_OnChangedVtxOffset@ImDrawList@@QEAAXXZ";
    _CalcCircleAutoSegmentCount :: (this: *ImDrawList, radius: float) -> s32 #cpp_method #foreign imgui "?_CalcCircleAutoSegmentCount@ImDrawList@@QEBAHM@Z";
    _PathArcToFastEx :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min_sample: s32, a_max_sample: s32, a_step: s32) -> void #cpp_method #foreign imgui "?_PathArcToFastEx@ImDrawList@@QEAAXAEBUImVec2@@MHHH@Z";
    _PathArcToFastEx :: (this: *ImDrawList, center: ImVec2, radius: float, a_min_sample: s32, a_max_sample: s32, a_step: s32) #no_context {
        _PathArcToFastEx(this, *center, radius, a_min_sample, a_max_sample, a_step);
    }
    _PathArcToN :: (this: *ImDrawList, center: *ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32) -> void #cpp_method #foreign imgui "?_PathArcToN@ImDrawList@@QEAAXAEBUImVec2@@MMMH@Z";
    _PathArcToN :: (this: *ImDrawList, center: ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32) #no_context {
        _PathArcToN(this, *center, radius, a_min, a_max, num_segments);
    }
}

// All draw data to render a Dear ImGui frame
// (NB: the style and the naming convention here is a little inconsistent, we currently preserve them for backward compatibility purpose,
// as this is one of the oldest structure exposed by the library! Basically, ImDrawList == CmdList)
ImDrawData :: struct {
    Valid:            bool; // Only valid after Render() is called and before the next NewFrame() is called.
    CmdListsCount:    s32; // Number of ImDrawList* to render
    TotalIdxCount:    s32; // For convenience, sum of all ImDrawList's IdxBuffer.Size
    TotalVtxCount:    s32; // For convenience, sum of all ImDrawList's VtxBuffer.Size
    CmdLists:         **ImDrawList; // Array of ImDrawList* to render. The ImDrawList are owned by ImGuiContext and only pointed to from here.
    DisplayPos:       ImVec2; // Top-left position of the viewport to render (== top-left of the orthogonal projection matrix to use) (== GetMainViewport()->Pos for the main viewport, == (0.0) in most single-viewport applications)
    DisplaySize:      ImVec2; // Size of the viewport to render (== GetMainViewport()->Size for the main viewport, == io.DisplaySize in most single-viewport applications)
    FramebufferScale: ImVec2; // Amount of pixels for each unit of DisplaySize. Based on io.DisplayFramebufferScale. Generally (1,1) on normal display, (2,2) on OSX with Retina display.
    OwnerViewport:    *Viewport; // Viewport carrying the ImDrawData instance, might be of use to the renderer (generally not).

    DeIndexAllBuffers :: (this: *ImDrawData) -> void #cpp_method #foreign imgui "?DeIndexAllBuffers@ImDrawData@@QEAAXXZ";
    ScaleClipRects :: (this: *ImDrawData, fb_scale: *ImVec2) -> void #cpp_method #foreign imgui "?ScaleClipRects@ImDrawData@@QEAAXAEBUImVec2@@@Z";
    ScaleClipRects :: (this: *ImDrawData, fb_scale: ImVec2) #no_context {
        ScaleClipRects(this, *fb_scale);
    }
}

//-----------------------------------------------------------------------------
// [SECTION] Font API (ImFontConfig, ImFontGlyph, ImFontAtlasFlags, ImFontAtlas, ImFontGlyphRangesBuilder, ImFont)
//-----------------------------------------------------------------------------
ImFontConfig :: struct {
    FontData:             *void; //          // TTF/OTF data
    FontDataSize:         s32; //          // TTF/OTF data size
    FontDataOwnedByAtlas: bool; // true     // TTF/OTF data ownership taken by the container ImFontAtlas (will delete memory itself).
    FontNo:               s32; // 0        // Index of font within TTF/OTF file
    SizePixels:           float; //          // Size in pixels for rasterizer (more or less maps to the resulting font height).
    OversampleH:          s32; // 3        // Rasterize at higher quality for sub-pixel positioning. Note the difference between 2 and 3 is minimal so you can reduce this to 2 to save memory. Read https://github.com/nothings/stb/blob/master/tests/oversample/README.md for details.
    OversampleV:          s32; // 1        // Rasterize at higher quality for sub-pixel positioning. This is not really useful as we don't use sub-pixel positions on the Y axis.
    PixelSnapH:           bool; // false    // Align every glyph to pixel boundary. Useful e.g. if you are merging a non-pixel aligned font with the default font. If enabled, you can set OversampleH/V to 1.
    GlyphExtraSpacing:    ImVec2; // 0, 0     // Extra spacing (in pixels) between glyphs. Only X axis is supported for now.
    GlyphOffset:          ImVec2; // 0, 0     // Offset all glyphs from this font input.
    GlyphRanges:          *ImWchar; // NULL     // Pointer to a user-provided list of Unicode range (2 value per range, values are inclusive, zero-terminated list). THE ARRAY DATA NEEDS TO PERSIST AS LONG AS THE FONT IS ALIVE.
    GlyphMinAdvanceX:     float; // 0        // Minimum AdvanceX for glyphs, set Min to align font icons, set both Min/Max to enforce mono-space font
    GlyphMaxAdvanceX:     float; // FLT_MAX  // Maximum AdvanceX for glyphs
    MergeMode:            bool; // false    // Merge into previous ImFont, so you can combine multiple inputs font into one ImFont (e.g. ASCII font + icons + Japanese glyphs). You may want to use GlyphOffset.y when merge font of different heights.
    FontBuilderFlags:     u32; // 0        // Settings for custom font builder. THIS IS BUILDER IMPLEMENTATION DEPENDENT. Leave as zero if unsure.
    RasterizerMultiply:   float; // 1.0f     // Brighten (>1.0f) or darken (<1.0f) font output. Brightening small fonts may be a good workaround to make them more readable.
    EllipsisChar:         ImWchar; // -1       // Explicitly specify unicode codepoint of ellipsis character. When fonts are being merged first specified ellipsis will be used.

    Name:                 [40] u8; // Name (strictly to ease debugging)
    DstFont:              *ImFont;

    Constructor :: (this: *ImFontConfig) -> void #cpp_method #foreign imgui "??0ImFontConfig@@QEAA@XZ";
}

// Hold rendering data for one glyph.
// (Note: some language parsers may fail to convert the 31+1 bitfield members, in this case maybe drop store a single u32 or we can rework this)
ImFontGlyph :: struct {
    Colored:   u32; // Flag to indicate glyph is colored and should generally ignore tinting (make it usable with no shift on little-endian as this is used in loops)
    #place Colored; /*bitfield 1*/ Visible:   u32; // Flag to indicate glyph has no visible pixels (e.g. space). Allow early out when rendering.
    #place Colored; /*bitfield 2*/ Codepoint: u32; // 0x0000..0x10FFFF
    AdvanceX:  float; // Distance to next character (= data from font + ImFontConfig::GlyphExtraSpacing.x baked in)
    X0:        float; // Glyph corners
    Y0:        float; // Glyph corners
    X1:        float; // Glyph corners
    Y1:        float; // Glyph corners
    U0:        float; // Texture coordinates
    V0:        float; // Texture coordinates
    U1:        float; // Texture coordinates
    V1:        float; // Texture coordinates
}

// Helper to build glyph ranges from text/string data. Feed your application strings/characters to it then call BuildRanges().
// This is essentially a tightly packed of vector of 64k booleans = 8KB storage.
ImFontGlyphRangesBuilder :: struct {
    UsedChars: ImVector(ImU32); // Store 1-bit per Unicode code point (0=unused, 1=used)

    AddText :: (this: *ImFontGlyphRangesBuilder, text: *u8, text_end: *u8 = null) -> void #cpp_method #foreign imgui "?AddText@ImFontGlyphRangesBuilder@@QEAAXPEBD0@Z";
    AddText :: (this: *ImFontGlyphRangesBuilder, text: string) #no_context {
        AddText(this, text.data, text.data + text.count);
    }
    AddRanges :: (this: *ImFontGlyphRangesBuilder, ranges: *ImWchar) -> void #cpp_method #foreign imgui "?AddRanges@ImFontGlyphRangesBuilder@@QEAAXPEBG@Z";
    BuildRanges :: (this: *ImFontGlyphRangesBuilder, out_ranges: *ImVector(ImWchar)) -> void #cpp_method #foreign imgui "?BuildRanges@ImFontGlyphRangesBuilder@@QEAAXPEAU?$ImVector@G@@@Z";
}

// See ImFontAtlas::AddCustomRectXXX functions.
ImFontAtlasCustomRect :: struct {
    Width:         u16; // Input    // Desired rectangle dimension
    Height:        u16; // Input    // Desired rectangle dimension
    X:             u16; // Output   // Packed position in Atlas
    Y:             u16; // Output   // Packed position in Atlas
    GlyphID:       u32; // Input    // For custom font glyphs only (ID < 0x110000)
    GlyphAdvanceX: float; // Input    // For custom font glyphs only: glyph xadvance
    GlyphOffset:   ImVec2; // Input    // For custom font glyphs only: glyph display offset
    Font:          *ImFont; // Input    // For custom font glyphs only: target font
}

// Flags for ImFontAtlas build
ImFontAtlasFlags :: enum_flags s32 {
    None               :: 0x0;
    NoPowerOfTwoHeight :: 0x1;
    NoMouseCursors     :: 0x2;
    NoBakedLines       :: 0x4;

    ImFontAtlasFlags_None               :: None;
    ImFontAtlasFlags_NoPowerOfTwoHeight :: NoPowerOfTwoHeight;
    ImFontAtlasFlags_NoMouseCursors     :: NoMouseCursors;
    ImFontAtlasFlags_NoBakedLines       :: NoBakedLines;
}

// Load and rasterize multiple TTF/OTF fonts into a same texture. The font atlas will build a single texture holding:
//  - One or more fonts.
//  - Custom graphics data needed to render the shapes needed by Dear ImGui.
//  - Mouse cursor shapes for software cursor rendering (unless setting 'Flags |= ImFontAtlasFlags_NoMouseCursors' in the font atlas).
// It is the user-code responsibility to setup/build the atlas, then upload the pixel data into a texture accessible by your graphics api.
//  - Optionally, call any of the AddFont*** functions. If you don't call any, the default font embedded in the code will be loaded for you.
//  - Call GetTexDataAsAlpha8() or GetTexDataAsRGBA32() to build and retrieve pixels data.
//  - Upload the pixels data into a texture within your graphics system (see imgui_impl_xxxx.cpp examples)
//  - Call SetTexID(my_tex_id); and pass the pointer/identifier to your texture in a format natural to your graphics API.
//    This value will be passed back to you during rendering to identify the texture. Read FAQ entry about ImTextureID for more details.
// Common pitfalls:
// - If you pass a 'glyph_ranges' array to AddFont*** functions, you need to make sure that your array persist up until the
//   atlas is build (when calling GetTexData*** or Build()). We only copy the pointer, not the data.
// - Important: By default, AddFontFromMemoryTTF() takes ownership of the data. Even though we are not writing to it, we will free the pointer on destruction.
//   You can set font_cfg->FontDataOwnedByAtlas=false to keep ownership of your data and it won't be freed,
// - Even though many functions are suffixed with "TTF", OTF data is supported just as well.
// - This is an old API and it is currently awkward for those and and various other reasons! We will address them in the future!
ImFontAtlas :: struct {
    Constructor :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "??0ImFontAtlas@@QEAA@XZ";
    Destructor :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "??1ImFontAtlas@@QEAA@XZ";
    AddFont :: (this: *ImFontAtlas, font_cfg: *ImFontConfig) -> *ImFont #cpp_method #foreign imgui "?AddFont@ImFontAtlas@@QEAAPEAUImFont@@PEBUImFontConfig@@@Z";
    AddFontDefault :: (this: *ImFontAtlas, font_cfg: *ImFontConfig = null) -> *ImFont #cpp_method #foreign imgui "?AddFontDefault@ImFontAtlas@@QEAAPEAUImFont@@PEBUImFontConfig@@@Z";
    AddFontFromFileTTF :: (this: *ImFontAtlas, filename: *u8, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "?AddFontFromFileTTF@ImFontAtlas@@QEAAPEAUImFont@@PEBDMPEBUImFontConfig@@PEBG@Z";
    AddFontFromMemoryTTF :: (this: *ImFontAtlas, font_data: *void, font_size: s32, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "?AddFontFromMemoryTTF@ImFontAtlas@@QEAAPEAUImFont@@PEAXHMPEBUImFontConfig@@PEBG@Z";
    AddFontFromMemoryCompressedTTF :: (this: *ImFontAtlas, compressed_font_data: *void, compressed_font_size: s32, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "?AddFontFromMemoryCompressedTTF@ImFontAtlas@@QEAAPEAUImFont@@PEBXHMPEBUImFontConfig@@PEBG@Z";
    AddFontFromMemoryCompressedBase85TTF :: (this: *ImFontAtlas, compressed_font_data_base85: *u8, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #cpp_method #foreign imgui "?AddFontFromMemoryCompressedBase85TTF@ImFontAtlas@@QEAAPEAUImFont@@PEBDMPEBUImFontConfig@@PEBG@Z";
    ClearInputData :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "?ClearInputData@ImFontAtlas@@QEAAXXZ";
    ClearTexData :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "?ClearTexData@ImFontAtlas@@QEAAXXZ";
    ClearFonts :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "?ClearFonts@ImFontAtlas@@QEAAXXZ";
    Clear :: (this: *ImFontAtlas) -> void #cpp_method #foreign imgui "?Clear@ImFontAtlas@@QEAAXXZ";

    // Build atlas, retrieve pixel data.
    // User is in charge of copying the pixels into graphics memory (e.g. create a texture with your engine). Then store your texture handle with SetTexID().
    // The pitch is always = Width * BytesPerPixels (1 or 4)
    // Building in RGBA32 format is provided for convenience and compatibility, but note that unless you manually manipulate or copy color data into
    // the texture (e.g. when using the AddCustomRect*** api), then the RGB pixels emitted will always be white (~75% of memory/bandwidth waste.
    Build :: (this: *ImFontAtlas) -> bool #cpp_method #foreign imgui "?Build@ImFontAtlas@@QEAA_NXZ";
    GetTexDataAsAlpha8 :: (this: *ImFontAtlas, out_pixels: **u8, out_width: *s32, out_height: *s32, out_bytes_per_pixel: *s32 = null) -> void #cpp_method #foreign imgui "?GetTexDataAsAlpha8@ImFontAtlas@@QEAAXPEAPEAEPEAH11@Z";
    GetTexDataAsRGBA32 :: (this: *ImFontAtlas, out_pixels: **u8, out_width: *s32, out_height: *s32, out_bytes_per_pixel: *s32 = null) -> void #cpp_method #foreign imgui "?GetTexDataAsRGBA32@ImFontAtlas@@QEAAXPEAPEAEPEAH11@Z";

    // Helpers to retrieve list of common Unicode ranges (2 value per range, values are inclusive, zero-terminated list)
    // NB: Make sure that your string are UTF-8 and NOT in your local code page. In C++11, you can create UTF-8 string literal using the u8"Hello world" syntax. See FAQ for details.
    // NB: Consider using ImFontGlyphRangesBuilder to build glyph ranges from textual data.
    GetGlyphRangesDefault :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesDefault@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesKorean :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesKorean@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesJapanese :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesJapanese@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesChineseFull :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesChineseFull@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesChineseSimplifiedCommon :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesChineseSimplifiedCommon@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesCyrillic :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesCyrillic@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesThai :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesThai@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesVietnamese :: (this: *ImFontAtlas) -> *ImWchar #cpp_method #foreign imgui "?GetGlyphRangesVietnamese@ImFontAtlas@@QEAAPEBGXZ";

    // You can request arbitrary rectangles to be packed into the atlas, for your own purposes.
    // - After calling Build(), you can query the rectangle position and render your pixels.
    // - If you render colored output, set 'atlas->TexPixelsUseColors = true' as this may help some backends decide of prefered texture format.
    // - You can also request your rectangles to be mapped as font glyph (given a font + Unicode point),
    //   so you can render e.g. custom colorful icons and use them as regular glyphs.
    // - Read docs/FONTS.md for more details about using colorful icons.
    // - Note: this API may be redesigned later in order to support multi-monitor varying DPI settings.
    AddCustomRectRegular :: (this: *ImFontAtlas, width: s32, height: s32) -> s32 #cpp_method #foreign imgui "?AddCustomRectRegular@ImFontAtlas@@QEAAHHH@Z";
    AddCustomRectFontGlyph :: (this: *ImFontAtlas, font: *ImFont, id: ImWchar, width: s32, height: s32, advance_x: float, offset: *ImVec2) -> s32 #cpp_method #foreign imgui "?AddCustomRectFontGlyph@ImFontAtlas@@QEAAHPEAUImFont@@GHHMAEBUImVec2@@@Z";
    AddCustomRectFontGlyph :: (this: *ImFontAtlas, font: *ImFont, id: ImWchar, width: s32, height: s32, advance_x: float, offset: ImVec2 = ImVec2.{0, 0}) -> s32 #no_context {
        return AddCustomRectFontGlyph(this, font, id, width, height, advance_x, *offset);
    }

    // [Internal]
    CalcCustomRectUV :: (this: *ImFontAtlas, rect: *ImFontAtlasCustomRect, out_uv_min: *ImVec2, out_uv_max: *ImVec2) -> void #cpp_method #foreign imgui "?CalcCustomRectUV@ImFontAtlas@@QEBAXPEBUImFontAtlasCustomRect@@PEAUImVec2@@1@Z";
    GetMouseCursorTexData :: (this: *ImFontAtlas, cursor: MouseCursor, out_offset: *ImVec2, out_size: *ImVec2, out_uv_border: *[2] ImVec2, out_uv_fill: *[2] ImVec2) -> bool #cpp_method #foreign imgui "?GetMouseCursorTexData@ImFontAtlas@@QEAA_NHPEAUImVec2@@0QEAU2@1@Z";

    Flags:              ImFontAtlasFlags; // Build flags (see ImFontAtlasFlags_)
    TexID:              ImTextureID; // User data to refer to the texture once it has been uploaded to user's graphic systems. It is passed back to you during rendering via the ImDrawCmd structure.
    TexDesiredWidth:    s32; // Texture width desired by user before Build(). Must be a power-of-two. If have many glyphs your graphics API have texture size restrictions you may want to increase texture width to decrease height.
    TexGlyphPadding:    s32; // Padding between glyphs within texture in pixels. Defaults to 1. If your rendering method doesn't rely on bilinear filtering you may set this to 0 (will also need to set AntiAliasedLinesUseTex = false).
    Locked:             bool; // Marked as Locked by ImGui::NewFrame() so attempt to modify the atlas will assert.

    TexReady:           bool; // Set when texture was built matching current font input
    TexPixelsUseColors: bool; // Tell whether our texture data is known to use colors (rather than just alpha channel), in order to help backend select a format.
    TexPixelsAlpha8:    *u8; // 1 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight
    TexPixelsRGBA32:    *u32; // 4 component per pixel, each component is unsigned 8-bit. Total size = TexWidth * TexHeight * 4
    TexWidth:           s32; // Texture width calculated during Build().
    TexHeight:          s32; // Texture height calculated during Build().
    TexUvScale:         ImVec2; // = (1.0f/TexWidth, 1.0f/TexHeight)
    TexUvWhitePixel:    ImVec2; // Texture coordinates to a white pixel
    Fonts:              ImVector(*ImFont); // Hold all the fonts returned by AddFont*. Fonts[0] is the default font upon calling ImGui::NewFrame(), use ImGui::PushFont()/PopFont() to change the current font.
    CustomRects:        ImVector(ImFontAtlasCustomRect); // Rectangles for packing custom texture data into the atlas.
    ConfigData:         ImVector(ImFontConfig); // Configuration data
    TexUvLines:         [64] ImVec4; // UVs for baked anti-aliased lines

    FontBuilderIO:      *ImFontBuilderIO; // Opaque interface to a font builder (default to stb_truetype, can be changed to use FreeType by defining IMGUI_ENABLE_FREETYPE).
    FontBuilderFlags:   u32; // Shared flags (for all fonts) for custom font builder. THIS IS BUILD IMPLEMENTATION DEPENDENT. Per-font override is also available in ImFontConfig.

    PackIdMouseCursors: s32; // Custom texture rectangle ID for white pixel and mouse cursors
    PackIdLines:        s32; // Custom texture rectangle ID for baked anti-aliased lines
}

// Font runtime data and rendering
// ImFontAtlas automatically loads a default embedded font for you when you call GetTexDataAsAlpha8() or GetTexDataAsRGBA32().
ImFont :: struct {
    IndexAdvanceX:       ImVector(float); // 12-16 // out //            // Sparse. Glyphs->AdvanceX in a directly indexable way (cache-friendly for CalcTextSize functions which only this this info, and are often bottleneck in large UI).
    FallbackAdvanceX:    float; // 4     // out // = FallbackGlyph->AdvanceX
    FontSize:            float; // 4     // in  //            // Height of characters/line, set during loading (don't change after loading)

    IndexLookup:         ImVector(ImWchar); // 12-16 // out //            // Sparse. Index glyphs by Unicode code-point.
    Glyphs:              ImVector(ImFontGlyph); // 12-16 // out //            // All glyphs.
    FallbackGlyph:       *ImFontGlyph; // 4-8   // out // = FindGlyph(FontFallbackChar)

    ContainerAtlas:      *ImFontAtlas; // 4-8   // out //            // What we has been loaded into
    ConfigData:          *ImFontConfig; // 4-8   // in  //            // Pointer within ContainerAtlas->ConfigData
    ConfigDataCount:     s16; // 2     // in  // ~ 1        // Number of ImFontConfig involved in creating this font. Bigger than 1 when merging multiple font sources into one ImFont.
    FallbackChar:        ImWchar; // 2     // out // = FFFD/'?' // Character used if a glyph isn't found.
    EllipsisChar:        ImWchar; // 2     // out // = '...'    // Character used for ellipsis rendering.
    DotChar:             ImWchar; // 2     // out // = '.'      // Character used for ellipsis rendering (if a single '...' character isn't found)
    DirtyLookupTables:   bool; // 1     // out //
    Scale:               float; // 4     // in  // = 1.f      // Base font scale, multiplied by the per-window font scale which you can adjust with SetWindowFontScale()
    Ascent:              float; // 4+4   // out //            // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
    Descent:             float; // 4+4   // out //            // Ascent: distance from top to bottom of e.g. 'A' [0..FontSize]
    MetricsTotalSurface: s32; // 4     // out //            // Total surface in pixels to get an idea of the font rasterization/texture cost (not exact, we approximate the cost of padding between glyphs)
    Used4kPagesMap:      [2] ImU8; // 2 bytes if ImWchar=ImWchar16, 34 bytes if ImWchar==ImWchar32. Store 1-bit for each block of 4K codepoints that has one active glyph. This is mainly used to facilitate iterations across all used codepoints.

    // Methods
    Constructor :: (this: *ImFont) -> void #cpp_method #foreign imgui "??0ImFont@@QEAA@XZ";
    Destructor :: (this: *ImFont) -> void #cpp_method #foreign imgui "??1ImFont@@QEAA@XZ";
    FindGlyph :: (this: *ImFont, c: ImWchar) -> *ImFontGlyph #cpp_method #foreign imgui "?FindGlyph@ImFont@@QEBAPEBUImFontGlyph@@G@Z";
    FindGlyphNoFallback :: (this: *ImFont, c: ImWchar) -> *ImFontGlyph #cpp_method #foreign imgui "?FindGlyphNoFallback@ImFont@@QEBAPEBUImFontGlyph@@G@Z";

    // 'max_width' stops rendering after a certain width (could be turned into a 2d size). FLT_MAX to disable.
    // 'wrap_width' enable automatic word-wrapping across multiple lines to fit into given width. 0.0f to disable.
    CalcTextSizeA :: (this: *ImFont, size: float, max_width: float, wrap_width: float, text_begin: *u8, text_end: *u8 = null, remaining: **u8 = null) -> ImVec2 #cpp_method #cpp_return_type_is_non_pod #foreign imgui "?CalcTextSizeA@ImFont@@QEBA?AUImVec2@@MMMPEBD0PEAPEBD@Z";
    CalcTextSizeA :: (this: *ImFont, size: float, max_width: float, wrap_width: float, text: string, remaining: **u8 = null) -> ImVec2 #no_context {
        return CalcTextSizeA(this, size, max_width, wrap_width, text.data, text.data + text.count, remaining);
    }
    CalcWordWrapPositionA :: (this: *ImFont, scale: float, text: *u8, text_end: *u8, wrap_width: float) -> *u8 #cpp_method #foreign imgui "?CalcWordWrapPositionA@ImFont@@QEBAPEBDMPEBD0M@Z";
    CalcWordWrapPositionA :: (this: *ImFont, scale: float, text: string, wrap_width: float) -> *u8 #no_context {
        return CalcWordWrapPositionA(this, scale, text.data, text.data + text.count, wrap_width);
    }
    RenderChar :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: *ImVec2, col: ImU32, c: ImWchar) -> void #cpp_method #foreign imgui "?RenderChar@ImFont@@QEBAXPEAUImDrawList@@MAEBUImVec2@@IG@Z";
    RenderChar :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: ImU32, c: ImWchar) #no_context {
        RenderChar(this, draw_list, size, *pos, col, c);
    }
    RenderText :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: *ImVec2, col: ImU32, clip_rect: *ImVec4, text_begin: *u8, text_end: *u8, wrap_width: float = 0.0, cpu_fine_clip := false) -> void #cpp_method #foreign imgui "?RenderText@ImFont@@QEBAXPEAUImDrawList@@MAEBUImVec2@@IAEBUImVec4@@PEBD3M_N@Z";
    RenderText :: (this: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: ImU32, clip_rect: ImVec4, text: string, wrap_width: float = 0.0, cpu_fine_clip := false) #no_context {
        RenderText(this, draw_list, size, *pos, col, *clip_rect, text.data, text.data + text.count, wrap_width, cpu_fine_clip);
    }

    // [Internal] Don't use!
    BuildLookupTable :: (this: *ImFont) -> void #cpp_method #foreign imgui "?BuildLookupTable@ImFont@@QEAAXXZ";
    ClearOutputData :: (this: *ImFont) -> void #cpp_method #foreign imgui "?ClearOutputData@ImFont@@QEAAXXZ";
    GrowIndex :: (this: *ImFont, new_size: s32) -> void #cpp_method #foreign imgui "?GrowIndex@ImFont@@QEAAXH@Z";
    AddGlyph :: (this: *ImFont, src_cfg: *ImFontConfig, c: ImWchar, x0: float, y0: float, x1: float, y1: float, u0: float, v0: float, u1: float, v1: float, advance_x: float) -> void #cpp_method #foreign imgui "?AddGlyph@ImFont@@QEAAXPEBUImFontConfig@@GMMMMMMMMM@Z";
    AddRemapChar :: (this: *ImFont, dst: ImWchar, src: ImWchar, overwrite_dst := true) -> void #cpp_method #foreign imgui "?AddRemapChar@ImFont@@QEAAXGG_N@Z";
    SetGlyphVisible :: (this: *ImFont, c: ImWchar, visible: bool) -> void #cpp_method #foreign imgui "?SetGlyphVisible@ImFont@@QEAAXG_N@Z";
    IsGlyphRangeUnused :: (this: *ImFont, c_begin: u32, c_last: u32) -> bool #cpp_method #foreign imgui "?IsGlyphRangeUnused@ImFont@@QEAA_NII@Z";
}

// Flags stored in ImGuiViewport::Flags, giving indications to the platform backends.
ViewportFlags :: enum_flags s32 {
    None                :: 0x0;
    IsPlatformWindow    :: 0x1;
    IsPlatformMonitor   :: 0x2;
    OwnedByApp          :: 0x4;
    NoDecoration        :: 0x8;
    NoTaskBarIcon       :: 0x10;
    NoFocusOnAppearing  :: 0x20;
    NoFocusOnClick      :: 0x40;
    NoInputs            :: 0x80;
    NoRendererClear     :: 0x100;
    TopMost             :: 0x200;
    Minimized           :: 0x400;
    NoAutoMerge         :: 0x800;
    CanHostOtherWindows :: 0x1000;

    ImGuiViewportFlags_None                :: None;
    ImGuiViewportFlags_IsPlatformWindow    :: IsPlatformWindow;
    ImGuiViewportFlags_IsPlatformMonitor   :: IsPlatformMonitor;
    ImGuiViewportFlags_OwnedByApp          :: OwnedByApp;
    ImGuiViewportFlags_NoDecoration        :: NoDecoration;
    ImGuiViewportFlags_NoTaskBarIcon       :: NoTaskBarIcon;
    ImGuiViewportFlags_NoFocusOnAppearing  :: NoFocusOnAppearing;
    ImGuiViewportFlags_NoFocusOnClick      :: NoFocusOnClick;
    ImGuiViewportFlags_NoInputs            :: NoInputs;
    ImGuiViewportFlags_NoRendererClear     :: NoRendererClear;
    ImGuiViewportFlags_TopMost             :: TopMost;
    ImGuiViewportFlags_Minimized           :: Minimized;
    ImGuiViewportFlags_NoAutoMerge         :: NoAutoMerge;
    ImGuiViewportFlags_CanHostOtherWindows :: CanHostOtherWindows;
}

// - Currently represents the Platform Window created by the application which is hosting our Dear ImGui windows.
// - With multi-viewport enabled, we extend this concept to have multiple active viewports.
// - In the future we will extend this concept further to also represent Platform Monitor and support a "no main platform window" operation mode.
// - About Main Area vs Work Area:
//   - Main Area = entire viewport.
//   - Work Area = entire viewport minus sections used by main menu bars (for platform windows), or by task bar (for platform monitor).
//   - Windows are generally trying to stay within the Work Area of their host viewport.
Viewport :: struct {
    ID_:                   ID; // Unique identifier for the viewport
    Flags:                 ViewportFlags; // See ImGuiViewportFlags_
    Pos:                   ImVec2; // Main Area: Position of the viewport (Dear ImGui coordinates are the same as OS desktop/native coordinates)
    Size:                  ImVec2; // Main Area: Size of the viewport.
    WorkPos:               ImVec2; // Work Area: Position of the viewport minus task bars, menus bars, status bars (>= Pos)
    WorkSize:              ImVec2; // Work Area: Size of the viewport minus task bars, menu bars, status bars (<= Size)
    DpiScale:              float; // 1.0f = 96 DPI = No extra scale.
    ParentViewportId:      ID; // (Advanced) 0: no parent. Instruct the platform backend to setup a parent/child relationship between platform windows.
    DrawData:              *ImDrawData; // The ImDrawData corresponding to this viewport. Valid after Render() and until the next call to NewFrame().

    RendererUserData:      *void; // void* to hold custom data structure for the renderer (e.g. swap chain, framebuffers etc.). generally set by your Renderer_CreateWindow function.
    PlatformUserData:      *void; // void* to hold custom data structure for the OS / platform (e.g. windowing info, render context). generally set by your Platform_CreateWindow function.
    PlatformHandle:        *void; // void* for FindViewportByPlatformHandle(). (e.g. suggested to use natural platform handle such as HWND, GLFWWindow*, SDL_Window*)
    PlatformHandleRaw:     *void; // void* to hold lower-level, platform-native window handle (under Win32 this is expected to be a HWND, unused for other platforms), when using an abstraction layer like GLFW or SDL (where PlatformHandle would be a SDL_Window*)
    PlatformRequestMove:   bool; // Platform window requested move (e.g. window was moved by the OS / host window manager, authoritative position will be OS window position)
    PlatformRequestResize: bool; // Platform window requested resize (e.g. window was resized by the OS / host window manager, authoritative size will be OS window size)
    PlatformRequestClose:  bool; // Platform window requested closure (e.g. window was moved by the OS / host window manager, e.g. pressing ALT-F4)
}

// (Optional) Access via ImGui::GetPlatformIO()
PlatformIO :: struct {
    Platform_CreateWindow:       #type (vp: *Viewport) -> void #c_call; // . . U . .  // Create a new platform window for the given viewport
    Platform_DestroyWindow:      #type (vp: *Viewport) -> void #c_call; // N . U . D  //
    Platform_ShowWindow:         #type (vp: *Viewport) -> void #c_call; // . . U . .  // Newly created windows are initially hidden so SetWindowPos/Size/Title can be called on them before showing the window
    Platform_SetWindowPos:       #type (vp: *Viewport, pos: ImVec2) -> void #c_call; // . . U . .  // Set platform window position (given the upper-left corner of client area)
    Platform_GetWindowPos:       #type (vp: *Viewport) -> ImVec2 #c_call #cpp_return_type_is_non_pod; // N . . . .  //
    Platform_SetWindowSize:      #type (vp: *Viewport, size: ImVec2) -> void #c_call; // . . U . .  // Set platform window client area size (ignoring OS decorations such as OS title bar etc.)
    Platform_GetWindowSize:      #type (vp: *Viewport) -> ImVec2 #c_call #cpp_return_type_is_non_pod; // N . . . .  // Get platform window client area size
    Platform_SetWindowFocus:     #type (vp: *Viewport) -> void #c_call; // N . . . .  // Move window to front and set input focus
    Platform_GetWindowFocus:     #type (vp: *Viewport) -> bool #c_call; // . . U . .  //
    Platform_GetWindowMinimized: #type (vp: *Viewport) -> bool #c_call; // N . . . .  // Get platform window minimized state. When minimized, we generally won't attempt to get/set size and contents will be culled more easily
    Platform_SetWindowTitle:     #type (vp: *Viewport, str: *u8) -> void #c_call; // . . U . .  // Set platform window title (given an UTF-8 string)
    Platform_SetWindowAlpha:     #type (vp: *Viewport, alpha: float) -> void #c_call; // . . U . .  // (Optional) Setup global transparency (not per-pixel transparency)
    Platform_UpdateWindow:       #type (vp: *Viewport) -> void #c_call; // . . U . .  // (Optional) Called by UpdatePlatformWindows(). Optional hook to allow the platform backend from doing general book-keeping every frame.
    Platform_RenderWindow:       #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Main rendering (platform side! This is often unused, or just setting a "current" context for OpenGL bindings). 'render_arg' is the value passed to RenderPlatformWindowsDefault().
    Platform_SwapBuffers:        #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Call Present/SwapBuffers (platform side! This is often unused!). 'render_arg' is the value passed to RenderPlatformWindowsDefault().
    Platform_GetWindowDpiScale:  #type (vp: *Viewport) -> float #c_call; // N . . . .  // (Optional) [BETA] FIXME-DPI: DPI handling: Return DPI scale for this viewport. 1.0f = 96 DPI.
    Platform_OnChangedViewport:  #type (vp: *Viewport) -> void #c_call; // . F . . .  // (Optional) [BETA] FIXME-DPI: DPI handling: Called during Begin() every time the viewport we are outputting into changes, so backend has a chance to swap fonts to adjust style.
    Platform_CreateVkSurface:    #type (vp: *Viewport, vk_inst: ImU64, vk_allocators: *void, out_vk_surface: *ImU64) -> s32 #c_call; // (Optional) For a Vulkan Renderer to call into Platform code (since the surface creation needs to tie them both).

    Renderer_CreateWindow:       #type (vp: *Viewport) -> void #c_call; // . . U . .  // Create swap chain, frame buffers etc. (called after Platform_CreateWindow)
    Renderer_DestroyWindow:      #type (vp: *Viewport) -> void #c_call; // N . U . D  // Destroy swap chain, frame buffers etc. (called before Platform_DestroyWindow)
    Renderer_SetWindowSize:      #type (vp: *Viewport, size: ImVec2) -> void #c_call; // . . U . .  // Resize swap chain, frame buffers etc. (called after Platform_SetWindowSize)
    Renderer_RenderWindow:       #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Clear framebuffer, setup render target, then render the viewport->DrawData. 'render_arg' is the value passed to RenderPlatformWindowsDefault().
    Renderer_SwapBuffers:        #type (vp: *Viewport, render_arg: *void) -> void #c_call; // . . . R .  // (Optional) Call Present/SwapBuffers. 'render_arg' is the value passed to RenderPlatformWindowsDefault().

    // (Optional) Monitor list
    // - Updated by: app/backend. Update every frame to dynamically support changing monitor or DPI configuration.
    // - Used by: dear imgui to query DPI info, clamp popups/tooltips within same monitor and not have them straddle monitors.
    Monitors:                    ImVector(PlatformMonitor);

    Viewports:                   ImVector(*Viewport); // Main viewports, followed by all secondary viewports.
}

// (Optional) This is required when enabling multi-viewport. Represent the bounds of each connected monitor/display and their DPI.
// We use this information for multiple DPI support + clamping the position of popups and tooltips so they don't straddle multiple monitors.
PlatformMonitor :: struct {
    MainPos:  ImVec2; // Coordinates of the area displayed on this monitor (Min = upper left, Max = bottom right)
    MainSize: ImVec2; // Coordinates of the area displayed on this monitor (Min = upper left, Max = bottom right)
    WorkPos:  ImVec2; // Coordinates without task bars / side bars / menu bars. Used to avoid positioning popups/tooltips inside this region. If you don't have this info, please copy the value for MainPos/MainSize.
    WorkSize: ImVec2; // Coordinates without task bars / side bars / menu bars. Used to avoid positioning popups/tooltips inside this region. If you don't have this info, please copy the value for MainPos/MainSize.
    DpiScale: float; // 1.0f = 96 DPI
}

// (Optional) Support for IME (Input Method Editor) via the io.SetPlatformImeDataFn() function.
PlatformImeData :: struct {
    WantVisible:     bool; // A widget wants the IME to be visible
    InputPos:        ImVec2; // Position of the input cursor
    InputLineHeight: float; // Line height
}

// OBSOLETED in 1.82 (from Mars 2021): flags for AddRect(), AddRectFilled(), AddImageRounded(), PathRect()
ImDrawCornerFlags :: ImDrawFlags;
ImDrawCornerFlags_ :: enum_flags s32 {
    None     :: 0x100;
    TopLeft  :: 0x10;
    TopRight :: 0x20;
    BotLeft  :: 0x40;
    BotRight :: 0x80;
    All      :: 0xf0;
    Top      :: 0x30;
    Bot      :: 0xc0;
    Left     :: 0x50;
    Right    :: 0xa0;

    ImDrawCornerFlags_None     :: None;
    ImDrawCornerFlags_TopLeft  :: TopLeft;
    ImDrawCornerFlags_TopRight :: TopRight;
    ImDrawCornerFlags_BotLeft  :: BotLeft;
    ImDrawCornerFlags_BotRight :: BotRight;
    ImDrawCornerFlags_All      :: All;
    ImDrawCornerFlags_Top      :: Top;
    ImDrawCornerFlags_Bot      :: Bot;
    ImDrawCornerFlags_Left     :: Left;
    ImDrawCornerFlags_Right    :: Right;
}

// RENAMED ImGuiKeyModFlags -> ImGuiModFlags in 1.88 (from April 2022)
KeyModFlags :: s32;
KeyModFlags_ :: enum_flags s32 {
    None  :: 0x0;
    Ctrl  :: 0x1;
    Shift :: 0x2;
    Alt   :: 0x4;
    Super :: 0x8;
    ImGuiKeyModFlags_None  :: None;
    ImGuiKeyModFlags_Ctrl  :: Ctrl;
    ImGuiKeyModFlags_Shift :: Shift;
    ImGuiKeyModFlags_Alt   :: Alt;
    ImGuiKeyModFlags_Super :: Super;
}

#scope_file

imgui :: #foreign_library "win/ImGui";
