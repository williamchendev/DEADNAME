//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

void main()
{
	vec4 Color = texture2D( gm_BaseTexture, v_vTexcoord );
	Color = vec4(0.0, 0.0, 0.0, Color.a);
    gl_FragColor = Color;
}
