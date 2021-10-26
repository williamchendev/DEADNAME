//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;

// Textures
uniform sampler2D occlusionTex;
uniform sampler2D noOcclusionTex;

void main()
{
	// Color Data
	vec4 OcclusionColor = texture2D(occlusionTex, v_vTexcoord);
	vec4 NoOcclusionColor = texture2D(noOcclusionTex, v_vTexcoord);
	vec4 DrawnColor = texture2D( gm_BaseTexture, v_vTexcoord );
	
    gl_FragColor = vec4(DrawnColor.r, DrawnColor.g, DrawnColor.b, max((OcclusionColor.a * DrawnColor.a) - NoOcclusionColor.a, 0.0));
}
