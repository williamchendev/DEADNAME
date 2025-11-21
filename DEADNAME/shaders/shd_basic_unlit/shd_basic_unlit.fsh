//
// Basic Unlit fragment shader meant to test rendering 3D models
//

// Interpolated Color, Normal, & Texture UVs
varying vec3 v_vNormal;
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Diffuse Texture Color
	vec4 Diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
	
	// Draw Color
	gl_FragColor = v_vColour * Diffuse;
}