/// @description Draw Lighting Engine Surfaces to Screen
// Draw the final lit render of the Lighting Engine's surface with any post processing effects and the ui layer

//
gpu_set_blendenable(false);

draw_surface_ext(final_render_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);

gpu_set_blendenable(true);

// Draw Optional Debug Surface
if (global.debug_surface_enabled and global.debug)
{
	draw_surface_ext(lights_mid_color_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
	//draw_surface_ext(lights_shadow_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
	draw_surface_ext(debug_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
}

// Draw UI Surface
draw_surface_ext(ui_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
