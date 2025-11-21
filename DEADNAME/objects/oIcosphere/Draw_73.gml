/// @description DEBUG DRAW EVENT
// Creates the Icosphere Vertex Buffer

//
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);

// Draw to UI Surface
surface_set_target(LightingEngine.depth_enabled_surface);
draw_clear_alpha(c_black, 1);

//
draw_set_color(c_white);
draw_set_alpha(1);

//
shader_set(shd_sphere_unlit);

//
shader_set_uniform_f(LightingEngine.sphere_unlit_shader_radius_index, radius);
shader_set_uniform_f(LightingEngine.sphere_unlit_shader_position_index, x, y, z);
shader_set_uniform_f(LightingEngine.sphere_unlit_shader_euler_angles_index, euler_angle_x, euler_angle_y, euler_angle_z);

//
vertex_submit(icosphere_vertex_buffer, pr_trianglelist, icosphere_texture);

//
shader_reset();

/*
// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_red);

draw_rectangle_color(x - 120, y - 120, x + 120, y + 120, c_black, c_black, c_black, c_black, false);

rot_v += rot_spd * frame_delta;
rot_v = rot_v mod 1;

var temp_rot_c = cos(rot_v * 2 * pi);
var temp_rot_s = sin(rot_v * 2 * pi);

for (var q = 0; q < array_length(icosphere.triangles); q++)
{
	var temp_tri = icosphere.triangles[q];
	
	var t1 = icosphere.vertices[temp_tri[0]];
	var t2 = icosphere.vertices[temp_tri[1]];
	var t3 = icosphere.vertices[temp_tri[2]];
	
	var q1 = ((t1[0] * temp_rot_c - t1[2] * temp_rot_s) * 80) + x;
	var q2 = (t1[1] * 80) + y;
	
	var q3 = ((t2[0] * temp_rot_c - t2[2] * temp_rot_s) * 80) + x;
	var q4 = (t2[1] * 80) + y;
	
	var q5 = ((t3[0] * temp_rot_c - t3[2] * temp_rot_s) * 80) + x;
	var q6 = (t3[1] * 80) + y;
	
	draw_set_color(merge_color(c_red, c_blue, q / array_length(icosphere.triangles)));
	draw_line(q1, q2, q3, q4);
	draw_line(q3, q4, q5, q6);
	draw_line(q5, q6, q1, q2);
}

for (var i = 0; i < array_length(icosphere.vertices); i++)
{
	var temp_vertex = icosphere.vertices[i];
	draw_set_color(merge_color(c_red, c_blue, i / array_length(icosphere.vertices)));
	draw_circle(((temp_vertex[0] * temp_rot_c - temp_vertex[2] * temp_rot_s) * 80) + x, (temp_vertex[1] * 80) + y, 1, false);
}
*/

// Reset Surface
surface_reset_target();

//
surface_set_target(LightingEngine.ui_surface);

draw_surface(LightingEngine.depth_enabled_surface, 0, 0);

surface_reset_target();

//
gpu_set_zwriteenable(false);
gpu_set_ztestenable(false);

