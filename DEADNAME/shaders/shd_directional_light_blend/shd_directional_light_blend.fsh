//
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

uniform vec2 in_LightSource_Vector;

//
varying vec2 v_vSurfaceUV;
varying vec4 v_vColour;

//
const float HighlightStrengthMult = 1.8;
const float BroadlightStrengthMult = 1.25;

const float HighlighttoBroadlightRatioMax = 5.0;

//
void main() 
{
	// 
	vec4 SurfaceShadow = texture2D(gm_BaseTexture, v_vSurfaceUV);
	
	//
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	//
	float HighlightStrength = dot(vec2(in_LightSource_Vector.x, in_LightSource_Vector.y), SurfaceNormal.xy) * HighlightStrengthMult;
	float BroadlightStrength = dot(1.0, SurfaceNormal.z) * BroadlightStrengthMult;
	
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * HighlighttoBroadlightRatioMax));
	
	//
	gl_FragColor = vec4(v_vColour.rgb, v_vColour.a * (1.0 - SurfaceShadow.a)) * LightStrength;
}