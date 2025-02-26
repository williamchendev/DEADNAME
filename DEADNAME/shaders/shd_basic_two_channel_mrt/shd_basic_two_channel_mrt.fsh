varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
	gl_FragData[0] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragData[1] = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
}