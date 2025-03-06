//
// Ambient Occlusion Light Blend vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec2 in_Position; 		// (x, y)

// Uniform Surface Size Properties
uniform vec2 in_SurfaceSize;

// Interpolated UVs
varying vec2 v_vSurfaceUV;

// Vertex Shader
void main() 
{
	// Directional Light Color & Surface UV
	v_vSurfaceUV = in_Position;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x * in_SurfaceSize.x, in_Position.y * in_SurfaceSize.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
