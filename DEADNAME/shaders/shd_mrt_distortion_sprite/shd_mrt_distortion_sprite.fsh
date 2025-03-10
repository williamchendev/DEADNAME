//
// MRT Distortion Sprite Drawing fragment shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Fragment Shader
void main() 
{
	// Normalize Distortion Sprite as Vector
	vec2 DistortionNormal = (texture2D(gm_BaseTexture, v_vTexcoord).xy * 2.0) - 1.0;
	
	// Seperate and Draw Vector to MRT Distortion Directional Channel Surfaces
	gl_FragData[0] = vec4(DistortionNormal.x, 0.0, 0.0, 1.0) * v_vColour.a;
	gl_FragData[1] = vec4(DistortionNormal.y, 0.0, 0.0, 1.0) * v_vColour.a;
}