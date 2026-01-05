/// @description Surfaces Initialization
// Creates the Surfaces for the Celestial Simulator

// Check if Celestial Simulator is Active
if (!active)
{
	// Inactive - Early Return
	return;
}

// Enable Depth for Celestial Simulation Pipeline Surfaces
surface_depth_disable(false);

// Pre-Draw Check and Create Celestial Simulator Utilized Depth Enabled Surfaces Event
if (!surface_exists(celestial_body_render_surface))
{
    celestial_body_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(celestial_body_atmosphere_depth_mask_surface))
{
    celestial_body_atmosphere_depth_mask_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r16float);
}

if (!surface_exists(clouds_render_surface))
{
    clouds_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(clouds_alpha_mask_surface))
{
    clouds_alpha_mask_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r8unorm);
}

if (!surface_exists(clouds_atmosphere_depth_mask_surface))
{
    clouds_atmosphere_depth_mask_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_r16float);
}

// Disable Depth for Celestial Simulation Pipeline Surfaces
surface_depth_disable(true);

// Pre-Draw Check and Create Celestial Simulator Utilized Surfaces Event
if (!surface_exists(final_render_surface))
{
    final_render_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Reset Celestial Simulator's Final Rendering Surface
surface_set_target(final_render_surface);
draw_clear_alpha(c_black, 1);
surface_reset_target();
