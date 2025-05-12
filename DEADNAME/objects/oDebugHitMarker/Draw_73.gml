/// @description Insert description here
// You can write your code in this editor

surface_set_target(LightingEngine.ui_surface);

draw_set_alpha(0.6);
draw_line_width_color(start_x - LightingEngine.render_x, start_y - LightingEngine.render_y, x - LightingEngine.render_x, y - LightingEngine.render_y, 2, c_white, c_black);

draw_set_alpha(1);
draw_sprite(sprite_index, image_index, x - LightingEngine.render_x, y - LightingEngine.render_y);

surface_reset_target();
