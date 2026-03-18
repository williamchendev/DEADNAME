//
// (Multi Render Target) Forward Rendered Lit Planet Lithosphere vertex shader meant for Inno's Solar System Overworld
//

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_Elevation; // (u, v)

// Camera Properties
uniform vec3 in_vsh_CameraPosition;

// Planet Properties
uniform float u_PlanetRadius;
uniform float u_PlanetElevation;
uniform vec3 u_PlanetPosition;
uniform vec3 u_PlanetEulerAngles;

// Atmosphere Properties
uniform float u_AtmosphereRadius;

// Interpolated Color, Normal, Position, Sphere Texture Vector, and Depth
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;
varying float v_vDepth;

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
	
	/*
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
	
	rotMatrix[0][0] =  cp * cy;
    rotMatrix[0][1] =  sy;
    rotMatrix[0][2] = -cy * sp;

    rotMatrix[1][0] =  sp * sr - cp * cr * sy;
    rotMatrix[1][1] =  cy * cr;
    rotMatrix[1][2] =  cp * sr + cr * sp * sy;

    rotMatrix[2][0] =  cr * sp + cp * sy * sr;
    rotMatrix[2][1] = -cy * sr;
    rotMatrix[2][2] =  cp * cr - sp * sy * sr;
	
	// Return Rotation Matrix
	return rotMatrix;
}

// Vertex Shader
void main() 
{
	// Create Rotation Matrix of Planet from Planet's Euler Angle Rotation
	mat3 planet_rotation_matrix = eulerRotationMatrix(u_PlanetEulerAngles);
	
	// Calculate Planet's Vertex Elevation based on Planet's Radius and Elevation
	float planet_vertex_elevation = u_PlanetRadius + (in_Elevation.x * u_PlanetElevation);
	
	// Calculate Planet's Local Vector, Rotated Local Vector, and Local Elevation Vector relative to Origin
	vec3 planet_local_vector = in_Position * inverse_vertical_vector;
	vec3 planet_rotated_local_vector = planet_local_vector * planet_rotation_matrix;
	vec3 planet_rotated_local_vector_elevation = planet_rotated_local_vector * planet_vertex_elevation;
	
	// Calculate Planet's Object Space Vertex Position
	vec4 planet_object_space_position = vec4(planet_local_vector * planet_vertex_elevation, 1.0);
	
	// Interpolated Color, Normal, Position, and Sphere Texture Vector
	v_vColour = in_Colour;
	v_vNormal = planet_rotated_local_vector;
	v_vPosition = planet_rotated_local_vector_elevation + u_PlanetPosition;
	v_vTexVector = in_Position;
	
	// Interpolated Depth of Elevated Vertex Position relative to Camera's Viewing Orientation and the Radius of Atmosphere
	vec3 camera_view_direction = normalize(v_vPosition - in_vsh_CameraPosition);
	v_vDepth = dot(camera_view_direction, planet_rotated_local_vector_elevation / u_AtmosphereRadius) * u_AtmosphereRadius;
	
	// Set Vertex Positions
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * planet_object_space_position;
}
