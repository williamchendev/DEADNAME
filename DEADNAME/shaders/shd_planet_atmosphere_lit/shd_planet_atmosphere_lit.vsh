//
// Forward Rendered Lit Planet Atmosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Camera Properties
uniform vec3 in_vsh_CameraPosition;
uniform mat4 in_vsh_CameraRotation;
uniform vec2 in_CameraDimensions;

// Atmosphere Properties
uniform float u_vsh_AtmosphereRadius;

// Planet Properties
uniform vec3 u_vsh_PlanetPosition;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec4 v_vSurfaceUV;
varying vec3 v_vWorldPosition;

// Constants
const vec3 up_vector = vec3(0.0, 1.0, 0.0);
const vec3 right_vector = vec3(1.0, 0.0, 0.0);
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);

// Rotation Matrix Functions
mat3 eulerRotationMatrix(vec3 euler_angles) 
{
	// Convert Euler Angles from Degrees to Radians
	float pitch = radians(euler_angles.x);
	float yaw = radians(euler_angles.y);
	float roll = radians(euler_angles.z);
	
	// Pre-calculate Sin and Cos values
	float cp = cos(pitch);
	float sp = sin(pitch);
	float cy = cos(yaw);
	float sy = sin(yaw);
	float cr = cos(roll);
	float sr = sin(roll);
	
	// Build rotation matrix (ZYX order - roll, yaw, pitch)
	mat3 rotMatrix;
    
    rotMatrix[0][0] = cy * cr;
    rotMatrix[0][1] = cy * sr;
    rotMatrix[0][2] = -sy;
    
    rotMatrix[1][0] = sp * sy * cr - cp * sr;
    rotMatrix[1][1] = sp * sy * sr + cp * cr;
    rotMatrix[1][2] = sp * cy;
    
    rotMatrix[2][0] = cp * sy * cr + sp * sr;
    rotMatrix[2][1] = cp * sy * sr - sp * cr;
    rotMatrix[2][2] = cp * cy;
	
	// Return Rotation Matrix
	return rotMatrix;
}

// Vertex Shader
void main() 
{
	// Calculate Render Vertex Position with Camera Rotation Matrix
	vec4 vertex_position = vec4(u_vsh_PlanetPosition - in_vsh_CameraPosition * inverse_vertical_vector, 1.0) * in_vsh_CameraRotation;
	vertex_position += vec4(in_Position * u_vsh_AtmosphereRadius, 0.0, 0.0);
	
	// Interpolated Position & Surface UV
	v_vPosition = (in_Position * 0.5) + 0.5;
	v_vSurfaceUV = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	
	// Interpolated World Position
	vec4 planet_position_horizontal = vec4(right_vector * in_Position.x * u_vsh_AtmosphereRadius, 0.0) * in_vsh_CameraRotation;
	vec4 planet_position_vertical = vec4(-up_vector * in_Position.y * u_vsh_AtmosphereRadius, 0.0) * in_vsh_CameraRotation;
	v_vWorldPosition = u_vsh_PlanetPosition + planet_position_horizontal.xyz + planet_position_vertical.xyz;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}