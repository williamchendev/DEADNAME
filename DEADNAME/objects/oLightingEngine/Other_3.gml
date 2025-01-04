/// @description Game End Cleanup Event
// Cleanup for Event Lighting Engine

// Clean Up Lighting Objects from Lighting Object "Painter's Sorted List"
for (var i = ds_list_size(lighting_engine_layer_object_list) - 1; i >= 0; i--)
{
    var temp_layer_object_list = ds_list_find_value(lighting_engine_layer_object_list, i);
    
    ds_list_delete(lighting_engine_layer_object_list, i);
    ds_list_destroy(temp_layer_object_list);
}

// Destroy Lighting Layer and Object DS Lists
ds_list_destroy(lighting_engine_layer_name_list);
lighting_engine_layer_name_list = -1;

ds_list_destroy(lighting_engine_layer_object_list);
lighting_engine_layer_object_list = -1;

ds_list_destroy(lighting_engine_layer_depth_list);
lighting_engine_layer_depth_list = -1;

// Free Surfaces
surface_free(lights_color_surface);
surface_free(lights_shadow_surface);

surface_free(diffuse_color_surface);
surface_free(normalmap_vector_surface);
surface_free(depth_specular_stencil_surface);

surface_free(ui_surface);

// Free Debug Surface
if (global.debug_surface_enabled)
{
	surface_free(debug_surface);
}

// Reset Surface Variables
lights_color_surface = -1;
lights_shadow_surface = -1;

diffuse_color_surface = -1;
normalmap_vector_surface = -1;
depth_specular_stencil_surface = -1;

ui_surface = -1;

debug_surface = -1;

// Delete Shadow Vertex Formats
vertex_format_delete(lighting_engine_box_shadows_vertex_format);
lighting_engine_box_shadows_vertex_format = -1;