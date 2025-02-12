//
// Surface Vertical (Second Pass) Blur Effect fragment shader
//

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Blur Size & Texel Size
uniform float in_BlurHeight;
uniform float in_TexelHeight;

// Fragment Shader
void main() 
{
	// Iterate through Color Values of Vertical Neighbors to add to Total Color
	vec4 TotalColor = vec4(0.0);
	
	for (float i = -in_BlurHeight; i <= in_BlurHeight; i++)
	{
		TotalColor += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, i * in_TexelHeight));
	}

	// Divide and Render Vertical Blur Color
	gl_FragColor = TotalColor / (2.0 * in_BlurHeight + 1.0);
}
