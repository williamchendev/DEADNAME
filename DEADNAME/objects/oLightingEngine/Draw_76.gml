/// @description Pre-Draw Lighting Engine Surface Creation
// Creates the Surfaces for the Lighting Engine

//
if (!surface_exists(diffuse_color_surface))
{
    diffuse_color_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(normalmap_color_surface))
{
    normalmap_color_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}

if (!surface_exists(depth_specular_stencil_surface))
{
    depth_specular_stencil_surface = surface_create(GameManager.game_width, GameManager.game_height, surface_rgba8unorm);
}