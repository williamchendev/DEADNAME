//
// (Multi Render Target) Unlit Sprite fragment shader for Inno's Solar System Overworld
//

// Interpolated Color & Texture UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Shader Effect Settings
uniform float u_Emissive;
uniform float u_Depth;

// Fragment Shader
void main()
{
	// Establish Final Unlit Color from Engine Color and Sprite Texture Color Sample
    vec4 unlit_color = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    // (Multiple Render Targets) Render Unlit Sprite, Diffuse, Emissive, and Atmospheric Depth Fragment Values
	gl_FragData[0] = unlit_color;
	gl_FragData[1] = unlit_color;
	gl_FragData[2] = vec4(vec3(u_Emissive), unlit_color.a);
	gl_FragData[3] = vec4(vec3(u_Depth), unlit_color.a > 0.0 ? 1.0 : 0.0);
}
