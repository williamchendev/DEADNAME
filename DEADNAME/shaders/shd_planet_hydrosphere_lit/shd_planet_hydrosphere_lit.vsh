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
uniform float u_vsh_AtmosphereRadius;

// Interpolated Color, Normal, Ocean Normal, Position, Sphere Texture, Camera View Vector, Planet Elevation, and Depth
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
	
	// Build rotation matrix (YZX order - pitch, yaw, roll)
	mat3 rotMatrix;
	
	rotMatrix[0][0] =  cp * cy;
	rotMatrix[0][1] =  cp * sy;
	rotMatrix[0][2] = -sp;

	rotMatrix[1][0] =  sr * sp * cr - cr * sy;
	rotMatrix[1][1] =  sr * sp * sr + cr * cy;
	rotMatrix[1][2] =  sr * cp;

	rotMatrix[2][0] =  cr * sp * cy + sr * sy;
	rotMatrix[2][1] =  cr * sp * sy - sr * cy;
	rotMatrix[2][2] =  cr * cp;
	
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
		float theta = clamp(atan2(in_Position.z, in_Position.x), -Pi, Pi);
		float phi = acos(in_Position.y);
		
		float wave_x = cos(theta) * sin(phi);
		float wave_y = sin(theta) * cos(phi);
		
		float phase = wave_number * (wave_direction_normalized.x * wave_x + wave_direction_normalized.y * wave_y) - angular_frequency * u_PlanetOcean_WaveTime;
		
		// Add Wave Height to Cumulative Wave Displacement Value
		ocean_wave_displacement += amplitude * cos(phase);
	}
	
	// Calculate Ocean Height with Wave Displacement
	float ocean_height = (ocean_wave_displacement / u_vsh_PlanetElevation) + u_vsh_PlanetOceanElevation;
	
	// Calculate Planet's Local Vector, Rotated Local Vector, and Local Elevation Vector relative to Origin
	vec3 planet_local_vector = in_Position * inverse_vertical_vector;
	vec3 planet_rotated_local_vector = planet_local_vector * planet_rotation_matrix;
	vec3 planet_rotated_local_vector_elevation = planet_rotated_local_vector * (u_PlanetRadius + (ocean_height * u_vsh_PlanetElevation));
	
	// Calculate Planet's Object Space Vertex Position
	vec4 planet_object_space_position = vec4(planet_local_vector * (u_PlanetRadius + (ocean_height * u_vsh_PlanetElevation)), 1.0);
	
	// Interpolated Color, Normal, Position, and Sphere Texture Vector
	v_vColour = in_Colour;
	v_vNormal = planet_rotated_local_vector;
	v_vOceanNormal = normalize(planet_rotated_local_vector + vec3(ocean_wave_displacement * ocean_waves_normal_strength));
	v_vPosition = planet_rotated_local_vector_elevation + u_PlanetPosition;
	v_vTexVector = in_Position;
	
	// Interpolated Planet Elevation
	v_vPlanetElevation = in_Elevation.x * u_vsh_PlanetElevation;
	
	// Interpolated Depth of Elevated Vertex Position relative to Camera's Viewing Orientation and the Radius of Atmosphere
	vec3 camera_view_direction = normalize(v_vPosition - in_vsh_CameraPosition);
	v_vDepth = (dot(camera_view_direction, planet_rotated_local_vector_elevation / u_vsh_AtmosphereRadius) * 0.5 + 0.5) * u_vsh_AtmosphereRadius;
	
	// Set Vertex Positions
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * planet_object_space_position;
}
