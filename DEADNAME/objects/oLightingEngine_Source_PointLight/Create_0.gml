/// @description Create Light Source
// You can write your code in this editor

//
point_light_render_enabled = false;
point_light_color = image_blend;
point_light_radius = abs(image_xscale * sprite_get_width(sprite_index));

//
point_light_collisions_list = ds_list_create();

//
old_point_light_radius = undefined;
old_point_light_position_x = undefined;
old_point_light_position_y = undefined;

//
visible = false;
sprite_index = -1;