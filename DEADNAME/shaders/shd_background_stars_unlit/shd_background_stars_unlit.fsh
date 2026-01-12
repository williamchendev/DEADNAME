//
// Unlit Solar System Background Stars fragment shader meant for Inno's Solar System Overworld
//

// Interpolated Color
varying vec4 v_vColour;

// Fragment Shader
void main() 
{
	// Render Lit Background Stars Color Fragment Value
	gl_FragData[0] = v_vColour;
	gl_FragData[1] = vec4(vec3(1.0), v_vColour.a);
}
