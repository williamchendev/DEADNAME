//
// (Multi Render Target) Dynamic Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Color & Rotate
varying vec4 v_vColour;
varying mat2 v_vRotate;

// Interpolated Sprite UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_MetallicRoughnessMap;
varying vec2 v_vTexcoord_EmissiveMap;

// Uniform Normal Map Transformations
uniform vec2 in_VectorScale;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

// Uniform Shader Effect Settings
uniform float in_NormalStrength;
uniform float in_Metallic;
uniform float in_Roughness;
uniform float in_Emissive;
uniform float in_EmissiveMultiplier;

// Uniform Normal, MetallicRoughness, & Emissive Map Toggles
uniform float in_NormalMap_Enabled;
uniform float in_MetallicRoughnessMap_Enabled;
uniform float in_EmissiveMap_Enabled;

// Uniform Normal, MetallicRoughness, & Emissive Map Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_MetallicRoughnessTexture;
uniform sampler2D gm_EmissiveTexture;

// Fragment Shader
void main()
{
	// Diffuse Map
	vec4 Diffuse = texture2D(gm_BaseTexture, v_vTexcoord_DiffuseMap);
	
	if (Diffuse.a == 0.0)
	{
		return;
	}
	
	// Normal Map
	vec4 Normal = in_NormalMap_Enabled != 1.0 ? vec4(0.0, 0.0, 1.0, Diffuse.a) : (texture2D(gm_NormalTexture, v_vTexcoord_NormalMap) - vec4(0.5, 0.5, 0.0, 0.0)) * vec4(2.0, 2.0, 1.0, 1.0);
	Normal *= vec4(in_VectorScale, 1.0, 1.0);
	Normal = vec4(mix(vec3(0.0, 0.0, 1.0), Normal.rgb, in_NormalStrength), Normal.a);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = (Normal * 0.5) + 0.5;
	
	// Metallic-Roughness PBR Data
	vec4 MetallicRoughnessMap = in_MetallicRoughnessMap_Enabled != 1.0 ? vec4(0.0, 0.0, 0.0, 0.0) : texture2D(gm_MetallicRoughnessTexture, v_vTexcoord_MetallicRoughnessMap);
	float Metallic = MetallicRoughnessMap.a > 0.0 ? (MetallicRoughnessMap.b > 0.5 ? 1.0 : -1.0) : in_Metallic;
	float Roughness = MetallicRoughnessMap.a > 0.0 ? MetallicRoughnessMap.r : in_Roughness;
	
	// Emissive Data
	float Emissive = in_EmissiveMap_Enabled != 1.0 ? in_Emissive * in_EmissiveMultiplier : in_EmissiveMultiplier * ((texture2D(gm_EmissiveTexture, v_vTexcoord_EmissiveMap).a * (1.0 - in_Emissive)) + in_Emissive);
	
	// MRT[0] Diffuse Color Layer: Draw Sprite Diffuse Color
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT[1] Normal Vector Layer: Draw Sprite Normal Vector
    gl_FragData[1] = vec4(Normal.rgb, v_vColour.a * Normal.a * Diffuse.a);
    
    // MRT[2] BRDF Workflow Layer: Draw PBR Metallic-Roughness, Emissive, and Depth Data
    gl_FragData[2] = vec4((Roughness * Metallic * 0.5) + 0.5, Emissive, (in_Layer_Depth * 0.5) + 0.5, v_vColour.a * Diffuse.a);
}
