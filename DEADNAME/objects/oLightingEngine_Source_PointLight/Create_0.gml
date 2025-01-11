/// @description Create Light Source
// You can write your code in this editor

//
point_light_collisions_list = ds_list_create();

//
old_point_light_radius = undefined;
old_point_light_position_x = undefined;
old_point_light_position_y = undefined;

//
point_light_vertex_buffer = vertex_create_buffer();
vertex_begin(point_light_vertex_buffer, LightingEngine.lighting_engine_point_light_vertex_format);

vertex_position(point_light_vertex_buffer, -1, -1);
vertex_position(point_light_vertex_buffer, 1, -1);
vertex_position(point_light_vertex_buffer, -1, 1);

vertex_position(point_light_vertex_buffer, 1, 1);
vertex_position(point_light_vertex_buffer, -1, 1);
vertex_position(point_light_vertex_buffer, 1, -1);

vertex_end(point_light_vertex_buffer);
vertex_freeze(point_light_vertex_buffer);

//
visible = false;
sprite_index = -1;