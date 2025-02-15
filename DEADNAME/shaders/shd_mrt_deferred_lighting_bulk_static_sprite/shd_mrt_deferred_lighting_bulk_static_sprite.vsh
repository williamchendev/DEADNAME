//
// (Multi Render Target) Bulk Static Sprite vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 									// (x, y, z)
attribute vec3 in_Normal;										// (nx, ny, nz)
attribute vec4 in_Colour;										// (r, g, b, a)
attribute vec2 in_TextureCoord_Diffuse; 						// (u, v)
attribute vec4 in_TextureCoord_Normal; 							// (x, y, z, w)
attribute vec4 in_TextureCoord_Specular; 						// (x, y, z, w)
attribute vec4 in_TextureCoord_Bloom; 							// (x, y, z, w)
attribute vec4 in_ShaderEffect_BaseStrength; 					// (x, y, z, w)
attribute vec3 in_ShaderEffect_Modifiers; 						// (x, y, z)

// Uniform Camera Properties
uniform vec2 in_Camera_Offset;

// Interpolated Shader Effect Base Strength & Modifiers
varying vec4 v_vShaderEffect_BaseStrength;
varying vec3 v_vShaderEffect_Modifiers;

// Interpolated Texture Map UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_SpecularMap;
varying vec2 v_vTexcoord_BloomMap;

// Interpolated Color, Scale, and Rotation Values
varying vec4 v_vColour;
varying vec3 v_vScale;
varying mat2 v_vRotate;

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
	v_vShaderEffect_BaseStrength = in_ShaderEffect_BaseStrength;
	v_vShaderEffect_Modifiers = in_ShaderEffect_Modifiers;
	
	// Set Sprite UVs
	v_vTexcoord_DiffuseMap = in_TextureCoord_Diffuse;
	v_vTexcoord_NormalMap = in_TextureCoord_Diffuse * in_TextureCoord_Normal.zw + in_TextureCoord_Normal.xy;
	v_vTexcoord_SpecularMap = in_TextureCoord_Diffuse * in_TextureCoord_Specular.zw + in_TextureCoord_Specular.xy;
	v_vTexcoord_BloomMap = in_TextureCoord_Diffuse * in_TextureCoord_Bloom.zw + in_TextureCoord_Bloom.xy;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x - in_Camera_Offset.x, in_Position.y - in_Camera_Offset.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
