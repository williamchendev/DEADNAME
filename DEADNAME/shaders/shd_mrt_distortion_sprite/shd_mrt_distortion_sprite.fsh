varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
	//
	vec2 DistortionNormal = (texture2D(gm_BaseTexture, v_vTexcoord).xy * 2.0) - 1.0;
	
	//
	gl_FragData[0] = vec4(DistortionNormal.x, 0.0, 0.0, 1.0);
	gl_FragData[1] = vec4(DistortionNormal.y, 0.0, 0.0, 1.0);
}