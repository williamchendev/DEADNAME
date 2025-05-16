//
// (Multi Render Target) Dynamic Primitive vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 		// (x, y, z)
attribute vec4 in_Colour;			// (r, g, b, a)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Interpolated Color
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Vertex Shader
void main() 
{
	// Set Interpolated Color
	v_vColour = in_Colour;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
