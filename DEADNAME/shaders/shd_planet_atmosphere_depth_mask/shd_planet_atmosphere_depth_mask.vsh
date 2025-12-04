//
// Planet Atmosphere Depth Mask vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_Elevation; // (u, v)

// Camera Properties
uniform vec3 in_vsh_camera_position;
uniform mat4 in_camera_rotation;
uniform vec2 in_camera_dimensions;

// Atmosphere Properties
uniform float u_vsh_Atmosphere_Mask_Radius;

// Planet Properties
uniform float u_Radius;
uniform float u_Elevation;
uniform vec3 u_Position;
uniform vec3 u_EulerAngles;
uniform float u_PlanetDistance;

// Interpolated Depth
varying float v_vDepth;

// Constants
const vec3 forward_vector = vec3(0.0, 0.0, -1.0);
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
	// Create Rotation Matrix from Euler Angles
	mat3 rotation_matrix = eulerRotationMatrix(u_EulerAngles);
	
	// Apply Rotation Matrix to the Position Vector
	vec3 rotated_vector = rotation_matrix * in_Position;
	
	// Calculate Vertex Position relative to Origin
	vec3 vertex_position = rotated_vector * (u_Radius + (in_Elevation.x * u_Elevation));
	
	// Calculate Render Vertex Position with Camera Rotation Matrix
	vec4 render_position = vec4(vertex_position + u_Position - in_vsh_camera_position * inverse_vertical_vector, 1.0) * in_camera_rotation;
	
	// Calculate Depth of Elevated Vertex Position relative to Camera's Orientation and the Radius of Atmosphere Mask
	vec4 camera_forward = vec4(forward_vector, 0.0) * in_camera_rotation;
	float depth_render_dot_product = dot(camera_forward.z, vertex_position.z / u_vsh_Atmosphere_Mask_Radius) * 0.5 + 0.5;
	
	// Interpolated Depth
	v_vDepth = 1.0 - depth_render_dot_product;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(render_position.xyz * inverse_vertical_vector + vec3(in_camera_dimensions * 0.5, 1.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
	
	//
	//v_vDepth = length((gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos).xyz) / 8000.0;
}
