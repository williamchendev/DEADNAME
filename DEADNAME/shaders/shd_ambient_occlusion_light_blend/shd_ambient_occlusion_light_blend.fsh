//
// Ambient Occlusion Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Light Color and Intensity
uniform vec3 in_LightColor;
uniform float in_LightIntensity;

// Fragment Shader
void main() 
{
	// MRT Render Directional Light to Light Blend Layers
	vec4 LightBlend = vec4(in_LightColor, in_LightIntensity);
	gl_FragData[0] = LightBlend;
	gl_FragData[1] = LightBlend;
	gl_FragData[2] = LightBlend;
}
