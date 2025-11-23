//
// Forward Rendered Lit Planet Body fragment shader meant for Inno's Solar System Overworld
//

// Forward Rendered Lighting Properties
#define MAX_LIGHTS 6

// Camera Properties
uniform vec3 in_camera_position;

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

// Interpolated Color, Normal, Position, and Sphere Texture Vector
varying vec4 v_vColour;
varying vec3 v_vNormal;
varying vec3 v_vPosition;
varying vec3 v_vTexVector;

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
	vec2 Texcoord = vec2(0.5 - atan2(-v_vTexVector.x, -v_vTexVector.z) / (2.0 * Pi), 0.5 - asin(-v_vTexVector.y) / Pi);
	
	// Diffuse Texture Color
	vec4 Diffuse = texture2D(gm_BaseTexture, Texcoord);
	
	//
	float Height = texture2D(in_heightmap_texture, Texcoord).r;
	
	//
	vec3 ViewDirection = normalize(in_camera_position - v_vPosition);
	float ViewStrength = max(dot(ViewDirection, v_vNormal), 0.0);
	
	/*
	vec3 n = UnityObjectToWorldNormal(vertex.normal);         // Transform normal to world space
	vec3 l = normalize(_WorldSpaceLightPos0.xyz);             // Get normalized light direction
	vec3 r = 2.0 * dot(n, l) * n - l;                         // Calculate reflection vector
	half3 v = normalize(_WorldSpaceCameraPos - worldPos);      // Get normalized view direction

	vec3 E0 = lightColor.rgb * max(0.0, dot(n, l)); 

	// Calculate angles of incidence and reflection
	float theta_i = acos(dot(l, n));
	float theta_r = acos(dot(r, n));
	
	// Project light and view vectors onto the tangent plane to calculate cosPhi, the cosine of the azimuthal angle (difference in orientation) between projected light and view
	vec3 Lproj = normalize(l - n * NdotL);
	vec3 Vproj = normalize(v - n * NdotV + 1.0); // +1 to remove a visual artifact
	float cosPhi = dot(Lproj, Vproj);
	
	// Determine max and min angles for roughness calculation
	float alpha = max(theta_i, theta_r);
	float beta = min(theta_i, theta_r);
	float sigmaSqr = sigma * sigma;
	
	// Calculate C1, C2, C3
	float C1 = 1.0 - 0.5 * (sigmaSqr / (sigmaSqr + 0.33));
	float C2 = cosPhi >= 0.0 ? 0.45 * (sigmaSqr / (sigmaSqr + 0.09)) * sin(alpha) 
	            : 0.45 * (sigmaSqr / (sigmaSqr + 0.09)) * (sin(alpha) - pow((2.0 * beta) / PI, 3.0));
	float C3 = 0.125 * (sigmaSqr / (sigmaSqr + 0.09)) * pow((4.0 * alpha * beta) / (PI * PI), 2.0);
	
	// Compute direct illumination term L1 and interreflected term L2
	vec3 L1 = diffuseColour * E0 * cos(theta_i) * (C1 + (C2 * cosPhi * tan(beta)) + (C3 * (1.0 - abs(cosPhi)) * tan((alpha + beta) / 2.0)));
	vec3 L2 = 0.17 * (diffuseColour * diffuseColour) * E0 * cos(theta_i) * (sigmaSqr / (sigmaSqr + 0.13)) 
	            * (1.0 - cosPhi * pow((2.0 * beta) / PI, 2.0));
	
	// Final light intensity
	vec3 L = clamp(L1 + L2, 0.0, 1.0); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1.
	*/
	
	//
	// Calculate angles of incidence and reflection
	float theta_i = acos(1.0);
	float theta_r = acos(dot(vec3(0.0), v_vNormal));
	
	// Determine max and min angles for roughness calculation
	float alpha = max(theta_i, theta_r);
	float beta = min(theta_i, theta_r);
	
	float sigma = 1.0 - pow(1.0 - Height, 2.0);
	float sigmaSqr = sigma * sigma;
	        
    //
    vec3 E0 = v_vColour.rgb; 
    
    // Project light and view vectors onto the tangent plane to calculate cosPhi, the cosine of the azimuthal angle (difference in orientation) between projected light and view
    vec3 Lproj = vec3(0.0);
	vec3 Vproj = normalize(ViewDirection - v_vNormal * ViewStrength + 1.0); // +1 to remove a visual artifact
	float cosPhi = dot(Lproj, Vproj);
	
	// Calculate C1, C2, C3
	float C1 = 1.0 - 0.5 * (sigmaSqr / (sigmaSqr + 0.33));
	float C2 = cosPhi >= 0.0 ? 0.45 * (sigmaSqr / (sigmaSqr + 0.09)) * sin(alpha) : 0.45 * (sigmaSqr / (sigmaSqr + 0.09)) * (sin(alpha) - pow((2.0 * beta) / Pi, 3.0));
	float C3 = 0.125 * (sigmaSqr / (sigmaSqr + 0.09)) * pow((4.0 * alpha * beta) / (Pi * Pi), 2.0);
	
	// Compute direct illumination term L1 and interreflected term L2
	vec3 L1 = Diffuse.rgb * E0 * cos(theta_i) * (C1 + (C2 * cosPhi * tan(beta)) + (C3 * (1.0 - abs(cosPhi)) * tan((alpha + beta) / 2.0)));
	vec3 L2 = 0.17 * (Diffuse.rgb * Diffuse.rgb) * E0 * cos(theta_i) * (sigmaSqr / (sigmaSqr + 0.13)) * (1.0 - cosPhi * pow((2.0 * beta) / Pi, 2.0));
	
	// Final light intensity
	vec3 L = clamp(L1 + L2, 0.0, 1.0); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1.
	
	//
	vec3 Light = L;
	
	// Iterate through all Lights
	for (int i = 0; i < MAX_LIGHTS; i++)
	{
		//
		if (in_light_exists[i] != 1.0)
		{
			continue;
		}
		
		//
		vec3 LightPosition = vec3(in_light_position_x[i], in_light_position_y[i], in_light_position_z[i]);
		
		// Light Falloff Effect
		float LightDistance = length(v_vPosition - LightPosition);
		float LightFade = pow((in_light_radius[i] - LightDistance) / in_light_radius[i], in_light_falloff[i]);
		
		//
		vec3 LightDirection = normalize(LightPosition - v_vPosition);
		//vec3 LightDirection = v_vNormal;
		float LightStrength = max(dot(LightDirection, v_vNormal), 0.0);
		
		//
		vec3 Reflection = 2.0 * LightStrength * (v_vNormal - LightDirection);
		
		//
		vec3 LightColor = vec3(in_light_color_r[i], in_light_color_g[i], in_light_color_b[i]);
		//Color += vec4(LightColor * LightStrength * in_light_intensity[i], 0.0);
		
		// Calculate angles of incidence and reflection
		theta_i = acos(dot(LightDirection, v_vNormal));
		theta_r = acos(dot(Reflection, v_vNormal));
		
		// Determine max and min angles for roughness calculation
		alpha = max(theta_i, theta_r);
		beta = min(theta_i, theta_r);
		        
        //
        E0 = LightColor * LightStrength; 
        
        // Project light and view vectors onto the tangent plane to calculate cosPhi, the cosine of the azimuthal angle (difference in orientation) between projected light and view
		Lproj = normalize(LightDirection - v_vNormal * LightStrength);
		Vproj = normalize(ViewDirection - v_vNormal * ViewStrength + 1.0); // +1 to remove a visual artifact
		cosPhi = dot(Lproj, Vproj);
		
		// Calculate C1, C2, C3
		C1 = 1.0 - 0.5 * (sigmaSqr / (sigmaSqr + 0.33));
		C2 = cosPhi >= 0.0 ? 0.45 * (sigmaSqr / (sigmaSqr + 0.09)) * sin(alpha) : 0.45 * (sigmaSqr / (sigmaSqr + 0.09)) * (sin(alpha) - pow((2.0 * beta) / Pi, 3.0));
		C3 = 0.125 * (sigmaSqr / (sigmaSqr + 0.09)) * pow((4.0 * alpha * beta) / (Pi * Pi), 2.0);
		
		// Compute direct illumination term L1 and interreflected term L2
		L1 = Diffuse.rgb * E0 * cos(theta_i) * (C1 + (C2 * cosPhi * tan(beta)) + (C3 * (1.0 - abs(cosPhi)) * tan((alpha + beta) / 2.0)));
		L2 = 0.17 * (Diffuse.rgb * Diffuse.rgb) * E0 * cos(theta_i) * (sigmaSqr / (sigmaSqr + 0.13)) * (1.0 - cosPhi * pow((2.0 * beta) / Pi, 2.0));
		
		// Final light intensity
		L = clamp(L1 + L2, 0.0, 1.0); // Clamped between 0 and 1 to prevent lighting values from going negative or exceeding 1.
		
		//
        Light += L * LightFade * in_light_intensity[i];
	}
	
	// Draw Sphere
	gl_FragColor = vec4(Light, Diffuse.a);
}
