//
// This file was auto-generated using the following command:
//
// jai generate.jai
//



IM3D_MATRIX_ROW_MAJOR :: 1;

IM3D_VERSION :: "1.16";

IM3D_VERTEX_ALIGNMENT :: 4;

U32 :: u32;

Id :: U32;
Id_Invalid: Id : 0;

// Get AppData struct from the current context, fill before calling NewFrame().
GetAppData :: () -> *AppData #foreign im3d "?GetAppData@Im3d@@YAAEAUAppData@1@XZ";
// Call at the start of each frame, after filling the AppData struct.
NewFrame :: () -> void #foreign im3d "?NewFrame@Im3d@@YAXXZ";
// Call after all Im3d calls have been made for the current frame, before accessing draw data.
EndFrame :: () -> void #foreign im3d "?EndFrame@Im3d@@YAXXZ";

// Access draw data. Draw lists are valid after calling EndFrame() and before calling NewFrame().
GetDrawLists :: () -> *DrawList #foreign im3d "?GetDrawLists@Im3d@@YAPEBUDrawList@1@XZ";
GetDrawListCount :: () -> U32 #foreign im3d "?GetDrawListCount@Im3d@@YAIXZ";

// Access to text draw data. Draw lists are valid after calling EndFrame() and before calling NewFrame().
GetTextDrawLists :: () -> *TextDrawList #foreign im3d "?GetTextDrawLists@Im3d@@YAPEBUTextDrawList@1@XZ";
GetTextDrawListCount :: () -> U32 #foreign im3d "?GetTextDrawListCount@Im3d@@YAIXZ";

// DEPRECATED (use EndFrame() + GetDrawLists()).
// Call after all Im3d calls have been made for the current frame.
Draw :: () -> void #foreign im3d "?Draw@Im3d@@YAXXZ";

// Begin/end primitive. End() must be called before starting each new primitive type.
BeginPoints :: () -> void #foreign im3d "?BeginPoints@Im3d@@YAXXZ";
BeginLines :: () -> void #foreign im3d "?BeginLines@Im3d@@YAXXZ";
BeginLineLoop :: () -> void #foreign im3d "?BeginLineLoop@Im3d@@YAXXZ";
BeginLineStrip :: () -> void #foreign im3d "?BeginLineStrip@Im3d@@YAXXZ";
BeginTriangles :: () -> void #foreign im3d "?BeginTriangles@Im3d@@YAXXZ";
BeginTriangleStrip :: () -> void #foreign im3d "?BeginTriangleStrip@Im3d@@YAXXZ";
End :: () -> void #foreign im3d "?End@Im3d@@YAXXZ";

// Add a vertex to the current primitive (call between Begin*() and End()).
Vertex :: (_position: *Vec3) -> void #foreign im3d "?Vertex@Im3d@@YAXAEBUVec3@1@@Z";
Vertex :: (_position: Vec3) #no_context {
    Vertex(*_position);
}
Vertex :: (_position: *Vec3, _color: Color) -> void #foreign im3d "?Vertex@Im3d@@YAXAEBUVec3@1@UColor@1@@Z";
Vertex :: (_position: Vec3, _color: Color) #no_context {
    Vertex(*_position, _color);
}
Vertex :: (_position: *Vec3, _size: float) -> void #foreign im3d "?Vertex@Im3d@@YAXAEBUVec3@1@M@Z";
Vertex :: (_position: Vec3, _size: float) #no_context {
    Vertex(*_position, _size);
}
Vertex :: (_position: *Vec3, _size: float, _color: Color) -> void #foreign im3d "?Vertex@Im3d@@YAXAEBUVec3@1@MUColor@1@@Z";
Vertex :: (_position: Vec3, _size: float, _color: Color) #no_context {
    Vertex(*_position, _size, _color);
}
Vertex :: (_x: float, _y: float, _z: float) -> void #foreign im3d "?Vertex@Im3d@@YAXMMM@Z";
Vertex :: (_x: float, _y: float, _z: float, _color: Color) -> void #foreign im3d "?Vertex@Im3d@@YAXMMMUColor@1@@Z";
Vertex :: (_x: float, _y: float, _z: float, _size: float) -> void #foreign im3d "?Vertex@Im3d@@YAXMMMM@Z";
Vertex :: (_x: float, _y: float, _z: float, _size: float, _color: Color) -> void #foreign im3d "?Vertex@Im3d@@YAXMMMMUColor@1@@Z";

// Color draw state (per vertex).
PushColor :: () -> void #foreign im3d "?PushColor@Im3d@@YAXXZ";
PushColor :: (_color: Color) -> void #foreign im3d "?PushColor@Im3d@@YAXUColor@1@@Z";
PopColor :: () -> void #foreign im3d "?PopColor@Im3d@@YAXXZ";
SetColor :: (_color: Color) -> void #foreign im3d "?SetColor@Im3d@@YAXUColor@1@@Z";
SetColor :: (_r: float, _g: float, _b: float, _a: float = 1.0) -> void #foreign im3d "?SetColor@Im3d@@YAXMMMM@Z";
GetColor :: () -> Color #cpp_return_type_is_non_pod #foreign im3d "?GetColor@Im3d@@YA?AUColor@1@XZ";

// Alpha draw state, multiplies the alpha set by the color draw state (per vertex).
PushAlpha :: () -> void #foreign im3d "?PushAlpha@Im3d@@YAXXZ";
PushAlpha :: (_alpha: float) -> void #foreign im3d "?PushAlpha@Im3d@@YAXM@Z";
PopAlpha :: () -> void #foreign im3d "?PopAlpha@Im3d@@YAXXZ";
SetAlpha :: (_alpha: float) -> void #foreign im3d "?SetAlpha@Im3d@@YAXM@Z";
GetAlpha :: () -> float #foreign im3d "?GetAlpha@Im3d@@YAMXZ";

