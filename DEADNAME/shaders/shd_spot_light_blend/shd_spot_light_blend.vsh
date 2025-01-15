//
// Spot Light Blend vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec2 in_Position; 		// (x, y)

// Uniform Light Source Properties
uniform float in_Radius;
uniform vec2 in_CenterPoint;

// Uniform Surface Position and Size Properties
uniform vec2 in_SurfaceSize;
uniform vec2 in_SurfacePosition;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

// Vertex Shader
void main() 
{
	// World Position
	vec2 vertex_position = in_CenterPoint + (in_Position * in_Radius);
	
	// Point Light Position
	v_vPosition = (in_Position * 0.5) + 0.5;
	
	// Point Light Surface UV
	v_vSurfaceUV = (vertex_position - in_SurfacePosition) / in_SurfaceSize;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(vertex_position.x, vertex_position.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
