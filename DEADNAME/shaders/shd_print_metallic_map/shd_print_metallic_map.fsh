// Uniform Surface Textures
uniform sampler2D gm_NormalMap_Texture;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	vec4 PBRMap = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 NormalMap = texture2D(gm_NormalMap_Texture, v_vTexcoord);
	vec3 Metallic = PBRMap.r <= 0.5 ? vec3(1.0, 0.0, 0.0) : vec3(1.0);
	float Normal = pow(max(dot(NormalMap.xyz, vec3(0.0, 0.0, 1.0)), 0.0), 3.0);
	gl_FragColor = vec4(Metallic * Normal, PBRMap.a);
}