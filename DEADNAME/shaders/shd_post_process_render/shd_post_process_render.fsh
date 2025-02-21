//
// (Multi Render Target) Lit Surface Post Process Rendering Pass fragment shader for Inno's Deferred Lighting System
//

#define FRESNEL 0.8

// Uniform Light Blend Surface Textures
uniform sampler2D gm_LightBlend_Texture;
uniform sampler2D gm_LightBlend_DotProduct_Texture;

// Uniform Depth, Specular, and Bloom Map
uniform sampler2D gm_DepthSpecularBloomMap;

// Uniform View Normal Map
uniform sampler2D gm_ViewNormal_Texture;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Constants
const float PI = 3.1415926535;
const float InversePI = 0.318309886184;
const float FresnelRefraction = FRESNEL;
const float FresnelReflection = 1.0 - FRESNEL;

// Fragment Shader
void main() 
{
	// Find Specular & Bloom Value at Pixel
	vec4 DepthSpecularBloomValue = texture2D(gm_DepthSpecularBloomMap, v_vTexcoord);
	float RoughnessModifier = pow(abs((DepthSpecularBloomValue.g - 0.5) * 2.0), 4.0);
	float MetallicModifier = ((DepthSpecularBloomValue.g - 0.5) * 2.0) > 0.0 ? 0.92 : 0.04;
	float BloomModifier = DepthSpecularBloomValue.b;
	
	// Establish Diffuse Map Surface Colors
	vec4 DiffuseMap_SurfaceColor = texture2D(gm_BaseTexture, v_vTexcoord) * FresnelRefraction * InversePI;
	
	// Establish Light Blend Surface Colors
	vec4 LightBlend_SurfaceColor = max(texture2D(gm_LightBlend_Texture, v_vTexcoord), vec4(BloomModifier));
	
	// Establish Light Dot Product Values
	
	
	vec4 Normal_DotProduct = texture2D(gm_LightBlend_DotProduct_Texture, v_vTexcoord).r;
	
	float Dis = (Normal_DotProduct * Normal_DotProduct) * (RoughnessModifier - 1.0) + 1.0;
	float NormalDistribution = RoughnessModifier / (PI * Dis * Dis);
	
	float GeometryDistribution = pow(RoughnessModifier + 1.0, 2.0) / 8.0;
	
	float FresnelApproximation = 
	
	float SpecularDenominator = 4.0 * Normal_DotProduct * View_DotProduct;
	
	// Layer Color Values
	vec4 RenderColor = vec4(mix(DiffuseMap_SurfaceColor.rgb, vec3(1.0), SpecularValue), DiffuseMap_SurfaceColor.a) * LightBlend_SurfaceColor;
	
	// Lit Surface Final Render Pass
	gl_FragColor = v_vColour * RenderColor;
}
