//
// (Multi Render Target) Bulk Static Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Shader Effect Base Strength & Modifiers
varying vec4 v_vNormal_Settings;
varying vec4 v_vPBR_Settings;

// Interpolated Sprite UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_SpecularMap;
varying vec2 v_vTexcoord_BloomMap;

// Interpolated Color & Rotate
varying vec4 v_vColour;
varying vec3 v_vScale;
varying mat2 v_vRotate;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

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
	vec4 Normal = v_vNormal_Settings.w != 1.0 ? vec4(0.0, 0.0, 1.0, Diffuse.a) : (texture2D(gm_BaseTexture, v_vTexcoord_NormalMap) - 0.5) * 2.0;
	vec3 NormalBaseStrength = vec3((vec2(v_vNormal_Settings.x, v_vNormal_Settings.y) - 0.5) * 2.0, v_vNormal_Settings.z);
	vec3 NormalInverseMagnitude = vec3(1.0) - abs(NormalBaseStrength);
	Normal = vec4(NormalBaseStrength, 0.0) + vec4(NormalInverseMagnitude * Normal.xyz, Normal.a);
	Normal *= vec4(v_vScale.xy, 1.0, 1.0);
	Normal = vec4(mix(vec3(0.0, 0.0, 1.0), Normal.rgb, v_vScale.z), Normal.a);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = (Normal * 0.5) + 0.5;
	
	// Specular Map
	float Metallic = v_vPBR_Settings.z > 0.0 ? ((((texture2D(gm_BaseTexture, v_vTexcoord_SpecularMap).r * 2.0) - 1.0) + (v_vPBR_Settings.z - 1.5)) < 0.0 ? -1.0 : 1.0) : (v_vPBR_Settings.z < -1.0 ? 1.0 : -1.0);
	float Roughness = v_vPBR_Settings.w;
	float Specular = (Roughness * Metallic * 0.5) + 0.5;
	
	// Bloom Map
	float Bloom = v_vPBR_Settings.x <= -1.0 ? v_vPBR_Settings.y * ((v_vPBR_Settings.x + 1.0) * -1.0) : v_vPBR_Settings.y * ((texture2D(gm_BaseTexture, v_vTexcoord_SpecularMap).a * (1.0 - v_vPBR_Settings.x)) + v_vPBR_Settings.x);
	
	// MRT Draw Diffuse Map
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT Draw Normal Map
    gl_FragData[1] = Normal;
    
    // MRT Draw Depth, Specular, and Bloom Map
    gl_FragData[2] = vec4((in_Layer_Depth * 0.5) + 0.5, Specular, Bloom, 1.0);
}