// Size draw state, for points/lines this is the radius/width in pixels (per vertex).
PushSize :: () -> void #foreign im3d "?PushSize@Im3d@@YAXXZ";
PushSize :: (_size: float) -> void #foreign im3d "?PushSize@Im3d@@YAXM@Z";
PopSize :: () -> void #foreign im3d "?PopSize@Im3d@@YAXXZ";
SetSize :: (_size: float) -> void #foreign im3d "?SetSize@Im3d@@YAXM@Z";
GetSize :: () -> float #foreign im3d "?GetSize@Im3d@@YAMXZ";

// Sorting draw state, enable depth sorting between primitives (per primitive).
PushEnableSorting :: () -> void #foreign im3d "?PushEnableSorting@Im3d@@YAXXZ";
PushEnableSorting :: (_enable: bool) -> void #foreign im3d "?PushEnableSorting@Im3d@@YAX_N@Z";
PopEnableSorting :: () -> void #foreign im3d "?PopEnableSorting@Im3d@@YAXXZ";
EnableSorting :: (_enable: bool) -> void #foreign im3d "?EnableSorting@Im3d@@YAX_N@Z";

// Push/pop all draw states (color, alpha, size, sorting).
PushDrawState :: () -> void #foreign im3d "?PushDrawState@Im3d@@YAXXZ";
PopDrawState :: () -> void #foreign im3d "?PopDrawState@Im3d@@YAXXZ";

// Transform state (per vertex).
PushMatrix :: () -> void #foreign im3d "?PushMatrix@Im3d@@YAXXZ";
PushMatrix :: (_mat4: *Mat4) -> void #foreign im3d "?PushMatrix@Im3d@@YAXAEBUMat4@1@@Z";
PushMatrix :: (_mat4: Mat4) #no_context {
    PushMatrix(*_mat4);
}
PopMatrix :: () -> void #foreign im3d "?PopMatrix@Im3d@@YAXXZ";
SetMatrix :: (_mat4: *Mat4) -> void #foreign im3d "?SetMatrix@Im3d@@YAXAEBUMat4@1@@Z";
SetMatrix :: (_mat4: Mat4) #no_context {
    SetMatrix(*_mat4);
}
SetIdentity :: () -> void #foreign im3d "?SetIdentity@Im3d@@YAXXZ";

MulMatrix :: (_mat4: *Mat4) -> void #foreign im3d "?MulMatrix@Im3d@@YAXAEBUMat4@1@@Z";
MulMatrix :: (_mat4: Mat4) #no_context {
    MulMatrix(*_mat4);
}
Translate :: (_x: float, _y: float, _z: float) -> void #foreign im3d "?Translate@Im3d@@YAXMMM@Z";
Translate :: (_vec3: *Vec3) -> void #foreign im3d "?Translate@Im3d@@YAXAEBUVec3@1@@Z";
Translate :: (_vec3: Vec3) #no_context {
    Translate(*_vec3);
}
Rotate :: (_axis: *Vec3, _angle: float) -> void #foreign im3d "?Rotate@Im3d@@YAXAEBUVec3@1@M@Z";
Rotate :: (_axis: Vec3, _angle: float) #no_context {
    Rotate(*_axis, _angle);
}
Rotate :: (_rotation: *Mat3) -> void #foreign im3d "?Rotate@Im3d@@YAXAEBUMat3@1@@Z";
Rotate :: (_rotation: Mat3) #no_context {
    Rotate(*_rotation);
}
Scale :: (_x: float, _y: float, _z: float) -> void #foreign im3d "?Scale@Im3d@@YAXMMM@Z";

