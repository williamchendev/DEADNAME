//
// (Multi Render Target) Dynamic Particle fragment shader for Inno's Deferred Lighting System
//

// Interpolated Texture UV & Color
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

// Uniform Shader Effect Settings
uniform float in_Metallic;
uniform float in_Roughness;
uniform float in_Emissive;
uniform float in_EmissiveMultiplier;

// Constants
const float AlphaThreshhold = 0.02;

// Fragment Shader
void main()
{
	// Diffuse Map
	vec4 Diffuse = texture2D(gm_BaseTexture, v_vTexcoord);
	
	if (Diffuse.a < AlphaThreshhold)
	{
		return;
	}
	
	// MRT[0] Diffuse Color Layer: Draw Particle Diffuse Color
    gl_FragData[0] = v_vColour * Diffuse;
    
    // MRT[1] Normal Vector Layer: Draw Particle Normal Vector
    gl_FragData[1] = vec4(0.5, 0.5, 1.0, Diffuse.a);
    
    // MRT[2] BRDF Workflow Layer: Draw PBR Metallic-Roughness, Emissive, and Depth Data
    gl_FragData[2] = vec4((in_Roughness * in_Metallic * 0.5) + 0.5, in_Emissive * in_EmissiveMultiplier, (in_Layer_Depth * 0.5) + 0.5, 1.0);
}
