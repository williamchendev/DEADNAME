//
// Directional Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Lighting Engine Strength Multiplier Settings
uniform float in_HighLight_Strength_Multiplier;
uniform float in_BroadLight_Strength_Multiplier;
uniform float in_HighLight_To_BroadLight_Ratio_Max;

// Uniform Light Source Properties
uniform vec2 in_LightSource_Vector;

// Uniform Light Layers
uniform vec3 in_Light_Layers;
uniform vec3 in_Shadow_Layers;

// Uniform Layered Diffuse Map, Normal Map, Shadow Map, and PBR Detail Map Surface Textures
uniform sampler2D gm_DiffuseMap_BackLayer_Texture;
uniform sampler2D gm_DiffuseMap_MidLayer_Texture;
uniform sampler2D gm_DiffuseMap_FrontLayer_Texture;

uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

uniform sampler2D gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture;

// Interpolated Color and UV
varying vec4 v_vColour;
varying vec2 v_vSurfaceUV;

// Constants
const float Pi = 3.14159265359;
const float OneOverPi = 0.31830988618;

const float PseudoZero = 0.00001;

const float DielectricMaterialLightReflectionCoefficient = 0.04;
const float MetallicMaterialLightReflectionCoefficient = 0.92;

// Fragment Shader
void main() 
{
	// Get Shadow Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceShadow = texture2D(gm_BaseTexture, v_vSurfaceUV);
	vec3 ShadowLayers = vec3(1.0) - (in_Shadow_Layers * SurfaceShadow.a);
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(in_LightSource_Vector.x, in_LightSource_Vector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(1.0, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));
	
	// Dot Product for Vectors
	float SurfaceToViewVectorDotProduct = max(dot(SurfaceNormal.xyz, vec3(0.0, 0.0, 1.0)), 0.0);
	float HalfViewVectorToLightVector_ViewVectorDotProduct =  max(dot(normalize(vec3(in_LightSource_Vector, 1.0) + vec3(0.0, 0.0, 1.0)), vec3(0.0, 0.0, 1.0)), 0.0);
	float HalfViewVectorToLightVector_SurfaceVectorDotProduct =  max(dot(normalize(vec3(in_LightSource_Vector, 1.0) + vec3(0.0, 0.0, 1.0)), SurfaceNormal.xyz), 0.0);
	
	// Surface Diffuse Color
	vec3 DiffuseMap_Back = texture2D(gm_DiffuseMap_BackLayer_Texture, v_vSurfaceUV).rgb;
	vec3 DiffuseMap_Mid = texture2D(gm_DiffuseMap_MidLayer_Texture, v_vSurfaceUV).rgb;
	vec3 DiffuseMap_Front = texture2D(gm_DiffuseMap_FrontLayer_Texture, v_vSurfaceUV).rgb;
	
	// Surface PBR Metallic-Roughness Value
	float MetallicRoughness = texture2D(gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture, v_vSurfaceUV).r;
	float LightReflectionCoefficient = MetallicRoughness <= 0.5 ? DielectricMaterialLightReflectionCoefficient : MetallicMaterialLightReflectionCoefficient;
	float Roughness = abs(MetallicRoughness - 0.5) * 2.0;
	
	// Frenel-Schlick Approximate
	float FrenelSchlick = LightReflectionCoefficient + ((1.0 - LightReflectionCoefficient) * pow(1.0 - HalfViewVectorToLightVector_ViewVectorDotProduct, 5.0));
	
	// GGX/Trowbridge-Reitz Normal Distribution Function
	float NormalDistribution_GGXTrowbridgeReitz = (Roughness * Roughness) / max(pow(((HalfViewVectorToLightVector_SurfaceVectorDotProduct * HalfViewVectorToLightVector_SurfaceVectorDotProduct) * ((Roughness * Roughness) - 1.0)) + 1.0, 2.0), PseudoZero);
	
	// Smith Model Geometry Shadowing Function
	float GeometricShadowing_ViewVector_Smith = SurfaceToViewVectorDotProduct / max((SurfaceToViewVectorDotProduct * (1.0 - (Roughness / 2.0)) + (Roughness / 2.0)), PseudoZero);
	float GeometricShadowing_LightVector_Smith = LightStrength / max((LightStrength * (1.0 - (Roughness / 2.0)) + (Roughness / 2.0)), PseudoZero);
	float GeometricShadowing_Smith = GeometricShadowing_ViewVector_Smith * GeometricShadowing_LightVector_Smith;
	
	// Cook-Torrance Specular Value
	float CookTorranceSpecular = (NormalDistribution_GGXTrowbridgeReitz * GeometricShadowing_Smith * FrenelSchlick) / max((4.0 * Pi * SurfaceToViewVectorDotProduct * LightStrength) * FrenelSchlick, PseudoZero);
	
	// Lambertian Diffuse Value
	vec3 LambertianDiffuse_Back = (1.0 - FrenelSchlick) * DiffuseMap_Back * OneOverPi;
	vec3 LambertianDiffuse_Mid = (1.0 - FrenelSchlick) * DiffuseMap_Mid * OneOverPi;
	vec3 LambertianDiffuse_Front = (1.0 - FrenelSchlick) * DiffuseMap_Front * OneOverPi;
	
	// MRT Render Directional Light to Light Blend Layers
	vec3 LightBlend = v_vColour.rgb * v_vColour.a * LightStrength;
	
	gl_FragData[0] = vec4((CookTorranceSpecular + LambertianDiffuse_Back) * LightBlend * ShadowLayers.x, 1.0);
	gl_FragData[1] = vec4((CookTorranceSpecular + LambertianDiffuse_Mid) * LightBlend * ShadowLayers.y, 1.0);
	gl_FragData[2] = vec4((CookTorranceSpecular + LambertianDiffuse_Front) * LightBlend * ShadowLayers.z, 1.0);
}
