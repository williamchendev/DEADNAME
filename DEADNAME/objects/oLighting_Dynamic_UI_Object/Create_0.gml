/// @description Default UI Object Initialization
// Initializes the UI Object for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds UI Object to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add UI Object to Lighting Engine Worker to add to UI Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.ui_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.ui_type_list, object_type);
    ds_list_add(LightingEngine.lighting_engine_worker.ui_depth_list, object_depth);
}
else
{
    // Add UI Object to Lighting Engine
    var temp_successfully_added_object = lighting_engine_add_ui_object(id, object_type, object_depth);
    
    // Debug Flag - Unsuccessfully added UI Object to Lighting Engine
    if (!temp_successfully_added_object)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added UI Object (Basic) \"{object_get_name(object_index)}\" to Lighting Engine");
        instance_destroy();
        return;
    }
}
