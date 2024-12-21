//
// Multi Render Target fragment shader for a Deferred Lighting System
//
varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordNormalMap;
varying vec2 v_vTexcoordSpecularMap;
varying vec4 v_vColour;

// Textures
uniform sampler2D normalMapTex;
uniform sampler2D specularMapTex;

void main()
{
	//
	
	// MRT
    gl_FragData[0] = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragData[1] = texture2D(normalMapTex, v_vTexcoord);
    gl_FragData[2] = texture2D(specularMapTex, v_vTexcoordSpecularMap);
}