//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//
uniform sampler2D gm_LightBlendTexture;

//
void main() {
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord) * texture2D(gm_LightBlendTexture, v_vTexcoord);
}