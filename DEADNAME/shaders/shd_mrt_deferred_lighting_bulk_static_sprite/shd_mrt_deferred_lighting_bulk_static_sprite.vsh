//
// (Multi Render Target) Dynamic Sprite vertex shader for Inno's Deferred Lighting System
//

// Vertex Buffer Properties
attribute vec3 in_Position; 				// (x, y, z)
attribute vec4 in_Colour;					// (r, g, b, a)
attribute vec3 in_Normal_Scale;				// (nx, ny, nz)
attribute vec2 in_TextureCoord_Diffuse; 	// (u, v)
attribute vec2 in_TextureCoord_Normal; 		// (u, v)
attribute vec2 in_TextureCoord_Specular; 	// (u, v)

// Interpolated Texture Map UVs
varying vec2 v_vTexcoord_DiffuseMap;
varying vec2 v_vTexcoord_NormalMap;
varying vec2 v_vTexcoord_SpecularMap;

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
	v_vScale = in_Normal_Scale;
	
	// Calculate Rotate Vector
	float RotateAngle = radians(in_Position.z);
	vec2 RotateVector = vec2(cos(RotateAngle), sin(RotateAngle));
	v_vRotate = mat2(RotateVector.x, -RotateVector.y, RotateVector.y, RotateVector.x);
	
	// Set Sprite UVs
	v_vTexcoord_DiffuseMap = in_TextureCoord_Diffuse;
	v_vTexcoord_NormalMap = in_TextureCoord_Normal;
	v_vTexcoord_SpecularMap = in_TextureCoord_Specular;
	
	// Set Vertex Positions
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, 0.0, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
}
