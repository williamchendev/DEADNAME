//
// (Multi Render Target) Dynamic Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Sprite UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_SpecularMap;

// Interpolated Color & Rotate
varying vec4 v_vColour;
varying vec3 v_vScale;
varying mat2 v_vRotate;

// Uniform Normal Map and Specular Map Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_SpecularTexture;

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
	vec4 Normal = (texture2D(gm_NormalTexture, v_vTexcoord_NormalMap) - 0.5) * 2.0;
	Normal *= vec4(v_vScale, 1.0);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = ((Normal / 2.0) + 0.5);
	
	// Specular Map
	vec4 Specular = texture2D(gm_SpecularTexture, v_vTexcoord_SpecularMap);
	
	// Draw MRT Diffuse, Normal, and Specular Map
    gl_FragData[0] = v_vColour * Diffuse;
    gl_FragData[1] = Normal;
    gl_FragData[2] = vec4(Specular.r * Specular.a, 0.0, 0.0, 1.0);
}
