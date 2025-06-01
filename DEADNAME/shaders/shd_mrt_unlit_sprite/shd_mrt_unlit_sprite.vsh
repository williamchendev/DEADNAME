//
// (Multi Render Target) Unlit Sprite vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Uniform Surface Size Properties
uniform vec2 in_SurfaceSize;

// Interpolated Color & Texture UVs
varying vec2 v_vTexcoord;
varying vec2 v_vSurfaceUV;
varying vec4 v_vColour;

// Vertex Shader
void main() 
{
	// Interpolated Colors & Texture UVs
	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
	
	// Interpolated Surface UVs
	v_vSurfaceUV = (in_Position.xy - in_Camera_Offset) / in_SurfaceSize;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}