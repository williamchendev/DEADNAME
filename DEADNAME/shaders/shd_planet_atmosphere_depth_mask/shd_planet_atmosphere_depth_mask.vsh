//
// Planet Atmosphere Depth Mask vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_Elevation; // (u, v)

// Camera Properties
uniform vec3 in_CameraPosition;
uniform mat4 in_CameraRotation;
uniform vec2 in_CameraDimensions;

// Atmosphere Properties
uniform float u_AtmosphereRadius;

// Hydrosphere Properties
uniform float u_PlanetOceanElevation;

// Planet Properties
uniform float u_PlanetRadius;
uniform float u_PlanetElevation;
uniform vec3 u_PlanetPosition;
uniform vec3 u_PlanetEulerAngles;

// Interpolated Depth
varying float v_vDepth;

// Constants
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);
const vec3 inverse_forward_vector = vec3(1.0, 1.0, -1.0);

// Rotation Matrix Functions
mat3 eulerRotationMatrix(vec3 euler_angles) 
{
	// Convert Euler Angles from Degrees to Radians
	float roll = radians(euler_angles.x);
	float pitch = radians(euler_angles.y);
	float yaw = radians(euler_angles.z);
	
	// Pre-calculate Sin and Cos values
	float cr = cos(roll);
	float sr = sin(roll);
	float cp = cos(pitch);
	float sp = sin(pitch);
	float cy = cos(yaw);
	float sy = sin(yaw);
	
	// Build rotation matrix (ZXY order - roll, yaw, pitch)
	mat3 rotMatrix;
    
    rotMatrix[0][0] = cy * cp - sr * sy * sp;
    rotMatrix[0][1] = sy * cp + sr * sp * cy;
    rotMatrix[0][2] = -sp * cr;
    
    rotMatrix[1][0] = -sy * cr;
    rotMatrix[1][1] = cr * cy;
    rotMatrix[1][2] = sr;
    
    rotMatrix[2][0] = sp * cy + sr * sy * cp;
    rotMatrix[2][1] = sp * sy - sr * cy * cp;
    rotMatrix[2][2] = cr * cp;
	
	// Return Rotation Matrix
	return rotMatrix;
}

// Vertex Shader
void main() 
{
	// Create Rotation Matrix of Planet from Planet's Euler Angle Rotation
	mat3 planet_rotation_matrix = eulerRotationMatrix(u_PlanetEulerAngles);
	
	// Calculate Planet's Local Vertex Vector and Vertex Position relative to Origin
	vec3 planet_rotated_local_vector = planet_rotation_matrix * in_Position;
	vec3 planet_rotated_local_vertex_position = planet_rotated_local_vector * (u_PlanetRadius + (max(in_Elevation.x, u_PlanetOceanElevation) * u_PlanetElevation));
	
	// Calculate Vertex Render Position relative to Camera Perspective
	vec4 render_position = vec4(planet_rotated_local_vertex_position + u_PlanetPosition - in_CameraPosition * inverse_vertical_vector, 1.0) * in_CameraRotation;
	
	// Calculate Depth of Elevated Vertex Position relative to Camera's Orientation and the Radius of Atmosphere
	vec3 camera_forward = normalize(in_CameraRotation[2].xyz);
	float depth_render_dot_product = dot(camera_forward, (planet_rotated_local_vertex_position.xyz * inverse_forward_vector) / u_AtmosphereRadius) * 0.5 + 0.5;
	
	// Interpolated Depth
	v_vDepth = depth_render_dot_product;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(render_position.xyz + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
