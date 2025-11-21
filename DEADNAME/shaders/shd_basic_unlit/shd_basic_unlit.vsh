//
// Basic Unlit vertex shader meant to test rendering 3D models
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec3 in_Normal; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

// Interpolated Color, Normal, & Texture UVs
varying vec3 v_vNormal;
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Vertex Shader
void main() 
{
	// Interpolated Colors, Normals, & Texture UVs
	v_vColour = in_Colour;
	v_vNormal = in_Normal;
	v_vTexcoord = in_TextureCoord;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}