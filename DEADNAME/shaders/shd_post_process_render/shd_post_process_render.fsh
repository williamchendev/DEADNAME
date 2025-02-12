//
// (Multi Render Target) Lit Surface Post Process Rendering Pass fragment shader for Inno's Deferred Lighting System
//

// Uniform Background Surface Texture
uniform sampler2D gm_Background_Texture;

// Uniform Diffuse Map Surface Textures
uniform sampler2D gm_DiffuseMap_BackLayer_Texture;
uniform sampler2D gm_DiffuseMap_FrontLayer_Texture;

// Uniform Light Blend Surface Textures
uniform sampler2D gm_LightBlend_BackLayer_Texture;
uniform sampler2D gm_LightBlend_MidLayer_Texture;
uniform sampler2D gm_LightBlend_FrontLayer_Texture;

// Uniform Depth, Specular, and Bloom Map
uniform sampler2D gm_DepthSpecularBloomMap;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Find Specular & Bloom Value at Pixel
	vec4 DepthSpecularBloomValue = texture2D(gm_DepthSpecularBloomMap, v_vTexcoord);
	float SpecularValue = DepthSpecularBloomValue.g;
	float BloomValue = DepthSpecularBloomValue.b;
	
	// Establish Background Surface Colors
	vec4 Background_SurfaceColor = texture2D(gm_Background_Texture, v_vTexcoord);
	
	// Establish Diffuse Map Surface Colors
	vec4 DiffuseMap_BackLayer_SurfaceColor = texture2D(gm_DiffuseMap_BackLayer_Texture, v_vTexcoord);
	vec4 DiffuseMap_MidLayer_SurfaceColor = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 DiffuseMap_FrontLayer_SurfaceColor = texture2D(gm_DiffuseMap_FrontLayer_Texture, v_vTexcoord);
	
	// Establish Light Blend Surface Colors
	vec4 LightBlend_BackLayer_SurfaceColor = max(texture2D(gm_LightBlend_BackLayer_Texture, v_vTexcoord), vec4(BloomValue));
	vec4 LightBlend_MidLayer_SurfaceColor = max(texture2D(gm_LightBlend_MidLayer_Texture, v_vTexcoord), vec4(BloomValue));
	vec4 LightBlend_FrontLayer_SurfaceColor = max(texture2D(gm_LightBlend_FrontLayer_Texture, v_vTexcoord), vec4(BloomValue));
	
	// Layer Color Values
	vec4 RenderColor_BackLayer = vec4(mix(DiffuseMap_BackLayer_SurfaceColor.rgb, vec3(1.0), SpecularValue), DiffuseMap_BackLayer_SurfaceColor.a) * LightBlend_BackLayer_SurfaceColor;
	vec4 RenderColor_MidLayer = vec4(mix(DiffuseMap_MidLayer_SurfaceColor.rgb, vec3(1.0), SpecularValue), DiffuseMap_MidLayer_SurfaceColor.a) * LightBlend_MidLayer_SurfaceColor;
	vec4 RenderColor_FrontLayer = vec4(mix(DiffuseMap_FrontLayer_SurfaceColor.rgb, vec3(1.0), SpecularValue), DiffuseMap_FrontLayer_SurfaceColor.a) * LightBlend_FrontLayer_SurfaceColor;
	
	vec4 RenderColor_Final = RenderColor_FrontLayer + (RenderColor_MidLayer * (1.0 - RenderColor_FrontLayer.a)) + (RenderColor_BackLayer * (1.0 - RenderColor_MidLayer.a) * (1.0 - RenderColor_FrontLayer.a)) + (Background_SurfaceColor * (1.0 - RenderColor_BackLayer.a) * (1.0 - RenderColor_MidLayer.a) * (1.0 - RenderColor_FrontLayer.a));
	
	// Lit Surface Final Render Pass
	gl_FragColor = v_vColour * RenderColor_Final;
}
