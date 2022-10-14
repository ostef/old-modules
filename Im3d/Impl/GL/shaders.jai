SHADER_HEADER :: #string GLSL
#define Vertex_Data\
	_Vertex_Data\
	{\
		noperspective float edge_distance;\
		noperspective float size;\
		smooth        vec4  color;\
	}

#define ANTIALIASING 2.0
GLSL

POINTS_HEADER :: #run str.join ("#version 330 core\n#define POINTS\n", SHADER_HEADER);
LINES_HEADER :: #run str.join ("#version 330 core\n#define LINES\n", SHADER_HEADER);
TRIANGLES_HEADER :: #run str.join ("#version 330 core\n#define TRIANGLES\n", SHADER_HEADER);

VERTEX_SHADER :: #string GLSL

layout (location = 0) in vec4 a_Position_Size;
layout (location = 1) in vec4 a_Color;

uniform mat4 u_View_Projection_Matrix;

out Vertex_Data Data;

void main ()
{
	Data.color = a_Color.abgr;
	#if !defined (TRIANGLES)
		Data.color.a *= smoothstep (0.0, 1.0, a_Position_Size.w / ANTIALIASING);
	#endif
	Data.size = max (a_Position_Size.w, ANTIALIASING);
	gl_Position = u_View_Projection_Matrix * vec4 (a_Position_Size.xyz, 1.0);
	#if defined (POINTS)
		gl_PointSize = Data.size;
	#endif
}
GLSL

GEOMETRY_SHADER :: #string GLSL

uniform vec2 u_Viewport;

layout (lines) in;
layout (triangle_strip, max_vertices = 4) out;

in  Vertex_Data Data_Input[];
out Vertex_Data Data_Output;

void main ()
{
	vec2 pos0 = gl_in[0].gl_Position.xy / gl_in[0].gl_Position.w;
	vec2 pos1 = gl_in[1].gl_Position.xy / gl_in[1].gl_Position.w;

	vec2 dir = pos0 - pos1;
	dir = normalize (vec2 (dir.x, dir.y * u_Viewport.y / u_Viewport.x));
	vec2 tng0 = vec2 (-dir.y, dir.x);
	vec2 tng1 = tng0 * Data_Input[1].size / u_Viewport;
	tng0 = tng0 * Data_Input[0].size / u_Viewport;

	gl_Position = vec4 ((pos0 - tng0) * gl_in[0].gl_Position.w, gl_in[0].gl_Position.zw);
	Data_Output.edge_distance = -Data_Input[0].size;
	Data_Output.size          =  Data_Input[0].size;
	Data_Output.color         =  Data_Input[0].color;
	EmitVertex ();

	gl_Position = vec4 ((pos0 + tng0) * gl_in[0].gl_Position.w, gl_in[0].gl_Position.zw);
	Data_Output.edge_distance = Data_Input[0].size;
	Data_Output.size          = Data_Input[0].size;
	Data_Output.color         = Data_Input[0].color;
	EmitVertex ();

	gl_Position = vec4 ((pos1 - tng1) * gl_in[1].gl_Position.w, gl_in[1].gl_Position.zw);
	Data_Output.edge_distance = -Data_Input[1].size;
	Data_Output.size          =  Data_Input[1].size;
	Data_Output.color         =  Data_Input[1].color;
	EmitVertex ();

	gl_Position = vec4 ((pos1 + tng1) * gl_in[1].gl_Position.w, gl_in[1].gl_Position.zw);
	Data_Output.edge_distance = Data_Input[1].size;
	Data_Output.size          = Data_Input[1].size;
	Data_Output.color         = Data_Input[1].color;
	EmitVertex ();
}
GLSL

FRAGMENT_SHADER :: #string GLSL

in Vertex_Data Data;

layout (location = 0) out vec4 Frag_Color;

void main ()
{
	Frag_Color = Data.color;

	#if defined (LINES)
		float d = abs (Data.edge_distance) / Data.size;
		d = smoothstep (1.0, 1.0 - (ANTIALIASING / Data.size), d);
		Frag_Color.a *= d;
	#elif defined (POINTS)
		float d = length (gl_PointCoord.xy - vec2 (0.5, 0.5));
		d = smoothstep (0.5, 0.5 - (ANTIALIASING / Data.size), d);
		Frag_Color.a *= d;
	#endif
}
GLSL
