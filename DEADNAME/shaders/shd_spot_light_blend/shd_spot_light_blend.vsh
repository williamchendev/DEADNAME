//
// Spot Light Blend vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec2 in_Position; 		// (x, y)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Uniform Light Source Properties
uniform float in_Radius;
uniform vec2 in_CenterPoint;

// Uniform Surface Size Properties
uniform vec2 in_SurfaceSize;

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
	v_vSurfaceUV = (vertex_position - in_Camera_Offset) / in_SurfaceSize;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(vertex_position.x - in_Camera_Offset.x, vertex_position.y - in_Camera_Offset.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
