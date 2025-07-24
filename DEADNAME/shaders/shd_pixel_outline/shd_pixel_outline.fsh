//
// Pixel Outline Effect fragment shader for Inno's Rendering System
//

// Interpolated Color and UVs
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniform Outline and Surface Size Settings
uniform float in_OutlineSize;
uniform vec2 in_SurfaceSize;

// Fragment Shader
void main() 
{
	// Establish Horizontal and Vertical Offset UVs based on Surface Resolution
	vec2 offset_x;
	offset_x.x = in_OutlineSize / in_SurfaceSize.x;
	
	vec2 offset_y;
	offset_y.y = in_OutlineSize / in_SurfaceSize.y;
	
	// Retreive Pixel Color at UV
	vec4 surface_color = texture2D( gm_BaseTexture, v_vTexcoord );

	// Calculate Maximum Alpha based on retreived Alpha Values at Offset UVs
	float alpha = surface_color.a;

	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offset_x).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offset_x).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord + offset_y).a);
	alpha = max(alpha, texture2D( gm_BaseTexture, v_vTexcoord - offset_y).a);
	
	// Create Outline 
	gl_FragColor = surface_color.a == 0.0 ? v_vColour * alpha : surface_color;
}