// High order shapes. Where _detail = -1, an automatic level of detail is chosen based on the distance to the view origin (as specified via the AppData struct).
DrawXyzAxes :: () -> void #foreign im3d "?DrawXyzAxes@Im3d@@YAXXZ";
DrawPoint :: (_position: *Vec3, _size: float, _color: Color) -> void #foreign im3d "?DrawPoint@Im3d@@YAXAEBUVec3@1@MUColor@1@@Z";
DrawPoint :: (_position: Vec3, _size: float, _color: Color) #no_context {
    DrawPoint(*_position, _size, _color);
}
DrawLine :: (_a: *Vec3, _b: *Vec3, _size: float, _color: Color) -> void #foreign im3d "?DrawLine@Im3d@@YAXAEBUVec3@1@0MUColor@1@@Z";
DrawLine :: (_a: Vec3, _b: Vec3, _size: float, _color: Color) #no_context {
    DrawLine(*_a, *_b, _size, _color);
}
DrawQuad :: (_a: *Vec3, _b: *Vec3, _c: *Vec3, _d: *Vec3) -> void #foreign im3d "?DrawQuad@Im3d@@YAXAEBUVec3@1@000@Z";
DrawQuad :: (_a: Vec3, _b: Vec3, _c: Vec3, _d: Vec3) #no_context {
    DrawQuad(*_a, *_b, *_c, *_d);
}
DrawQuad :: (_origin: *Vec3, _normal: *Vec3, _size: *Vec2) -> void #foreign im3d "?DrawQuad@Im3d@@YAXAEBUVec3@1@0AEBUVec2@1@@Z";
DrawQuad :: (_origin: Vec3, _normal: Vec3, _size: Vec2) #no_context {
    DrawQuad(*_origin, *_normal, *_size);
}
DrawQuadFilled :: (_a: *Vec3, _b: *Vec3, _c: *Vec3, _d: *Vec3) -> void #foreign im3d "?DrawQuadFilled@Im3d@@YAXAEBUVec3@1@000@Z";
DrawQuadFilled :: (_a: Vec3, _b: Vec3, _c: Vec3, _d: Vec3) #no_context {
    DrawQuadFilled(*_a, *_b, *_c, *_d);
}
DrawQuadFilled :: (_origin: *Vec3, _normal: *Vec3, _size: *Vec2) -> void #foreign im3d "?DrawQuadFilled@Im3d@@YAXAEBUVec3@1@0AEBUVec2@1@@Z";
DrawQuadFilled :: (_origin: Vec3, _normal: Vec3, _size: Vec2) #no_context {
    DrawQuadFilled(*_origin, *_normal, *_size);
}
DrawCircle :: (_origin: *Vec3, _normal: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "?DrawCircle@Im3d@@YAXAEBUVec3@1@0MH@Z";
DrawCircle :: (_origin: Vec3, _normal: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCircle(*_origin, *_normal, _radius, _detail);
}
DrawCircleFilled :: (_origin: *Vec3, _normal: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "?DrawCircleFilled@Im3d@@YAXAEBUVec3@1@0MH@Z";
DrawCircleFilled :: (_origin: Vec3, _normal: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCircleFilled(*_origin, *_normal, _radius, _detail);
}
DrawSphere :: (_origin: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "?DrawSphere@Im3d@@YAXAEBUVec3@1@MH@Z";
DrawSphere :: (_origin: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawSphere(*_origin, _radius, _detail);
}
DrawSphereFilled :: (_origin: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "?DrawSphereFilled@Im3d@@YAXAEBUVec3@1@MH@Z";
DrawSphereFilled :: (_origin: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawSphereFilled(*_origin, _radius, _detail);
}
DrawAlignedBox :: (_min: *Vec3, _max: *Vec3) -> void #foreign im3d "?DrawAlignedBox@Im3d@@YAXAEBUVec3@1@0@Z";
DrawAlignedBox :: (_min: Vec3, _max: Vec3) #no_context {
    DrawAlignedBox(*_min, *_max);
}
DrawAlignedBoxFilled :: (_min: *Vec3, _max: *Vec3) -> void #foreign im3d "?DrawAlignedBoxFilled@Im3d@@YAXAEBUVec3@1@0@Z";
DrawAlignedBoxFilled :: (_min: Vec3, _max: Vec3) #no_context {
    DrawAlignedBoxFilled(*_min, *_max);
}
DrawCylinder :: (_start: *Vec3, _end: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "?DrawCylinder@Im3d@@YAXAEBUVec3@1@0MH@Z";
DrawCylinder :: (_start: Vec3, _end: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCylinder(*_start, *_end, _radius, _detail);
}
DrawCapsule :: (_start: *Vec3, _end: *Vec3, _radius: float, _detail: s32 = -1) -> void #foreign im3d "?DrawCapsule@Im3d@@YAXAEBUVec3@1@0MH@Z";
DrawCapsule :: (_start: Vec3, _end: Vec3, _radius: float, _detail: s32 = -1) #no_context {
    DrawCapsule(*_start, *_end, _radius, _detail);
}
DrawPrism :: (_start: *Vec3, _end: *Vec3, _radius: float, _sides: s32) -> void #foreign im3d "?DrawPrism@Im3d@@YAXAEBUVec3@1@0MH@Z";
DrawPrism :: (_start: Vec3, _end: Vec3, _radius: float, _sides: s32) #no_context {
    DrawPrism(*_start, *_end, _radius, _sides);
}
DrawArrow :: (_start: *Vec3, _end: *Vec3, _headLength: float = -1.0, _headThickness: float = -1.0) -> void #foreign im3d "?DrawArrow@Im3d@@YAXAEBUVec3@1@0MM@Z";
DrawArrow :: (_start: Vec3, _end: Vec3, _headLength: float = -1.0, _headThickness: float = -1.0) #no_context {
    DrawArrow(*_start, *_end, _headLength, _headThickness);
}

// Add text. See TextFlags_ enum for _textFlags. _size is a hint to the application-side text rendering.
Text :: (_position: *Vec3, _textFlags: U32, _text: *u8, __args: ..Any) -> void #foreign im3d "?Text@Im3d@@YAXAEBUVec3@1@IPEBDZZ";
Text :: (_position: *Vec3, _size: float, _color: Color, _textFlags: U32, _text: *u8, __args: ..Any) -> void #foreign im3d "?Text@Im3d@@YAXAEBUVec3@1@MUColor@1@IPEBDZZ";

// IDs are used to uniquely identify gizmos and layers. Gizmo should have a unique ID during a frame.
// Note that ids are a hash of the whole ID stack, see PushId(), PopId().
MakeId :: (_str: *u8) -> Id #foreign im3d "?MakeId@Im3d@@YAIPEBD@Z";
MakeId :: (_ptr: *void) -> Id #foreign im3d "?MakeId@Im3d@@YAIPEBX@Z";
MakeId :: (_i: s32) -> Id #foreign im3d "?MakeId@Im3d@@YAIH@Z";

// PushId(), PopId() affect the result of subsequent calls to MakeId(), use when creating gizmos in a loop.
PushId :: () -> void #foreign im3d "?PushId@Im3d@@YAXXZ";
PushId :: (_id: Id) -> void #foreign im3d "?PushId@Im3d@@YAXI@Z";
PushId :: (_str: *u8) -> void #foreign im3d "?PushId@Im3d@@YAXPEBD@Z";
PushId :: (_ptr: *void) -> void #foreign im3d "?PushId@Im3d@@YAXPEBX@Z";
PushId :: (_i: s32) -> void #foreign im3d "?PushId@Im3d@@YAXH@Z";
PopId :: () -> void #foreign im3d "?PopId@Im3d@@YAXXZ";
GetId :: () -> Id #foreign im3d "?GetId@Im3d@@YAIXZ";

