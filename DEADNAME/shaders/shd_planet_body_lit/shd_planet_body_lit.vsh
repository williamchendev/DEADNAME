//
// Forward Rendered Lit Planet Body vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec3 in_Normal; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

// Planet Body Properties
uniform float u_Radius;
uniform vec3 u_Position;
uniform vec3 u_EulerAngles;

// Interpolated Color, Normal, Position, and Sphere Texture Vector
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;

// Rotation Matrix Functions
mat4 eulerRotationMatrix(vec3 euler_angles) 
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
	mat4 rotMatrix;
    
    rotMatrix[0][0] = cy * cr;
    rotMatrix[0][1] = cy * sr;
    rotMatrix[0][2] = -sy;
    rotMatrix[0][3] = 0.0;
    
    rotMatrix[1][0] = sp * sy * cr - cp * sr;
    rotMatrix[1][1] = sp * sy * sr + cp * cr;
    rotMatrix[1][2] = sp * cy;
    rotMatrix[1][3] = 0.0;
    
    rotMatrix[2][0] = cp * sy * cr + sp * sr;
    rotMatrix[2][1] = cp * sy * sr - sp * cr;
    rotMatrix[2][2] = cp * cy;
    rotMatrix[2][3] = 0.0;
    
    rotMatrix[3][0] = 0.0;
    rotMatrix[3][1] = 0.0;
    rotMatrix[3][2] = 0.0;
    rotMatrix[3][3] = 1.0;
	
	// Return Rotation Matrix
	return rotMatrix;
}

// Vertex Shader
void main() 
{
	// Create rotation matrix from Euler Angles
	mat4 rotation_matrix = eulerRotationMatrix(u_EulerAngles);
	
	// Apply rotation to the Vertex Position
	vec4 rotated_position = rotation_matrix * vec4(in_Position * u_Radius, 1.0);
	
	// Interpolated Color, Normal, Position, and Sphere Texture Vector
	v_vColour = in_Colour;
	v_vNormal = normalize(rotated_position.xyz);
	v_vPosition = rotated_position.xyz + u_Position;
	v_vTexVector = normalize(in_Position);
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(rotated_position.xyz + u_Position, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
