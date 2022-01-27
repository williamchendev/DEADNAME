//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Textures
uniform sampler2D spriteNormalTex;
uniform sampler2D lightVectorTex;
uniform sampler2D lightBlendTex;
uniform sampler2D lightShadowsTex;
uniform sampler2D lightRenderTex;

void main()
{
	// Color Data
	vec4 NormalColor = texture2D(spriteNormalTex, v_vTexcoord);
	vec4 LightVectorColor = texture2D(lightVectorTex, v_vTexcoord);
	vec4 LightBlendColor = texture2D(lightBlendTex, v_vTexcoord);
	vec4 lightShadowsColor = texture2D(lightShadowsTex, v_vTexcoord);
	vec4 LightColor = texture2D(lightRenderTex, v_vTexcoord);
	
	vec4 Color = vec4(0.0, 0.0, 0.0, 0.0);
	
	// Calculate Vector Color
	float LightVector = 0.0;
	if (NormalColor.a > 0.0) {
		if (LightBlendColor.a > 0.0) {
			// Vector RGB
			float LightVectorR = (LightVectorColor.r * 2.0) - 1.0;
			float LightVectorG = (LightVectorColor.g * 2.0) - 1.0;
			float LightVectorB = (LightVectorColor.b * 2.0) - 1.0;
		
			// Normal RGB
			float NormalR = (NormalColor.r * 2.0) - 1.0;
			float NormalG = ((1.0 - NormalColor.g) * 2.0) - 1.0;
			float NormalB = (NormalColor.b * 2.0) - 1.0;
		
			// Vector Calc
			NormalR = clamp(1.0 - abs(NormalR - LightVectorR), 0.0, 1.0);
			NormalG = clamp(1.0 - abs(NormalG - LightVectorG), 0.0, 1.0);
			NormalB = clamp(1.0 - abs(NormalB - LightVectorB), 0.0, 1.0);
		
			float Highlights = (NormalR + NormalG) * 0.5;
		
			LightVector = (Highlights * 0.5) + (NormalB * 0.5);
		
			// New Stuff
			Color = max(LightBlendColor * LightVector, LightColor);
			Color.a = 1.0 - lightShadowsColor.a;
		}
	}
	
    gl_FragColor = Color;
}
