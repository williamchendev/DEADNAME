//
// Forward Rendered Lit Planet without Atmosphere fragment shader meant for Inno's Solar System Overworld
//

// Interpolated Surface Mask UV
varying vec2 v_vSurfaceUV;

// Texture Properties
uniform sampler2D gm_CelestialBodyDiffuseSurface;
uniform sampler2D gm_CelestialBodyEmissiveSurface;

// Fragment Shader
void main()
{
	// Retreive Celestial Body's Diffuse Color
	vec4 diffuse_color = texture2D(gm_BaseTexture, v_vSurfaceUV);
	
	// Retreive Celestial Body's Bloom Diffuse & Emissive Surface Values
	vec3 bloom_diffuse = texture2D(gm_CelestialBodyDiffuseSurface, v_vSurfaceUV).rgb;
	float bloom_emissive = texture2D(gm_CelestialBodyEmissiveSurface, v_vSurfaceUV).r;
	
	// Render Lit Planet, Diffuse, and Emissive Fragment Color Value
	gl_FragData[0] = diffuse_color;
	gl_FragData[1] = vec4(bloom_diffuse, diffuse_color.a);
	gl_FragData[2] = vec4(vec3(bloom_emissive), diffuse_color.a);
}
