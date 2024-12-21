/// @description Room End Cleanup Event
// Cleanup for Event Lighting Engine

//
for (var i = ds_list_size(lighting_engine_layer_object_list) - 1; i >= 0; i--)
{
    var temp_layer_object_list = ds_list_find_value(lighting_engine_layer_object_list, i);
    
    ds_list_delete(lighting_engine_layer_object_list, i);
    ds_list_destroy(temp_layer_object_list);
}

//
ds_list_clear(lighting_engine_layer_name_list);
ds_list_clear(lighting_engine_layer_object_list);
ds_list_clear(lighting_engine_layer_depth_list);

// Add Default Layers to Lighting Engine
lighting_engine_create_default_layers();