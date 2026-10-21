varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() 
{
	float pixel_alpha = v_vColour.a * texture2D(gm_BaseTexture, v_vTexcoord).a;
	gl_FragColor = vec4(1.0, 1.0, 1.0, pixel_alpha);
}