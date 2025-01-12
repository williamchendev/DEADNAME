/// @description Insert description here
// You can write your code in this editor

//
spot_light_collisions_list = ds_list_create();

//
old_spot_light_radius = undefined;
old_spot_light_position_x = undefined;
old_spot_light_position_y = undefined;

//
spot_light_vertex_buffer = vertex_create_buffer();
vertex_begin(spot_light_vertex_buffer, LightingEngine.lighting_engine_point_light_vertex_format);

vertex_position(spot_light_vertex_buffer, -1, -1);
vertex_position(spot_light_vertex_buffer, 1, -1);
vertex_position(spot_light_vertex_buffer, -1, 1);

vertex_position(spot_light_vertex_buffer, 1, 1);
vertex_position(spot_light_vertex_buffer, -1, 1);
vertex_position(spot_light_vertex_buffer, 1, -1);

vertex_end(spot_light_vertex_buffer);
vertex_freeze(spot_light_vertex_buffer);

//
visible = false;
sprite_index = -1;