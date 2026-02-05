//
// Lit Raymarched SDF Sphere Cloud fragment shader meant for Inno's Solar System Overworld
//

// Camera Properties
uniform vec3 in_fsh_CameraPosition;
uniform mat4 in_fsh_CameraRotation;

// Temporal Properties
uniform float u_NoiseTime;

// Sample Properties
uniform float u_CloudNoiseSquareSize;
uniform float u_CloudNoiseCubeSize;

uniform float u_ScatterPointSamplesCount;
uniform float u_LightDepthSamplesCount;
uniform float u_CloudSampleScale;

// Atmosphere Properties
uniform float u_fsh_AtmosphereRadius;

// Planet Properties
uniform float u_fsh_PlanetRadius;
uniform vec3 u_fsh_PlanetPosition;

// Cloud Properties
uniform float u_fsh_CloudRadius;

uniform float u_CloudAbsorption;
uniform float u_CloudDensity;
uniform float u_CloudDensityFalloff;
uniform float u_CloudAnisotropicLightScattering;

uniform vec3 u_CloudColor;
uniform vec3 u_CloudAmbientLightColor;

// Texture Properties
uniform sampler2D gm_AtmospherePlanetDepthMask;

// Interpolated Square UV, Surface Mask UV, and World Position
varying vec2 v_vSquareUV;
varying vec4 v_vSurfaceUV;
varying vec3 v_vCloudPosition;
varying vec3 v_vLocalPosition;
varying vec3 v_vSampleForward;
varying vec3 v_vSamplePosition;
varying mat3 v_vPlanetRotation;

// Constants
const float Pi = 3.14159265359;

const float epsilon = 0.0001;
const float pseudo_infinity = 1.0 / 0.0;

const vec2 center = vec2(0.5, 0.5);
const vec3 inverse_forward_vector = vec3(1.0, 1.0, -1.0);

const float blue_noise_alpha_ditering_strength = 0.005;
const float blue_noise_offset_ditering_strength = 0.25;

const float breakpoint = 50.0;

// Noise Methods
// Hash function for pseudo-random values
float hash(vec3 p) 
{
	p = fract(p * 0.0917);
	p += dot(p, p.xzy + 51.19);
	return fract((p.y + p.z) * p.x);
}

// Spatiotemporal pseudo-random Blue Noise
float blueNoiseTemporal(vec3 pos, float time) 
{
	// Temporal offset – cycles through stable patterns
	float temporal_offset = floor(time * 60.0);
	vec3 time_vec = vec3(temporal_offset * 0.754877, temporal_offset * 0.569840, temporal_offset * 0.885301);
	
	// Base Blue Noise
	vec3 pb = pos * 256.0;
	vec3 ib = floor(pb);
	vec3 fb = fract(pb);
	
	// Smooth interpolation
	vec3 u1 = fb * fb * (3.0 - 2.0 * fb);
	
	// Sample 8 corners (trilinear)
	float a1 = hash(ib + vec3(0.0, 0.0, 0.0) + time_vec);
	float b1 = hash(ib + vec3(1.0, 0.0, 0.0) + time_vec);
	float c1 = hash(ib + vec3(0.0, 1.0, 0.0) + time_vec);
	float d1 = hash(ib + vec3(1.0, 1.0, 0.0) + time_vec);
	float e1 = hash(ib + vec3(0.0, 0.0, 1.0) + time_vec);
	float f1 = hash(ib + vec3(1.0, 0.0, 1.0) + time_vec);
	float g1 = hash(ib + vec3(0.0, 1.0, 1.0) + time_vec);
	float h1 = hash(ib + vec3(1.0, 1.0, 1.0) + time_vec);
	
	float x00b = mix(a1, b1, u1.x);
	float x10b = mix(c1, d1, u1.x);
	float x01b = mix(e1, f1, u1.x);
	float x11b = mix(g1, h1, u1.x);
	
	float y0b = mix(x00b, x10b, u1.y);
	float y1b = mix(x01b, x11b, u1.y);
	
	float base_noise = mix(y0b, y1b, u1.z);
	
	// Detail Blue Noise
	vec3 pd = pos * 512.0;
	vec3 id = floor(pd);
	vec3 fd = fract(pd);
	
	vec3 u2 = fd * fd * (3.0 - 2.0 * fd);
	
	float a2 = hash(id + vec3(0.0, 0.0, 0.0) + time_vec);
	float b2 = hash(id + vec3(1.0, 0.0, 0.0) + time_vec);
	float c2 = hash(id + vec3(0.0, 1.0, 0.0) + time_vec);
	float d2 = hash(id + vec3(1.0, 1.0, 0.0) + time_vec);
	float e2 = hash(id + vec3(0.0, 0.0, 1.0) + time_vec);
	float f2 = hash(id + vec3(1.0, 0.0, 1.0) + time_vec);
	float g2 = hash(id + vec3(0.0, 1.0, 1.0) + time_vec);
	float h2 = hash(id + vec3(1.0, 1.0, 1.0) + time_vec);
	
	float x00d = mix(a2, b2, u2.x);
	float x10d = mix(c2, d2, u2.x);
	float x01d = mix(e2, f2, u2.x);
	float x11d = mix(g2, h2, u2.x);
	
	float y0d = mix(x00d, x10d, u2.y);
	float y1d = mix(x01d, x11d, u2.y);
	
	float detail_noise = mix(y0d, y1d, u2.z);
	
	// Combine base + detail
	float noise = base_noise * 0.7 + detail_noise * 0.3;
	
	// Map from [0,1] → [-1,1]
	return noise * 2.0 - 1.0;
}

