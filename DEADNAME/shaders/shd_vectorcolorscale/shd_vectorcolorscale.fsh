//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float rScale;
uniform float gScale;
uniform float bScale;

void main()
{	
	// Find Variables
	vec3 Scale = vec3(rScale, gScale, bScale);
	vec4 Color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );

	// RGB Value Scaled -1 to 1
	float Red = ((Color.r - 0.5) * 2.0);
	float Green = ((Color.g - 0.5) * 2.0);
	float Blue = ((Color.b - 0.5) * 2.0);
		
	// RGB Value Calculation
	Red = Red * Scale.x;
	Green = Green * Scale.y;
	Blue = Blue * Scale.z;
		
	// RGB Value Scale Reset
	Red = ((Red / 2.0) + 0.5);
	Green = ((Green / 2.0) + 0.5);
	Blue = ((Blue / 2.0) + 0.5);
	
	// Pass Color
	gl_FragColor = vec4(Red, Green, Blue, Color.a);
}
