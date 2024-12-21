//
// Multi Render Target fragment shader for a Deferred Lighting System
//
varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordNormalMap;
varying vec2 v_vTexcoordSpecularMap;
varying vec4 v_vColour;

// Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_SpecularTexture;

void main()
{
	// MRT
    gl_FragData[0] = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragData[1] = texture2D(gm_NormalTexture, v_vTexcoordNormalMap);
    gl_FragData[2] = texture2D(gm_SpecularTexture, v_vTexcoordSpecularMap);
}