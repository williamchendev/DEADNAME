//
// Point Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Lighting Engine Strength Multiplier Settings
uniform float in_HighLight_Strength_Multiplier;
uniform float in_BroadLight_Strength_Multiplier;
uniform float in_HighLight_To_BroadLight_Ratio_Max;

// Uniform Light Source Properties
uniform vec3 in_LightColor;
uniform float in_LightIntensity;
uniform float in_LightFalloff;

// Uniform Normal Map and Shadow Map Surface Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

// Constants
const vec2 Center = vec2(0.5, 0.5);
const float HalfPi = 1.57079632679;

// Fragment Shader
void main() 
{
	// Point Light Distance
	float Distance = distance(v_vPosition, Center);
	
	if (Distance > 0.5)
	{
		// Circle Cut-Out Early Return
		return;
	}
	
	// Light Falloff Effect
	float LightFade = 1.0 - pow((Distance / 0.5), in_LightFalloff);
	
	// Get Shadow Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceShadow = texture2D(gm_ShadowTexture, v_vSurfaceUV);
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Point Light Vector
	vec3 PointLightVector = vec3(normalize(Center - v_vPosition), cos((Distance / 0.5) * HalfPi));
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(PointLightVector.x, -PointLightVector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(PointLightVector.z, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));
	
	// Render Point Light
	gl_FragColor = vec4(in_LightColor, in_LightIntensity * (1.0 - SurfaceShadow.a)) * LightStrength * LightFade;
}