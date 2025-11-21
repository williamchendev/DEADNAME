//

// Pre-Draw Check and Create Depth Enabled Surfaces Event
surface_depth_disable(false);

if (!surface_exists(planets_depth_surface))
{
    planets_depth_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

// Disable Depth for Planet Simulation Pipeline Surfaces
surface_depth_disable(true);

// Pre-Draw Check and Create Lighting Engine Utilized Surfaces Event


//
surface_set_target(planets_depth_surface);
draw_clear_alpha(c_black, 1);
surface_reset_target();
