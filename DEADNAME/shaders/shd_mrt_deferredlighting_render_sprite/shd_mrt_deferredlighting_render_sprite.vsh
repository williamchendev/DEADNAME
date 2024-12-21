//
attribute vec3 in_Position; // (x, y, z)
attribute vec4 in_Colour; // (r, g, b, a)
attribute vec2 in_TextureCoord; // (u, v)

// UVs
uniform vec4 in_Normal_UVs;
uniform vec4 in_Specular_UVs;

//
varying vec2 v_vTexcoord;
varying vec2 v_vTexcoordNormalMap;
varying vec2 v_vTexcoordSpecularMap;
varying vec4 v_vColour;

void main() 
{
	vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

	v_vColour = in_Colour;
	v_vTexcoord = in_TextureCoord;
	v_vTexcoordNormalMap = in_TextureCoord * in_Normal_UVs.zw + in_Normal_UVs.xy;
	v_vTexcoordSpecularMap = in_TextureCoord * in_Specular_UVs.zw + in_Specular_UVs.xy;
}