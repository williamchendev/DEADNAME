/// @description Draw Lighting Engine Surfaces to Screen
// Draw the final lit render of the Lighting Engine's surface with any post processing effects and the ui layer

// Draw Lit Surface with Post Processing (Post Processing in development RIP)
gpu_set_blendenable(false);
//draw_surface_ext(global.debug ? normalmap_vector_surface : diffuse_color_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
draw_surface_ext(diffuse_color_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
gpu_set_blendenable(true);

// Draw UI Surface
draw_surface_ext(ui_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);

// Draw Optional Debug Surface
if (global.debug_surface_enabled)
{
	draw_surface_ext(debug_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
}
