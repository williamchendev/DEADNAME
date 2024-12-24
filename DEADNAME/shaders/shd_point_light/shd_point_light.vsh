///

//
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)

//
uniform float in_Radius;
uniform vec2 in_CenterPoint;

//
varying vec4 v_vColour;
varying vec4 v_vNormal;

//
const float HalfPi = 1.57079632679;

//
void main() 
{
	//
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

	//
	v_vColour = in_Colour;
	
	//
	vec2 Pos = vec2(in_Position.x, in_Position.y) - in_CenterPoint;
	Pos.y = -Pos.y;
	
	//
	float Dis = 1.0 - pow((sqrt(dot(Pos, Pos)) / in_Radius), 2.0);
	
	//
	vec2 Vec = (sin((Pos / in_Radius) * HalfPi) + 1.0) / 2.0;
	vec3 Norm = normalize(vec3(Vec, max(max(Vec.x, Vec.y), 1.0)));
	
	//
	v_vNormal = vec4((Norm * 0.8) + 0.2, 1.0);
}