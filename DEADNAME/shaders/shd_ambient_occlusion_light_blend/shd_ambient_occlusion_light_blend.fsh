//
// Ambient Occlusion Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Light Color
uniform vec3 in_LightColor;

// Fragment Shader
void main() 
{
	// MRT Render Ambient Occlusion Light to Light Blend Layers
	vec4 LightBlend = vec4(in_LightColor, 1.0);
	
	gl_FragData[0] = LightBlend;
	gl_FragData[1] = LightBlend;
	gl_FragData[2] = LightBlend;
}
