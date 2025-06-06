//
// Ambient Occlusion Light Blend fragment shader for Inno's Deferred Lighting System
//

// Interpolated UVs
varying vec2 v_vSurfaceUV;

// Uniform Light Color
uniform vec3 in_LightColor;
uniform float in_LightIntensity;
uniform float in_LightSurfaceTangentExponent;

// Uniform Layered Diffuse Maps, Normal Map, and PBR Detail Map Surface Textures
uniform sampler2D gm_DiffuseMap_BackLayer_Texture;
uniform sampler2D gm_DiffuseMap_MidLayer_Texture;
uniform sampler2D gm_DiffuseMap_FrontLayer_Texture;

uniform sampler2D gm_NormalTexture;

// Fragment Shader
void main() 
{
	// Get Normal Map Surface Texture's Pixel Value at Pixel's UV
	vec4 SurfaceNormal = (texture2D(gm_NormalTexture, v_vSurfaceUV) * 2.0) - 1.0;
	float SurfaceToViewVectorDotProduct = pow(max(dot(SurfaceNormal.xyz, vec3(0.0, 0.0, 1.0)), 0.0), in_LightSurfaceTangentExponent);
	
	// Surface Diffuse Color
	vec4 DiffuseMap_Back = texture2D(gm_DiffuseMap_BackLayer_Texture, v_vSurfaceUV);
	vec4 DiffuseMap_Mid = texture2D(gm_DiffuseMap_MidLayer_Texture, v_vSurfaceUV);
	vec4 DiffuseMap_Front = texture2D(gm_DiffuseMap_FrontLayer_Texture, v_vSurfaceUV);

	// MRT Render Ambient Occlusion Light to Light Blend Layers
	gl_FragData[0] = vec4(DiffuseMap_Back.rgb * in_LightColor * in_LightIntensity * SurfaceToViewVectorDotProduct, 1.0);
	gl_FragData[1] = vec4(DiffuseMap_Mid.rgb * in_LightColor * in_LightIntensity * SurfaceToViewVectorDotProduct, 1.0);
	gl_FragData[2] = vec4(DiffuseMap_Front.rgb * in_LightColor * in_LightIntensity * SurfaceToViewVectorDotProduct, 1.0);
}
