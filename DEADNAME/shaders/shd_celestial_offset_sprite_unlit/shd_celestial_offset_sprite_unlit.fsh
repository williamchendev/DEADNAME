//
// Simple passthrough fragment shader
//

// 
uniform vec4 u_Color;

// Interpolated UVs
varying vec2 v_vTexcoord;

// Fragment Shader
void main()
{
    //gl_FragColor = u_Color * texture2D( gm_BaseTexture, v_vTexcoord );
    //gl_FragColor = vec4(1.0);
    
    // (Multiple Render Targets) Render Lit Sphere, Diffuse, Emissive, and Atmospheric Depth Fragment Values
	gl_FragData[0] = vec4(1.0);
	gl_FragData[1] = vec4(1.0);
	gl_FragData[2] = vec4(vec3(0.0), 1.0);
	gl_FragData[3] = vec4(vec3(0.0), 1.0);
}
