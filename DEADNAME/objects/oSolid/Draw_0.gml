/// @description Insert description here
// You can write your code in this editor


draw_self();

//draw_circle(corner_xpos_a, corner_ypos_a, 3, false);
//draw_circle(corner_xpos_b, corner_ypos_b, 3, false);
//draw_circle(corner_xpos_c, corner_ypos_c, 3, false);
//draw_circle(corner_xpos_d, corner_ypos_d, 3, false);

//draw_text(lerp(corner_xpos_a, corner_xpos_c, 0.5), lerp(corner_ypos_a, corner_ypos_c, 0.5), $"{rotations}");

//draw_point(mouse_x, mouse_y);

//point_check_solid_surface_angle(mouse_x, mouse_y, self); 

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fDiest64);
draw_text(corner_xpos_a, corner_ypos_a, $"{corner_angle_a}");
draw_text(corner_xpos_b, corner_ypos_b, $"{corner_angle_b}");
draw_text(corner_xpos_c, corner_ypos_c, $"{corner_angle_c}");
draw_text(corner_xpos_d, corner_ypos_d, $"{corner_angle_d}");

draw_text(center_xpos, center_ypos, $"{rotations}");

var temp_mouse_val = point_check_solid_surface_angle_and_closest_point(mouse_x, mouse_y, self);
draw_circle_color(temp_mouse_val.return_x, temp_mouse_val.return_y, 3, c_red, c_red, false);