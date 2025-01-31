//
// Background Surface Rendering fragment shader for Inno's Deferred Lighting System
//

// Uniform Background Settings
uniform vec2 in_Background_Tile;
uniform vec2 in_Background_Offset;
uniform vec2 in_Background_Position;
uniform vec4 in_Background_UVs;

// Interpolated Color and UVs
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Establish Background UVs
	//float Background_U = clamp(in_Background_Tile.x < 1.0 ? (v_vTexcoord.x + in_Background_Offset.x + in_Background_Position.x) : mod(v_vTexcoord.x + in_Background_Offset.x, 1.0), 0.0, 1.0);
	//float Background_V = clamp(in_Background_Tile.y < 1.0 ? (v_vTexcoord.y + in_Background_Offset.y + in_Background_Position.y) : mod(v_vTexcoord.y + in_Background_Offset.y, 1.0), 0.0, 1.0);
	
	vec2 TextureUVs = vec2(mix(in_Background_UVs.x, in_Background_UVs.z, v_vTexcoord.x), mix(in_Background_UVs.y, in_Background_UVs.w, v_vTexcoord.y));
	
	// Render Background Color
	gl_FragColor = texture2D(gm_BaseTexture, TextureUVs);
}