/// @description Game End Cleanup Event
// Cleanup for Event Lighting Engine

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

// Destroy Backgrounds DS List
ds_list_destroy(lighting_engine_backgrounds);
lighting_engine_backgrounds = -1;

ds_list_destroy(lighting_engine_background_layer_ids);
lighting_engine_background_layer_ids = -1;

// Free Surfaces
surface_free(temp_surface);

surface_free(background_surface);

surface_free(diffuse_back_color_surface);
surface_free(diffuse_mid_color_surface);
surface_free(diffuse_front_color_surface);

surface_free(lights_back_color_surface);
surface_free(lights_mid_color_surface);
surface_free(lights_front_color_surface);

surface_free(normalmap_vector_surface);
surface_free(depth_specular_bloom_surface);
surface_free(background_depth_specular_bloom_surface);

surface_free(bloom_effect_surface);
surface_free(distortion_effect_surface);

surface_free(post_processing_surface);
surface_free(final_render_surface);

surface_free(ui_surface);

// Free Debug Surface
if (global.debug_surface_enabled)
{
	surface_free(debug_surface);
}

// Reset Surface Variables
temp_surface = -1;

background_surface = -1;

diffuse_back_color_surface = -1;
diffuse_mid_color_surface = -1;
diffuse_front_color_surface = -1;

lights_back_color_surface = -1;
lights_mid_color_surface = -1;
lights_front_color_surface = -1;

normalmap_vector_surface = -1;
depth_specular_bloom_surface = -1;
background_depth_specular_bloom_surface = -1;

bloom_effect_surface = -1;
distortion_effect_surface = -1;

post_processing_surface = -1;
final_render_surface = -1;

ui_surface = -1;

debug_surface = -1;

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