// Layer id state, subsequent primitives are added to a separate draw list associated with the id (per primitive).
PushLayerId :: (_layer: Id) -> void #foreign im3d "?PushLayerId@Im3d@@YAXI@Z";
PushLayerId :: (_str: *u8) -> void #foreign im3d "?PushLayerId@Im3d@@YAXPEBD@Z";
PopLayerId :: () -> void #foreign im3d "?PopLayerId@Im3d@@YAXXZ";
GetLayerId :: () -> Id #foreign im3d "?GetLayerId@Im3d@@YAIXZ";

// Manipulate translation/rotation/scale via a gizmo. Return true if the gizmo is 'active' (if it modified the output parameter).
// If _local is true, the Gizmo* functions expect that the local matrix is on the matrix stack; in general the application should
// push the local matrix before calling any of the following.
GizmoTranslation :: (_id: *u8, _translation_: *[3] float, _local := false) -> bool #foreign im3d "?GizmoTranslation@Im3d@@YA_NPEBDQEAM_N@Z";
GizmoRotation :: (_id: *u8, _rotation_: *[9] float, _local := false) -> bool #foreign im3d "?GizmoRotation@Im3d@@YA_NPEBDQEAM_N@Z";
GizmoScale :: (_id: *u8, _scale_: *[3] float) -> bool #foreign im3d "?GizmoScale@Im3d@@YA_NPEBDQEAM@Z";
// Unified gizmo, selects local/global, translation/rotation/scale based on the context-global gizmo modes. Return true if the gizmo is active.
Gizmo :: (_id: *u8, _translation_: *[3] float, _rotation_: *[9] float, _scale_: *[3] float) -> bool #foreign im3d "?Gizmo@Im3d@@YA_NPEBDQEAM11@Z";
Gizmo :: (_id: *u8, _transform_: *[16] float) -> bool #foreign im3d "?Gizmo@Im3d@@YA_NPEBDQEAM@Z";

// Gizmo* overloads which take an ID directly. In some cases the app may want to call MakeId() separately, usually to change the gizmo appearance if hot/active.
GizmoTranslation :: (_id: Id, _translation_: *[3] float, _local := false) -> bool #foreign im3d "?GizmoTranslation@Im3d@@YA_NIQEAM_N@Z";
GizmoRotation :: (_id: Id, _rotation_: *[9] float, _local := false) -> bool #foreign im3d "?GizmoRotation@Im3d@@YA_NIQEAM_N@Z";
GizmoScale :: (_id: Id, _scale_: *[3] float) -> bool #foreign im3d "?GizmoScale@Im3d@@YA_NIQEAM@Z";
Gizmo :: (_id: Id, _transform_: *[16] float) -> bool #foreign im3d "?Gizmo@Im3d@@YA_NIQEAM@Z";
Gizmo :: (_id: Id, _translation_: *[3] float, _rotation_: *[9] float, _scale_: *[3] float) -> bool #foreign im3d "?Gizmo@Im3d@@YA_NIQEAM00@Z";

// Active gizmo ID. This will match the _id parameter passed to a Gizmo* function. Return Id_Invalid if no gizmo is in use.
GetActiveId :: () -> Id #foreign im3d "?GetActiveId@Im3d@@YAIXZ";
// ID of the current current 'hot' gizmo (nearest intersecting gizmo along the cursor ray).
GetHotId :: () -> Id #foreign im3d "?GetHotId@Im3d@@YAIXZ";

// Visibility tests. The application must set a culling frustum via AppData.
IsVisible :: (_origin: *Vec3, _radius: float) -> bool #foreign im3d "?IsVisible@Im3d@@YA_NAEBUVec3@1@M@Z";
IsVisible :: (_origin: Vec3, _radius: float) -> bool #no_context {
    return IsVisible(*_origin, _radius);
}
IsVisible :: (_min: *Vec3, _max: *Vec3) -> bool #foreign im3d "?IsVisible@Im3d@@YA_NAEBUVec3@1@0@Z";
IsVisible :: (_min: Vec3, _max: Vec3) -> bool #no_context {
    return IsVisible(*_min, *_max);
}

// Get/set the current context. All Im3d calls affect the currently bound context.
GetContext :: () -> *Context #foreign im3d "?GetContext@Im3d@@YAAEAUContext@1@XZ";
SetContext :: (_ctx: *Context) -> void #foreign im3d "?SetContext@Im3d@@YAXAEAUContext@1@@Z";
// Merge vertex data from _src into _dst_. Layers are preserved. Call before EndFrame().
MergeContexts :: (_dst_: *Context, _src: *Context) -> void #foreign im3d "?MergeContexts@Im3d@@YAXAEAUContext@1@AEBU21@@Z";
MergeContexts :: (_dst_: *Context, _src: Context) #no_context {
    MergeContexts(_dst_, *_src);
}

Color :: struct {
    v: U32; // rgba8 (MSB = r)

    Constructor :: (this: *Color, _rgba: *Vec4) -> void #cpp_method #foreign im3d "??0Color@Im3d@@QEAA@AEBUVec4@1@@Z";
    Constructor :: (this: *Color, _rgba: Vec4) #no_context {
        Constructor(this, *_rgba);
    }
    Constructor :: (this: *Color, _rgb: *Vec3, _alpha: float) -> void #cpp_method #foreign im3d "??0Color@Im3d@@QEAA@AEBUVec3@1@M@Z";
    Constructor :: (this: *Color, _rgb: Vec3, _alpha: float) #no_context {
        Constructor(this, *_rgb, _alpha);
    }
    Constructor :: (this: *Color, _r: float, _g: float, _b: float, _a: float = 1.0) -> void #cpp_method #foreign im3d "??0Color@Im3d@@QEAA@MMMM@Z";
}

