//
// Planet Atmosphere Depth Mask fragment shader meant for Inno's Solar System Overworld
//

// Interpolated Depth
varying float v_vDepth;

// Fragment Shader
void main() 
{
	// Render Lit Sphere Fragment Value
	gl_FragColor = vec4(vec3(v_vDepth), 1.0);
}
