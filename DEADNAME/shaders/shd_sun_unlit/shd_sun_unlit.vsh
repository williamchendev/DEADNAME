//
// Forward Rendered Sun vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_Elevation; // (u, v)

// Planet Properties
uniform float u_Radius;
uniform float u_Elevation;
uniform vec3 u_Position;
uniform vec3 u_EulerAngles;

// Interpolated Color, Normal, Position, and Sphere Texture Vector
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;

// Constants
const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);

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

// Vertex Shader
void main() 
{
	// Create Rotation Matrix of Sun from Sun's Euler Angle Rotation
	mat3 rotation_matrix = eulerRotationMatrix(u_EulerAngles);
	
	// Calculate Sun's Vertex Elevation based on Sun's Radius and Elevation
	float vertex_elevation = u_Radius + (in_Elevation.x * u_Elevation);
	
	// Calculate Sun's Local Vector, Rotated Local Vector, and Local Elevation Vector relative to Origin
	vec3 local_vector = in_Position * inverse_vertical_vector;
	vec3 rotated_local_vector = local_vector * rotation_matrix;
	vec3 rotated_local_vector_elevation = rotated_local_vector * vertex_elevation;
	
	// Calculate Sun's Object Space Vertex Position
	vec4 object_space_position = vec4(local_vector * vertex_elevation, 1.0);
	
	// Interpolated Color, Normal, Position, and Sphere Texture Vector
	v_vColour = in_Colour;
	v_vNormal = rotated_local_vector;
	v_vPosition = rotated_local_vector_elevation + u_Position;
	v_vTexVector = in_Position;
	
	// Set Vertex Positions
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_position;
}
