//
// Lit Raymarched SDF Sphere Cloud fragment shader meant for Inno's Solar System Overworld
//

// Camera Properties
uniform vec3 in_fsh_CameraPosition;
uniform mat4 in_fsh_CameraRotation;

// Sample Properties
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

const float cell_count = 20.0;
const float worley_noise_frequency = 15.0;
const vec3 perlin_noise_period = vec3(25.0, 40.0, 15.0);

// Noise Methods
vec3 modulo(vec3 divident, vec3 divisor)
{
	vec3 positive_divident = mod(divident, divisor) + divisor;
	return mod(positive_divident, divisor);
}

vec3 random(vec3 value)
{
	vec3 value_dot_product = vec3(dot(value, vec3(12.9898, 78.233, 34.897)), dot(value, vec3(12.345, 67.89, 412.12)), dot(value, vec3(56.345, 290.8912, 14.1212)));
	vec3 value_trig = vec3(cos(value_dot_product.x), sin(value_dot_product.y), cos(value_dot_product.z));
	vec3 value_mod = (mod(197.0 * value_trig, 1.0) + value_trig) * 0.5453;
	return fract(value_mod * 43758.5453123) * 2.0 - 1.0;
}

vec3 randomAngle(vec3 value)
{
	vec2 value_dot_product = vec2(dot(value, vec3(12.9898, 78.233, 34.897)), dot(value, vec3(12.345, 67.89, 412.12)));
	vec2 value_trig = vec2(cos(value_dot_product.x), sin(value_dot_product.y));
	vec2 value_mod = (mod(197.0 * value_trig, 1.0) + value_trig) * 0.5453;
	vec2 random_values = fract(value_mod * 43758.5453123);
	
	float theta = acos(2.0 * random_values.x - 1.0);
	float phi = 2.0 * random_values.y * Pi;
	
	float angle_x = cos(phi) * sin(theta);
	float angle_y = sin(phi) * sin(theta);
	float angle_z = cos(theta);
	
	return vec3(angle_x, angle_y, angle_z);
}

float perlinNoise(vec3 uvw, vec3 period)
{
	// Perlin Noise Grid Variables
	uvw = uvw * float(cell_count);
	vec3 cells_min = modulo(floor(uvw), period);
	vec3 cells_max = modulo(ceil(uvw), period);
	vec3 uvw_fract = fract(uvw);
	vec3 blur = smoothstep(0.0, 1.0, uvw_fract);
	
	// Establish 8 Corners of Seamless Sample Cube
	vec3 left_down_back 	= randomAngle(vec3(cells_min.x, cells_min.y, cells_min.z));
	vec3 right_down_back	= randomAngle(vec3(cells_max.x, cells_min.y, cells_min.z));
	vec3 left_up_back		= randomAngle(vec3(cells_min.x, cells_max.y, cells_min.z));
	vec3 left_down_front	= randomAngle(vec3(cells_min.x, cells_min.y, cells_max.z));
	vec3 right_up_back		= randomAngle(vec3(cells_max.x, cells_max.y, cells_min.z));
	vec3 right_down_front	= randomAngle(vec3(cells_max.x, cells_min.y, cells_max.z));
	vec3 left_up_front		= randomAngle(vec3(cells_min.x, cells_max.y, cells_max.z));
	vec3 right_up_front 	= randomAngle(vec3(cells_max.x, cells_max.y, cells_max.z));
	
	// Interpolate Horizontal
	float horizontal_sample_a = mix(dot(left_down_back, uvw_fract - vec3(0.0, 0.0, 0.0)), dot(right_down_back, uvw_fract - vec3(1.0, 0.0, 0.0)), blur.x);
	float horizontal_sample_b = mix(dot(left_up_back, uvw_fract - vec3(0.0, 1.0, 0.0)), dot(right_up_back, uvw_fract - vec3(1.0, 1.0, 0.0)), blur.x);
	float horizontal_sample_c = mix(dot(left_down_front, uvw_fract - vec3(0.0, 0.0, 1.0)), dot(right_down_front, uvw_fract - vec3(1.0, 0.0, 1.0)), blur.x);
	float horizontal_sample_d = mix(dot(left_up_front, uvw_fract - vec3(0.0, 1.0, 1.0)), dot(right_up_front, uvw_fract - vec3(1.0, 1.0, 1.0)), blur.x);
	
	// Interpolate Vertical
	float vertical_sample_a = mix(horizontal_sample_a, horizontal_sample_b, blur.y);
	float vertical_sample_b = mix(horizontal_sample_c, horizontal_sample_d, blur.y);
	
	// Return Final Value
	return mix(vertical_sample_a, vertical_sample_b, blur.z) * 0.8 + 0.5;
}

