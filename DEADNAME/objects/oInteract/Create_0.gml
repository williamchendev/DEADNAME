/// @description Interact Init
// Creates the variables and settings of the Interaction

// Game Manager Singleton
game_manager = instance_find(oGameManager, 0);

// Interact Settings
active = true;

infinite_range = false;

// Animation Settings
interact_select = false;
interact_select_draw_spd = 0.15;

interact_mirror_select_obj = true;

// UI Settings
interact_description = "Press [E]";
interact_description_font = fNormalFont;

interact_icon_index = 0;
interact_select_outline_color = c_white;
interact_select_second_outline_color = c_black;

interact_description_yoffset = -9;

// Walk Settings
interact_walk = false;
interact_walk_x = x;
interact_walk_y = y;
interact_walk_face_xdirection = true;

interact_walk_range = false;
interact_walk_radius = 64;

// Interact Variables
interact_action = false;
interact_destroy = false;

interact_obj = noone;
interact_unit = noone;

// Animation Variables
interact_select_draw_value = 0;

// UI Variables
interact_description_show = false;

interact_image_xscale = 1;
interact_image_yscale = 1;

// Surface Variables
temp_surface = noone;
interact_surface = noone;

// Shader Variables
uniform_pixel_width = shader_get_uniform(shd_outline, "pixelW");
uniform_pixel_height = shader_get_uniform(shd_outline, "pixelH");