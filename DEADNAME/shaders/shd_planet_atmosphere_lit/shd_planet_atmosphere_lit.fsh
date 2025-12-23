//
// Forward Rendered Lit Planet Atmosphere fragment shader meant for Inno's Solar System Overworld
//

// Camera Properties
uniform vec3 in_fsh_CameraPosition;
uniform mat4 in_fsh_CameraRotation;
uniform vec2 in_fsh_CameraDimensions;

// Sample Properties
uniform float u_ScatterPointSamplesCount;
uniform float u_OpticalDepthSamplesCount;

// Atmosphere Properties
uniform float u_fsh_AtmosphereRadius;
uniform float u_AtmosphereDensityFalloff;
uniform vec3 u_AtmosphereScatteringCoefficients;

// Planet Properties
uniform vec3 u_fsh_PlanetPosition;
uniform float u_PlanetRadius;

// Blue Noise Texture Properties
uniform vec2 u_BlueNoise_Texture_Size;

// Texture Properties
uniform sampler2D gm_BlueNoiseTexture;
uniform sampler2D gm_AtmospherePlanetDepthMask;

// Interpolated Square UV, Surface Mask UV, and World Position
varying vec2 v_vSquareUV;
varying vec4 v_vSurfaceUV;
varying vec3 v_vWorldPosition;

// Constants
const vec2 center = vec2(0.5, 0.5);

const float Pi = 3.14159265359;

const float epsilon = 0.0001;
const float pseudo_infinity = 1.0 / 0.0;

const float blue_noise_strength = 0.01;
const float blue_noise_dithering_scale = 3.0;

const float brightness_adaption_strength = 0.15;
const float reflected_light_out_scatter_strength = 3.0;

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

// Sphere Functions
// Returns vector (distance_to_sphere, distance_through_sphere)
vec2 raySphere(vec3 sphere_center, float sphere_radius, vec3 ray_origin, vec3 ray_direction) 
{
	// If ray origin is inside sphere, dstToSphere = 0
	// If ray misses sphere, dstToSphere = maxValue; dstThroughSphere = 0
	vec3 offset = ray_origin - sphere_center;
	float s_a = dot(ray_direction, ray_direction);
	float s_b = 2.0 * dot(offset, ray_direction);
	float s_c = dot(offset, offset) - sphere_radius * sphere_radius;
	float s_d = s_b * s_b - 4.0 * s_a * s_c; // Sphere Discriminant

	// Number of intersections: 0 when d < 0; 1 when d = 0; 2 when d > 0
	if (s_d > 0.0) 
	{
		float s_s = sqrt(s_d);
		float distance_to_sphere_near = max(0.0, (-s_b - s_s) / (2.0 * s_a));
		float distance_to_sphere_far = (-s_b + s_s) / (2.0 * s_a);
		
		// Ignore intersections that occur behind the ray
		if (distance_to_sphere_far >= 0.0) 
		{
			return vec2(distance_to_sphere_near, distance_to_sphere_far - distance_to_sphere_near);
		}
	}
	
	// Ray did not intersect sphere
	return vec2(pseudo_infinity, 0.0);
}

// Atmosphere Functions
// Calculates the Atmosphere Density with the given Sample Position based on the Celestial Body's Position, Radius, and Atmosphere Radius
float densityAtPoint(vec3 density_sample_position)
{
	float distance_above_surface = distance(density_sample_position, u_fsh_PlanetPosition) - u_PlanetRadius;
	float sample_height = distance_above_surface / (u_fsh_AtmosphereRadius - u_PlanetRadius);
	float sample_density = exp(-sample_height * u_AtmosphereDensityFalloff) * (1.0 - sample_height);
	return sample_density;
}

// Calculates the Optical Depth through the Atmosphere based on the given Ray's Position, Direction, and Length
float opticalDepth(vec3 ray_origin, vec3 ray_direction, float ray_length)
{
	vec3 density_sample_position = ray_origin;
	float step_size = ray_length / (u_OpticalDepthSamplesCount - 1.0);
	float optical_depth = 0.0;
	
	for (float i = 0.0; i < u_OpticalDepthSamplesCount; i++)
	{
		float local_density = densityAtPoint(density_sample_position);
		optical_depth += local_density * step_size;
		density_sample_position += ray_direction * step_size;
	}
	
	return optical_depth;
}

