//
// Background Surface Rendering fragment shader for Inno's Deferred Lighting System
//

// Uniform Background Settings
uniform vec2 in_Background_Tile;
uniform vec2 in_Background_Offset;
uniform vec2 in_Background_Position;

// Interpolated Color and UVs
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

// Fragment Shader
void main() 
{
	// Establish Background UVs
	float Background_U = clamp(in_Background_Tile.x < 1.0 ? (v_vTexcoord.x + in_Background_Offset.x + in_Background_Position.x) : mod(v_vTexcoord.x + in_Background_Offset.x + in_Background_Position.x, 1.0), 0.0, 1.0);
	float Background_V = clamp(in_Background_Tile.y < 1.0 ? (v_vTexcoord.y + in_Background_Offset.y + in_Background_Position.y) : mod(v_vTexcoord.y + in_Background_Offset.y + in_Background_Position.y, 1.0), 0.0, 1.0);
	
	// Render Background Color
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, vec2(Background_U, Background_V));
}