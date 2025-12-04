/// @description Surfaces Initialization
// Creates the Surfaces for the Celestial Simulator

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Pre-Draw Check and Create Depth Enabled Surfaces Event
surface_depth_disable(false);

if (!surface_exists(celestial_render_surface))
{
    celestial_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(atmosphere_depth_mask_surface))
{
    atmosphere_depth_mask_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r8unorm);
}

// Disable Depth for Celestial Simulation Pipeline Surfaces
surface_depth_disable(true);

// Pre-Draw Check and Create Celestial Simulator Utilized Surfaces Event


// Reset Depth Enabled Celestial Rendering Surface
surface_set_target(celestial_render_surface);
draw_clear_alpha(c_black, 1);
draw_clear_depth(1);
surface_reset_target();
