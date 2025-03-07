/// @description Default Dynamic Object Initialization
// Initialized Dynamic Object for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds Dynamic Object to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Dynamic Object to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.Dynamic_Basic);
}
else
{
    // Add Dynamic Object to Sub Layer by Sub Layer Name
    var temp_dynamic_object_layer = sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name;
    var temp_successfully_added_object = lighting_engine_add_object(id, LightingEngineObjectType.Dynamic_Basic, sub_layer_use_default_layer ? LightingEngineDefaultLayer : temp_dynamic_object_layer);
    
    // Debug Flag - Unsuccessfully added Dynamic Object to Lighting Engine Sub Layer
    if (!temp_successfully_added_object)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Dynamic Object (Basic) to Lighting Engine Sub Layer with name \"{sub_layer_use_default_layer ? LightingEngineDefaultLayer : temp_dynamic_object_layer}\"");
        return;
    }
}

// Initialize Dynamic Object Textures & UVs
normalmap_spritepack = normal_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, normal_map);
metallicroughnessmap_spritepack = metallicroughness_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, metallicroughness_map);
emissivemap_spritepack = emissive_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, emissive_map);
