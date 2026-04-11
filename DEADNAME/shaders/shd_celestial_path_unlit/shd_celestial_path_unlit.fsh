//
// (Multi Render Target) Unlit Pathfinding Path fragment shader for Inno's Solar System Overworld
//

// Interpolated Color & Texture UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Uniform Shader Effect Settings
uniform float u_Depth;

// Fragment Shader
void main()
{
	// Establish Final Unlit Color from Engine Color and Sprite Texture Color Sample
    vec4 path_color_data = texture2D( gm_BaseTexture, v_vTexcoord );
    vec4 unlit_color = v_vColour * vec4(1.0, 1.0, 1.0, path_color_data.r * path_color_data.a);
    
    // (Multiple Render Targets) Render Unlit Pathfinding Path, Diffuse, Emissive, and Atmospheric Depth Fragment Values
	gl_FragData[0] = unlit_color;
	gl_FragData[1] = unlit_color;
	gl_FragData[2] = vec4(vec3(0.0), unlit_color.a);
}
