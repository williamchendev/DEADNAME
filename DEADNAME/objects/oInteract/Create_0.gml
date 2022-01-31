/// @description Insert description here
// You can write your code in this editor

// Game Manager Singleton
game_manager = instance_find(oGameManager, 0);

// Interact Settings
active = true;

infinite_range = false;

// Animation Settings
interact_select = false;
interact_select_draw_spd = 0.15;
interact_select_outline_color = c_white;

interact_icon_index = 0;

// Interact Variables
interact_action = false;
interact_destroy = false;

interact_obj = noone;
interact_unit = noone;

// Animation Variables
interact_select_draw_value = 0;

// Surface Variables
temp_surface = noone;
interact_surface = noone;

// Shader Variables
uniform_pixel_width = shader_get_uniform(shd_outline, "pixelW");
uniform_pixel_height = shader_get_uniform(shd_outline, "pixelH");