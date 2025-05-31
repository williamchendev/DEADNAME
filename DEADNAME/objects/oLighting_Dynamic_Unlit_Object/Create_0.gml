/// @description Default Unlit Object Initialization
// Initialized Unlit Object for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds Unlit Object to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Unlit Object to Lighting Engine Worker to add to Unlit Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.unlit_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.unlit_type_list, object_type);
    ds_list_add(LightingEngine.lighting_engine_worker.unlit_depth_list, object_depth);
}
else
{
    // Add Unlit Object to Lighting Engine
    var temp_successfully_added_object = lighting_engine_add_unlit_object(id, object_type, object_depth);
    
    // Debug Flag - Unsuccessfully added Unlit Object to Lighting Engine
    if (!temp_successfully_added_object)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Unlit Object (Basic) \"{object_get_name(object_index)}\" to Lighting Engine");
        instance_destroy();
        return;
    }
}