float worleyNoise(vec3 uvw, float freq)
{
	// Worley Noise Variables
	float minDist = 10000.0;
	vec3 index_uvw = floor(uvw);
	vec3 fract_uvw = fract(uvw);
	
	// Obtain Offset from Each Neighboring Voronoi Cell to find Gradient
	for (float w_w = -1.0; w_w <= 1.0; ++w_w)
	{
		for(float w_h = -1.0; w_h <= 1.0; ++w_h)
		{
			for(float w_l = -1.0; w_l <= 1.0; ++w_l)
			{
				vec3 offset = vec3(w_w, w_h, w_l);
				vec3 h = random(mod(index_uvw + offset, vec3(freq))) * .5 + .5;
				h += offset;
				vec3 d = fract_uvw - h;
				minDist = min(minDist, dot(d, d));
			}
		}
	}
	
	// Return Inverted Worley Noise Value
	return 1.0 - minDist;
}

float worleyFractionalBrownianMotion(vec3 uvw, float freq)
{
	float worley_noise_oct_a = worleyNoise(uvw * freq, freq) * 0.625;
	float worley_noise_oct_b = worleyNoise(uvw * freq * 2.0, freq * 2.0) * 0.25;
	float worley_noise_oct_c = worleyNoise(uvw * freq * 4.0, freq * 4.0) * 0.125;
	return worley_noise_oct_a + worley_noise_oct_b + worley_noise_oct_c;
}

float cloudNoise(vec3 uvw)
{
	// Worley Noise Generation
	float worley_noise_oct_a = worleyFractionalBrownianMotion(uvw, 10.0) * 0.75;
	float worley_noise_oct_b = worleyFractionalBrownianMotion(uvw * 2.0, 20.0) * 0.15;
	float worley_noise_oct_c = worleyFractionalBrownianMotion(uvw * 4.0, 40.0) * 0.1;
	
	float worley_noise = worley_noise_oct_a + worley_noise_oct_b + worley_noise_oct_c;
	
	// Perlin Noise Generation
	float perlin_noise_oct_a = perlinNoise(uvw * 2.0, perlin_noise_period) * 0.625;
	float perlin_noise_oct_b = perlinNoise(uvw * 7.0, perlin_noise_period * 25.0) * 0.25;
	float perlin_noise_oct_c = perlinNoise(uvw * 16.0, perlin_noise_period * 50.0) * 0.125;
	
	float perlin_noise = abs((perlin_noise_oct_a + perlin_noise_oct_b + perlin_noise_oct_c) * 2.0 - 1.0);
	
	// Return Final Value
	float final_result = worley_noise + (perlin_noise * 0.2);
	return final_result;
}

vec3 cloudNoiseNormal(vec3 uvw, float offset)
{
	vec3 offset_xyy = vec3(offset, 0.0, 0.0);
	vec3 offset_yxy = vec3(0.0, offset, 0.0);
	vec3 offset_yyx = vec3(0.0, 0.0, offset);
	vec3 normal = vec3(cloudNoise(uvw)) - vec3(cloudNoise(uvw - offset_xyy), cloudNoise(uvw - offset_yxy), cloudNoise(uvw - offset_yyx));
	return normalize(normal);
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
	
	// Establish Cloud Light, Alpha, and Transmittance
	vec3 light = vec3(0.0);
	float alpha = 0.0;
	float transmittance = 1.0;
	
	// Iterate through Cloud Light Scatter Point Sampling
	for (float i = 0.0; i < u_ScatterPointSamplesCount; i++)
	{
		// Sample Local Density from Cloud Noise
		float local_noise = cloudNoise(cloud_sample_position * u_CloudSampleScale);
		float local_density = local_noise * densityAtPoint(point_in_cloud);
		
		// Calculate Cloud's Powder Effect with Sample's Local Density
		float powder_effect = powder(local_noise, light_cos_theta);
		
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
			float light_density = cloudNoise(light_source_cloud_sample_position * u_CloudSampleScale);
			
			// Multiply Beer's Law Light Absoption from Light Source's Light passing through Cloud's Density
			light_source_transmittance *= beer(light_density, u_CloudAbsorption);
			
			// Increment Cloud Sampling Position
			light_source_cloud_sample_position -= light_sample_direction * light_source_sample_step_size;
		}
		
		// Calculate Total Scattered Light at Point in Cloud - Add Visible Scattered Light to Cloud's Cumulative Light Value
		vec3 scattered_light = light_color * light_scattering_phase * light_source_transmittance * powder_effect;
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
	gl_FragColor = vec4(u_CloudColor * (u_CloudAmbientLightColor + light), alpha);
}
