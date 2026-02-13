//
// Forward Rendered Lit Planet without Atmosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Camera Properties
uniform vec3 in_CameraPosition;
uniform mat4 in_CameraRotation;
uniform vec2 in_CameraDimensions;

// Planet Properties
uniform float u_PlanetRadius;
uniform vec3 u_PlanetPosition;

// Interpolated Surface Mask UV
varying vec4 v_vSurfaceUV;

// Constants
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);

// Vertex Shader
void main() 
{
	// Calculate Render Vertex Position with Camera Rotation Matrix
	vec4 vertex_position = vec4(u_PlanetPosition - in_CameraPosition * inverse_vertical_vector, 1.0) * in_CameraRotation;
	vertex_position += vec4(in_Position * u_PlanetRadius, 0.0, 0.0);
	
	// Interpolated Surface UV
	v_vSurfaceUV = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
