//
// Spot Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Lighting Engine Strength Multiplier Settings
uniform float in_HighLight_Strength_Multiplier;
uniform float in_BroadLight_Strength_Multiplier;
uniform float in_HighLight_To_BroadLight_Ratio_Max;

// Uniform Light Source Properties
uniform vec3 in_LightColor;
uniform float in_LightAlpha;
uniform float in_LightIntensity;
uniform float in_LightFalloff;

// Uniform Spot Light Properties
uniform vec2 in_LightDirection;
uniform float in_LightAngle;

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

// Fast Approximation Inverse Cosign Method
float fastacos(float x) 
{
	// Handbook of Mathematical Functions
	// M. Abramowitz and I.A. Stegun, Ed.

	float negate = float(x < 0.0);
	x = abs(x);
	float ret = -0.0187293;
	ret *= x;
	ret += 0.0742610;
	ret *= x;
	ret -= 0.2121144;
	ret *= x;
	ret += 1.5707288;
	ret *= sqrt(1.0 - x);
	ret = ret - 2.0 * negate * ret;
	return negate * Pi + ret;
}

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
	
	// Spot Light Vector
	vec2 SpotLightVector = normalize(Center - v_vPosition);
	
	// Spot Light FOV Calculation
	float LightDirectionDotProduct = clamp(dot(-SpotLightVector, vec2(in_LightDirection.x, -in_LightDirection.y)), -1.0, 1.0);
	float LightDirectionValue = fastacos(LightDirectionDotProduct) / Pi;
	
	if (LightDirectionValue > in_LightAngle)
	{
		// Outside Spot Light FOV Early Return
		return;
	}
	
	// Spot Light (Broadlight) Depth Vector Calculation
	float LightDirectionStrength = pow(1.0 - (((1.0 - LightDirectionValue) - (1.0 - in_LightAngle)) / in_LightAngle), 2.0);
	float LightDepthVector = cos(LightDirectionStrength * HalfPi);
	
	// Light Falloff Effect
	float LightFade = 1.0 - pow((Distance / 0.5), in_LightFalloff);
	
	// Get Shadow Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceShadow = texture2D(gm_ShadowTexture, v_vSurfaceUV);
	vec3 ShadowLayers = vec3(1.0) - (in_Shadow_Layers * SurfaceShadow.a);
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(SpotLightVector.x, -SpotLightVector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(LightDepthVector, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));

	// Dot Product for Vectors
	float SurfaceToViewVectorDotProduct = max(dot(SurfaceNormal.xyz, vec3(0.0, 0.0, 1.0)), 0.0);
	float HalfViewVectorToLightVector_ViewVectorDotProduct =  max(dot(normalize(vec3(SpotLightVector.x, -SpotLightVector.y, LightDepthVector) + vec3(0.0, 0.0, 1.0)), vec3(0.0, 0.0, 1.0)), 0.0);
	float HalfViewVectorToLightVector_SurfaceVectorDotProduct =  max(dot(normalize(vec3(SpotLightVector.x, -SpotLightVector.y, LightDepthVector) + vec3(0.0, 0.0, 1.0)), SurfaceNormal.xyz), 0.0);
	
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
	float GeometricShadowing_RoughnessK = ((Roughness + 1.0) * (Roughness + 1.0)) / 8.0;
	GeometricShadowing_RoughnessK = Roughness / 2.0;
	float GeometricShadowing_ViewVector_Smith = SurfaceToViewVectorDotProduct / max((SurfaceToViewVectorDotProduct * (1.0 - GeometricShadowing_RoughnessK) + GeometricShadowing_RoughnessK), PseudoZero);
	float GeometricShadowing_LightVector_Smith = LightStrength / max((LightStrength * (1.0 - GeometricShadowing_RoughnessK) + GeometricShadowing_RoughnessK), PseudoZero);
	float GeometricShadowing_Smith = GeometricShadowing_ViewVector_Smith * GeometricShadowing_LightVector_Smith;
	
	// Cook-Torrance Specular Value
	vec3 CookTorranceSpecular = ((NormalDistribution_GGXTrowbridgeReitz * GeometricShadowing_Smith * FrenelSchlick) / max(4.0 * Pi * SurfaceToViewVectorDotProduct * LightStrength, PseudoZero)) * FrenelSchlick;
	
	// Lambertian Diffuse Value
	vec3 LambertianDiffuse_Back = (1.0 - FrenelSchlick) * DiffuseMap_Back.rgb * OneOverPi;
	vec3 LambertianDiffuse_Mid = (1.0 - FrenelSchlick) * DiffuseMap_Mid.rgb * OneOverPi;
	vec3 LambertianDiffuse_Front = (1.0 - FrenelSchlick) * DiffuseMap_Front.rgb * OneOverPi;
	
	// MRT Render Point Light to Light Blend Layers
	vec3 LightBlend = in_LightColor * in_LightAlpha * in_LightIntensity * LightStrength * LightFade;
	
	gl_FragData[0] = vec4((CookTorranceSpecular + LambertianDiffuse_Back) * LightBlend * ShadowLayers.x, 1.0);
	gl_FragData[1] = vec4((CookTorranceSpecular + LambertianDiffuse_Mid) * LightBlend * ShadowLayers.y, 1.0);
	gl_FragData[2] = vec4((CookTorranceSpecular + LambertianDiffuse_Front) * LightBlend * ShadowLayers.z, 1.0);
}
