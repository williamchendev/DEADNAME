//
// Forward Rendered Lit Planet Atmosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec2 in_Position; // (x, y)

// Camera Properties
uniform vec3 in_vsh_camera_position;
uniform mat4 in_camera_rotation;
uniform vec2 in_camera_dimensions;
uniform mat4 in_camera_view_projection;

// Atmosphere Properties
uniform float u_vsh_Atmosphere_Mask_Radius;

// Planet Properties
uniform vec3 u_Position;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec4 v_vSurfaceUV;

// Constants
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
	vec4 vertex_position = vec4(u_Position - in_vsh_camera_position * inverse_vertical_vector, 1.0) * in_camera_rotation;
	vertex_position += vec4(in_Position * u_vsh_Atmosphere_Mask_Radius, 0.0, 0.0);
	
	// Interpolated Position
	v_vPosition = (in_Position * 0.5) + 0.5;
	
	//
	v_vSurfaceUV = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vertex_position.xyz + vec3(in_camera_dimensions * 0.5, 1.0), 1.0);
	
	// Point Light Surface UV
	//v_vSurfaceUV = vertex_position.xy / in_camera_dimensions;
	
	// Point Light Surface UV
	//vec4 vertex_transformed_position = vertex_position * in_camera_view_projection;
	//v_vSurfaceUV = (vertex_transformed_position.xy / vertex_transformed_position.w) / in_camera_dimensions;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(vertex_position.xyz * inverse_vertical_vector + vec3(in_camera_dimensions * 0.5, 1.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}