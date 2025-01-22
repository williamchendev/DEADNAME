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

// Uniform Light & Shadow Layers
uniform vec3 in_Light_Layers;
uniform vec3 in_Shadow_Layers;

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
	vec3 ShadowLayers = vec3(1.0) - (in_Shadow_Layers * SurfaceShadow.a);
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Point Light Vector
	vec3 PointLightVector = vec3(normalize(Center - v_vPosition), cos((Distance / 0.5) * HalfPi));
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(PointLightVector.x, -PointLightVector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(PointLightVector.z, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));
	
	// MRT Render Point Light to Light Blend Layers
	vec3 LightBlend = in_LightColor * in_LightIntensity * LightStrength * LightFade;
	
	gl_FragData[0] = vec4(LightBlend * ShadowLayers.x, 1.0) * in_Light_Layers.x;
	gl_FragData[1] = vec4(LightBlend * ShadowLayers.y, 1.0) * in_Light_Layers.y;
	gl_FragData[2] = vec4(LightBlend * ShadowLayers.z, 1.0) * in_Light_Layers.z;
}
