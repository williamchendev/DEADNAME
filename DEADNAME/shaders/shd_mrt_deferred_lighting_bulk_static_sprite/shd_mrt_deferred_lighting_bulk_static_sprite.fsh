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
	vec4 Normal = (texture2D(gm_BaseTexture, v_vTexcoord_NormalMap) - 0.5) * 2.0;
	Normal *= vec4(v_vScale, 1.0);
	
	// Normal Vector Rotation & Scale Calculation
	Normal.xy = Normal.xy * v_vRotate;
	Normal = (Normal * 0.5) + 0.5;
	
	// Specular Map
	vec4 Specular = texture2D(gm_BaseTexture, v_vTexcoord_SpecularMap);
	
	// MRT Draw Diffuse Map
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT Draw Normal Map
    gl_FragData[1] = Normal;
    
    // MRT Draw Depth, Specular, and Stencil Map
    gl_FragData[2] = vec4((in_Layer_Depth * 0.5) + 0.5, Specular.r, 0.0, 1.0);
}
