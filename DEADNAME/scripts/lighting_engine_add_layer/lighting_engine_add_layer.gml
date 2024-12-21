

function lighting_engine_add_layer(layer_name, layer_depth_value) 
{
    // Check if Layer already exists
    if (ds_list_find_index(LightingEngine.lighting_engine_layer_name_list, layer_name) != -1)
    {
        // Layer Creation: Failure
        return false;
    }
    
    // Clamp Layer Depth
    layer_depth_value = clamp(layer_depth_value, -1, 1);
    
    // Find Index based on Layer Depth
    var i = 0;
    
    repeat(ds_list_size(LightingEngine.lighting_engine_layer_depth_list))
    {
        var temp_layer_depth = ds_list_find_value(LightingEngine.lighting_engine_layer_depth_list, i);
        
        if (layer_depth_value < temp_layer_depth)
        {
            break;
        }
        
        i++;
    }
    
    // Add Layer to Lighting Engine
    ds_list_add(LightingEngine.lighting_engine_layer_name_list, layer_name);
    ds_list_add(LightingEngine.lighting_engine_layer_object_list, ds_list_create());
    ds_list_add(LightingEngine.lighting_engine_layer_depth_list, layer_depth_value);
    
    show_debug_message(ds_list_find_value(LightingEngine.lighting_engine_layer_name_list, 0));
    
    // Layer Creation: Success
    return true;
}