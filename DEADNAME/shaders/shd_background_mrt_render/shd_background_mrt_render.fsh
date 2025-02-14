varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() 
{
	vec4 Color = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragData[0] = vec4(v_vColour.rgb, 1.0) * Color;
	gl_FragData[1] = vec4(0.0, 0.0, v_vColour.a, 1.0) * (Color.a > 0.0 ? 1.0 : 0.0);
}