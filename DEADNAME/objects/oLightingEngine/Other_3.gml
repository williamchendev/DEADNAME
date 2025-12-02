/// @description Game End Cleanup Event
// Cleanup Event for Lighting Engine

// Clean Up all Sub Layers and Lighting Objects from Lighting Object "Painter's Sorted List" DS Lists
lighting_engine_delete_all_sub_layers();

// Destroy Sub Layer Organization DS Lists
ds_list_destroy(lighting_engine_sub_layer_name_list);
lighting_engine_sub_layer_name_list = -1;

ds_list_destroy(lighting_engine_sub_layer_render_layer_type_list);
lighting_engine_sub_layer_render_layer_type_list = -1;

ds_list_destroy(lighting_engine_back_layer_sub_layer_name_list);
lighting_engine_back_layer_sub_layer_name_list = -1;

ds_list_destroy(lighting_engine_back_layer_sub_layer_depth_list);
lighting_engine_back_layer_sub_layer_depth_list = -1;

ds_list_destroy(lighting_engine_back_layer_sub_layer_type_list);
lighting_engine_back_layer_sub_layer_type_list = -1;

ds_list_destroy(lighting_engine_back_layer_sub_layer_object_list);
lighting_engine_back_layer_sub_layer_object_list = -1;

ds_list_destroy(lighting_engine_back_layer_sub_layer_object_type_list);
lighting_engine_back_layer_sub_layer_object_type_list = -1;

ds_list_destroy(lighting_engine_mid_layer_sub_layer_name_list);
lighting_engine_mid_layer_sub_layer_name_list = -1;

ds_list_destroy(lighting_engine_mid_layer_sub_layer_depth_list);
lighting_engine_mid_layer_sub_layer_depth_list = -1;

ds_list_destroy(lighting_engine_mid_layer_sub_layer_type_list);
lighting_engine_mid_layer_sub_layer_type_list = -1;

ds_list_destroy(lighting_engine_mid_layer_sub_layer_object_list);
lighting_engine_mid_layer_sub_layer_object_list = -1;

ds_list_destroy(lighting_engine_mid_layer_sub_layer_object_type_list);
lighting_engine_mid_layer_sub_layer_object_type_list = -1;

ds_list_destroy(lighting_engine_front_layer_sub_layer_name_list);
lighting_engine_front_layer_sub_layer_name_list = -1;

ds_list_destroy(lighting_engine_front_layer_sub_layer_depth_list);
lighting_engine_front_layer_sub_layer_depth_list = -1;

ds_list_destroy(lighting_engine_front_layer_sub_layer_type_list);
lighting_engine_front_layer_sub_layer_type_list = -1;

ds_list_destroy(lighting_engine_front_layer_sub_layer_object_list);
lighting_engine_front_layer_sub_layer_object_list = -1;

ds_list_destroy(lighting_engine_front_layer_sub_layer_object_type_list);
lighting_engine_front_layer_sub_layer_object_type_list = -1;

ds_list_destroy(lighting_engine_unlit_layer_object_list);
lighting_engine_unlit_layer_object_list = -1;

ds_list_destroy(lighting_engine_unlit_layer_object_type_list);
lighting_engine_unlit_layer_object_type_list = -1;

ds_list_destroy(lighting_engine_unlit_layer_object_depth_list);
lighting_engine_unlit_layer_object_depth_list = -1;

ds_list_destroy(lighting_engine_ui_layer_object_list);
lighting_engine_ui_layer_object_list = -1;

ds_list_destroy(lighting_engine_ui_layer_object_type_list);
lighting_engine_ui_layer_object_type_list = -1;

ds_list_destroy(lighting_engine_ui_layer_object_depth_list);
lighting_engine_ui_layer_object_depth_list = -1;

// Destroy Backgrounds DS List
ds_list_destroy(lighting_engine_backgrounds);
lighting_engine_backgrounds = -1;

ds_list_destroy(lighting_engine_background_layer_ids);
lighting_engine_background_layer_ids = -1;

// Destroy Culling Regions DS Map
ds_map_destroy(lighting_engine_culling_regions_map);
lighting_engine_culling_regions_map = -1;

// Free all Surfaces used by the Lighting Engine
lighting_engine_render_clear_surfaces();

// Delete Vertex Formats
vertex_format_delete(lighting_engine_box_shadows_vertex_format);
lighting_engine_box_shadows_vertex_format = -1;

vertex_format_delete(lighting_engine_simple_light_vertex_format);
lighting_engine_simple_light_vertex_format = -1;

vertex_format_delete(lighting_engine_screen_space_render_vertex_format);
lighting_engine_screen_space_render_vertex_format = -1;

vertex_format_delete(lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format);
lighting_engine_static_sprite_bulk_mrt_rendering_vertex_format = -1;

// Delete Vertex Buffers
vertex_delete_buffer(simple_light_vertex_buffer);
simple_light_vertex_buffer = -1;

vertex_delete_buffer(screen_space_vertex_buffer);
screen_space_vertex_buffer = -1;

// Delete Directional Shadows Variables and List
directional_light_collisions_exist = false;

ds_list_destroy(directional_light_collisions_list);
directional_light_collisions_list = -1;