//
// Forward Rendered Lit Planet Lithosphere fragment shader meant for Inno's Solar System Overworld
//

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
	vec2 sphere_uv = vec2(0.5 - atan2(-v_vTexVector.x, -v_vTexVector.z) / (2.0 * Pi), 0.5 - asin(-v_vTexVector.y) / Pi);
	
	// Establish Diffuse Texture Color at Sphere UV
	vec4 diffuse_color = texture2D(gm_BaseTexture, sphere_uv);
	
	// Render Lit Sphere Fragment Value
	gl_FragColor = v_vColour;
}