Color_Black: Color : Color.{255};
Color_White: Color : Color.{4294967295};
Color_Gray: Color : Color.{2155905279};
Color_Red: Color : Color.{4278190335};
Color_Green: Color : Color.{16711935};
Color_Blue: Color : Color.{65535};
Color_Magenta: Color : Color.{4278255615};
Color_Yellow: Color : Color.{4294902015};
Color_Cyan: Color : Color.{16777215};

Color_Pink: Color : Color.{4290825215};
Color_Orange: Color : Color.{4289003775};
Color_Gold: Color : Color.{4292280575};
Color_Brown: Color : Color.{2336560127};
Color_Purple: Color : Color.{2147516671};
Color_Teal: Color : Color.{8421631};
Color_Navy: Color : Color.{33023};

VertexData :: struct {
    positionSize: Vec4; // xyz = position, w = size
    color:        Color; // rgba8 (MSB = r)
}

DrawPrimitiveType :: enum s32 {
    DrawPrimitive_Triangles :: 0;
    DrawPrimitive_Lines     :: 1;
    DrawPrimitive_Points    :: 2;

    DrawPrimitive_Count     :: 3;
}

DrawList :: struct {
    layerId:     Id;
    primType:    DrawPrimitiveType;
    vertexData:  *VertexData;
    vertexCount: U32;
}

DrawPrimitivesCallback :: #type (_drawList: *DrawList) -> void #c_call;

TextFlags :: enum s32 {
    AlignLeft   :: 1;
    AlignRight  :: 2;
    AlignTop    :: 8;
    AlignBottom :: 16;

    Default     :: 0;

    TextFlags_AlignLeft   :: AlignLeft;
    TextFlags_AlignRight  :: AlignRight;
    TextFlags_AlignTop    :: AlignTop;
    TextFlags_AlignBottom :: AlignBottom;

    TextFlags_Default     :: Default;
}

TextData :: struct {
    positionSize:     Vec4; // xyz = position, w = size
    color:            Color; // rgba8 (MSB = r)
    flags:            U32; // TextFlags
    textLength:       U32; // # chars in the text, excluding null terminator
    textBufferOffset: U32; // start of the text in the draw list's text buffer
}

TextDrawList :: struct {
    layerId:       Id;
    textData:      *TextData;
    textDataCount: U32;
    textBuffer:    *u8;
}

Key :: enum s32 {
    Mouse_Left              :: 0;
    L                       :: 1;
    R                       :: 2;
    S                       :: 3;
    T                       :: 4;

    Count                   :: 5;

    Action_Select           :: 0;
    Action_GizmoLocal       :: 1;
    Action_GizmoRotation    :: 2;
    Action_GizmoScale       :: 3;
    Action_GizmoTranslation :: 4;

    Action_Count            :: 5;

    Key_L     :: L;
    Key_R     :: R;
    Key_S     :: S;
    Key_T     :: T;

    Key_Count :: Count;
}

FrustumPlane :: enum s32 {
    Near   :: 0;
    Far    :: 1;
    Top    :: 2;
    Right  :: 3;
    Bottom :: 4;
    Left   :: 5;

    Count  :: 6;

    FrustumPlane_Near   :: Near;
    FrustumPlane_Far    :: Far;
    FrustumPlane_Top    :: Top;
    FrustumPlane_Right  :: Right;
    FrustumPlane_Bottom :: Bottom;
    FrustumPlane_Left   :: Left;

    FrustumPlane_Count  :: Count;
}

AppData :: struct {
    keyDown:             [5] bool; // Key states.
    cullFrustum:         [6] Vec4; // Frustum planes for culling (if culling enabled).
    cursorRayOrigin:     Vec3; // World space cursor ray origin.
    cursorRayDirection:  Vec3; // World space cursor ray direction.
    worldUp:             Vec3; // World space 'up' vector.
    viewOrigin:          Vec3; // World space render origin (camera position).
    viewDirection:       Vec3; // World space view direction.
    viewportSize:        Vec2; // Viewport size (pixels).
    projScaleY:          float = 1.0; // Scale factor used to convert from pixel size -> world scale; use tan(fov) for perspective projections, far plane height for ortho.
    projOrtho            := false; // If the projection matrix is orthographic.
    deltaTime:           float = 0.0; // Time since previous frame (seconds).
    snapTranslation:     float = 0.0; // Snap value for translation gizmos (world units). 0 = disabled.
    snapRotation:        float = 0.0; // Snap value for rotation gizmos (radians). 0 = disabled.
    snapScale:           float = 0.0; // Snap value for scale gizmos. 0 = disabled.
    flipGizmoWhenBehind  := true; // Flip gizmo axes when viewed from behind.
    appData:             *void = null; // App-specific data.

    drawCallback:        DrawPrimitivesCallback = null; // e.g. void Im3d_Draw(const DrawList& _drawList)

    // Extract cull frustum planes from the view-projection matrix.
    // Set _ndcZNegativeOneToOne = true if the proj matrix maps z from [-1,1] (OpenGL style).
    setCullFrustum :: (this: *AppData, _viewProj: *Mat4, _ndcZNegativeOneToOne: bool) -> void #cpp_method #foreign im3d "?setCullFrustum@AppData@Im3d@@QEAAXAEBUMat4@2@_N@Z";
    setCullFrustum :: (this: *AppData, _viewProj: Mat4, _ndcZNegativeOneToOne: bool) #no_context {
        setCullFrustum(this, *_viewProj, _ndcZNegativeOneToOne);
    }
}

// Minimal vector.
Vector :: struct(T: Type) {
    data:     *T = null;
    size:     U32 = 0;
    capacity: U32 = 0;
}

PrimitiveMode :: enum s32 {
    None          :: 0;
    Points        :: 1;
    Lines         :: 2;
    LineStrip     :: 3;
    LineLoop      :: 4;
    Triangles     :: 5;
    TriangleStrip :: 6;

    PrimitiveMode_None          :: None;
    PrimitiveMode_Points        :: Points;
    PrimitiveMode_Lines         :: Lines;
    PrimitiveMode_LineStrip     :: LineStrip;
    PrimitiveMode_LineLoop      :: LineLoop;
    PrimitiveMode_Triangles     :: Triangles;
    PrimitiveMode_TriangleStrip :: TriangleStrip;
}

