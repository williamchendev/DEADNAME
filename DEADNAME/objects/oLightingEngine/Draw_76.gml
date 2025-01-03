/// @description Pre-Draw Lighting Engine Surface Creation
// Creates the Surfaces for the Lighting Engine

// Pre-Draw Check and Create Lighting Engine Utilized Surfaces Event
if (!surface_exists(lights_color_surface))
{
    lights_color_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(lights_vector_surface))
{
    lights_vector_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(diffuse_color_surface))
{
    diffuse_color_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(normalmap_vector_surface))
{
    normalmap_vector_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(depth_specular_stencil_surface))
{
    depth_specular_stencil_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(ui_surface))
{
    ui_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Refresh UI Surface Clear
surface_set_target(ui_surface);
draw_clear_alpha(c_black, 0);
surface_reset_target();

// Debug-Enabled Surfaces Behaviour
if (global.debug_surface_enabled)
{
	// Check and Create Debug Surface
	if (!surface_exists(debug_surface))
	{
		debug_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
	}
	
	// Refresh Debug Surface Clear
	surface_set_target(debug_surface);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
}