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
uniform sampler2D gm_DiffuseTexture_BackLayer;
uniform sampler2D gm_DiffuseTexture_MidLayer;
uniform sampler2D gm_DiffuseTexture_FrontLayer;

uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

uniform sampler2D gm_DepthSpecularBloomTexture;

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
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Light Falloff Effect
	float LightFade = 1.0 - pow((Distance / 0.5), in_LightFalloff);
	
	// Get Shadow Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceShadow = texture2D(gm_ShadowTexture, v_vSurfaceUV);
	vec3 ShadowLayers = (vec3(1.0) - (in_Shadow_Layers * SurfaceShadow.a)) * in_Light_Layers;
	
	// Point Light Vector
	vec3 PointLightVector = vec3(normalize(Center - v_vPosition), cos((Distance / 0.5) * HalfPi));
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(PointLightVector.x, -PointLightVector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(PointLightVector.z, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));
	
	// Dot Product for Vectors
	float SurfaceToViewVectorDotProduct = dot(SurfaceNormal.xyz, vec3(0.0, 0.0, 1.0));
	float HalfViewVectorToLightVectorDotProduct =  dot(normalize(SurfaceNormal.xyz + PointLightVector), vec3(0.0, 0.0, 1.0));
	
	
	
	
	// MRT Render Point Light to Light Blend Layers
	vec3 LightBlend = in_LightColor * in_LightIntensity * LightStrength * LightFade;
	
	gl_FragData[0] = vec4(LightBlend * ShadowLayers.x, 1.0);
	gl_FragData[1] = vec4(LightBlend * ShadowLayers.y, 1.0);
	gl_FragData[2] = vec4(LightBlend * ShadowLayers.z, 1.0);
	gl_FragData[3] = vec4(in_Light_Layers.x, in_Light_Layers.y, in_Light_Layers.z, LightStrength);
}
