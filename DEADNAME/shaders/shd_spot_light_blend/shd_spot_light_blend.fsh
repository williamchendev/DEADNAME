///

//
uniform vec3 in_LightColor;
uniform float in_LightIntensity;

uniform vec2 in_LightDirection;
uniform float in_LightAngle;

uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

//
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

//1.57079632679
//3.14159265359

//
const float HighlightStrengthMult = 1.8;
const float BroadlightStrengthMult = 1.25;

const float HighlighttoBroadlightRatioMax = 5.0;

//
const vec2 Center = vec2(0.5, 0.5);
const float HalfPi = 1.57079632679;
const float FullPi = 3.14159265359;

//
void main() 
{
	//
	float Distance = distance(v_vPosition, Center);
	
	if (Distance > 0.5)
	{
		return;
	}
	
	//
	vec2 LightNormalXY = normalize(Center - v_vPosition);
	
	//
	float LightDirection = acos(dot(-LightNormalXY, vec2(in_LightDirection.x, -in_LightDirection.y))) / FullPi;
	
	if (LightDirection > in_LightAngle)
	{
		return;
	}
	
	//
	float LightDirectionStrength = ((LightDirection - (1.0 - in_LightAngle)) / in_LightAngle) * 0.5;
	float LightNormalZ = cos(((LightDirectionStrength + 0.5) * HalfPi) - HalfPi);
	
	// 
	vec4 SurfaceShadow = texture2D(gm_ShadowTexture, v_vSurfaceUV);
	
	//
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	//
	float HighlightStrength = dot(vec2(LightNormalXY.x, -LightNormalXY.y), SurfaceNormal.xy) * HighlightStrengthMult;
	float BroadlightStrength = dot(LightNormalZ, SurfaceNormal.z) * BroadlightStrengthMult;
	
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * HighlighttoBroadlightRatioMax));
	
	//
	float LightFade = 1.0 - pow((Distance / 0.5), 2.0);

	//
	gl_FragColor = vec4(1.0);
	//gl_FragColor = vec4(in_LightColor, in_LightIntensity * (1.0 - SurfaceShadow.a)) * LightStrength * LightFade;
}