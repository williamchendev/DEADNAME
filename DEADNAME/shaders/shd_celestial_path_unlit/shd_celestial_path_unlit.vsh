//
// (Multi Render Target) Unlit Pathfinding Path vertex shader for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

// Interpolated Color & Texture UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Vertex Shader
void main()
{
	// Interpolated Colors & Texture UVs
	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
	
	// Set Vertex Positions
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