// Samples noise from a three-dimensional cloud noise texture at the given coordinate
float cloudSampleNoise(vec3 uvw)
{
	vec3 sample_uvw = floor(mod(uvw, 1.0) * u_CloudNoiseCubeSize);
	sample_uvw = mod(sample_uvw + u_CloudNoiseCubeSize, u_CloudNoiseCubeSize);
	
	float linear = sample_uvw.x * u_CloudNoiseCubeSize * u_CloudNoiseCubeSize + sample_uvw.y * u_CloudNoiseCubeSize + sample_uvw.z;
	float rgba_id = floor(linear / (u_CloudNoiseSquareSize * u_CloudNoiseSquareSize));
	float offset = mod(linear, u_CloudNoiseSquareSize * u_CloudNoiseSquareSize);
	
	float row = floor(offset / u_CloudNoiseSquareSize) / u_CloudNoiseSquareSize;
	float col = mod(offset, u_CloudNoiseSquareSize) / u_CloudNoiseSquareSize;
	
	vec2 uv = vec2(row, col);
	
	vec4 noise = texture2D(gm_BaseTexture, uv);
	
	float value = rgba_id == 0.0 ? noise.r : (rgba_id == 1.0 ? noise.g : (rgba_id == 2.0 ? noise.b : noise.a));
	return value;
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

// Density Functions
float densityAtPoint(vec3 density_sample_position)
{
	float distance_from_center = distance(density_sample_position, v_vCloudPosition);
	float sample_distance = distance_from_center / u_fsh_CloudRadius;
	float sample_density = exp(-sample_distance * u_CloudDensityFalloff) * (1.0 - sample_distance);
	return sample_density;
}

// Light Scattering Approximation Functions
float henyeyGreenstein(float g_anisotropy_factor, float cos_theta) 
{
	float g_sqr = g_anisotropy_factor * g_anisotropy_factor;
	return (1.0 - g_sqr) / (4.0 * Pi * pow(1.0 + g_sqr - 2.0 * g_anisotropy_factor * cos_theta, 1.5));
}

float doubleHenyeyGreenstein(float cos_theta, float g1, float g2, float blend) 
{
	float forward_scattering_g = henyeyGreenstein(g1, cos_theta);
	float backward_scattering_g = henyeyGreenstein(g2, cos_theta);
	return mix(backward_scattering_g, forward_scattering_g, blend);
}

float beer(float sample_density, float absorption) 
{
	return exp(-sample_density * absorption);
}

float powder(float sample_density, float cos_theta) 
{
	float powder_value = 1.0 - exp(-sample_density * 2.0);
	return mix(1.0, powder_value, clamp((-cos_theta * 0.5) + 0.5, 0.0, 1.0));
}

// Fragment Shader
void main() 
{
	// Find Pixel's Cloud Radius
	float radius = distance(v_vSquareUV, center);
	
	// Circle Cut-Out - Early Return
	if (radius > 0.5)
	{
		return;
	}
	
	// Calculate Camera Forward Vector from Camera's Rotation Matrix
	vec3 camera_forward = normalize(in_fsh_CameraRotation[2].xyz);
	
	// Calculate Cloud Depth, Position within Cloud, and Depth relative to the Planet's Atmosphere
	float sphere_depth = cos(radius * Pi);
	vec3 point_in_cloud = u_fsh_PlanetPosition + v_vLocalPosition - (sphere_depth - epsilon) * camera_forward;
	float atmosphere_depth = (dot(-camera_forward, (v_vLocalPosition - (u_fsh_CloudRadius * sphere_depth - epsilon) * camera_forward) / u_fsh_AtmosphereRadius) * 0.5 + 0.5) * u_fsh_AtmosphereRadius;
	
	// Calculate UV Position of Surface and Retreive Atmosphere's Planet Depth Mask
	vec2 uv = (v_vSurfaceUV.xy / v_vSurfaceUV.w) * 0.5 + 0.5;
	float planet_mask = texture2D(gm_AtmospherePlanetDepthMask, uv).r;
	
	// Check if Cloud Pixel Render's Depth is behind Planet - Early Return
	if (planet_mask > atmosphere_depth)
	{
		return;
	}
	
	// Generate Blue Noise
	float blue_noise = blueNoiseTemporal(point_in_cloud, u_NoiseTime);
	
	// Establish Light Source
	float light_radius = 1000.0;
	vec3 light_position = vec3(0.0);
	vec3 light_color = vec3(1.0);
	
	vec3 light_direction = point_in_cloud - light_position;
	float light_distance = length(light_direction);
	light_direction = normalize(light_direction);
	
	vec3 light_sample_direction = light_direction * v_vPlanetRotation;
	
	// Calculate Light Source's Directional Scattering Phase
	float light_cos_theta = dot(camera_forward, light_direction);
	float light_scattering_phase = doubleHenyeyGreenstein(light_cos_theta, 0.6, -0.3, 0.75) * u_CloudAnisotropicLightScattering + (1.0 - u_CloudAnisotropicLightScattering);
	
	// Establish Cloud Noise Sampling Variables
	vec3 cloud_sample_position = v_vSamplePosition - v_vSampleForward * (u_fsh_CloudRadius - epsilon);
	float cloud_sample_ray_length = (u_fsh_CloudRadius * sphere_depth - epsilon) * 2.0;
	float cloud_sample_step_size = cloud_sample_ray_length / (u_ScatterPointSamplesCount - 1.0);
	
	// Apply Blue Noise Offset to Sample Positions
	cloud_sample_position += v_vSampleForward * cloud_sample_step_size * blue_noise * blue_noise_offset_ditering_strength;
	
	// Establish Cloud Light, Alpha, and Transmittance
	vec3 light = u_CloudAmbientLightColor;
	float alpha = blue_noise * blue_noise_alpha_ditering_strength;
	float transmittance = 1.0;
	
	// Iterate through Cloud Light Scatter Point Sampling
	for (float i = 0.0; i < u_ScatterPointSamplesCount; i++)
	{
		// Manual Breakpoint so the Compiler doesn't get mad
		if (i >= breakpoint) 
		{
			break;
		}
		
		// Sample Local Density from Cloud Noise
		float local_density = cloudSampleNoise(cloud_sample_position * u_CloudSampleScale) * densityAtPoint(point_in_cloud);
		
		// Calculate Cloud's Powder Effect with Sample's Local Density
		float powder_effect = powder(local_density, light_cos_theta);
		
		// Calculate Planet Shadow Impact on Light Source
		vec3 planet_direction = u_fsh_PlanetPosition - point_in_cloud;
		float planet_distance = length(planet_direction);
		planet_direction = normalize(planet_direction);
		
		float planet_shadow_d = light_distance * (asin(min(1.0, length(cross(light_direction, planet_direction)))) - asin(min(1.0, u_fsh_PlanetRadius / planet_distance)));
		float planet_shadow_w = smoothstep(-1.0, 1.0, -planet_shadow_d / light_radius);
		planet_shadow_w = planet_shadow_w * smoothstep(0.0, 0.2, dot(light_direction, planet_direction));
		
		// Iterate through Light Sample Ray through Cloud Density to obtain Light Source's Transmittance
		float light_source_transmittance = 1.0;
		
		vec3 light_source_cloud_sample_position = cloud_sample_position;
		float light_source_sample_ray_length = raySphere(v_vCloudPosition, u_fsh_CloudRadius, point_in_cloud, -light_direction).y - epsilon;
		float light_source_sample_step_size = light_source_sample_ray_length / (u_LightDepthSamplesCount - 1.0);
		
		for (float j = 0.0; j < u_LightDepthSamplesCount; j++)
		{
			// Sample Local Density from Cloud Noise
			float light_density = cloudSampleNoise(light_source_cloud_sample_position * u_CloudSampleScale);
			
			// Multiply Beer's Law Light Absoption from Light Source's Light passing through Cloud's Density
			light_source_transmittance *= beer(light_density, u_CloudAbsorption);
			
			// Increment Cloud Sampling Position
			light_source_cloud_sample_position -= light_sample_direction * light_source_sample_step_size;
		}
		
		// Calculate Total Scattered Light at Point in Cloud - Add Visible Scattered Light to Cloud's Cumulative Light Value
		vec3 scattered_light = light_color * light_source_transmittance * light_scattering_phase * powder_effect;
		light += scattered_light * transmittance * planet_shadow_w;
		
		// Add Local Density to Cloud's Visible Alpha
		alpha += local_density * u_CloudDensity;
		
		// Multiply Beer's Law Light Absoption from Observable Light passing through Cloud's Density
		transmittance *= beer(local_density, u_CloudAbsorption);
		
		// Increment Cloud Sampling Positions
		cloud_sample_position += v_vSampleForward * cloud_sample_step_size;
		point_in_cloud += camera_forward * cloud_sample_step_size;
	}
	
	// Render Lit Cloud Fragment Color Value
	gl_FragColor = vec4(u_CloudColor * light, alpha);
}