GizmoMode :: enum s32 {
    Translation :: 0;
    Rotation    :: 1;
    Scale       :: 2;

    GizmoMode_Translation :: Translation;
    GizmoMode_Rotation    :: Rotation;
    GizmoMode_Scale       :: Scale;
}

// Context stores all relevant state - main interface affects the context currently bound via SetCurrentContext().
Context :: struct {
    Constructor :: (this: *Context) -> void #cpp_method #foreign im3d "??0Context@Im3d@@QEAA@XZ";
    Destructor :: (this: *Context) -> void #cpp_method #foreign im3d "??1Context@Im3d@@QEAA@XZ";

    begin :: (this: *Context, _mode: PrimitiveMode) -> void #cpp_method #foreign im3d "?begin@Context@Im3d@@QEAAXW4PrimitiveMode@2@@Z";
    end :: (this: *Context) -> void #cpp_method #foreign im3d "?end@Context@Im3d@@QEAAXXZ";

    vertex :: (this: *Context, _position: *Vec3, _size: float, _color: Color) -> void #cpp_method #foreign im3d "?vertex@Context@Im3d@@QEAAXAEBUVec3@2@MUColor@2@@Z";
    vertex :: (this: *Context, _position: Vec3, _size: float, _color: Color) #no_context {
        vertex(this, *_position, _size, _color);
    }

    text :: (this: *Context, _position: *Vec3, _size: float, _color: Color, _flags: TextFlags, _textStart: *u8, _textEnd: *u8) -> void #cpp_method #foreign im3d "?text@Context@Im3d@@QEAAXAEBUVec3@2@MUColor@2@W4TextFlags@2@PEBD3@Z";
    text :: (this: *Context, _position: Vec3, _size: float, _color: Color, _flags: TextFlags, _textStart: *u8, _textEnd: *u8) #no_context {
        text(this, *_position, _size, _color, _flags, _textStart, _textEnd);
    }

    reset :: (this: *Context) -> void #cpp_method #foreign im3d "?reset@Context@Im3d@@QEAAXXZ";
    merge :: (this: *Context, _src: *Context) -> void #cpp_method #foreign im3d "?merge@Context@Im3d@@QEAAXAEBU12@@Z";
    merge :: (this: *Context, _src: Context) #no_context {
        merge(this, *_src);
    }
    endFrame :: (this: *Context) -> void #cpp_method #foreign im3d "?endFrame@Context@Im3d@@QEAAXXZ";
    draw :: (this: *Context) -> void #cpp_method #foreign im3d "?draw@Context@Im3d@@QEAAXXZ";

    setEnableSorting :: (this: *Context, _enable: bool) -> void #cpp_method #foreign im3d "?setEnableSorting@Context@Im3d@@QEAAX_N@Z";

    pushEnableSorting :: (this: *Context, _enable: bool) -> void #cpp_method #foreign im3d "?pushEnableSorting@Context@Im3d@@QEAAX_N@Z";
    popEnableSorting :: (this: *Context) -> void #cpp_method #foreign im3d "?popEnableSorting@Context@Im3d@@QEAAXXZ";

    pushLayerId :: (this: *Context, _layer: Id) -> void #cpp_method #foreign im3d "?pushLayerId@Context@Im3d@@QEAAXI@Z";
    popLayerId :: (this: *Context) -> void #cpp_method #foreign im3d "?popLayerId@Context@Im3d@@QEAAXXZ";

    // Low-level interface for internal and app-defined gizmos. May be subject to breaking changes.
    gizmoAxisTranslation_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *Vec3) -> bool #cpp_method #foreign im3d "?gizmoAxisTranslation_Behavior@Context@Im3d@@QEAA_NIAEBUVec3@2@0MMMPEAU32@@Z";
    gizmoAxisTranslation_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *Vec3) -> bool #no_context {
        return gizmoAxisTranslation_Behavior(this, _id, *_origin, *_axis, _snap, _worldHeight, _worldSize, _out_);
    }
    gizmoAxisTranslation_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _worldHeight: float, _worldSize: float, _color: Color) -> void #cpp_method #foreign im3d "?gizmoAxisTranslation_Draw@Context@Im3d@@QEAAXIAEBUVec3@2@0MMUColor@2@@Z";
    gizmoAxisTranslation_Draw :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _worldHeight: float, _worldSize: float, _color: Color) #no_context {
        gizmoAxisTranslation_Draw(this, _id, *_origin, *_axis, _worldHeight, _worldSize, _color);
    }

    gizmoPlaneTranslation_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _normal: *Vec3, _snap: float, _worldSize: float, _out_: *Vec3) -> bool #cpp_method #foreign im3d "?gizmoPlaneTranslation_Behavior@Context@Im3d@@QEAA_NIAEBUVec3@2@0MMPEAU32@@Z";
    gizmoPlaneTranslation_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _normal: Vec3, _snap: float, _worldSize: float, _out_: *Vec3) -> bool #no_context {
        return gizmoPlaneTranslation_Behavior(this, _id, *_origin, *_normal, _snap, _worldSize, _out_);
    }
    gizmoPlaneTranslation_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _normal: *Vec3, _worldSize: float, _color: Color) -> void #cpp_method #foreign im3d "?gizmoPlaneTranslation_Draw@Context@Im3d@@QEAAXIAEBUVec3@2@0MUColor@2@@Z";
    gizmoPlaneTranslation_Draw :: (this: *Context, _id: Id, _origin: Vec3, _normal: Vec3, _worldSize: float, _color: Color) #no_context {
        gizmoPlaneTranslation_Draw(this, _id, *_origin, *_normal, _worldSize, _color);
    }

    gizmoAxislAngle_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _snap: float, _worldRadius: float, _worldSize: float, _out_: *float) -> bool #cpp_method #foreign im3d "?gizmoAxislAngle_Behavior@Context@Im3d@@QEAA_NIAEBUVec3@2@0MMMPEAM@Z";
    gizmoAxislAngle_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _snap: float, _worldRadius: float, _worldSize: float, _out_: *float) -> bool #no_context {
        return gizmoAxislAngle_Behavior(this, _id, *_origin, *_axis, _snap, _worldRadius, _worldSize, _out_);
    }
    gizmoAxislAngle_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _worldRadius: float, _angle: float, _color: Color, _minAlpha: float) -> void #cpp_method #foreign im3d "?gizmoAxislAngle_Draw@Context@Im3d@@QEAAXIAEBUVec3@2@0MMUColor@2@M@Z";
    gizmoAxislAngle_Draw :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _worldRadius: float, _angle: float, _color: Color, _minAlpha: float) #no_context {
        gizmoAxislAngle_Draw(this, _id, *_origin, *_axis, _worldRadius, _angle, _color, _minAlpha);
    }

    gizmoAxisScale_Behavior :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *float) -> bool #cpp_method #foreign im3d "?gizmoAxisScale_Behavior@Context@Im3d@@QEAA_NIAEBUVec3@2@0MMMPEAM@Z";
    gizmoAxisScale_Behavior :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _snap: float, _worldHeight: float, _worldSize: float, _out_: *float) -> bool #no_context {
        return gizmoAxisScale_Behavior(this, _id, *_origin, *_axis, _snap, _worldHeight, _worldSize, _out_);
    }
    gizmoAxisScale_Draw :: (this: *Context, _id: Id, _origin: *Vec3, _axis: *Vec3, _worldHeight: float, _worldSize: float, _color: Color) -> void #cpp_method #foreign im3d "?gizmoAxisScale_Draw@Context@Im3d@@QEAAXIAEBUVec3@2@0MMUColor@2@@Z";
    gizmoAxisScale_Draw :: (this: *Context, _id: Id, _origin: Vec3, _axis: Vec3, _worldHeight: float, _worldSize: float, _color: Color) #no_context {
        gizmoAxisScale_Draw(this, _id, *_origin, *_axis, _worldHeight, _worldSize, _color);
    }

    // Convert pixels -> world space size based on distance between _position and view origin.
    pixelsToWorldSize :: (this: *Context, _position: *Vec3, _pixels: float) -> float #cpp_method #foreign im3d "?pixelsToWorldSize@Context@Im3d@@QEAAMAEBUVec3@2@M@Z";
    pixelsToWorldSize :: (this: *Context, _position: Vec3, _pixels: float) -> float #no_context {
        return pixelsToWorldSize(this, *_position, _pixels);
    }

    // Convert world space size -> pixels based on distance between _position and view origin.
    worldSizeToPixels :: (this: *Context, _position: *Vec3, _pixels: float) -> float #cpp_method #foreign im3d "?worldSizeToPixels@Context@Im3d@@QEAAMAEBUVec3@2@M@Z";
    worldSizeToPixels :: (this: *Context, _position: Vec3, _pixels: float) -> float #no_context {
        return worldSizeToPixels(this, *_position, _pixels);
    }

    // Blend between _min and _max based on distance betwen _position and view origin.
    estimateLevelOfDetail :: (this: *Context, _position: *Vec3, _worldSize: float, _min: s32 = 4, _max: s32 = 256) -> s32 #cpp_method #foreign im3d "?estimateLevelOfDetail@Context@Im3d@@QEAAHAEBUVec3@2@MHH@Z";
    estimateLevelOfDetail :: (this: *Context, _position: Vec3, _worldSize: float, _min: s32 = 4, _max: s32 = 256) -> s32 #no_context {
        return estimateLevelOfDetail(this, *_position, _worldSize, _min, _max);
    }

    // Make _id hot if _depth < m_hotDepth && _intersects.
    makeHot :: (this: *Context, _id: Id, _depth: float, _intersects: bool) -> bool #cpp_method #foreign im3d "?makeHot@Context@Im3d@@QEAA_NIM_N@Z";

    // Make _id active.
    makeActive :: (this: *Context, _id: Id) -> void #cpp_method #foreign im3d "?makeActive@Context@Im3d@@QEAAXI@Z";

    // Reset the acive/hot ids and the hot depth.
    resetId :: (this: *Context) -> void #cpp_method #foreign im3d "?resetId@Context@Im3d@@QEAAXXZ";

    // Visibiity tests for culling.
    isVisible :: (this: *Context, _vdata: *VertexData, _prim: DrawPrimitiveType) -> bool #cpp_method #foreign im3d "?isVisible@Context@Im3d@@QEAA_NPEBUVertexData@2@W4DrawPrimitiveType@2@@Z";
    isVisible :: (this: *Context, _origin: *Vec3, _radius: float) -> bool #cpp_method #foreign im3d "?isVisible@Context@Im3d@@QEAA_NAEBUVec3@2@M@Z";
    isVisible :: (this: *Context, _origin: Vec3, _radius: float) -> bool #no_context {
        return isVisible(this, *_origin, _radius);
    }
    isVisible :: (this: *Context, _min: *Vec3, _max: *Vec3) -> bool #cpp_method #foreign im3d "?isVisible@Context@Im3d@@QEAA_NAEBUVec3@2@0@Z";
    isVisible :: (this: *Context, _min: Vec3, _max: Vec3) -> bool #no_context {
        return isVisible(this, *_min, *_max);
    }

    gizmoLocal:         bool; // Global mode selection for gizmos.
    gizmoMode:          GizmoMode; //               "
    activeId:           Id; // Currently active gizmo. If set, this is the same as m_hotId.
    hotId:              Id; // ID of the current 'hot' gizmo (nearest intersecting gizmo along the cursor ray). NB this is the id of the *sub* gizmo, not the app-specified ID.
    hotDepth:           float; // Depth of the current hot gizmo along the cursor ray, for handling occlusion.
    appId:              Id; // Current ID *without* the hashing the ID stack (= _id arg to Gizmo* functions).
    appActiveId:        Id; // Copied from m_appId for the current active gizmo.
    appHotId:           Id; // Copied from m_appId for the current 'hot' gizmo.
    gizmoStateVec3:     Vec3; // Stored state for the active gizmo.
    gizmoStateMat3:     Mat3; //               "
    gizmoStateFloat:    float; //               "
    gizmoHeightPixels:  float; // Height/radius of gizmos.
    gizmoSizePixels:    float; // Thickness of gizmo lines.

    // Return the total number of primitives (sorted + unsorted) of the given _type in all layers.
    getPrimitiveCount :: (this: *Context, _type: DrawPrimitiveType) -> U32 #cpp_method #foreign im3d "?getPrimitiveCount@Context@Im3d@@QEBAIW4DrawPrimitiveType@2@@Z";

    // Return the total number of text primitives in all layers.
    getTextCount :: (this: *Context) -> U32 #cpp_method #foreign im3d "?getTextCount@Context@Im3d@@QEBAIXZ";

    // State stacks.
    colorStack:         Vector(Color);
    alphaStack:         Vector(float);
    sizeStack:          Vector(float);
    enableSortingStack: Vector(bool);
    matrixStack:        Vector(Mat4);
    idStack:            Vector(Id);
    layerIdStack:       Vector(Id);

    // Vertex data: one list per layer, per primitive type, *2 for sorted/unsorted.
    VertexList :: Vector(VertexData);
    vertexData:         [2] Vector(*VertexList); // Each layer is DrawPrimitive_Count consecutive lists.
    vertexDataIndex:    s32; // 0, or 1 if sorting enabled.
    layerIdMap:         Vector(Id); // Map Id -> vertex data index.
    layerIndex:         s32; // Index of the currently active layer in m_layerIdMap.
    drawLists:          Vector(DrawList); // All draw lists for the current frame, available after calling endFrame() before calling reset().
    sortCalled:         bool; // Avoid calling sort() during every call to draw().
    endFrameCalled:     bool; // For assert, if vertices are pushed after endFrame() was called.

    // Text data: one list per layer.
    TextList :: Vector(TextData);
    textData:           Vector(*TextList);
    textBuffer:         Vector(u8);
    textDrawLists:      Vector(TextDrawList);

    // Primitive state.
    primMode:           PrimitiveMode;
    primType:           DrawPrimitiveType;
    firstVertThisPrim:  U32; // Index of the first vertex pushed during this primitive.
    vertCountThisPrim:  U32; // # calls to vertex() since the last call to begin().
    minVertThisPrim:    Vec3;
    maxVertThisPrim:    Vec3;

    // App data.
    appData:            AppData;
    keyDownCurr:        [5] bool; // Key state captured during reset().
    keyDownPrev:        [5] bool; // Key state from previous frame.
    cullFrustum:        [6] Vec4; // Optimized frustum planes from m_appData.m_cullFrustum.
    cullFrustumCount:   s32; // # valid frustum planes in m_cullFrustum.

    // Sort primitive data.
    sort :: (this: *Context) -> void #cpp_method #foreign im3d "?sort@Context@Im3d@@AEAAXXZ";

    // Return -1 if _id not found.
    findLayerIndex :: (this: *Context, _id: Id) -> s32 #cpp_method #foreign im3d "?findLayerIndex@Context@Im3d@@AEBAHI@Z";

    // Access the current vertex/text data based on m_layerIndex.
    getCurrentVertexList :: (this: *Context) -> *VertexList #cpp_method #foreign im3d "?getCurrentVertexList@Context@Im3d@@AEAAPEAU?$Vector@UVertexData@Im3d@@@2@XZ";
    getCurrentTextList :: (this: *Context) -> *TextList #cpp_method #foreign im3d "?getCurrentTextList@Context@Im3d@@AEAAPEAU?$Vector@UTextData@Im3d@@@2@XZ";
}

