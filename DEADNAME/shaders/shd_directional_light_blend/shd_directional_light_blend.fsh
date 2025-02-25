//
// Directional Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Lighting Engine Strength Multiplier Settings
uniform float in_Global_Illumination_Multiplier;
uniform float in_HighLight_Strength_Multiplier;
uniform float in_BroadLight_Strength_Multiplier;
uniform float in_HighLight_To_BroadLight_Ratio_Max;

// Uniform Light Source Properties
uniform vec2 in_LightSource_Vector;
uniform float in_LightIntensity;

// Uniform Light Layers
uniform vec3 in_Light_Layers;
uniform vec3 in_Shadow_Layers;

// Uniform Layered Diffuse Maps, Normal Map, Shadow Map, and PBR Detail Map Surface Textures
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
	vec4 DiffuseMap_Back = texture2D(gm_DiffuseMap_BackLayer_Texture, v_vSurfaceUV);
	vec4 DiffuseMap_Mid = texture2D(gm_DiffuseMap_MidLayer_Texture, v_vSurfaceUV);
	vec4 DiffuseMap_Front = texture2D(gm_DiffuseMap_FrontLayer_Texture, v_vSurfaceUV);
	
	// Surface PBR Metallic-Roughness Value
	float MetallicRoughness = texture2D(gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture, v_vSurfaceUV).r;
	vec3 LightReflectionCoefficient = MetallicRoughness <= 0.5 ? vec3(DielectricMaterialLightReflectionCoefficient) : DiffuseMap_Front.rgb + (DiffuseMap_Mid.rgb * (1.0 - DiffuseMap_Front.a)) + (DiffuseMap_Back.rgb * (1.0 - DiffuseMap_Mid.a) * (1.0 - DiffuseMap_Front.a));
	float Roughness = abs(MetallicRoughness - 0.5);
	
	// Frenel-Schlick Approximate
	vec3 FrenelSchlick = LightReflectionCoefficient + ((1.0 - LightReflectionCoefficient) * pow(1.0 - HalfViewVectorToLightVector_ViewVectorDotProduct, 5.0));
	
	// GGX/Trowbridge-Reitz Normal Distribution Function
	float NormalDistribution_Roughness = Roughness * Roughness * Roughness;
	float NormalDistribution_GGXTrowbridgeReitz = NormalDistribution_Roughness / (Pi * max(pow(((HalfViewVectorToLightVector_SurfaceVectorDotProduct * HalfViewVectorToLightVector_SurfaceVectorDotProduct) * (NormalDistribution_Roughness - 1.0)) + 1.0, 2.0), PseudoZero));
	
	// Smith Model Geometry Shadowing Function
	float GeometricShadowing_RoughnessK = ((Roughness + 1.0) * (Roughness + 1.0)) / 8.0;
	float GeometricShadowing_ViewVector_Smith = SurfaceToViewVectorDotProduct / max((SurfaceToViewVectorDotProduct * (1.0 - GeometricShadowing_RoughnessK) + GeometricShadowing_RoughnessK), PseudoZero);
	float GeometricShadowing_LightVector_Smith = LightStrength / max((LightStrength * (1.0 - GeometricShadowing_RoughnessK) + GeometricShadowing_RoughnessK), PseudoZero);
	float GeometricShadowing_Smith = GeometricShadowing_ViewVector_Smith * GeometricShadowing_LightVector_Smith;
	
	// Cook-Torrance Specular Value
	vec3 CookTorranceSpecular = (NormalDistribution_GGXTrowbridgeReitz * GeometricShadowing_Smith * FrenelSchlick) / max(4.0 * SurfaceToViewVectorDotProduct * LightStrength, PseudoZero);
	
	// Burley Diffuse Geometry Shadowing Function
	float GeometricShadowing_RoughnessFD = (3.0 * Roughness * HalfViewVectorToLightVector_SurfaceVectorDotProduct * HalfViewVectorToLightVector_SurfaceVectorDotProduct);
	float GeometricShadowing_ViewVector_Burley = 1.0 + pow((GeometricShadowing_RoughnessFD - 1.0) * (1.0 - SurfaceToViewVectorDotProduct), 3.0);
	float GeometricShadowing_LightVector_Burley = 1.0 + pow((GeometricShadowing_RoughnessFD - 1.0) * (1.0 - LightStrength), 3.0);
	float GeometricShadowing_Inno = 1.0 - pow(Roughness * 1.5, 3.0);
	float GeometricShadowing_Burley = GeometricShadowing_ViewVector_Burley * GeometricShadowing_LightVector_Burley * GeometricShadowing_Inno;
	
	// Lambertian Diffuse Value
	vec3 LambertianDiffuse_Back = (1.0 - FrenelSchlick) * DiffuseMap_Back.rgb * OneOverPi * GeometricShadowing_Burley;
	vec3 LambertianDiffuse_Mid = (1.0 - FrenelSchlick) * DiffuseMap_Mid.rgb * OneOverPi * GeometricShadowing_Burley;
	vec3 LambertianDiffuse_Front = (1.0 - FrenelSchlick) * DiffuseMap_Front.rgb * OneOverPi * GeometricShadowing_Burley;
	
	// MRT Render Directional Light to Light Blend Layers
	vec3 LightBlend = v_vColour.rgb * v_vColour.a * in_LightIntensity * LightStrength * in_Global_Illumination_Multiplier;
	
	gl_FragData[0] = vec4((CookTorranceSpecular + LambertianDiffuse_Back) * LightBlend * ShadowLayers.x, 1.0);
	gl_FragData[1] = vec4((CookTorranceSpecular + LambertianDiffuse_Mid) * LightBlend * ShadowLayers.y, 1.0);
	gl_FragData[2] = vec4((CookTorranceSpecular + LambertianDiffuse_Front) * LightBlend * ShadowLayers.z, 1.0);
}
