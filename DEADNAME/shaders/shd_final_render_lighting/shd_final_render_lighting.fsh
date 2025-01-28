//
// (Multi Render Target) Lit Surface Final Rendering Pass fragment shader for Inno's Deferred Lighting System
//

// Uniform Distortion Settings & Surface Texture
uniform float in_Distortion_Strength;
uniform float in_Distortion_Aspect;

uniform sampler2D gm_Distortion_Texture;

// Uniform Background Surface Texture
uniform sampler2D gm_Background_Texture;

// Uniform Diffuse Map Surface Textures
uniform sampler2D gm_DiffuseMap_BackLayer_Texture;
uniform sampler2D gm_DiffuseMap_FrontLayer_Texture;

// Uniform Light Blend Surface Textures
uniform sampler2D gm_LightBlend_BackLayer_Texture;
uniform sampler2D gm_LightBlend_MidLayer_Texture;
uniform sampler2D gm_LightBlend_FrontLayer_Texture;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Establish Distortion Offset
	vec2 Distortion_Offset = (texture2D(gm_Distortion_Texture, v_vTexcoord).xy - 0.5) * 2.0 * in_Distortion_Strength;
	Distortion_Offset *= vec2(in_Distortion_Aspect, -1.0);
	
	// Establish Background Surface Colors
	vec4 Background_SurfaceColor = texture2D(gm_Background_Texture, v_vTexcoord + Distortion_Offset);
	
	// Establish Diffuse Map Surface Colors
	vec4 DiffuseMap_BackLayer_SurfaceColor = texture2D(gm_DiffuseMap_BackLayer_Texture, v_vTexcoord + Distortion_Offset);
	vec4 DiffuseMap_MidLayer_SurfaceColor = texture2D(gm_BaseTexture, v_vTexcoord + Distortion_Offset);
	vec4 DiffuseMap_FrontLayer_SurfaceColor = texture2D(gm_DiffuseMap_FrontLayer_Texture, v_vTexcoord + Distortion_Offset);
	
	// Establish Light Blend Surface Colors
	vec4 LightBlend_BackLayer_SurfaceColor = texture2D(gm_LightBlend_BackLayer_Texture, v_vTexcoord + Distortion_Offset);
	vec4 LightBlend_MidLayer_SurfaceColor = texture2D(gm_LightBlend_MidLayer_Texture, v_vTexcoord + Distortion_Offset);
	vec4 LightBlend_FrontLayer_SurfaceColor = texture2D(gm_LightBlend_FrontLayer_Texture, v_vTexcoord + Distortion_Offset);
	
	// Layer Color Values
	vec4 RenderColor_BackLayer = DiffuseMap_BackLayer_SurfaceColor * LightBlend_BackLayer_SurfaceColor;
	vec4 RenderColor_MidLayer = DiffuseMap_MidLayer_SurfaceColor * LightBlend_MidLayer_SurfaceColor;
	vec4 RenderColor_FrontLayer = DiffuseMap_FrontLayer_SurfaceColor * LightBlend_FrontLayer_SurfaceColor;
	
	vec4 RenderColor_Final = RenderColor_FrontLayer + (RenderColor_MidLayer * (1.0 - RenderColor_FrontLayer.a)) + (RenderColor_BackLayer * (1.0 - RenderColor_MidLayer.a) * (1.0 - RenderColor_FrontLayer.a)) + (Background_SurfaceColor * (1.0 - RenderColor_BackLayer.a) * (1.0 - RenderColor_MidLayer.a) * (1.0 - RenderColor_FrontLayer.a));
	
	// Lit Surface Final Render Pass
	gl_FragColor = v_vColour * RenderColor_Final;
}