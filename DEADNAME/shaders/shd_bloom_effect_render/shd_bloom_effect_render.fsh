//
// Surface Bloom Effect fragment shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Blur Settings
uniform float in_AlphaMult;
uniform vec2 in_TexelSize;

// Unifrom Bloom Maps
uniform sampler2D in_DiffuseMap;
uniform sampler2D in_EmissiveMap;

// Constants
const float LightingImpact = 0.5;
const float BloomBlurSize = 2.0;

// Fragment Shader
void main() 
{
	// Iterate through Color Values of Neighbors to add to Total Color
	float BloomAlpha = 0.0;
	float BloomCount = 0.0;
	vec3 BloomColor = vec3(0.0);
	
	for (float x = -BloomBlurSize; x <= BloomBlurSize; x++)
	{
		for (float y = -BloomBlurSize; y <= BloomBlurSize; y++)
		{
			// Find Bloom Value from Neighbor
			float Neighbor = texture2D(in_EmissiveMap, v_vTexcoord + in_TexelSize * vec2(x, y)).g * v_vColour.a;
			
			// Establish Bloom Value At Pixel
			BloomAlpha += Neighbor;
			BloomCount += Neighbor > 0.0 ? 1.0 : 0.0;
			BloomColor += Neighbor > 0.0 ? mix(texture2D(gm_BaseTexture, v_vTexcoord + in_TexelSize * vec2(x, y)).rgb, texture2D(in_DiffuseMap, v_vTexcoord + in_TexelSize * vec2(x, y)).rgb, (1.0 - LightingImpact) + (Neighbor * LightingImpact)) : vec3(0.0);
		}
	}
	
	// Divide and Render Premultiplied Blur Color
	vec4 Bloom = vec4(v_vColour.rgb, 1.0) * vec4(BloomColor / BloomCount, BloomAlpha / pow(2.0 * BloomBlurSize + 1.0, 2.0));
	gl_FragColor = vec4(Bloom.rgb * Bloom.a, Bloom.a) * in_AlphaMult;
}
