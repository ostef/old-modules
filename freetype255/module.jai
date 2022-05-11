// Bindings for the FreeType font library.

Init_FreeType   :: (library : **Library) -> Error    #foreign ft "FT_Init_FreeType";
New_Face        :: (library : *Library, filepathname : *u8, face_index : Long, aface : *Face) -> Error #foreign ft "FT_New_Face";
New_Memory_Face :: (library : *Library, file_base : *void, file_size : Long, face_index : Long, aface : *Face) -> Error   #foreign ft "FT_New_Memory_Face";

Load_Char       :: (face : Face, charcode : ULong, load_flags : Int) -> Error #foreign ft "FT_Load_Char";
Load_Glyph      :: (face : Face, glyph_index : UInt, load_flags : s32) -> Error  #foreign ft "FT_Load_Glyph";
Get_Char_Index  :: (face : Face, charcode : ULong) -> u32  #foreign ft "FT_Get_Char_Index";

Set_Pixel_Sizes :: (face : Face, pixel_width : u32, pixel_height : u32) -> Error  #foreign ft "FT_Set_Pixel_Sizes";

Get_Kerning     :: (face : Face, left_glyph : u32, right_glyph : u32, kern_mode : u32, akerning : *Vector) -> Error  #foreign ft "FT_Get_Kerning";

Select_Charmap  :: (face : Face, encoding : Encoding) -> Error #foreign ft "FT_Select_Charmap";

Load_Sfnt_Table :: (face : Face, tag : ULong, offset : Long, buffer : *u8, length : *ULong) -> Error #foreign ft "FT_Load_Sfnt_Table";

Done_Face       :: (face : Face) -> Error #foreign ft "FT_Done_Face";
Done_FreeType   :: (library : *Library) -> Error #foreign ft "FT_Done_FreeType";

//Error :: s32;
Encoding :: u32;
Sfnt_Tag :: u32;

using Error :: enum s32
{
	// Generic errors
	Err_Ok                    :: 0x00;
	Err_Cannot_Open_Resource  :: 0x01;
	Err_Unknown_File_Format   :: 0x02;
	Err_Invalid_File_Format   :: 0x03;
	Err_Invalid_Version       :: 0x04;
	Err_Lower_Module_Version  :: 0x05;
	Err_Invalid_Argument      :: 0x06;
	Err_Unimplemented_Feature :: 0x07;
	Err_Invalid_Table         :: 0x08;
	Err_Invalid_Offset        :: 0x09;
	Err_Array_Too_Large       :: 0x0a;
	Err_Missing_Module        :: 0x0b;
	Err_Missing_Property      :: 0x0c;
	// Glyph/character errors
	Err_Invalid_Glyph_Index    :: 0x10;
	Err_Invalid_Character_Code :: 0x11;
	Err_Invalid_Glyph_Format   :: 0x12;
	Err_Cannot_Render_Glyph    :: 0x13;
	Err_Invalid_Outline        :: 0x14;
	Err_Invalid_Composite      :: 0x15;
	Err_Too_Many_Hints         :: 0x16;
	Err_Invalid_Pixel_Size     :: 0x17;
	// Handle errors
	Err_Invalid_Handle         :: 0x20;
	Err_Invalid_Library_Handle :: 0x21;
	Err_Invalid_Driver_Handle  :: 0x22;
	Err_Invalid_Face_Handle    :: 0x23;
	Err_Invalid_Size_Handle    :: 0x24;
	Err_Invalid_Slot_Handle    :: 0x25;
	Err_Invalid_CharMap_Handle :: 0x26;
	Err_Invalid_Cache_Handle   :: 0x27;
	Err_Invalid_Stream_Handle  :: 0x28;
}

GlyphSlotRec :: struct
{
	library : *Library;
	face : Face;
	next : *GlyphSlotRec;
	reserved : UInt;
	generic : Generic;

	metrics : Glyph_Metrics;
	linearHoriAdvance : Fixed;
	linearVertAdvance : Fixed;

	advance : Vector;

	format : Glyph_Format;

	bitmap : Bitmap;
	bitmap_left : Int;
	bitmap_top : Int;

	outline : Outline;

	num_subglyphs : UInt;
	subglyphs : *void;

	control_data : *void;

#if OS == .WINDOWS
	control_len : s32;
else
	control_len : s64;

	lsb_delta : Pos;
	rsb_delta : Pos;

	other : *void;

	internal : *Slot_InternalRec;
}

CharMapRec :: struct {}
StreamRec  :: struct {}
MemoryRec  :: struct {}
ListNode   :: struct {}
Library    :: struct {}
Face_Internal :: struct {}
Slot_InternalRec :: struct {}
Size_InternalRec :: struct {}

Generic :: struct
{
	data : *void;
	finalizer : (object : *void) -> *void;
}

Vector :: struct
{
	x : Pos;
	y : Pos;
}

LOAD_DEFAULT                      :: 0x0000;
LOAD_NO_SCALE                     :: 0x0001;
LOAD_NO_HINTING                   :: 0x0002;
LOAD_RENDER                       :: 0x0004;
LOAD_NO_BITMAP                    :: 0x0008;
LOAD_VERTICAL_LAYOUT              :: 0x0010;
LOAD_FORCE_AUTOHINT               :: 0x0020;
LOAD_CROP_BITMAP                  :: 0x0040;
LOAD_PEDANTIC                     :: 0x0080;
LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH  :: 0x0200;
LOAD_NO_RECURSE                   :: 0x0400;
LOAD_IGNORE_TRANSFORM             :: 0x0800;
LOAD_MONOCHROME                   :: 0x1000;
LOAD_LINEAR_DESIGN                :: 0x2000;
LOAD_NO_AUTOHINT                  :: 0x8000;
LOAD_COLOR                        :: 0x20000;

