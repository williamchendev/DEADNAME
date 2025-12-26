//
// Lit Raymarched SDF Sphere Cloud fragment shader meant for Inno's Solar System Overworld
//

// Inno's Test Noise Fragment Shader
uniform float u_Time;

// Interpolated UV & Color
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Constants
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

float perlinNoise(vec3 uvw, vec3 period)
{
	// Perlin Noise Grid Variables
	uvw = uvw * float(cell_count);
	vec3 cells_min = modulo(floor(uvw), period);
	vec3 cells_max = modulo(ceil(uvw), period);
	vec3 uvw_fract = fract(uvw);
	vec3 blur = smoothstep(0.0, 1.0, uvw_fract);
	
	// Establish 8 Corners of Seamless Sample Cube
	vec3 left_down_back 	= random(vec3(cells_min.x, cells_min.y, cells_min.z));
	vec3 right_down_back	= random(vec3(cells_max.x, cells_min.y, cells_min.z));
	vec3 left_up_back		= random(vec3(cells_min.x, cells_max.y, cells_min.z));
	vec3 left_down_front	= random(vec3(cells_min.x, cells_min.y, cells_max.z));
	vec3 right_up_back		= random(vec3(cells_max.x, cells_max.y, cells_min.z));
	vec3 right_down_front	= random(vec3(cells_max.x, cells_min.y, cells_max.z));
	vec3 left_up_front		= random(vec3(cells_min.x, cells_max.y, cells_max.z));
	vec3 right_up_front 	= random(vec3(cells_max.x, cells_max.y, cells_max.z));
	
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
	
	// 
	//float perlin_noise_large = clamp(perlinNoise(uvw * 0.25, perlin_noise_period) * 2.0, 0.5, 1.0);
	//float perlin_noise_large = min(abs(perlinNoise(uvw * 0.25, perlin_noise_period) * 2.0 - 1.0) * 2.0, 1.0);
	
	// Return Final Value
	//return worley_noise + (perlin_noise * 0.2);
	float final_result = worley_noise + (perlin_noise * 0.2);
	return final_result;
}

// Fragment Shader
void main() 
{
	gl_FragColor = v_vColour * cloudNoise(vec3(v_vTexcoord, 0.0) + vec3(u_Time, u_Time, 0.0) * 0.00001);
}
