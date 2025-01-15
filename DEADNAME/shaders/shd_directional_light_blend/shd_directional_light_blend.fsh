//
// Directional Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Lighting Engine Strength Multiplier Settings
uniform float in_HighLight_Strength_Multiplier;
uniform float in_BroadLight_Strength_Multiplier;
uniform float in_HighLight_To_BroadLight_Ratio_Max;

// Uniform Light Source Properties
uniform vec2 in_LightSource_Vector;

// Uniform Normal Map and Shadow Map Surface Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

// Interpolated Color and UV
varying vec4 v_vColour;
varying vec2 v_vSurfaceUV;

// Fragment Shader
void main() 
{
	// Get Shadow Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceShadow = texture2D(gm_BaseTexture, v_vSurfaceUV);
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(in_LightSource_Vector.x, in_LightSource_Vector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(1.0, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));
	
	// Render Directional Light
	gl_FragColor = vec4(v_vColour.rgb, v_vColour.a * (1.0 - SurfaceShadow.a)) * LightStrength;
}
