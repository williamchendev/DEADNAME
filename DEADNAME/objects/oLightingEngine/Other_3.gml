/// @description Game End Cleanup Event
// Cleanup for Event Lighting Engine

//
for (var i = ds_list_size(lighting_engine_layer_object_list) - 1; i >= 0; i--)
{
    var temp_layer_object_list = ds_list_find_value(lighting_engine_layer_object_list, i);
    
    ds_list_delete(lighting_engine_layer_object_list, i);
    ds_list_destroy(temp_layer_object_list);
}

//
ds_list_destroy(lighting_engine_layer_name_list);
lighting_engine_layer_name_list = -1;

ds_list_destroy(lighting_engine_layer_object_list);
lighting_engine_layer_object_list = -1;

ds_list_destroy(lighting_engine_layer_depth_list);
lighting_engine_layer_depth_list = -1;

//
surface_free(diffuse_color_surface);
surface_free(normalmap_color_surface);
surface_free(depth_specular_stencil_surface);
surface_free(ui_surface);

//
if (global.debug_surface_enabled)
{
	surface_free(debug_surface);
}

//
diffuse_color_surface = -1;
normalmap_color_surface = -1;
depth_specular_stencil_surface = -1;
ui_surface = -1;
debug_surface = -1;