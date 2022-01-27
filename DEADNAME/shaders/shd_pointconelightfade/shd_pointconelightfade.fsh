//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float lightConeDirection;
uniform float lightConeFOV;

#define PI 3.1415926535

void main()
{
	// Vector Data
	float PointDistance = distance(v_vTexcoord, vec2(0.5, 0.5));
	
	// Check Point Range
	float LightStrength = 0.0;
	if (PointDistance <= 0.5) {
		// Cone Angle Calculation
		float PointAngle = atan(-(v_vTexcoord.y - 0.5), v_vTexcoord.x - 0.5);
		float PointAngleDis = abs(mod(PointAngle + (2.0 * PI), 2.0 * PI) - lightConeDirection);
		PointAngleDis = min(PointAngleDis, (2.0 * PI) - PointAngleDis);
		
		// Point within Cone FOV
		if (PointAngleDis <= (lightConeFOV / 2.0)) {
			// Light Strength Calculation
			float Red = 1.0 - (PointAngleDis / (lightConeFOV * 0.75));
			float Green = sin(Red * (PI / 2.0));
			float Blue = sqrt(1.0 - (PointDistance * 1.2));

			// Set Light Strength
			LightStrength = Green * Blue;
		}
	}
	
	// Pass Color
    gl_FragColor = v_vColour * LightStrength;
}