internal :: struct {
    g_CurrentContext: *Context;

    ScalarT :: struct {
        __empty_struct_padding: u8; // C++ makes empty structs have length 1
    }
    FloatT :: struct {
        #as using scalart: ScalarT;
    }
    IntT :: struct {
        #as using scalart: ScalarT;
    }
    CompositeT :: struct {
        __empty_struct_padding: u8; // C++ makes empty structs have length 1
    }
    VecT :: struct {
        #as using compositet: CompositeT;
    }
    MatT :: struct {
        #as using compositet: CompositeT;
    }

    TypeTraits :: struct(T: Type) {
        Type :: T;
        anon_enum_1 :: enum s32 {
            kSize :: 0;
        }
    }
}

Line :: struct {
    origin:    Vec3;
    direction: Vec3; // unit length
}

Ray :: struct {
    origin:    Vec3;
    direction: Vec3; // unit length
}

LineSegment :: struct {
    start: Vec3;
    end:   Vec3;
}

Sphere :: struct {
    origin: Vec3;
    radius: float;
}

Plane :: struct {
    normal: Vec3;
    offset: float;
}

Capsule :: struct {
    start:  Vec3;
    end:    Vec3;
    radius: float;
}

Pi: float : 3.141593;
TwoPi: float : 2.0 * Pi;
HalfPi: float : 0.5 * Pi;

#scope_file

im3d :: #foreign_library "win/Im3d";
