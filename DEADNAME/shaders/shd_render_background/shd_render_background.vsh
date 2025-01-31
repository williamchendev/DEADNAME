//
// Background Surface Rendering vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec2 in_Position; 		// (x, y)

// Uniform Screen Settings
uniform vec2 in_SurfaceSize;

// Uniform Background Settings
uniform vec2 in_Background_Size;
uniform vec2 in_Background_Trim;

// Interpolated Color and UVs
varying vec2 v_vTexcoord;

// Vertex Shader
void main() 
{
	// Vertex Position
	vec2 VertexPosition = (in_SurfaceSize * 0.5) + ((in_Position - 0.5) * in_Background_Size);
	
	// Surface UV
	v_vTexcoord = in_Position;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(VertexPosition.x, VertexPosition.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}