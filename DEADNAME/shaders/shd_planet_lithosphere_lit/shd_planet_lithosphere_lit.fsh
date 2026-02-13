//
// (Multi Render Target) Forward Rendered Lit Planet Lithosphere fragment shader meant for Inno's Solar System Overworld
//

// Forward Rendered Lighting Properties
#define MAX_LIGHTS 6
#define MAX_SHADOWS 8

// Camera Properties
uniform vec3 in_fsh_CameraPosition;

// Temporal Properties
uniform float u_NoiseTime;

// Light Source Properties
uniform float in_Light_Exists[MAX_LIGHTS];

uniform float in_Light_Position_X[MAX_LIGHTS];
uniform float in_Light_Position_Y[MAX_LIGHTS];
uniform float in_Light_Position_Z[MAX_LIGHTS];

uniform float in_Light_Color_R[MAX_LIGHTS];
uniform float in_Light_Color_G[MAX_LIGHTS];
uniform float in_Light_Color_B[MAX_LIGHTS];

uniform float in_Light_Radius[MAX_LIGHTS];
uniform float in_Light_Falloff[MAX_LIGHTS];
uniform float in_Light_Intensity[MAX_LIGHTS];
uniform float in_Light_Emitter_Size[MAX_LIGHTS];

// Shadow Properties
uniform float in_Shadow_Exists[MAX_SHADOWS];
uniform float in_Shadow_Radius[MAX_SHADOWS];

uniform float in_Shadow_Position_X[MAX_SHADOWS];
uniform float in_Shadow_Position_Y[MAX_SHADOWS];
uniform float in_Shadow_Position_Z[MAX_SHADOWS];

// Emissive Properties
uniform float u_Emissive;

// Planet Texture Properties
uniform sampler2D in_PlanetTexture;

// Interpolated Color, Normal, Position, Sphere Texture Vector, and Depth
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;
varying float v_vDepth;

// Constants
const float Pi = 3.14159265359;

const float color_range = 256.0;

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

