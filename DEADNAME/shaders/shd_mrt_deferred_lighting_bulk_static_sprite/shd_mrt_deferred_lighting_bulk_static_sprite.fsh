//
// (Multi Render Target) Dynamic Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Shader Effect Toggles
varying float in_Normal_Enabled;
varying float in_Specular_Enabled;
varying float in_Bloom_Enabled;

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
	vec4 Normal = in_Normal_Enabled == 1.0 ? (texture2D(gm_BaseTexture, v_vTexcoord_NormalMap) - 0.5) * 2.0 : vec4(0.0, 0.0, 1.0, Diffuse.a);
	Normal *= vec4(v_vScale.xy, 1.0, 1.0);
	Normal = vec4(mix(vec3(0.0, 0.0, 1.0), Normal.rgb, v_vScale.z), Normal.a);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = (Normal * 0.5) + 0.5;
	
	// Specular Map
	float Specular = in_Specular_Enabled == 1.0 ? texture2D(gm_BaseTexture, v_vTexcoord_SpecularMap).r : 0.0;
	
	// Bloom Map
	float Bloom = in_Bloom_Enabled == 1.0 ? texture2D(gm_BaseTexture, v_vTexcoord_BloomMap).a : 0.0;
	
	// MRT Draw Diffuse Map
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT Draw Normal Map
    gl_FragData[1] = Normal;
    
    // MRT Draw Depth, Specular, and Bloom Map
    gl_FragData[2] = vec4((in_Layer_Depth * 0.5) + 0.5, Specular, Bloom, 1.0);
}
