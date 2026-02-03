//
// (Multi Render Target) Forward Rendered Lit Planet Lithosphere fragment shader meant for Inno's Solar System Overworld
//

// Forward Rendered Lighting Properties
#define MAX_LIGHTS 6

// Camera Properties
uniform vec3 in_fsh_CameraPosition;

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
        light += l * light_fade * in_Light_Intensity[i];
	}
	
	// (Multiple Render Targets) Render Lit Sphere & Depth Fragment Values
	gl_FragData[0] = vec4(light, diffuse_color.a);
	gl_FragData[1] = vec4(vec3(v_vDepth), 1.0);
}
