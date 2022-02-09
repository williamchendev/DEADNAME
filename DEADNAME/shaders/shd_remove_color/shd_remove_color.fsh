//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

uniform vec3 chromaKey;

void main()
{
	vec4 Color = texture2D( gm_BaseTexture, v_vTexcoord );
	vec3 CheckColor = vec3(Color.r, Color.g, Color.b);
	if (CheckColor == chromaKey) {
		Color = vec4(0.0, 0.0, 0.0, 0.0);
	}
    gl_FragColor = Color;
}
