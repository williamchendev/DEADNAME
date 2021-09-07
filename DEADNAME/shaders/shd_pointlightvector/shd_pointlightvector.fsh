//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

void main()
{	
	// Vector Data
	float PointDistance = distance(v_vTexcoord, vec2(0.5, 0.5));
	
	// Check Point Range
	vec4 Color = vec4(0.0, 0.0, 0.0, 0.0);
	if (PointDistance <= 0.5) {
		// Variables
		float PI = 3.141592;
		
		// RGB Value Calculation
		float Red = ((-1.0 * cos(v_vTexcoord.x * PI)) / 2.0) + 0.5;
		float Green = ((-1.0 * cos((1.0 - v_vTexcoord.y) * PI)) / 2.0) + 0.5;
		float Blue = sqrt(1.0 - (PointDistance * 1.5));
		float Alpha = 1.0;
		
		// Set Color
		Color = vec4(Red, Green, Blue, Alpha);
	}
	
	// Pass Color
	vec4 cl = (Color * 2.0) - 1.0;
	vec2 pd1 = vec2(cl.r, cl.g) / cl.b;
	vec2 pd2 = vec2(0.5, 0.5);
	vec2 pd = (pd1 + pd2) / 2.0;
	
	vec3 normalPd = normalize(vec3(pd.x, pd.y, 1.0));

	Color = vec4(Color.x, Color.y, normalPd.z, Color.a);
	gl_FragColor = Color;
}
