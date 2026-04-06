//
// Lit Raymarched SDF Sphere Cloud vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Planet Properties
uniform float u_vsh_PlanetRadius;
uniform vec3 u_vsh_PlanetPosition;
uniform vec3 u_PlanetEulerAngles;

// Cloud Properties
uniform vec2 u_CloudUV;
uniform float u_vsh_CloudRadius;
uniform float u_CloudHeight;

// Interpolated Surface Mask UV, Cloud Position, Local Position, Sample Position, and Inverse Planet Rotation Matrix
varying vec2 v_vSurfaceUV;
varying vec3 v_vCloudPosition;
varying vec3 v_vLocalPosition;
varying vec3 v_vSamplePosition;
varying mat3 v_vInvPlanetRotation;

// Constants
const float Pi = 3.14159265359;

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
	
	// Build rotation matrix (Tait–Bryan YZX order - pitch, yaw, roll)
	mat3 rotMatrix;
	
	rotMatrix[0][0] =  cp * cy;
	rotMatrix[0][1] =  sy;
	rotMatrix[0][2] = -cy * sp;
	
	rotMatrix[1][0] =  sp * sr - cp * cr * sy;
	rotMatrix[1][1] =  cy * cr;
	rotMatrix[1][2] =  cp * sr + cr * sp * sy;
	
	rotMatrix[2][0] =  cr * sp + cp * sy * sr;
	rotMatrix[2][1] = -cy * sr;
	rotMatrix[2][2] =  cp * cr - sp * sy * sr;
	
	/*
	// Inverse Rotation Matrix ^^^
	
	rotMatrix[0][0] = cp * cy;
	rotMatrix[0][1] = sp * sr - cp * cr * sy;
	rotMatrix[0][2] = cr * sp + cp * sy * sr;
	
	rotMatrix[1][0] = sy;
	rotMatrix[1][1] = cy * cr;
	rotMatrix[1][2] = -cy * sr;
	
	rotMatrix[2][0] = -cy * sp;
	rotMatrix[2][1] = cp * sr + cr * sp * sy;
	rotMatrix[2][2] = cp * cr - sp * sy * sr;
	*/
	
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
	// Calculate Camera Right, Up, and Forward Vectors from Camera's View Matrix
	vec3 camera_right = normalize(vec3(gm_Matrices[MATRIX_VIEW][0][0], gm_Matrices[MATRIX_VIEW][1][0], gm_Matrices[MATRIX_VIEW][2][0]));
	vec3 camera_up = normalize(vec3(gm_Matrices[MATRIX_VIEW][0][1], gm_Matrices[MATRIX_VIEW][1][1], gm_Matrices[MATRIX_VIEW][2][1]));
	
	// Calculate Planet Rotation Matrix from Planet's Euler Angles
	mat3 planet_rotation_matrix = eulerRotationMatrix(u_PlanetEulerAngles);
	mat3 inverse_planet_rotation_matrix = inverse(planet_rotation_matrix);
	
	// Convert Cloud UV into Normalized Position Vector Relative to Planet Center
	vec3 cloud_sphere_vector = sphereVectorFromUV(u_CloudUV);
	
	// Translate Square UV into Square Offset matching Camera's Orientation
	vec3 camera_quad_offset = camera_right * in_Position.x + camera_up * in_Position.y;
	
	// Calculate Cloud's Offset from Planet's Center Pivot Position
	vec3 cloud_to_planet_offset = (u_vsh_PlanetRadius + u_CloudHeight) * cloud_sphere_vector;
	
	// Calculate Imposter Sphere's Quad Vertex World Positions
	vec3 vertex_local_position = cloud_to_planet_offset * planet_rotation_matrix + (camera_quad_offset * u_vsh_CloudRadius * 2.0);
	vec4 vertex_world_position = vec4(vertex_local_position + u_vsh_PlanetPosition, 1.0);
	
	// Interpolated Local Position
	v_vLocalPosition = vertex_local_position;
	v_vCloudPosition = u_vsh_PlanetPosition + cloud_to_planet_offset * planet_rotation_matrix;
	
	// Interpolated Sample Position
	v_vSamplePosition = cloud_to_planet_offset - (camera_quad_offset * u_vsh_CloudRadius * 2.0) * inverse_planet_rotation_matrix;
	
	// Interpolated Inverse Planet Rotation Matrix
	v_vInvPlanetRotation = inverse_planet_rotation_matrix;
	
	// Translate Imposter Sphere's Quad Vertex World Positions to Clip Space Position
	gl_Position = gm_Matrices[MATRIX_PROJECTION] * gm_Matrices[MATRIX_VIEW] * vertex_world_position;
	
	// Update Surface Mask UV from Clip Space Position
	v_vSurfaceUV = (vec2(gl_Position.x, -gl_Position.y) / gl_Position.w) * 0.5 + 0.5;
}
