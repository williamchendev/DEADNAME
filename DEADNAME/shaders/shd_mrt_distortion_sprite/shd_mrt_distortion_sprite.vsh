//
// MRT Distortion Sprite Drawing vertex shader for Inno's Rendering System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 		// (x, y, z)
attribute vec4 in_Colour;			// (r, g, b, a)
attribute vec2 in_TextureCoord; 	// (u, v)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Vertex Shader
void main() 
{
	// Render Color & Surface UV
	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}