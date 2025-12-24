//
// (Multi Render Target) Forward Rendered Lit Planet Hydrosphere vertex shader meant for Inno's Solar System Overworld
//

// Planet Hydrosphere Properties
#define MAX_WAVES 4

// Vertex Buffer Properties
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_Elevation; // (u, v)

// Camera Properties
uniform vec3 in_vsh_CameraPosition;
uniform mat4 in_vsh_CameraRotation;
uniform vec2 in_CameraDimensions;

// Planet Properties
uniform float u_PlanetRadius;
uniform float u_vsh_PlanetElevation;
uniform vec3 u_PlanetPosition;
uniform vec3 u_PlanetEulerAngles;

// Ocean Properties
uniform float u_vsh_PlanetOceanElevation;

uniform float u_PlanetOcean_WaveTime;
uniform vec2 u_PlanetOcean_WaveDirection[MAX_WAVES];
uniform float u_PlanetOcean_WaveSteepness[MAX_WAVES];
uniform float u_PlanetOcean_WaveLength[MAX_WAVES];
uniform float u_PlanetOcean_WaveSpeed[MAX_WAVES];

// Atmosphere Properties
uniform float u_AtmosphereRadius;

// Interpolated Color, Normal, Ocean Normal, Position, Sphere Texture, Planet Elevation, and Depth
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vOceanNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;
varying float v_vPlanetElevation;
varying float v_vDepth;

// Constants
const float Pi = 3.14159265359;

const vec3 inverse_vertical_vector = vec3(1.0, -1.0, 1.0);
const vec3 inverse_forward_vector = vec3(1.0, 1.0, -1.0);

const float ocean_waves_normal_strength = 0.5;

// Trigonometry Functions
// returns the angle in the plane (in radians) between the positive x-axis and the ray from (0, 0) to the point (x, y)
float atan2(float y, float x)
{
	float t0, t1, t2, t3, t4;
	
	t3 = abs(x);
	t1 = abs(y);
	t0 = max(t3, t1);
	t1 = min(t3, t1);
	t3 = 1.0 / t0;
	t3 = t1 * t3;
	
	t4 = t3 * t3;
	t0 =         - 0.013480470;
	t0 = t0 * t4 + 0.057477314;
	t0 = t0 * t4 - 0.121239071;
	t0 = t0 * t4 + 0.195635925;
	t0 = t0 * t4 - 0.332994597;
	t0 = t0 * t4 + 0.999995630;
	t3 = t0 * t3;
	
	t3 = (abs(y) > abs(x)) ? 1.570796327 - t3 : t3;
	t3 = (x < 0.0) ?  3.14159265359 - t3 : t3;
	t3 = (y < 0.0) ? -t3 : t3;
	
	return t3;
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

// Vertex Shader
void main() 
{
	// Create Rotation Matrix of Planet from Planet's Euler Angle Rotation
	mat3 planet_rotation_matrix = eulerRotationMatrix(u_PlanetEulerAngles);
	
	// Calculate Trochoidal Waveform Height
	float ocean_wave_displacement = 0.0;

	for (int i = 0; i < MAX_WAVES; i++)
	{
		// Calculate Wave Properties
		vec2 wave_direction_normalized = normalize(u_PlanetOcean_WaveDirection[i]);
		
		float wave_number = (2.0 * Pi) / u_PlanetOcean_WaveLength[i];
		float angular_frequency = sqrt(9.81 * wave_number) * u_PlanetOcean_WaveSpeed[i];
		float amplitude = u_PlanetOcean_WaveSteepness[i] / wave_number;
		
		// Calculate Wave Phase
		float theta = atan2(in_Position.z, in_Position.x);
		float phi = acos(in_Position.y);
		
		float wave_x = cos(theta) * sin(phi);
		float wave_y = sin(theta) * cos(phi);
		
		float phase = wave_number * (wave_direction_normalized.x * wave_x + wave_direction_normalized.y * wave_y) - angular_frequency * u_PlanetOcean_WaveTime;
		
		// Add Wave Height to Cumulative Wave Displacement Value
		ocean_wave_displacement += amplitude * cos(phase);
	}
	
	// Calculate Ocean Height with Wave Displacement
	float ocean_height = (ocean_wave_displacement / u_vsh_PlanetElevation) + u_vsh_PlanetOceanElevation;
	
	// Calculate Planet's Local Vertex Vector and Vertex Position relative to Origin
	vec3 planet_rotated_local_vector = planet_rotation_matrix * in_Position;
	vec3 planet_rotated_local_vertex_position = planet_rotated_local_vector * (u_PlanetRadius + (ocean_height * u_vsh_PlanetElevation));
	
	// Calculate Vertex Render Position relative to Camera Perspective
	vec4 render_position = vec4(planet_rotated_local_vertex_position + u_PlanetPosition - in_vsh_CameraPosition * inverse_vertical_vector, 1.0) * in_vsh_CameraRotation;
	
	// Interpolated Color, Normal, Position, and Sphere Texture Vector
	v_vColour = in_Colour;
	v_vNormal = planet_rotated_local_vector;
	v_vOceanNormal = normalize(planet_rotated_local_vector + vec3(ocean_wave_displacement * ocean_waves_normal_strength));
	v_vPosition = planet_rotated_local_vertex_position + u_PlanetPosition;
	v_vTexVector = in_Position;
	
	// Interpolated Planet Elevation
	v_vPlanetElevation = in_Elevation.x * u_vsh_PlanetElevation;
	
	// Interpolated Depth of Elevated Vertex Position relative to Camera's Orientation and the Radius of Atmosphere
	vec3 camera_forward = normalize(in_vsh_CameraRotation[2].xyz);
	v_vDepth = dot(camera_forward, (planet_rotated_local_vertex_position.xyz * inverse_forward_vector) / u_AtmosphereRadius) * 0.5 + 0.5;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(render_position.xyz + vec3(in_CameraDimensions * 0.5, 0.0), 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
