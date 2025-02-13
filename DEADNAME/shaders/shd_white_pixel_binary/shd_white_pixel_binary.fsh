varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() 
{
	float PixelBinary = texture2D(gm_BaseTexture, v_vTexcoord).a > 0.0 ? 1.0 : 0.0;
	gl_FragColor = v_vColour * vec4(PixelBinary);
}