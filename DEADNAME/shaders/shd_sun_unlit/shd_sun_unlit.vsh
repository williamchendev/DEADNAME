//
// Forward Rendered Lit Planet Lithosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_Elevation; // (u, v)

// Camera Properties
uniform vec3 in_camera_position;
uniform mat4 in_camera_rotation;
uniform vec2 in_camera_dimensions;

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
	// Create Rotation Matrix from Euler Angles
	mat3 rotation_matrix = eulerRotationMatrix(u_EulerAngles);
	
	// Apply Rotation Matrix to the Position Vector
	vec3 rotated_vector = rotation_matrix * in_Position;
	
	// Calculate Vertex Position relative to Origin
	vec3 vertex_position = rotated_vector * u_Radius;
	
	// Calculate Render Vertex Position with Camera Rotation Matrix
	vec4 render_position = vec4(vertex_position + u_Position - in_camera_position * inverse_vertical_vector, 1.0) * in_camera_rotation;
	
	// Interpolated Color, Normal, Position, and Sphere Texture Vector
	v_vColour = in_Colour;
	v_vNormal = rotated_vector;
	v_vPosition = vertex_position + u_Position;
	v_vTexVector = in_Position;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(render_position.xyz + vec3(in_camera_dimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
