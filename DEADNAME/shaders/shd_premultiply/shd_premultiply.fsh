varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() 
{
	vec4 Color = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor = v_vColour * vec4(Color.rgb * Color.a, Color.a);
}