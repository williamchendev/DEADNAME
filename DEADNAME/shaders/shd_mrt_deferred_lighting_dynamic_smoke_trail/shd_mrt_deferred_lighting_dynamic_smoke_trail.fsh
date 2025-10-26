//
// (Multi Render Target) Dynamic Smoke Trail fragment shader for Inno's Deferred Lighting System
//

// Interpolated Texture UVs, Color, & Rotate
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying mat2 v_vRotate;

// Uniform Layer Depth Value
uniform float in_Layer_Depth;

// Uniform Shader Effect Settings
uniform float in_Metallic;
uniform float in_Roughness;
uniform float in_Emissive;
uniform float in_EmissiveMultiplier;

// Constants
const float HalfPi = 1.57079632679;

// Fragment Shader
void main()
{
	// Calculate Smoke Trail's Normal Map's Z-Depth
	float SmokeTrail_Depth = ((1.0 - (v_vTexcoord.y * v_vTexcoord.y * v_vTexcoord.y * v_vTexcoord.y)) * v_vColour.a) + (1.0 - v_vColour.a);
	
	// MRT[0] Diffuse Color Layer: Draw Smoke Trail Diffuse Color
    gl_FragData[0] = v_vColour;
    
    // MRT[1] Normal Vector Layer: Draw Smoke Trail Normal Vector
    gl_FragData[1] = vec4(0.5, 0.5, (SmokeTrail_Depth * 0.2) + 0.8, v_vColour.a);
    
    // MRT[2] BRDF Workflow Layer: Draw PBR Metallic-Roughness, Emissive, and Depth Data
    gl_FragData[2] = vec4((in_Roughness * in_Metallic * 0.5) + 0.5, in_Emissive * in_EmissiveMultiplier, (in_Layer_Depth * 0.5) + 0.5, v_vColour.a);
}
