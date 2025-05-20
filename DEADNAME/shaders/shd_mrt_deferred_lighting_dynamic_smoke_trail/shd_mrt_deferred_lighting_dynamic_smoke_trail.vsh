//
// (Multi Render Target) Dynamic Smoke Trail vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 		// (x, y, z)
attribute vec4 in_Colour;			// (r, g, b, a)
attribute vec2 in_TextureCoord; 	// (u, v)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Interpolated Texture UVs, Color, & Rotate
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying mat2 v_vRotate;

// Constants
const float TwoPi = 6.28318530718;

// Vertex Shader
void main() 
{
	// Set Interpolated Texture UVs & Color
	v_vColour = in_Colour;
	v_vTexcoord = (in_TextureCoord * 2.0) - 1.0;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
