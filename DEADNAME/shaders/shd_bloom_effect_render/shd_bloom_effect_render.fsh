//
// Surface Bloom Effect vertex shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Texel Size
uniform vec2 in_Surface_Texel_Size;

// Unifrom Bloom Texture
uniform sampler2D in_Bloom_Texture;

// Constants
const float BloomPreMult = 0.66666;

// Fragment Shader
void main() 
{
	//
	float BloomAlpha = 0.0;
	float BloomCount = 0.0;
	vec3 BloomColor = vec3(0.0);
	
	// Establish Bloom Value At Pixel
	for (float x = -2.0; x <= 2.0; x++)
	{
		for (float y = -2.0; y <= 2.0; y++)
		{
			//
			float Neighbor = texture2D(in_Bloom_Texture, v_vTexcoord + (in_Surface_Texel_Size * vec2(x, y))).b;
			
			//
			BloomAlpha += Neighbor;
			BloomCount += Neighbor > 0.0 ? 1.0 : 0.0;
			BloomColor += Neighbor > 0.0 ? texture2D(gm_BaseTexture, v_vTexcoord + (in_Surface_Texel_Size * vec2(x, y))).rgb : vec3(0.0);
		}
	}
	
	//
	vec4 Bloom = v_vColour * vec4(BloomColor / BloomCount, BloomAlpha / 25.0);
	
	//
	gl_FragColor = vec4(Bloom.rgb * Bloom.a, Bloom.a) * BloomPreMult;
}