// Calculates the Visible Light when viewing the Atmosphere from a Ray's Position, Direction
vec3 calculateLight(vec3 ray_origin, vec3 ray_direction, float ray_length, vec3 direction_to_light, float light_intensity, vec3 original_color, vec2 uv)
{
	// Calculate Blue Noise
	float blue_noise = (texture2D(gm_BlueNoiseTexture, uv * blue_noise_dithering_scale).b - 0.5) * blue_noise_strength;
	
	// Scatter Point Sampling Variables
	vec3 in_scatter_point = ray_origin;
	vec3 in_scattered_light = vec3(0.0);
	float view_ray_optical_depth = 0.0;
	float step_size = ray_length / (u_ScatterPointSamplesCount - 1.0);
	
	// Calculate Scattered Light through Atmosphere based on Ray-Marching through Atmosphere to retreive Density and Light from Light Source
	for (float i = 0.0; i < u_ScatterPointSamplesCount; i++)
	{
		// Calculate Light Source Ray's Optical Depth at Scattering Sample Point
		float light_source_ray_length = raySphere(u_fsh_PlanetPosition, u_fsh_AtmosphereRadius, in_scatter_point, direction_to_light).y;
		float light_source_ray_optical_depth = opticalDepth(in_scatter_point, direction_to_light, light_source_ray_length);
		
		// Calculate View Ray's Optical Depth at Scattering Sample Point
		view_ray_optical_depth = opticalDepth(in_scatter_point, -ray_direction, step_size * i);
		
		// Find Atmosphere's Local Density at Scattering Sample Point
		float local_density = densityAtPoint(in_scatter_point);
		
		// Calculate Transmittance of Light at Scattering Sample Point
		vec3 transmittance = exp(-(light_source_ray_optical_depth + view_ray_optical_depth) * u_AtmosphereScatteringCoefficients);
		
		// Add Transmittance of Light to Total Atmosphere Light Visible at the given Pixel based on Local Density of Atmosphere at Scattering Sample Point
		in_scattered_light += local_density * transmittance;
		
		// Increment Scattering Sample Point by Ray Marching Step Size in Direction of View Vector
		in_scatter_point += ray_direction * step_size;
	}
	
	// Normalize Total Atmosphere Light Visible at the given Pixel
	in_scattered_light *= u_AtmosphereScatteringCoefficients * light_intensity * (step_size / u_PlanetRadius);
	in_scattered_light += vec3(0.0, 0.0, blue_noise);
	
	// Attenuate brightness of light reflected from Celestial Body's Surface
	float brightness_adaption = dot(in_scattered_light, vec3(1.0)) * brightness_adaption_strength;
	float brightness_sum = view_ray_optical_depth * light_intensity * reflected_light_out_scatter_strength + brightness_adaption;
	float reflected_light_strength = exp(-brightness_sum);
	float hdr_strength = max(min((dot(original_color, vec3(1.0)) / 3.0) - 1.0, 1.0), 0.0);
	reflected_light_strength = mix(reflected_light_strength, 1.0, hdr_strength);
	vec3 reflected_light = original_color * reflected_light_strength;
	
	// Return Final Color
	return (original_color + in_scattered_light);
}

// Fragment Shader
void main()
{
	// Atmosphere Radius
	float radius = distance(v_vSquareUV, center);
	
	// Circle Cut-Out Early Return
	if (radius > 0.5)
	{
		return;
	}
	
	// Calculate Camera Forward Vector from Camera's Rotation Matrix
	vec3 camera_forward = normalize(in_fsh_CameraRotation[2].xyz);
	
	// Calculate UV Position of Surface and Retreive Atmosphere's Planet Depth Mask
	vec2 uv = (v_vSurfaceUV.xy / v_vSurfaceUV.w) * 0.5 + 0.5;
	vec4 planet_mask = texture2D(gm_AtmospherePlanetDepthMask, uv);
	
	// Retreive Celestial Body's Surface Color
	vec4 diffuse_color = texture2D(gm_BaseTexture, uv);
	
	// Calculate Atmosphere Depth based on Radial Distance from Center of the Atmosphere
	float atmosphere_depth = cos(radius * Pi);
	float atmosphere_depth_mask_adjusted = (atmosphere_depth * 2.0 * (1.0 - planet_mask.a)) + ((1.0 - planet_mask.r) * planet_mask.a);
	
	// Calculate Atmosphere Surface Position
	vec3 atmosphere_surface_position = v_vWorldPosition - (atmosphere_depth * u_fsh_AtmosphereRadius * camera_forward);
	
	// Calculate Distance through Atmosphere
	float distance_through_atmosphere = atmosphere_depth_mask_adjusted * u_fsh_AtmosphereRadius;
	
	// Calculate Point within Atmosphere by incrementing a distance of Epsilon to intersect the Surface of the Sphere
	vec3 point_in_atmosphere = atmosphere_surface_position + (epsilon * camera_forward);
	
	// Calculate Light Source's Direction Vector
	vec3 light_position = vec3(0.0);
	vec3 light_direction = normalize(point_in_atmosphere - light_position) * 100.0;
	
	// Calculate Light Visible from Surface of Atmosphere
	vec3 light = calculateLight(point_in_atmosphere, camera_forward, distance_through_atmosphere - epsilon * 2.0, -light_direction, 4.0, diffuse_color.rgb, (uv * in_fsh_CameraDimensions) / u_BlueNoise_Texture_Size);
	
	// Calculate Atmosphere Alpha
	float atmosphere_alpha = min(atmosphere_depth + planet_mask.a, 1.0);
	
	// Render Lit Atmosphere Fragment Color Value
    gl_FragColor = vec4(light, atmosphere_alpha);
}
