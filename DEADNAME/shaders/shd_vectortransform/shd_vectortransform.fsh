//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float vectorAngle;
uniform vec3 vectorScale;

void main()
{	
	// Find Variables
	vec4 Pixel = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	vec3 Color = vec3(Pixel.r, Pixel.g, Pixel.b);

	// RGB Value Scaled -1 to 1
	Color = ((Color - 0.5) * 2.0);
	
	// RGB Value Calculation
	Color = Color * vec3(vectorScale.x * vectorScale.z, vectorScale.y * vectorScale.z, 1.0);
	float ColorDistance = sqrt((Color.x * Color.x) + (Color.y * Color.y));
	float ColorAngle = atan(Color.y, Color.x);
	ColorAngle = ColorAngle + vectorAngle;
	Color.x = cos(ColorAngle) * ColorDistance;
	Color.y = sin(ColorAngle) * ColorDistance;
		
	// RGB Value Scale Reset
	Color = ((Color / 2.0) + 0.5);
	
	// Pass Color
	gl_FragColor = vec4(Color.x, Color.y, Color.z, Pixel.a);
}
