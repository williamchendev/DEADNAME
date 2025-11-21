//
// Basic Unlit Sphere fragment shader meant to test rendering 3D models
//

// Interpolated Color, Normal, & Texture UVs
varying vec3 v_vNormal;
varying vec4 v_vColour;

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
	vec2 Texcoord = vec2(0.5 - atan2(-v_vNormal.x, -v_vNormal.z) / (2.0 * Pi), 0.5 - asin(-v_vNormal.y) / Pi);
	
	// Diffuse Texture Color
	vec4 Diffuse = texture2D(gm_BaseTexture, Texcoord);
	
	// Draw Sphere
	gl_FragColor = v_vColour * Diffuse;
}