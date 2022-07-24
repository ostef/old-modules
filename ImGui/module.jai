#scope_module

linalg :: #import "Linalg";
math   :: #import "Math";

FLOAT32_MIN :: math.F32_MIN;
FLOAT32_MAX :: math.F32_MAX;
size_t :: u64;

#scope_export

#if OS == .WINDOWS
{
	#load "win32.jai";

	user32 :: #foreign_system_library "User32";	// Needed unless ImGui is compiled with IMGUI_DISABLE_WIN32_DEFAULT_CLIPBOARD_FUNCS
}

ImVec2 :: linalg.Vec2f;
ImVec4 :: linalg.Vec4f;
ImColor:: linalg.Vec4f;

ImVector :: struct (T : Type)
{
	Size     : s32;
	Capacity : s32;
	Data     : *T;
}

ImDrawCallback :: #type (parent_list : *ImDrawList, cmd : *ImDrawCmd) #c_call;
ImDrawCallback_ResetRenderState :: -1;
