//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
	// Vector Data
	float PointDistance = distance(v_vTexcoord, vec2(0.5, 0.5));
	
	// Check Point Range
	vec3 Color = vec3(0.0, 0.0, 0.0);
	if (PointDistance <= 0.5) {
		// Variables
		float PI = 3.141592;
		
		// RGB Value Calculation
		float Red = (sin(v_vTexcoord.x * PI) / 2.0) + 0.5;
		float Green = (sin((1.0 - v_vTexcoord.y) * PI) / 2.0) + 0.5;
		float Blue = sqrt(1.0 - (PointDistance * 1.2));
		
		// Set Color
		Color = vec3(Red, Green, Blue);
	}
	
	// Pass Color
    gl_FragColor = v_vColour * Color.r * Color.g * Color.b;
}
