varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() 
{
	gl_FragColor = vec4(vec3(texture2D(gm_BaseTexture, v_vTexcoord).b), 1.0);
}