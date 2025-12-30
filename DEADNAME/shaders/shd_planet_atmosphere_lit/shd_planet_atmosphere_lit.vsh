//
// Forward Rendered Lit Planet Atmosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Camera Properties
uniform vec3 in_vsh_CameraPosition;
uniform mat4 in_vsh_CameraRotation;
uniform vec2 in_vsh_CameraDimensions;

// Atmosphere Properties
uniform float u_vsh_AtmosphereRadius;

// Planet Properties
uniform vec3 u_vsh_PlanetPosition;

// Interpolated Square UV, Surface Mask UV, and World Position
varying vec2 v_vSquareUV;
varying vec4 v_vSurfaceUV;
varying vec3 v_vWorldPosition;

// Constants
const vec3 right_vector = vec3(1.0, 0.0, 0.0);
const vec3 up_vector = vec3(0.0, 1.0, 0.0);
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);

// Vertex Shader
void main() 
{
	// Calculate Render Vertex Position with Camera Rotation Matrix
	vec4 vertex_position = vec4(u_vsh_PlanetPosition - in_vsh_CameraPosition * inverse_vertical_vector, 1.0) * in_vsh_CameraRotation;
	vertex_position += vec4(in_Position * u_vsh_AtmosphereRadius, 0.0, 0.0);
	
	// Interpolated Square UV and Surface UV
	v_vSquareUV = (in_Position * 0.5) + 0.5;
	v_vSurfaceUV = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_vsh_CameraDimensions * 0.5, 0.0), 1.0);
	
	// Calculate Camera Right and Up Vectors from Camera's Rotation Matrix
	vec3 camera_right = normalize(in_vsh_CameraRotation[0].xyz);
	vec3 camera_up = normalize(in_vsh_CameraRotation[1].xyz);
	
	// Interpolated World Position
	vec3 planet_position_horizontal = camera_right * in_Position.x * u_vsh_AtmosphereRadius;
	vec3 planet_position_vertical = camera_up * in_Position.y * u_vsh_AtmosphereRadius;
	v_vWorldPosition = u_vsh_PlanetPosition + planet_position_horizontal + planet_position_vertical;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_vsh_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
