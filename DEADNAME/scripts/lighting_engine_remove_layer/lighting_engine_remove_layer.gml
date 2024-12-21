

function lighting_engine_remove_layer(layer_name) 
{
    // Find Layer Index
    var temp_layer_index = ds_list_find_index(LightingEngine.lighting_engine_layer_name_list, layer_name);
    
    // Remove Layer
    if (temp_layer_index != -1)
    {
        // Delete Lighting Engine Layer
        ds_list_delete(LightingEngine.lighting_engine_layer_name_list, temp_layer_index);
        ds_list_delete(LightingEngine.lighting_engine_layer_object_list, temp_layer_index);
        ds_list_delete(LightingEngine.lighting_engine_layer_depth_list, temp_layer_index);
    }
}