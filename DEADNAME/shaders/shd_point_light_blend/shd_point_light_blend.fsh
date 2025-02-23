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

// Uniform Layered Diffuse Map, Normal Map, Shadow Map, and PBR Detail Map Surface Textures
uniform sampler2D gm_DiffuseMap_BackLayer_Texture;
uniform sampler2D gm_DiffuseMap_MidLayer_Texture;
uniform sampler2D gm_DiffuseMap_FrontLayer_Texture;

uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

uniform sampler2D gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

// Constants
const vec2 Center = vec2(0.5, 0.5);

const float Pi = 3.14159265359;
const float HalfPi = 1.57079632679;
const float OneOverPi = 0.31830988618;

const float PseudoZero = 0.00001;

const float DielectricMaterialLightReflectionCoefficient = 0.04;

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
	vec3 PointLightVector = vec3(normalize(Center - v_vPosition), cos((Distance / 0.5) * HalfPi)) * vec3(1.0, -1.0, 1.0);
	
	// Light Strength Dot Product
	float HighlightStrength = dot(PointLightVector.xy, SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(PointLightVector.z, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));
	
	// Dot Product for Vectors
	float SurfaceToViewVectorDotProduct = max(dot(SurfaceNormal.xyz, vec3(0.0, 0.0, 1.0)), 0.0);
	float HalfViewVectorToLightVector_ViewVectorDotProduct =  max(dot(normalize(PointLightVector + vec3(0.0, 0.0, 1.0)), vec3(0.0, 0.0, 1.0)), 0.0);
	float HalfViewVectorToLightVector_SurfaceVectorDotProduct =  max(dot(normalize(PointLightVector + vec3(0.0, 0.0, 1.0)), SurfaceNormal.xyz), 0.0);
	
	// Surface Diffuse Color
	vec4 DiffuseMap_Back = texture2D(gm_DiffuseMap_BackLayer_Texture, v_vSurfaceUV);
	vec4 DiffuseMap_Mid = texture2D(gm_DiffuseMap_MidLayer_Texture, v_vSurfaceUV);
	vec4 DiffuseMap_Front = texture2D(gm_DiffuseMap_FrontLayer_Texture, v_vSurfaceUV);
	
	// Surface PBR Metallic-Roughness Value
	float MetallicRoughness = texture2D(gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture, v_vSurfaceUV).r;
	vec3 LightReflectionCoefficient = MetallicRoughness <= 0.5 ? vec3(DielectricMaterialLightReflectionCoefficient) : DiffuseMap_Front.rgb + (DiffuseMap_Mid.rgb * (1.0 - DiffuseMap_Front.a)) + (DiffuseMap_Back.rgb * (1.0 - DiffuseMap_Mid.a) * (1.0 - DiffuseMap_Front.a));
	float Roughness = abs(MetallicRoughness - 0.5) * 2.0;
	
	// Frenel-Schlick Approximate
	vec3 FrenelSchlick = LightReflectionCoefficient + ((1.0 - LightReflectionCoefficient) * pow(1.0 - HalfViewVectorToLightVector_ViewVectorDotProduct, 5.0));
	
	// GGX/Trowbridge-Reitz Normal Distribution Function
	float NormalDistribution_GGXTrowbridgeReitz = (Roughness * Roughness) / max(pow(((HalfViewVectorToLightVector_SurfaceVectorDotProduct * HalfViewVectorToLightVector_SurfaceVectorDotProduct) * ((Roughness * Roughness) - 1.0)) + 1.0, 2.0), PseudoZero);
	
	// Smith Model Geometry Shadowing Function
	float GeometricShadowing_ViewVector_Smith = SurfaceToViewVectorDotProduct / max((SurfaceToViewVectorDotProduct * (1.0 - (Roughness / 2.0)) + (Roughness / 2.0)), PseudoZero);
	float GeometricShadowing_LightVector_Smith = LightStrength / max((LightStrength * (1.0 - (Roughness / 2.0)) + (Roughness / 2.0)), PseudoZero);
	float GeometricShadowing_Smith = GeometricShadowing_ViewVector_Smith * GeometricShadowing_LightVector_Smith;
	
	// Cook-Torrance Specular Value
	vec3 CookTorranceSpecular = ((NormalDistribution_GGXTrowbridgeReitz * GeometricShadowing_Smith * FrenelSchlick) / max(4.0 * Pi * SurfaceToViewVectorDotProduct * LightStrength, PseudoZero)) * FrenelSchlick;
	
	// Lambertian Diffuse Value
	vec3 LambertianDiffuse_Back = (1.0 - FrenelSchlick) * DiffuseMap_Back.rgb * OneOverPi;
	vec3 LambertianDiffuse_Mid = (1.0 - FrenelSchlick) * DiffuseMap_Mid.rgb * OneOverPi;
	vec3 LambertianDiffuse_Front = (1.0 - FrenelSchlick) * DiffuseMap_Front.rgb * OneOverPi;
	
	// MRT Render Point Light to Light Blend Layers
	vec3 LightBlend = in_LightColor * in_LightIntensity * LightStrength * LightFade;
	
	gl_FragData[0] = vec4((CookTorranceSpecular + LambertianDiffuse_Back) * LightBlend * ShadowLayers.x, 1.0);
	gl_FragData[1] = vec4((CookTorranceSpecular + LambertianDiffuse_Mid) * LightBlend * ShadowLayers.y, 1.0);
	gl_FragData[2] = vec4((CookTorranceSpecular + LambertianDiffuse_Front) * LightBlend * ShadowLayers.z, 1.0);
}
