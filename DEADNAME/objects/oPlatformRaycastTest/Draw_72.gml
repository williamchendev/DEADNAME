/// @description Insert description here
// You can write your code in this editor

surface_set_target(LightingEngine.debug_surface);

var temp_collision = platform_raycast(x, y, 300, point_direction(x, y, mouse_x + LightingEngine.render_x, mouse_y + LightingEngine.render_y));

draw_set_color(c_red);
draw_line_width(x - LightingEngine.render_x, y - LightingEngine.render_y, temp_collision.collision_x - LightingEngine.render_x, temp_collision.collision_y - LightingEngine.render_y, 3);
draw_set_color(c_white);

surface_reset_target();