//
// Forward Rendered Lit Planet Hydrosphere fragment shader meant for Inno's Solar System Overworld
//

// Forward Rendered Lighting Properties
#define MAX_LIGHTS 6

// Camera Properties
uniform vec3 in_fsh_camera_position;

// Planet Properties
uniform float u_fsh_Elevation;

// Hydrosphere Properties
uniform float u_fsh_Ocean_Elevation;
uniform float u_Ocean_Roughness;
uniform vec4 u_Ocean_Color;

uniform float u_Ocean_Foam_Size;
uniform vec4 u_Ocean_Foam_Color;

// Light Source Properties
uniform float in_light_exists[MAX_LIGHTS];

uniform float in_light_position_x[MAX_LIGHTS];
uniform float in_light_position_y[MAX_LIGHTS];
uniform float in_light_position_z[MAX_LIGHTS];

uniform float in_light_color_r[MAX_LIGHTS];
uniform float in_light_color_g[MAX_LIGHTS];
uniform float in_light_color_b[MAX_LIGHTS];

uniform float in_light_radius[MAX_LIGHTS];
uniform float in_light_falloff[MAX_LIGHTS];
uniform float in_light_intensity[MAX_LIGHTS];

// Planet Texture Properties
uniform sampler2D in_heightmap_texture;

// Interpolated Color, Normal, Position, Sphere Texture, and Elevation Vector
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;
varying float v_vElevation;

// Constants
const float Pi = 3.14159265359;

const float pseudo_zero = 0.00001;
const float pseudo_infinity = 1.0 / 0.0;

const float dielectric_material_light_reflection_coefficient = 0.04;

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
	// Calculate Camera View Direction Vector and View Dot Product to Surface Tangent
	vec3 view_direction = normalize(in_fsh_camera_position - v_vPosition);
	float view_strength = max(dot(view_direction, v_vNormal), 0.0);
	
	// Check if Sphere Fragment is facing Camera's Forward Vector
	if (dot(view_direction, v_vNormal) <= 0.0)
	{
		return;
	}
	
	// Calculate Ocean Foam Difference
	float ocean_height = u_fsh_Elevation * u_fsh_Ocean_Elevation;
	
	// Check if Elevation is Higher or Equal to Ocean Height
	if (v_vElevation >= ocean_height)
	{
		return;
	}
	
	// Sphere UV Calculation
	vec2 sphere_uv = vec2(0.5 - atan2(-v_vTexVector.x, -v_vTexVector.z) / (2.0 * Pi), 0.5 - asin(-v_vTexVector.y) / Pi);
	
	// Establish Diffuse Texture Color
	float ocean_height_difference = abs(ocean_height - v_vElevation);
	vec4 diffuse_color = (ocean_height_difference <= u_Ocean_Foam_Size) ? u_Ocean_Foam_Color : u_Ocean_Color;
	
	// Calculate Angles of incidence and reflection
	float theta_i = acos(1.0);
	float theta_r = acos(dot(vec3(0.0), v_vNormal));
	
	// Determine max and min Angles for roughness calculation
	float alpha = max(theta_i, theta_r);
	float beta = min(theta_i, theta_r);
	
	// Calculate Oren-Nayar Sigma Values
	float sigma_sqr = u_Ocean_Roughness * u_Ocean_Roughness;
	
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
	vec3 o_l = clamp(l_a + l_b, 0.0, 1.0); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1
	
	// Establish Cumulative Light Value with Calculated Ambient Occlusion Light Value
	vec3 light = o_l;
	
	// Iterate through all Lights
	for (int i = 0; i < MAX_LIGHTS; i++)
	{
		// Check if Light Source Exists
		if (in_light_exists[i] != 1.0)
		{
			continue;
		}
		
		// Establish Light Source's Color
		vec3 light_color = vec3(in_light_color_r[i], in_light_color_g[i], in_light_color_b[i]);
		
		// Calculate Light Source's Position, Distance, and Falloff Effect
		vec3 light_position = vec3(in_light_position_x[i], in_light_position_y[i], in_light_position_z[i]);
		float light_distance = length(v_vPosition - light_position);
		float light_fade = pow((in_light_radius[i] - light_distance) / in_light_radius[i], in_light_falloff[i]);
		
		// Calculate Light Source's Direction Vector and Light Source's Dot Product to Surface Tangent
		vec3 light_direction = normalize(light_position - v_vPosition);
		float light_strength = max(dot(light_direction, v_vNormal), 0.0);
		
		// Calculate Normalized Sum of Light Source's Direction Vector and the View Direction Vector
		vec3 normalized_light_and_view_direction = normalize(light_direction + view_direction);      
		
		// Calculate Half Dot Product of Light Source's Direction to the View Direction
		float half_view_to_light_strength =  max(dot(normalized_light_and_view_direction, view_direction), 0.0);
		
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
        
        // Cook-Torrance Specular Lighting
		float s_a = acos(light_strength); // Convert NdotH to an angle in radians
		float s_m = clamp(sigma_sqr, pseudo_zero, 1.0);	// Clamp roughness value to avoid extreme cases
		float s_exp = exp(-tan(s_a) * tan(s_a) / (s_m * s_m)); // Exponent term for Beckmann distribution
		float s_d = clamp(s_exp / (Pi * s_m * s_m * pow(light_strength, 4.0)), pseudo_zero, pseudo_infinity); // Beckmann Distribution. Clamped to get rid of a visual artefact
		
		// Calculate Light Reflection Coefficient
		vec3 light_reflection_coefficient = (ocean_height_difference <= u_Ocean_Foam_Size) ? vec3(dielectric_material_light_reflection_coefficient) : diffuse_color.rgb;
		
		// Calculate Fresnel using Schlick's approximation
		vec3 frenel_schlick = light_reflection_coefficient + ((1.0 - light_reflection_coefficient) * pow(1.0 - half_view_to_light_strength, 5.0));
		
		// Smith Model Geometry Shadowing Function
		float s_ga = 2.0 * dot(normalized_light_and_view_direction, v_vNormal) * dot(v_vNormal, view_direction) / dot(view_direction, normalized_light_and_view_direction);
		float s_gb = 2.0 * dot(normalized_light_and_view_direction, v_vNormal) * dot(v_vNormal, light_direction) / dot(view_direction, normalized_light_and_view_direction);
		float s_g = min(1.0, min(s_ga, s_gb));
		
		// Specular Reflection Light Component
		vec3 s_l = ((s_d * s_g * frenel_schlick) / (4.0 * dot(v_vNormal, light_direction) * dot(v_vNormal, view_direction))) * e;
        
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
		
		// Calculate Oren-Nayar Light Component
		o_l = clamp(l_a + l_b, 0.0, 1.0) * (vec3(1.0) - frenel_schlick); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1
		
		// Add Calculated Light to Cumulative Light Value
        light += (o_l + s_l) * light_fade * in_light_intensity[i];
	}
	
	// Render Lit Sphere Fragment Value
	gl_FragColor = vec4(light, diffuse_color.a);
}
