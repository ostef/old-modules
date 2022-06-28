#load "window.jai";
#load "button.jai";

Common_Style :: struct
{
	background_color : math.RGBA;
	border_color : math.RGBA;
	border_thickness : f32;
	border_inset : f32;
	// @Todo
	corner_radiuses : struct
	{
		top_left     : f32;
		top_right    : f32;
		bottom_left  : f32;
		bottom_right : f32;
	};
}
