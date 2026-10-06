//
// Vertical Binary Alpha Cutoff Effect fragment shader for Inno's Celestial Overworld Combat Rendering System
//

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Interpolated Position
varying vec2 v_vPosition;

// Uniform Fade Settings
uniform float in_CutoffPosition;
uniform float in_CutoffDirection;

// Fragment Shader
void main()
{
	float Transparency = (in_CutoffPosition - v_vPosition.y) * in_CutoffDirection < 0.0 ? 1.0 : 0.0;
	vec4 Color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = vec4(Color.rgb, Color.a * Transparency);
}
