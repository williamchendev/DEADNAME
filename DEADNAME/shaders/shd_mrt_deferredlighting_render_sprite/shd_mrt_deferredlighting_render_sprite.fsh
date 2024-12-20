//
// Multi Render Target fragment shader for a Deferred Lighting System
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Textures
uniform sampler2D normalMapTex;
uniform sampler2D specularMap;

void main()
{
	// Texture Data
	vec4 Diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 Normal = texture2D(normalMapTex, v_vTexcoord);
	vec4 Specular = texture2D(specularMap, v_vTexcoord);
	
	// MRT
    gl_FragData[0] = vec4(1.0, 0.0, 0.0, 1.0);
    gl_FragData[1] = vec4(1.0, 0.0, 0.0, 1.0);
    gl_FragData[2] = Specular;
}