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

if (!surface_exists(planets_depth_surface))
{
    planets_depth_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Disable Depth for Celestial Simulation Pipeline Surfaces
surface_depth_disable(true);

// Pre-Draw Check and Create Celestial Simulator Utilized Surfaces Event


// Reset Depth Enabled Celestial Rendering Surface
surface_set_target(planets_depth_surface);
draw_clear_alpha(c_black, 1);
surface_reset_target();
