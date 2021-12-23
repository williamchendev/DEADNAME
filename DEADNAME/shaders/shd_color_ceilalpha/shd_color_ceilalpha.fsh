//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

uniform vec3 forcedColor;

void main()
{
	vec4 AlphaColor = texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 Color = vec4(forcedColor.x, forcedColor.y, forcedColor.z, ceil(AlphaColor.a));
    gl_FragColor = Color;
}
