//
// Lit Raymarched SDF Sphere Cloud vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y, z)

// Camera Properties
uniform vec3 in_vsh_CameraPosition;
uniform mat4 in_vsh_CameraRotation;
uniform vec2 in_vsh_CameraDimensions;

// Atmosphere Properties
uniform float u_vsh_AtmosphereRadius;

// Planet Properties
uniform float u_PlanetRadius;
uniform vec3 u_PlanetPosition;
uniform vec3 u_PlanetEulerAngles;

// Cloud Properties
uniform vec2 u_CloudUV;
uniform float u_CloudRadius;
uniform float u_CloudHeight;

uniform float u_vsh_CloudSampleRadius;

// Interpolated Square UV, Surface Mask UV, and World Position
varying vec2 v_vSquareUV;
varying vec4 v_vSurfaceUV;
varying vec3 v_vLocalPosition;
varying vec3 v_vSampleForward;
varying vec3 v_vSamplePosition;

// Constants
const float Pi = 3.14159265359;

const vec3 right_vector = vec3(1.0, 0.0, 0.0);
const vec3 up_vector = vec3(0.0, 1.0, 0.0);
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);

// UV Functions
vec3 sphereVectorFromUV(vec2 uv)
{
	// Find Vertical Sphere Vector
	float atan_value = (0.5 - uv.x) * 2.0 * Pi;
	float asin_value = (0.5 - uv.y) * Pi;
	float y_value = -sin(asin_value);
	
	// Find Horizontal and Forwards Sphere Vectors
	float sphere_horizontal_radius = sqrt(1.0 - y_value * y_value);
	float x_value = sphere_horizontal_radius * -sin(atan_value);
	float z_value = sphere_horizontal_radius * -cos(atan_value);
	
	// Return assembled Sphere Vector
	return vec3(x_value, y_value, z_value);
}

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

mat3 inverse(mat3 m) 
{
	float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2];
	float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2];
	float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2];
	
	float b01 = a22 * a11 - a12 * a21;
	float b11 = -a22 * a10 + a12 * a20;
	float b21 = a21 * a10 - a11 * a20;
	
	float det = a00 * b01 + a01 * b11 + a02 * b21;

	return mat3(b01, (-a22 * a01 + a02 * a21), (a12 * a01 - a02 * a11), b11, (a22 * a00 - a02 * a20), (-a12 * a00 + a02 * a10), b21, (-a21 * a00 + a01 * a20), (a11 * a00 - a01 * a10)) / det;
}

// Vertex Shader
void main() 
{
	// Calculate Camera Right and Up Vectors from Camera's Rotation Matrix
	vec3 camera_right = normalize(in_vsh_CameraRotation[0].xyz);
	vec3 camera_up = normalize(in_vsh_CameraRotation[1].xyz);
	vec3 camera_forward = normalize(in_vsh_CameraRotation[2].xyz);
	
	// Calculate Planet Rotation Matrix from Planet's Euler Angles
	mat3 planet_rotation_matrix = eulerRotationMatrix(-u_PlanetEulerAngles);
	mat3 inverse_planet_rotation_matrix = inverse(planet_rotation_matrix);
	
	// Convert Cloud UV into Normalized Position Vector Relative to Planet Center
	vec3 cloud_sphere_vector = sphereVectorFromUV(u_CloudUV);
	
	// Calculate Render Planet Position with Camera Rotation Matrix
	vec4 planet_position = vec4(u_PlanetPosition - in_vsh_CameraPosition * inverse_vertical_vector, 1.0) * in_vsh_CameraRotation;
	
	// Calculate Cloud Offset from Planet Center
	vec3 cloud_planet_center_offset = (u_PlanetRadius + u_CloudHeight) * cloud_sphere_vector * planet_rotation_matrix;
	
	// Calculate Render Cloud Vertex Position with Camera Rotation Matrix
	vec4 cloud_world_position = vec4(u_PlanetPosition + cloud_planet_center_offset - in_vsh_CameraPosition * inverse_vertical_vector, 1.0) * in_vsh_CameraRotation;
	vec4 cloud_vertex_position = cloud_world_position + vec4(in_Position * u_CloudRadius, 0.0, 0.0);
	
	// Interpolated Square UV and Surface UV
	v_vSquareUV = (in_Position * 0.5) + 0.5;
	v_vSurfaceUV = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(cloud_vertex_position.xyz * inverse_vertical_vector + vec3(in_vsh_CameraDimensions * 0.5, 0.0), 1.0);
	
	// Interpolated World Position
	vec3 planet_position_horizontal = camera_right * in_Position.x * u_CloudRadius;
	vec3 planet_position_vertical = camera_up * in_Position.y * u_CloudRadius;
	v_vLocalPosition = cloud_planet_center_offset + planet_position_horizontal + planet_position_vertical;
	
	// Interpolated Sample Position
	vec3 sample_position_horizontal = camera_right * in_Position.x * u_CloudRadius * inverse_planet_rotation_matrix;
	vec3 sample_position_vertical = camera_up * in_Position.y * u_CloudRadius * inverse_planet_rotation_matrix;
	v_vSampleForward = camera_forward * inverse_planet_rotation_matrix;
	v_vSamplePosition = (u_PlanetRadius + u_CloudHeight) * cloud_sphere_vector + sample_position_horizontal + sample_position_vertical;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(cloud_vertex_position.xyz + vec3(in_vsh_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}