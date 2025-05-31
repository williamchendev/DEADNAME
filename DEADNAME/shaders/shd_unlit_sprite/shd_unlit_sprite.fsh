//
// Unlit Sprite fragment shader for Inno's Deferred Lighting System
//

// Interpolated Color & Rotate
varying vec2 v_vTexcoord;
varying vec2 v_vSurfaceUV;
varying vec4 v_vColour;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

// Uniform PBR Detail Map Textures
uniform sampler2D gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture;

// Fragment Shader
void main() 
{
	// Diffuse Map
	vec4 Diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
	
	if (Diffuse.a == 0.0)
	{
		return;
	}
	
	// Depth Map
	float Depth = (texture2D(gm_PBR_MetallicRoughness_Emissive_Depth_Map_Texture, v_vSurfaceUV).b * 2.0) - 1.0;
	
	if (in_Layer_Depth < Depth)
	{
		return;
	}
	
	// Draw Unlit Sprite
	gl_FragColor = v_vColour * Diffuse;
}