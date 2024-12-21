/// @description Insert description here
// You can write your code in this editor

//
gpu_set_blendenable(false);
draw_surface_ext(global.debug ? normalmap_color_surface : diffuse_color_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
gpu_set_blendenable(true);

//
draw_surface_ext(ui_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);

//
if (global.debug_surface_enabled)
{
	draw_surface_ext(debug_surface, 0, 0, GameManager.game_scale, GameManager.game_scale, 0, c_white, 1);
}
