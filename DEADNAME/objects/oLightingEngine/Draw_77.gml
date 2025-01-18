/// @description Draw Lighting Engine Surfaces to Screen
// Draw the final lit render of the Lighting Engine's surface with any post processing effects and the ui layer

// Draw Lit Surface with Post Processing (Post Processing in development RIP)
gpu_set_blendenable(false);

shader_set(shd_final_render_lighting);

texture_set_stage(final_render_lighting_shader_diffusemap_back_layer_texture_index, surface_get_texture(diffuse_back_color_surface));
texture_set_stage(final_render_lighting_shader_diffusemap_front_layer_texture_index, surface_get_texture(diffuse_front_color_surface));

texture_set_stage(final_render_lighting_shader_lightblend_back_layer_texture_index, surface_get_texture(lights_back_color_surface));
texture_set_stage(final_render_lighting_shader_lightblend_mid_layer_texture_index, surface_get_texture(lights_mid_color_surface));
texture_set_stage(final_render_lighting_shader_lightblend_front_layer_texture_index, surface_get_texture(lights_front_color_surface));

draw_surface_ext(diffuse_mid_color_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);

shader_reset();

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
