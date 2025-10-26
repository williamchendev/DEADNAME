//
// (Multi Render Target) Dynamic Sprite with Alpha Filtering vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 		// (x, y, z)
attribute vec4 in_Colour;			// (r, g, b, a)
attribute vec2 in_TextureCoord; 	// (u, v)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Uniform Sprite UVs
uniform vec4 in_Normal_UVs;
uniform vec4 in_MetallicRoughness_UVs;
uniform vec4 in_Emissive_UVs;
uniform vec4 in_AlphaFilter_UVs;

// Uniform Normal Map Transformations
uniform float in_VectorAngle;

// Interpolated Transformed UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_MetallicRoughnessMap;
varying vec2 v_vTexcoord_EmissiveMap;
varying vec2 v_vTexcoord_AlphaFilterMap;

// Interpolated Color & Rotate
varying vec4 v_vColour;
varying mat2 v_vRotate;

// Vertex Shader
void main() 
{
	// Set Interpolated Colors
	v_vColour = in_Colour;
	
	// Calculate Rotate Vector
	float RotateAngle = radians(in_VectorAngle);
	vec2 RotateVector = vec2(cos(RotateAngle), sin(RotateAngle));
	v_vRotate = mat2(RotateVector.x, -RotateVector.y, RotateVector.y, RotateVector.x);
	
	// Transform and set Sprite UVs
	v_vTexcoord_DiffuseMap = in_TextureCoord;
	v_vTexcoord_NormalMap = in_TextureCoord * in_Normal_UVs.zw + in_Normal_UVs.xy;
	v_vTexcoord_MetallicRoughnessMap = in_TextureCoord * in_MetallicRoughness_UVs.zw + in_MetallicRoughness_UVs.xy;
	v_vTexcoord_EmissiveMap = in_TextureCoord * in_Emissive_UVs.zw + in_Emissive_UVs.xy;
	v_vTexcoord_AlphaFilterMap = in_TextureCoord * in_AlphaFilter_UVs.zw + in_AlphaFilter_UVs.xy;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
