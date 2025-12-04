//
// Forward Rendered Lit Planet Atmosphere fragment shader meant for Inno's Solar System Overworld
//

// Atmosphere Properties
uniform float u_fsh_Atmosphere_Mask_Radius;

// Planet Properties
uniform float u_Radius;
uniform float u_Elevation;
uniform vec3 u_EulerAngles;

// Texture Properties
uniform sampler2D gm_Atmosphere_Depth_Mask;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec4 v_vSurfaceUV;

// Constants
const vec2 center = vec2(0.5, 0.5);

const float Pi = 3.14159265359;
const float HalfPi = 1.57079632679;

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
	//
	//vec2 uv = (v_vSurfaceUV.xy / v_vSurfaceUV.w) * 0.5 + 0.5;
	//gl_FragColor = vec4(vec3(uv.x, uv.y, 0.0), 1.0);
	//gl_FragColor = vec4(1.0);
	//return;
	
	// Atmosphere Radius
	float radius = distance(v_vPosition, center);
	
	if (radius > 0.5)
	{
		// Circle Cut-Out Early Return
		//return;
	}
	
	//
	vec2 uv = (v_vSurfaceUV.xy / v_vSurfaceUV.w) * 0.5 + 0.5;
	vec4 planet_mask = texture2D(gm_Atmosphere_Depth_Mask, uv);
	
	//
	float atmosphere_depth = (cos(radius * Pi) * (1.0 - planet_mask.a)) + ((1.0 - planet_mask.r) * planet_mask.a);
	
	
	//atmosphere_depth = (1.0 - planet_mask.r);
	
	//
	//float planet_depth = texture2D(gm_Atmosphere_Depth_Mask, v_vSurfaceUV).r;
	
	//float planet_elevation_radius_to_mask_radius_ratio = u_fsh_Atmosphere_Mask_Radius / (u_Radius + u_Elevation);
	
	//
	/*
	if (radius * planet_elevation_radius_to_mask_radius_ratio <= 0.5)
	{
		//
		float planet_radius = radius * planet_elevation_radius_to_mask_radius_ratio;
		planet_depth = cos(planet_radius * Pi);
		
		// Point Light Vector
		mat3 sphere_rotation = eulerRotationMatrix(u_EulerAngles);
		vec3 sphere_vector = vec3((v_vPosition * 2.0 - 1.0) * planet_elevation_radius_to_mask_radius_ratio, cos(planet_radius * Pi)) * vec3(1.0, -1.0, 1.0);
		
		// Sphere UV Calculation
		vec2 sphere_uv = vec2(0.5 - atan2(-sphere_vector.x, -sphere_vector.z) / (2.0 * Pi), 0.5 - asin(-sphere_vector.y) / Pi);
		
		//
		atmosphere_depth = texture2D(gm_BaseTexture, vec2(mod(sphere_uv.x + (radians(u_EulerAngles.y) / 2.0 * Pi), 1.0), sphere_uv.y)).r;
	}
	*/
	
	// Render Atmosphere
    gl_FragColor = vec4(vec3(atmosphere_depth), 1.0);
    //gl_FragColor = vec4(vec3(v_vSurfaceUV.x, 1.0 - v_vSurfaceUV.y, 0.0), 1.0);
}
