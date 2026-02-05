//
// Forward Rendered Lit Planet Atmosphere fragment shader meant for Inno's Solar System Overworld
//

// Forward Rendered Lighting Properties
#define MAX_LIGHTS 6

// Camera Properties
uniform vec3 in_fsh_CameraPosition;
uniform mat4 in_fsh_CameraRotation;
uniform vec2 in_fsh_CameraDimensions;

// Temporal Properties
uniform float u_Time;

// Sample Properties
uniform float u_ScatterPointSamplesCount;
uniform float u_OpticalDepthSamplesCount;

// Light Source Properties
uniform float in_Light_Exists[MAX_LIGHTS];

uniform float in_Light_Position_X[MAX_LIGHTS];
uniform float in_Light_Position_Y[MAX_LIGHTS];
uniform float in_Light_Position_Z[MAX_LIGHTS];

uniform float in_Light_Radius[MAX_LIGHTS];
uniform float in_Light_Falloff[MAX_LIGHTS];
uniform float in_Light_Intensity[MAX_LIGHTS];

// Atmosphere Properties
uniform float u_fsh_AtmosphereRadius;
uniform float u_AtmosphereDensityFalloff;
uniform vec3 u_AtmosphereScatteringCoefficients;

// Cloud Properties
uniform float u_CloudsAlphaBlendingPower;

// Planet Properties
uniform vec3 u_fsh_PlanetPosition;
uniform float u_PlanetRadius;

// Texture Properties
uniform sampler2D gm_AtmosphereCloudsSurface;
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

const float color_range = 256.0;

const float cloud_alpha_minimum = 0.02;
const float cloud_surface_mask_cutout_depth = 0.65;

const float blue_noise_ditering_scale = 2.0;
const float blue_noise_ditering_strength = 0.005;
const float blue_noise_light_source_time_interval = 20.0;

const float light_source_intensity_multiplier = 4.0;

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

// Noise Functions
// Hash function for pseudo-random values
float hash(vec2 p) 
{
	p = fract(p * vec2(443.897, 441.423));
	p += dot(p, p.yx + 19.19);
	return fract(p.x * p.y);
}

