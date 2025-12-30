//
// Lit Raymarched SDF Sphere Cloud fragment shader meant for Inno's Solar System Overworld
//

// Camera Properties
uniform vec3 in_fsh_CameraPosition;
uniform mat4 in_fsh_CameraRotation;

//


// 
uniform float u_Time;

//
uniform float u_fsh_CloudRadius;

uniform float u_fsh_CloudSampleRadius;
uniform float u_CloudPointSamplesCount;

// Interpolated Square UV, Surface Mask UV, and World Position
varying vec2 v_vSquareUV;
varying vec4 v_vSurfaceUV;
varying vec3 v_vWorldPosition;
varying vec3 v_vSampleForward;
varying vec3 v_vSamplePosition;

// Constants
const float Pi = 3.14159265359;

const float epsilon = 0.0001;

const vec2 center = vec2(0.5, 0.5);

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
	
	// Calculate Cloud Depth
	float cloud_depth = cos(radius * Pi);
	
	// Calculate UV Position of Surface and Retreive Atmosphere's Planet Depth Mask
	vec2 uv = (v_vSurfaceUV.xy / v_vSurfaceUV.w) * 0.5 + 0.5;
	//vec4 planet_mask = texture2D(gm_AtmospherePlanetDepthMask, uv);
	
	// Sample Cloud Noise
	float cloud_optical_density = 0.0;
	vec3 cloud_sample_position = v_vSamplePosition - v_vSampleForward * (u_fsh_CloudSampleRadius - epsilon);
	float cloud_sample_ray_length = u_fsh_CloudSampleRadius * cloud_depth - epsilon * 2.0;
	float cloud_sample_step_size = cloud_sample_ray_length / (u_CloudPointSamplesCount - 1.0);
	
	for (float i = 0.0; i < u_CloudPointSamplesCount; i++)
	{
		//
		cloud_optical_density += cloudNoise(cloud_sample_position * 0.01) * 0.05;
		cloud_sample_position += v_vSampleForward * cloud_sample_step_size;
	}
	
	//
	//gl_FragColor = cloudNoise(vec3(v_vTexcoord, 0.0) + vec3(u_Time, u_Time, 0.0) * 0.00001);
	
	gl_FragData[0] = vec4(vec3(cloud_optical_density), 1.0);
	gl_FragData[1] = vec4(vec3(cloud_optical_density), 1.0);
}
