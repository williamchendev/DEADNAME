//
// (Multi Render Target) Background Diffuse & Bloom Render fragment shader
//

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Fragment Shader
void main() 
{
	// Get Background Texture
	vec4 Color = texture2D(gm_BaseTexture, v_vTexcoord);
	
	// Render Background Diffuse Color with Background Color Blending
	gl_FragData[0] = vec4(v_vColour.rgb, 1.0) * Color;
	
	// Render Background Bloom and use Background Color Blend Alpha as Emissive Channel
	gl_FragData[1] = vec4(0.0, v_vColour.a, 0.0, 1.0) * (Color.a > 0.0 ? 1.0 : 0.0);
}