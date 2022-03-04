/// @description Insert description here
// You can write your code in this editor

// Darken Background
draw_set_alpha(background_darken_value);
draw_set_color(c_black);
draw_rectangle(-150, -150, game_manager.camera_width + 150, game_manager.camera_height + 150, false);
draw_set_alpha(1.0);
draw_set_color(c_white);