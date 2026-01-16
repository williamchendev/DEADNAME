//
// Lit Raymarched SDF Sphere Cloud vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

//
uniform float u_TextureSize;

//
varying vec2 v_vTexcoord;

//
void main() 
{
	//
	v_vTexcoord = in_Position;
	
	//
	vec4 object_space_pos = vec4(in_Position.x * u_TextureSize, in_Position.y * u_TextureSize, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
