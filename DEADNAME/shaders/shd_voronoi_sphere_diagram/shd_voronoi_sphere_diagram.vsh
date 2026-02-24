//
// Voronoi Sphere Diagram vertex shader that Inno made for her Projects
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Texture Size Settings
uniform float u_TextureSize;

// Interpolated UV
varying vec2 v_vTexcoord;

// Vertex Shader
void main() 
{
	// Set Interpolated UV from Square's Vertex Position
	v_vTexcoord = in_Position;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x * u_TextureSize * 2.0, in_Position.y * u_TextureSize, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
