//
// Vertical Fade Effect fragment shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Interpolated Position
varying vec2 v_vPosition;

// Uniform Fade Settings
uniform float in_FadePosition;
uniform float in_FadeOffset;
uniform float in_FadeHeight;

// Fragment Shader
void main()
{
	float Transparency = 1.0 - clamp((in_FadePosition - v_vPosition.y - in_FadeOffset) / in_FadeHeight, 0.0, 1.0);
	vec4 Color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = vec4(Color.rgb, Color.a * Transparency * Transparency);
}