// Noise Functions
// Hash function for pseudo-random values
float hash(vec3 p) 
{
	p = fract(p * 0.1031);
    p += dot(p, p.yzx + 33.33);
    return fract((p.x + p.y) * p.z);
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

// Dithering Functions
// Spatiotemporal pseudo-random Blue Noise dithered color quantization
vec3 dither(vec3 pos, float time, vec3 light)
{
	// Generate stable Spatiotemporal pseudo-random world-space Blue Noise
	float dither_noise = blueNoiseTemporal(pos, time) - 0.5;
	
	// Apply dither before quantization
	vec3 dithered_color = light + (dither_noise / color_range);
	
	// Quantize lighting
	return floor(dithered_color * color_range) / color_range;
}

// Shadow Functions
// Calculates the visible light accumulated at a position behind a sphere's soft shadow
float shadow(vec3 world_position, vec3 light_direction, float light_emitter_size, float light_distance, vec3 sphere_position, float sphere_radius)
{
	vec3 shadow_direction = sphere_position - world_position;
	float shadow_distance = length(shadow_direction);
	shadow_direction = normalize(shadow_direction);
	
	float shadow_d = light_distance * (asin(min(1.0, length(cross(light_direction, shadow_direction)))) - asin(min(1.0, sphere_radius / shadow_distance)));
	float shadow_w = smoothstep(-1.0, 1.0, -shadow_d / light_emitter_size);
	return 1.0 - (shadow_w * smoothstep(0.0, 0.2, dot(light_direction, shadow_direction)));
}

// Fragment Shader
void main() 
{
	// Sphere UV Calculation
	vec2 sphere_uv = vec2(0.5 - atan2(-v_vTexVector.x, -v_vTexVector.z) / (2.0 * Pi), 0.5 - asin(-v_vTexVector.y) / Pi);
	
	// Establish Planet Texture Values at Sphere UV
	vec4 diffuse_color = texture2D(gm_BaseTexture, sphere_uv);
	vec4 planet_values = texture2D(in_PlanetTexture, sphere_uv);
	
	// Establish Roughness Texture Value at Sphere UV
	float roughness = 1.0 - pow(1.0 - planet_values.r, 2.0);
	
	// Calculate Camera View Direction Vector and View Dot Product to Surface Tangent
	vec3 view_direction = normalize(in_fsh_CameraPosition - v_vPosition);
	float view_strength = max(dot(view_direction, v_vNormal), 0.0);
	
	// Calculate Angles of incidence and reflection
	float theta_i = acos(1.0);
	float theta_r = acos(dot(vec3(0.0), v_vNormal));
	
	// Determine max and min Angles for roughness calculation
	float alpha = max(theta_i, theta_r);
	float beta = min(theta_i, theta_r);
	
	// Calculate Oren-Nayar Sigma Values
	float sigma = roughness;
	float sigma_sqr = sigma * sigma;
	
    // Establish Ambient Occlusion Light Color
    vec3 e = v_vColour.rgb; 
    
    // Project light and view vectors onto the tangent plane to calculate cos_phi, the cosine of the azimuthal angle (difference in orientation) between projected light and view
    vec3 l_proj = vec3(0.0);
	vec3 v_proj = normalize(view_direction - v_vNormal * view_strength + 1.0); // +1 to remove a visual artifact
	float cos_phi = dot(l_proj, v_proj);
	
	// Calculate c_a, c_b, c_c
	float c_a = 1.0 - 0.5 * (sigma_sqr / (sigma_sqr + 0.33));
	float c_b = cos_phi >= 0.0 ? 0.45 * (sigma_sqr / (sigma_sqr + 0.09)) * sin(alpha) : 0.45 * (sigma_sqr / (sigma_sqr + 0.09)) * (sin(alpha) - pow((2.0 * beta) / Pi, 3.0));
	float c_c = 0.125 * (sigma_sqr / (sigma_sqr + 0.09)) * pow((4.0 * alpha * beta) / (Pi * Pi), 2.0);
	
	// Compute direct illumination term l_a and interreflected term l_b
	vec3 l_a = diffuse_color.rgb * e * cos(theta_i) * (c_a + (c_b * cos_phi * tan(beta)) + (c_c * (1.0 - abs(cos_phi)) * tan((alpha + beta) / 2.0)));
	vec3 l_b = 0.17 * (diffuse_color.rgb * diffuse_color.rgb) * e * cos(theta_i) * (sigma_sqr / (sigma_sqr + 0.13)) * (1.0 - cos_phi * pow((2.0 * beta) / Pi, 2.0));
	
	// Calculate Final Light Intensity
	vec3 l = clamp(l_a + l_b, 0.0, 1.0); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1.
	
	// Establish Cumulative Light Value with Calculated Ambient Occlusion Light Value
	vec3 light = l;
	
	// Iterate through all Light Sources
	for (int i = 0; i < MAX_LIGHTS; i++)
	{
		// Check if Light Source Exists
		if (in_Light_Exists[i] != 1.0)
		{
			continue;
		}
		
		// Establish Light Source's Color
		vec3 light_color = vec3(in_Light_Color_R[i], in_Light_Color_G[i], in_Light_Color_B[i]);
		
		// Calculate Light Source's Position, Distance, and Falloff Effect
		vec3 light_position = vec3(in_Light_Position_X[i], in_Light_Position_Y[i], in_Light_Position_Z[i]);
		float light_distance = length(v_vPosition - light_position);
		float light_fade = pow((in_Light_Radius[i] - light_distance) / in_Light_Radius[i], in_Light_Falloff[i]);
		
		// Calculate Light Source's Direction Vector and Light Source's Dot Product to Surface Tangent
		vec3 light_direction = normalize(light_position - v_vPosition);
		float light_strength = max(dot(light_direction, v_vNormal), 0.0);
		
		// Calculate Cumulative Shadow by iterating through all Shadow Spheres casting Soft Shadows
		float shadows = 1.0;
		
		for (int n = 0; n < MAX_SHADOWS; n++)
		{
			shadows = in_Shadow_Exists[n] != 1.0 ? shadows : min(shadows, shadow(v_vPosition, light_direction, in_Light_Emitter_Size[i], light_distance, vec3(in_Shadow_Position_X[n], in_Shadow_Position_Y[n], in_Shadow_Position_Z[n]), in_Shadow_Radius[n]));
		}
		
		// Calculate Reflection Coefficent
		vec3 reflection = 2.0 * light_strength * (v_vNormal - light_direction);
		
		// Calculate Angles of incidence and reflection
		theta_i = acos(dot(light_direction, v_vNormal));
		theta_r = acos(dot(reflection, v_vNormal));
		
		// Determine max and min angles for Roughness calculation
		alpha = max(theta_i, theta_r);
		beta = min(theta_i, theta_r);
		
        // Establish Light Source Color with Surface Tangent's Light Strength 
        e = light_color * light_strength; 
        
        // Project light and view vectors onto the tangent plane to calculate cos_phi, the cosine of the azimuthal angle (difference in orientation) between projected light and view
		l_proj = normalize(light_direction - v_vNormal * light_strength);
		v_proj = normalize(view_direction - v_vNormal * view_strength + 1.0); // +1 to remove a visual artifact
		cos_phi = dot(l_proj, v_proj);
		
		// Calculate c_a, c_b, c_c
		c_a = 1.0 - 0.5 * (sigma_sqr / (sigma_sqr + 0.33));
		c_b = cos_phi >= 0.0 ? 0.45 * (sigma_sqr / (sigma_sqr + 0.09)) * sin(alpha) : 0.45 * (sigma_sqr / (sigma_sqr + 0.09)) * (sin(alpha) - pow((2.0 * beta) / Pi, 3.0));
		c_c = 0.125 * (sigma_sqr / (sigma_sqr + 0.09)) * pow((4.0 * alpha * beta) / (Pi * Pi), 2.0);
		
		// Compute direct illumination term l_a and interreflected term l_b
		l_a = diffuse_color.rgb * e * cos(theta_i) * (c_a + (c_b * cos_phi * tan(beta)) + (c_c * (1.0 - abs(cos_phi)) * tan((alpha + beta) / 2.0)));
		l_b = 0.17 * (diffuse_color.rgb * diffuse_color.rgb) * e * cos(theta_i) * (sigma_sqr / (sigma_sqr + 0.13)) * (1.0 - cos_phi * pow((2.0 * beta) / Pi, 2.0));
		
		// Calculate Final Light Intensity
		l = clamp(l_a + l_b, 0.0, 1.0); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1.
		
		// Add Calculated Light to Cumulative Light Value
		light += l * light_fade * in_Light_Intensity[i] * shadows;
	}
	
	// Apply Spatiotemporal Blue Noise Dither Corrected Quantization to Light Color to prevent Color Banding
	light = dither(v_vPosition, u_NoiseTime, light);
	
	// (Multiple Render Targets) Render Lit Sphere, Diffuse, Emissive, and Atmospheric Depth Fragment Values
	gl_FragData[0] = vec4(light, diffuse_color.a);
	gl_FragData[1] = diffuse_color;
	gl_FragData[2] = vec4(vec3(u_Emissive), diffuse_color.a);
	gl_FragData[3] = vec4(vec3(v_vDepth), 1.0);
}
