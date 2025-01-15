//
// Directional Light Blend vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec2 in_Position; 		// (x, y, z)
attribute vec4 in_Colour;			// (r, g, b, a)
attribute vec2 in_TextureCoord; 	// (u, v)

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vSurfaceUV;

// Vertex Shader
void main() 
{
	// Directional Light Color & Surface UV
	v_vColour = in_Colour;
	v_vSurfaceUV = in_TextureCoord;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
