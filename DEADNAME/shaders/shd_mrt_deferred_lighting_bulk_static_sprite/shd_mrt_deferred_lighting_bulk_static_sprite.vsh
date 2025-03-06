//
// (Multi Render Target) Bulk Static Sprite vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 									// (x, y, z)
attribute vec3 in_Normal;										// (nx, ny, nz)
attribute vec4 in_Colour;										// (r, g, b, a)
attribute vec2 in_TextureCoord_DiffuseMap; 						// (u, v)
attribute vec4 in_TextureCoord_NormalMap; 						// (x, y, z, w)
attribute vec4 in_TextureCoord_MetallicRoughnessMap; 			// (x, y, z, w)
attribute vec4 in_TextureCoord_EmissiveMap; 					// (x, y, z, w)
attribute vec4 in_PBR_Settings; 								// (x, y, z, w)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Interpolated Color, Scale, and Rotation Values
varying vec4 v_vColour;
varying vec3 v_vScale;
varying mat2 v_vRotate;

// Interpolated Texture Map UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec3 v_vTexcoord_NormalMap;
varying vec3 v_vTexcoord_MetallicRoughnessMap;
varying vec3 v_vTexcoord_EmissiveMap;

// Interpolated Shader Effect Base Strength & Modifiers
varying vec4 v_vPBR_Settings;

// Constants
const vec4 TextureIsNull = vec4(-1.0, -1.0, -1.0, -1.0);

// Vertex Shader
void main() 
{
	// Set Sprite Color
	v_vColour = in_Colour;
	
	// Set Sprite Scale
	v_vScale = in_Normal;
	
	// Calculate Rotate Vector
	float RotateAngle = radians(in_Position.z);
	vec2 RotateVector = vec2(cos(RotateAngle), sin(RotateAngle));
	v_vRotate = mat2(RotateVector.x, -RotateVector.y, RotateVector.y, RotateVector.x);
	
	// Set Shader Effect Toggles
	v_vPBR_Settings = in_PBR_Settings;
	
	// Set Sprite UVs
	v_vTexcoord_DiffuseMap = in_TextureCoord_DiffuseMap;
	v_vTexcoord_NormalMap = vec3(in_TextureCoord_DiffuseMap * in_TextureCoord_NormalMap.zw + in_TextureCoord_NormalMap.xy, in_TextureCoord_NormalMap == TextureIsNull ? 0.0 : 1.0);
	v_vTexcoord_MetallicRoughnessMap = vec3(in_TextureCoord_DiffuseMap * in_TextureCoord_MetallicRoughnessMap.zw + in_TextureCoord_MetallicRoughnessMap.xy, in_TextureCoord_MetallicRoughnessMap == TextureIsNull ? 0.0 : 1.0);
	v_vTexcoord_EmissiveMap = vec3(in_TextureCoord_DiffuseMap * in_TextureCoord_EmissiveMap.zw + in_TextureCoord_EmissiveMap.xy, in_TextureCoord_EmissiveMap == TextureIsNull ? 0.0 : 1.0);
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
