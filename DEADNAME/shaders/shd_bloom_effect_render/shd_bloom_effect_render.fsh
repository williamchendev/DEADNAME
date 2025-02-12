//
// Surface Bloom Effect fragment shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Blur Settings
uniform float in_AlphaMult;
uniform vec2 in_TexelSize;

// Unifrom Bloom Texture
uniform sampler2D in_Bloom_Texture;

// Constants
const float BloomBlurSize = 2.0;

// Fragment Shader
void main() 
{
	// Iterate through Color Values of Neighbors to add to Total Color
	float BloomAlpha = 0.0;
	vec3 BloomColor = vec3(0.0);
	
	for (float x = -BloomBlurSize; x <= BloomBlurSize; x++)
	{
		for (float y = -BloomBlurSize; y <= BloomBlurSize; y++)
		{
			//
			float Neighbor = texture2D(in_Bloom_Texture, v_vTexcoord + in_TexelSize * vec2(x, y)).b;
			
			// Establish Bloom Value At Pixel
			BloomAlpha += Neighbor;
			BloomColor += Neighbor > 0.0 ? texture2D(gm_BaseTexture, v_vTexcoord + in_TexelSize * vec2(x, y)).rgb : vec3(0.0);
		}
	}
	
	// Divide and Render Premultiplied Blur Color
	vec4 Bloom = v_vColour * vec4(BloomColor / BloomAlpha, BloomAlpha / pow(2.0 * BloomBlurSize + 1.0, 2.0));
	gl_FragColor = vec4(Bloom.rgb * Bloom.a, Bloom.a) * in_AlphaMult;
}
