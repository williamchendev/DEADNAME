//
// (Multi Render Target) Lit Surface Final Rendering Pass fragment shader for Inno's Deferred Lighting System
//

// Uniform Light Blend Surface Texture
uniform sampler2D gm_LightBlendTexture;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Find Diffuse Surface Value
	vec4 DiffuseSurfaceColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	// Find Light Blend Surface Value
	vec4 LightBlendSurfaceColor = texture2D(gm_LightBlendTexture, v_vTexcoord);
	
	// Lit Surface Final Render Pass
	gl_FragColor = v_vColour * DiffuseSurfaceColor * LightBlendSurfaceColor;
}