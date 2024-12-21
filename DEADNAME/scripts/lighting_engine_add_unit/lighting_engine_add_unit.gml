
function lighting_engine_add_unit(unit_instance, layer_name = LightingEngineUnitLayer) 
{
    //
    var temp_lighting_object =
    {
        lit_object_type: LightingEngineLitObjectType.Unit,
        lit_object_instance: unit_instance
    }

    //
    var temp_lighting_engine_layer_index = ds_list_find_index(LightingEngine.lighting_engine_layer_name_list, layer_name);
    
    if (temp_lighting_engine_layer_index != -1)
    {
        var temp_lighting_engine_layer = ds_list_find_value(LightingEngine.lighting_engine_layer_object_list, temp_lighting_engine_layer_index);
        
        ds_list_add(temp_lighting_engine_layer, temp_lighting_object);
        show_debug_message("ker");
    }
}