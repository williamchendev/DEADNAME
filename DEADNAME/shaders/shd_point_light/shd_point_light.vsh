///

//
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

//
uniform float in_Radius;
uniform vec2 in_CenterPoint;

uniform vec2 in_SurfaceSize;
uniform vec2 in_SurfacePosition;

//
varying vec4 v_vColour;
varying vec4 v_vNormal;
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

//
const vec2 Center = vec2(0.5, 0.5);
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
	vec2 Norm = normalize(Center - in_TextureCoord);
	//vec2 Norm = normalize(Center - in_TextureCoord);
	float Dis = pow(1.0 - (distance(in_TextureCoord, Center) * 2.0), 2.0);
	v_vNormal = vec4(Norm.x, -Norm.y, 1.0 - Dis, 1.0);
	
	//
	v_vPosition = in_TextureCoord;
	
	//
	//float Dis = distance(v_vPosition, vec2(0.5, 0.5));
	//vec2 Vec = sin(v_vPosition * HalfPi);
	//v_vNormal = vec4(Vec.x, 1.0 - Vec.y, cos(Dis * HalfPi), 1.0);
	
	//
	v_vSurfaceUV = (in_Position.xy - in_SurfacePosition) / in_SurfaceSize;
	
	
	
	
	
	
	
	//
	//vec2 Pos = in_TextureCoord;
	//v_vNormal = vec4(Pos.x, 1.0 - Pos.y, 0, 1.0);
	
	//
	//float Dis = 1.0 - pow((sqrt(dot(Pos, Pos)) / in_Radius), 2.0);
	
	
	//
	//vec2 Vec = sin(v_vPosition * HalfPi);
	//v_vNormal = vec4(Vec.x, 1.0 - Vec.y, 0.5, 1.0);
	
	//
	//Pos = ((Pos + (in_Radius / 2.0)) / in_Radius);
	//Vec = Pos;
	//
}