//
// Surface Bloom (First Pass) Box Blur Effect fragment shader
//

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Texel Size
uniform float in_TexelSize;

// Constants
const float BlurSize = 2.0;
const float BloomPreMult = 0.666666;

// Fragment Shader
void main() 
{
	// Iterate through Color Values of Neighbors to add to Total Color
	float TotalAlpha = 0.0;
	vec3 TotalColor = vec3(0.0);
	
	for (float x = -BlurSize; x <= BlurSize; x++)
	{
		for (float y = -BlurSize; y <= BlurSize; y++)
		{
			vec4 Neighbor = texture2D(gm_BaseTexture, v_vTexcoord + in_TexelSize * vec2(x, y));
			
			TotalColor += Neighbor.rgb;
			TotalAlpha += Neighbor.a;
		}
	}

	// Divide and Render Blur Color
	vec4 Bloom = vec4(TotalColor / TotalAlpha, TotalAlpha / pow(2.0 * BlurSize + 1.0, 2.0));
	gl_FragColor = vec4(Bloom.rgb * Bloom.a, Bloom.a) * BloomPreMult;
}