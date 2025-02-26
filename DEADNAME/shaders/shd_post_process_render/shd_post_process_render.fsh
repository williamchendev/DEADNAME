//
// (Multi Render Target) Lit Surface Post Process Rendering Pass fragment shader for Inno's Deferred Lighting System
//

// Uniform Surface Textures
uniform sampler2D gm_LightBlend_Texture;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Establish Diffuse Map Surface Colors
	vec4 DiffuseMap_SurfaceColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	// Establish Light Blend Surface Colors
	vec4 LightBlend_SurfaceColor = texture2D(gm_LightBlend_Texture, v_vTexcoord);
	
	// Layer Color Values
	vec4 RenderColor = vec4(LightBlend_SurfaceColor.rgb, DiffuseMap_SurfaceColor.a);
	
	// Lit Surface Final Render Pass
	gl_FragData[0] = v_vColour * RenderColor;
	gl_FragData[1] = v_vColour * DiffuseMap_SurfaceColor;
}
