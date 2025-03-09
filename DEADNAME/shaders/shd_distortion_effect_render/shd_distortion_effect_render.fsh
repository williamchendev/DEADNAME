//
// Surface Distortion Effect fragment shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Distortion Settings
uniform float in_Distortion_Strength;
uniform float in_Distortion_Aspect;

// Uniform Distortion Surface Texture
uniform sampler2D gm_Distortion_Horizontal_Channel_Texture;
uniform sampler2D gm_Distortion_Vertical_Channel_Texture;

// Fragment Shader
void main() 
{
	// Establish Distortion Offset
	vec2 Distortion_Offset = vec2(texture2D(gm_Distortion_Horizontal_Channel_Texture, v_vTexcoord).r, texture2D(gm_Distortion_Vertical_Channel_Texture, v_vTexcoord).r) * in_Distortion_Strength;
	Distortion_Offset *= vec2(-in_Distortion_Aspect, -1.0);
	
	// Render Base Texture with Distortion Offset Effect
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + Distortion_Offset);
}