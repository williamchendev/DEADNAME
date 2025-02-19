//
// Spot Light Blend fragment shader for Inno's Deferred Lighting System
//

// Uniform Lighting Engine Strength Multiplier Settings
uniform float in_HighLight_Strength_Multiplier;
uniform float in_BroadLight_Strength_Multiplier;
uniform float in_HighLight_To_BroadLight_Ratio_Max;

// Uniform Light Source Properties
uniform vec3 in_LightColor;
uniform float in_LightIntensity;
uniform float in_LightFalloff;

// Uniform Spot Light Properties
uniform vec2 in_LightDirection;
uniform float in_LightAngle;

// Uniform Light Layers
uniform vec3 in_Light_Layers;
uniform vec3 in_Shadow_Layers;

// Uniform Normal Map and Shadow Map Surface Textures
uniform sampler2D gm_NormalTexture;
uniform sampler2D gm_ShadowTexture;

// Interpolated Position and UV
varying vec2 v_vPosition;
varying vec2 v_vSurfaceUV;

// Constants
const vec2 Center = vec2(0.5, 0.5);
const float HalfPi = 1.57079632679;
const float FullPi = 3.14159265358979;

// Fast Approximation Inverse Cosign Method
float fastacos(float x) 
{
	// Handbook of Mathematical Functions
	// M. Abramowitz and I.A. Stegun, Ed.

	float negate = float(x < 0.0);
	x = abs(x);
	float ret = -0.0187293;
	ret *= x;
	ret += 0.0742610;
	ret *= x;
	ret -= 0.2121144;
	ret *= x;
	ret += 1.5707288;
	ret *= sqrt(1.0 - x);
	ret = ret - 2.0 * negate * ret;
	return negate * FullPi + ret;
}

// Fragment Shader
void main() 
{
	// Point Light Distance
	float Distance = distance(v_vPosition, Center);
	
	if (Distance > 0.5)
	{
		// Circle Cut-Out Early Return
		return;
	}
	
	// Spot Light Vector
	vec2 SpotLightVector = normalize(Center - v_vPosition);
	
	// Spot Light FOV Calculation
	float LightDirectionDotProduct = clamp(dot(-SpotLightVector, vec2(in_LightDirection.x, -in_LightDirection.y)), -1.0, 1.0);
	float LightDirectionValue = fastacos(LightDirectionDotProduct) / FullPi;
	
	if (LightDirectionValue > in_LightAngle)
	{
		// Outside Spot Light FOV Early Return
		return;
	}
	
	// Spot Light (Broadlight) Depth Vector Calculation
	float LightDirectionStrength = pow(1.0 - (((1.0 - LightDirectionValue) - (1.0 - in_LightAngle)) / in_LightAngle), 2.0);
	float LightDepthVector = cos(LightDirectionStrength * HalfPi);
	
	// Light Falloff Effect
	float LightFade = 1.0 - pow((Distance / 0.5), in_LightFalloff);
	
	// Get Shadow Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceShadow = texture2D(gm_ShadowTexture, v_vSurfaceUV);
	vec3 ShadowLayers = vec3(1.0) - (in_Shadow_Layers * SurfaceShadow.a);
	
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	
	// Light Strength Dot Product
	float HighlightStrength = dot(vec2(SpotLightVector.x, -SpotLightVector.y), SurfaceNormal.xy) * in_HighLight_Strength_Multiplier;
	float BroadlightStrength = dot(LightDepthVector, SurfaceNormal.z) * in_BroadLight_Strength_Multiplier;
	
	// Light Strength Ratio Calculation
	float LightStrength = max(BroadlightStrength, min(HighlightStrength, BroadlightStrength * in_HighLight_To_BroadLight_Ratio_Max));

	// MRT Render Spot Light to Light Blend Layers
	vec3 LightBlend = in_LightColor * in_LightIntensity * LightStrength * LightFade;
	
	gl_FragData[0] = vec4(LightBlend * ShadowLayers.x, 1.0) * in_Light_Layers.x;
	gl_FragData[1] = vec4(LightBlend * ShadowLayers.y, 1.0) * in_Light_Layers.y;
	gl_FragData[2] = vec4(LightBlend * ShadowLayers.z, 1.0) * in_Light_Layers.z;
	gl_FragData[3] = vec4(in_Light_Layers.x, in_Light_Layers.y, in_Light_Layers.z, LightStrength);
}
