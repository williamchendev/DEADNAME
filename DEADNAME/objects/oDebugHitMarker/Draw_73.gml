/// @description Insert description here
// You can write your code in this editor

surface_set_target(LightingEngine.ui_surface);

//draw_line_width_color(start_x - LightingEngine.render_x, start_y - LightingEngine.render_y, x - LightingEngine.render_x, y - LightingEngine.render_y, 2, c_white, c_black);

draw_primitive_begin(pr_trianglestrip);

var temp_old_pos_x = start_x;
var temp_old_pos_y = start_y;

draw_vertex_color(start_x - LightingEngine.render_x, start_y - LightingEngine.render_y, trail_start_color, trail_start_alpha);
draw_vertex_color(start_x - LightingEngine.render_x, start_y - LightingEngine.render_y, trail_start_color, trail_start_alpha);

var temp_trail_length = trail_segments * trail_segment_divisions;

for (var i = 0; i < temp_trail_length; i++)
{
	var temp_trail_weight = trail_weights[i div trail_segment_divisions];
	
	var temp_trail_v = (i mod trail_segment_divisions) / trail_segment_divisions;
	var temp_trail_pa = lerp(0, temp_trail_weight, temp_trail_v);
	var temp_trail_pb = lerp(0, trail_segment_divisions, temp_trail_v);
	var temp_trail_pc = lerp(temp_trail_weight, 0, temp_trail_v);
	var temp_trail_pd = lerp(temp_trail_pa, temp_trail_pb, temp_trail_v);
	var temp_trail_pe = lerp(temp_trail_pb, temp_trail_pc, temp_trail_v);
	var temp_trail_p = lerp(temp_trail_pd, temp_trail_pe, temp_trail_v);
	
	var temp_pos_x = start_x + (i * trail_segment_length * trail_vector_h) + (temp_trail_p * trail_vector_v);
	var temp_pos_y = start_y + (i * trail_segment_length * -trail_vector_v) + (temp_trail_p * trail_vector_h);
	
	var temp_trail_progress = i / temp_trail_length;
	var temp_trail_color = merge_color(trail_start_color, trail_end_color, temp_trail_progress);
	var temp_trail_alpha = lerp(trail_start_alpha, trail_end_alpha, temp_trail_progress);
	
	draw_vertex_color(temp_pos_x - LightingEngine.render_x + (trail_thickness * trail_vector_v), temp_pos_y - LightingEngine.render_y + (trail_thickness * trail_vector_h), temp_trail_color, temp_trail_alpha * trail_alpha);
	draw_vertex_color(temp_pos_x - LightingEngine.render_x + (-trail_thickness * trail_vector_v), temp_pos_y - LightingEngine.render_y + (-trail_thickness * trail_vector_h), temp_trail_color, temp_trail_alpha * trail_alpha);
}

draw_primitive_end();

if (hitmarker_destroy_timer > 0)
{
	draw_sprite_ext(sprite_index, image_index, x - LightingEngine.render_x + hitmarker_dropshadow_horizontal_offset, y - LightingEngine.render_y + hitmarker_dropshadow_vertical_offset, 1, 1, image_angle, c_black, 1);
	draw_sprite_ext(sprite_index, image_index, x - LightingEngine.render_x, y - LightingEngine.render_y, 1, 1, image_angle, c_white, 1);
}

surface_reset_target();