FACE_FLAG_SCALABLE          :: 0x0000;
FACE_FLAG_FIXED_SIZES       :: 0x0001;
FACE_FLAG_FIXED_WIDTH       :: 0x0002;
FACE_FLAG_SFNT              :: 0x0004;
FACE_FLAG_HORIZONTAL        :: 0x0008;
FACE_FLAG_VERTICAL          :: 0x0010;
FACE_FLAG_KERNING           :: 0x0020;
FACE_FLAG_FAST_GLYPHS       :: 0x0040;
FACE_FLAG_MULTIPLE_MASTERS  :: 0x0080;
FACE_FLAG_GLYPH_NAMES       :: 0x0100;
FACE_FLAG_EXTERNAL_STREAM   :: 0x0200;
FACE_FLAG_HINTER            :: 0x0400;
FACE_FLAG_CID_KEYED         :: 0x0800;
FACE_FLAG_TRICKY            :: 0x1000;
FACE_FLAG_COLOR             :: 0x2000;

KERNING_DEFAULT   : u32 : 0;
KERNING_UNFITTED  : u32 : 1;
KERNING_UNSCALED  : u32 : 2;

ENCODING_UNICODE : u32 : 0x756e6963;

TTAG_GSUB : u32 : 0x47535542;

Glyph_Metrics :: struct
{
	width  : Pos;
	height : Pos;

	horiBearingX : Pos;
	horiBearingY : Pos;
	horiAdvance  : Pos;

	vertBearingX : Pos;
	vertBearingY : Pos;
	vertAdvance  : Pos;
}

Glyph_Format :: enum u32
{
	PLACEHOLDER :: 0;
}

Bitmap :: struct
{
	rows : s32;
	width : s32;
	pitch : s32;
	buffer : *u8;
	num_grays : s16;
	pixel_mode : s8;
	palette_mode : s8;
	palette : *void;
}

Size_Metrics :: struct
{
	x_ppem : UShort;      /* horizontal pixels per EM               */
	y_ppem : UShort;      /* vertical pixels per EM                 */

	x_scale : Fixed;     /* scaling values used to convert font    */
	y_scale : Fixed;     /* units to 26.6 fractional pixels        */

	ascender : Pos;    /* ascender in 26.6 frac. pixels          */
	descender : Pos;   /* descender in 26.6 frac. pixels         */
	height : Pos;      /* text height in 26.6 frac. pixels       */
	max_advance : Pos; /* max horizontal advance, in 26.6 pixels */
}

SizeRec :: struct
{
	face : Face;
	generic : Generic;
	metrics : Size_Metrics;
	internal : *Size_InternalRec;
}

BBox :: struct
{
	xMin : Pos;
	yMin : Pos;
	xMax : Pos;
	yMax : Pos;
}

ListRec :: struct
{
	head : *ListNode;
	tail : *ListNode;
}

#if OS == .WINDOWS
{
	Long  :: s32;
	ULong :: u32;
	Int  :: s32;
	UInt :: u32;
	UShort :: u16;
	Short  :: s16;

	Fixed :: u32;
	Pos   :: s32;

}
else
{
	Long  :: s64;
	ULong :: u64;
	UShort :: u16;
	Short  :: s16;
	Int  :: s32;
	UInt :: u32;

	Fixed :: u64;
	Pos   :: s64;
}

FaceRec :: struct
{
	num_faces : Long;
	face_index : Long;

	face_flags : Long;
	style_flags : Long;

	num_glyphs : Long;

	family_name : *u8;
	style_name : *u8;

	num_fixed_sizes : Int;
	available_sizes : *void;   // Was *Bitmap_Size; ignoring for now.

	num_charmaps : Int;
	charmaps : *void;  // Going to ignore this for now.

	generic : Generic;

	/*# The following member variables (down to `underline_thickness') */
	/*# are only relevant to scalable outlines; cf. @Bitmap_Size    */
	/*# for bitmap fonts.                                              */

	bbox : BBox;

	units_per_EM : UShort;
	ascender : Short;
	descender : Short;
	height : Short;

	max_advance_width  : Short;
	max_advance_height : Short;

	underline_position  : Short;
	underline_thickness : Short;

	glyph : *GlyphSlotRec;
	size : *SizeRec;
	charmap : *CharMapRec;

	/*@private begin */

	driver : *void;
	memory : *MemoryRec;
	stream : *StreamRec;

	sizes_list : ListRec;

	autohint : Generic;
	extensions : *void;

	internal : *Face_Internal;

	/*@private end */
}

Outline :: struct
{
	n_contours : s16;      /* number of contours in glyph        */
	n_points : s16;      /* number of points in the glyph      */

	points : *Vector;   /* the outline's points               */
	tags : *u8;      /* the points flags                   */
	contours : *s16;     /* the contour end points             */

	flags : s32;      /* outline masks                      */
}

Face :: *FaceRec;

#scope_file

#if OS == .WINDOWS
	ft :: #foreign_library "win/freetype255MT";
else #if OS == .LINUX
	ft :: #foreign_library "linux/freetype255MT";
else #if OS == .MACOS
	ft :: #foreign_library "mac/libfreetype";
