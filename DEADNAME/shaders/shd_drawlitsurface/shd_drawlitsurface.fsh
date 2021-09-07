//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D lightTex;

void main()
{
	vec4 LightColor = texture2D(lightTex, v_vTexcoord);
	vec4 BaseColor = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = LightColor * BaseColor;
}
