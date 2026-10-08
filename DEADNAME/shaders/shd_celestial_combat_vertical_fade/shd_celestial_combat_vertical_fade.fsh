//
// Vertical Alpha Fade Effect fragment shader for Inno's Celestial Overworld Combat Rendering System
//

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Interpolated Position
varying vec2 v_vPosition;

// Uniform Fade Settings
uniform float in_FadePosition;
uniform float in_FadeLength;
uniform float in_FadeDirection;

// Fragment Shader
void main()
{
	float Fade = clamp(((v_vPosition.y - in_FadePosition) * in_FadeDirection) / in_FadeLength, 0.0, 1.0);
	vec4 Color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = vec4(Color.rgb, Color.a * Fade * Fade);
}
