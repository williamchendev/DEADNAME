//
// (Multi Render Target) Bulk Static Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Color & Rotate
varying vec4 v_vColour;
varying vec3 v_vScale;
varying mat2 v_vRotate;

// Interpolated Sprite UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec3 v_vTexcoord_NormalMap;
varying vec3 v_vTexcoord_MetallicRoughnessMap;
varying vec3 v_vTexcoord_EmissiveMap;

// Interpolated Shader Effect Base Strength & Modifiers
varying vec4 v_vPBR_Settings;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

// Fragment Shader
void main()
{
	// Diffuse Color Data
	vec4 Diffuse = texture2D(gm_BaseTexture, v_vTexcoord_DiffuseMap);
	
	if (Diffuse.a == 0.0)
	{
		return;
	}
	
	// Normal Vector Data
	vec4 Normal = v_vTexcoord_NormalMap.z != 1.0 ? vec4(0.0, 0.0, 1.0, Diffuse.a) : (texture2D(gm_BaseTexture, v_vTexcoord_NormalMap.xy) - vec4(0.5, 0.5, 0.0, 0.0)) * vec4(2.0, 2.0, 1.0, 1.0);
	Normal *= vec4(v_vScale.xy, 1.0, 1.0);
	Normal = vec4(mix(vec3(0.0, 0.0, 1.0), Normal.rgb, v_vScale.z), Normal.a);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = (Normal * 0.5) + 0.5;
	
	// Metallic-Roughness PBR Data
	vec4 MetallicRoughnessMap = v_vTexcoord_MetallicRoughnessMap.z != 1.0 ? vec4(0.0, 0.0, 0.0, 0.0) : texture2D(gm_BaseTexture, v_vTexcoord_MetallicRoughnessMap.xy);
	float Metallic = MetallicRoughnessMap.a > 0.0 ? (MetallicRoughnessMap.b > 0.5 ? 1.0 : -1.0) : (v_vPBR_Settings.x > 0.5 ? 1.0 : -1.0);
	float Roughness = MetallicRoughnessMap.a > 0.0 ? MetallicRoughnessMap.r : v_vPBR_Settings.y;
	
	// Emissive Data
	float Emissive = v_vTexcoord_EmissiveMap.z != 1.0 ? v_vPBR_Settings.z * v_vPBR_Settings.w : v_vPBR_Settings.w * ((texture2D(gm_BaseTexture, v_vTexcoord_EmissiveMap.xy).a * (1.0 - v_vPBR_Settings.z)) + v_vPBR_Settings.z);
	
	// MRT[0] Diffuse Color Layer: Draw Sprite Diffuse Color
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT[1] Normal Vector Layer: Draw Sprite Normal Vector
    gl_FragData[1] = vec4(Normal.rgb, v_vColour.a * Normal.a * Diffuse.a);
    
    // MRT[2] BRDF Workflow Layer: Draw PBR Metallic-Roughness, Emissive, and Depth Data
    gl_FragData[2] = vec4((Roughness * Metallic * 0.5) + 0.5, Emissive, (in_Layer_Depth * 0.5) + 0.5, 1.0);
}
