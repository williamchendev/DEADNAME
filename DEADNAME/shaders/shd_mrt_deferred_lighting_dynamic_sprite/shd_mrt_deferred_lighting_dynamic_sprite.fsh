//
// (Multi Render Target) Dynamic Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Sprite UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_SpecularMap;
varying vec2 v_vTexcoord_BloomMap;

// Interpolated Color & Rotate
varying vec4 v_vColour;
varying mat2 v_vRotate;

// Uniform Normal Map Transformations
uniform vec2 in_VectorScale;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

// Uniform Shader Effect Settings
uniform vec3 in_Normal_BaseStrength;
uniform float in_Specular_BaseStrength;
uniform float in_Bloom_BaseStrength;

uniform float in_Normal_Modifier;
uniform float in_Specular_Modifier;
uniform float in_Bloom_Modifier;

uniform float in_Normal_Enabled;
uniform float in_Specular_Enabled;
uniform float in_Bloom_Enabled;

// Uniform Normal Map and Specular Map Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_SpecularTexture;
uniform sampler2D gm_BloomTexture;

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
	vec4 Normal = in_Normal_Enabled == 1.0 ? (texture2D(gm_NormalTexture, v_vTexcoord_NormalMap) - 0.5) * 2.0 : vec4(0.0, 0.0, 1.0, Diffuse.a);
	Normal = vec4(in_Normal_BaseStrength, 0.0) + vec4((vec3(1.0) - abs(in_Normal_BaseStrength)) * Normal.xyz, Normal.a);
	Normal *= vec4(in_VectorScale, 1.0, 1.0);
	Normal = vec4(mix(vec3(0.0, 0.0, 1.0), Normal.rgb, in_Normal_Modifier), Normal.a);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = (Normal * 0.5) + 0.5;
	
	// Specular Map
	float Specular = in_Specular_Enabled == 1.0 ? in_Specular_Modifier * ((texture2D(gm_SpecularTexture, v_vTexcoord_SpecularMap).r * (1.0 - in_Specular_BaseStrength)) + in_Specular_BaseStrength) : in_Specular_BaseStrength * in_Specular_Modifier;
	
	// Bloom Map
	float Bloom = in_Bloom_Enabled == 1.0 ? in_Bloom_Modifier * ((texture2D(gm_BloomTexture, v_vTexcoord_BloomMap).a * (1.0 - in_Bloom_BaseStrength)) + in_Bloom_BaseStrength) : in_Bloom_BaseStrength * in_Bloom_Modifier;
	
	// MRT Draw Diffuse Map
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT Draw Normal Map
    gl_FragData[1] = Normal;
    
    // MRT Draw Depth, Specular, and Bloom Map
    gl_FragData[2] = vec4((in_Layer_Depth * 0.5) + 0.5, Specular, Bloom, 1.0);
}