// Spatiotemporal pseudo-random Blue Noise
float blueNoiseTemporal(vec2 uv, float time) 
{
	// Temporal offset - rotates through different noise patterns over time
	float temporalOffset = floor(time * 60.0);
	vec2 timeVec = vec2(temporalOffset * 0.754877, temporalOffset * 0.569840);
	
	// Spatial Blue Noise approximation using multiple octaves
	vec2 p1 = uv * 256.0;
	vec2 i1 = floor(p1);
	vec2 f1 = fract(p1);
	
	// Smooth interpolation
	vec2 u1 = f1 * f1 * (3.0 - 2.0 * f1);
	
	// Sample 4 corners with temporal variation
	float a1 = hash(i1 + timeVec);
	float b1 = hash(i1 + vec2(1.0, 0.0) + timeVec);
	float c1 = hash(i1 + vec2(0.0, 1.0) + timeVec);
	float d1 = hash(i1 + vec2(1.0, 1.0) + timeVec);
	
	// Bilinear interpolation
	float noise = mix(mix(a1, b1, u1.x), mix(c1, d1, u1.x), u1.y);
	
	// Add higher frequency detail for better blue noise characteristics
	vec2 p2 = uv * 512.0;
	vec2 i2 = floor(p2);
	vec2 f2 = fract(p2);
	
	// Smooth interpolation
	vec2 u2 = f2 * f2 * (3.0 - 2.0 * f2);
	
	// Sample 4 corners with temporal variation
	float a2 = hash(i2 + timeVec);
	float b2 = hash(i2 + vec2(1.0, 0.0) + timeVec);
	float c2 = hash(i2 + vec2(0.0, 1.0) + timeVec);
	float d2 = hash(i2 + vec2(1.0, 1.0) + timeVec);
	
	// Bilinear interpolation
	float detail = mix(mix(a2, b2, u2.x), mix(c2, d2, u2.x), u2.y);
	
	// Combine base and detail
	noise = noise * 0.7 + detail * 0.3;
	
	// Map from [0,1] to [-1,1]
	return noise * 2.0 - 1.0;
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

//
// Dithering Functions
// Screen Space pseudo-random Blue Noise dithered color quantization
vec3 dither(vec2 uv, float time, vec3 light)
{
	// Generate stable Spatiotemporal pseudo-random screen-space Blue Noise
	float dither_noise = blueNoiseTemporal(uv, time) - 0.5;
	
	// Luminosity correction
	float luma = dot(light, vec3(0.0722, 0.2126, 0.7152));
	light += dither_noise / color_range;
	light *= luma < 0.05 ? 1.0 : luma / max(dot(light, vec3(0.0722, 0.2126, 0.7152)), 0.0001);
	
	// Apply dither before quantization
	vec3 dithered_color = light + (dither_noise / color_range);
	
	// Quantize lighting
	return floor(dithered_color * color_range) / color_range;
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
	
	// Calculate UV Position of Surface
	vec2 uv = (v_vSurfaceUV.xy / v_vSurfaceUV.w) * 0.5 + 0.5;
	
	// Retreive Celestial Body's Combined Planet & Clouds Diffuse Color
	vec4 planet_diffuse_color = texture2D(gm_BaseTexture, uv);
	vec4 clouds_diffuse_color = texture2D(gm_AtmosphereCloudsSurface, uv);
	
	float cloud_blend_alpha = pow(clouds_diffuse_color.a, u_CloudsAlphaBlendingPower);
	vec4 diffuse_color = (1.0 - cloud_blend_alpha) * planet_diffuse_color + vec4(clouds_diffuse_color.rgb, cloud_blend_alpha);
	
	// Retreive Atmosphere's Planet Mask and Create Combined Planet & Clouds Surface Depth Mask from Cloud Alpha Blending
	float planet_mask = texture2D(gm_AtmospherePlanetDepthMask, uv).r;
	float surface_mask = (cloud_blend_alpha > cloud_alpha_minimum ? max(u_fsh_AtmosphereRadius * cloud_surface_mask_cutout_depth, planet_mask) : planet_mask) / u_fsh_AtmosphereRadius;
	
	// Calculate Atmosphere Depth based on Radial Distance from Center of the Atmosphere
	float atmosphere_depth = cos(radius * Pi);
	float atmosphere_depth_mask_adjusted = surface_mask == 0.0 ? atmosphere_depth * 2.0 : 1.0 - surface_mask;
	
	// Calculate Atmosphere Surface Position
	vec3 atmosphere_surface_position = v_vWorldPosition - (atmosphere_depth * u_fsh_AtmosphereRadius * camera_forward);
	
	// Calculate Distance through Atmosphere
	float distance_through_atmosphere = atmosphere_depth_mask_adjusted * u_fsh_AtmosphereRadius;
	
	// Calculate Point within Atmosphere by incrementing a distance of Epsilon to intersect the Surface of the Sphere
	vec3 point_in_atmosphere = atmosphere_surface_position + (epsilon * camera_forward);
	
	// Establish Cumulative Light Value
	vec3 light = vec3(0.0);
	
	// Iterate through all Light Sources
	for (int l = 0; l < MAX_LIGHTS; l++)
	{
		// Check if Light Source Exists
		if (in_Light_Exists[l] != 1.0)
		{
			continue;
		}
		
		// Calculate Temporal Blue Noise at UV position and Time
		float blue_noise = blueNoiseTemporal(uv * blue_noise_ditering_scale * vec2(1.0, in_fsh_CameraDimensions.y / in_fsh_CameraDimensions.x), u_Time + blue_noise_light_source_time_interval * float(l)) * blue_noise_ditering_strength;
		
		// Calculate Light Source's Position & Direction Vector
		vec3 light_position = vec3(in_Light_Position_X[l], in_Light_Position_Y[l], in_Light_Position_Z[l]);
		vec3 light_direction = normalize(point_in_atmosphere - light_position) * 100.0;
		
		// Scatter Point Sampling Variables
		vec3 in_scatter_point = point_in_atmosphere;
		vec3 in_scattered_light = vec3(0.0);
		float view_ray_optical_depth = 0.0;
		float step_size = (distance_through_atmosphere - epsilon * 2.0) / (u_ScatterPointSamplesCount - 1.0);
		
		// Calculate Scattered Light through Atmosphere based on Ray-Marching through Atmosphere to retreive Density and Light from Light Source
		for (float i = 0.0; i < u_ScatterPointSamplesCount; i++)
		{
			// Calculate Light Source Distance Fade Falloff Effect
			float light_source_distance = length(in_scatter_point - light_position);
			float light_source_fade = pow((in_Light_Radius[l] - light_source_distance) / in_Light_Radius[l], in_Light_Falloff[l]);
			
			// Calculate Light Source Ray's Optical Depth at Scattering Sample Point
			float light_source_ray_length = raySphere(u_fsh_PlanetPosition, u_fsh_AtmosphereRadius, in_scatter_point, -light_direction).y;
			float light_source_ray_optical_depth = opticalDepth(in_scatter_point, -light_direction, light_source_ray_length);
			
			// Calculate View Ray's Optical Depth at Scattering Sample Point
			view_ray_optical_depth = opticalDepth(in_scatter_point, -camera_forward, step_size * i);
			
			// Find Atmosphere's Local Density at Scattering Sample Point
			float local_density = densityAtPoint(in_scatter_point);
			
			// Calculate Transmittance of Light at Scattering Sample Point
			vec3 transmittance = exp(-(light_source_ray_optical_depth + view_ray_optical_depth) * u_AtmosphereScatteringCoefficients);
			
			// Add Transmittance of Light to Total Atmosphere Light Visible at the given Pixel based on Local Density of Atmosphere at Scattering Sample Point
			in_scattered_light += local_density * transmittance * light_source_fade;
			
			// Increment Scattering Sample Point by Ray Marching Step Size in Direction of View Vector
			in_scatter_point += camera_forward * step_size;
		}
		
		// Normalize Total Atmosphere Light Visible at the given Pixel
		in_scattered_light *= u_AtmosphereScatteringCoefficients * light_source_intensity_multiplier * in_Light_Intensity[l] * (step_size / u_PlanetRadius);
		
		// Attenuate brightness of light reflected from Celestial Body's Surface
		float brightness_adaption = dot(in_scattered_light, vec3(1.0)) * brightness_adaption_strength;
		float brightness_sum = view_ray_optical_depth * light_source_intensity_multiplier * in_Light_Intensity[l] * reflected_light_out_scatter_strength + brightness_adaption;
		float reflected_light_strength = exp(-brightness_sum);
		float hdr_strength = max(min((dot(diffuse_color.rgb, vec3(1.0)) / 3.0) - 1.0, 1.0), 0.0);
		reflected_light_strength = mix(reflected_light_strength, 1.0, hdr_strength);
		vec3 reflected_light = diffuse_color.rgb * reflected_light_strength;
		
		// Add Light Visible from Surface of Atmosphere
		light += diffuse_color.rgb + in_scattered_light + reflected_light + blue_noise;
	}
	
	// Calculate Atmosphere Alpha
	float atmosphere_alpha = min(atmosphere_depth + (surface_mask == 0.0 ? 0.0 : 1.0), 1.0);
	
	// Render Lit Atmosphere Fragment Color Value
	gl_FragColor = vec4(light, atmosphere_alpha);
}
