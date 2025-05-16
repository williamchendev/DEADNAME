/// @description Default Dynamic Particle Initialization
// Initializes Dynamic Particle for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Initialize Particle System as Null
dynamic_particle_system = -1;

// Adds Dynamic Particle to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Dynamic Particle to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.Dynamic_Particle);
}
else
{
    // Add Dynamic Particle to Sub Layer by Sub Layer Name
    var temp_dynamic_particle_layer = sub_layer_use_default_layer ? LightingEngineDefaultLayer : (sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name);
    var temp_successfully_added_particle = lighting_engine_add_object(id, LightingEngineObjectType.Dynamic_Basic, temp_dynamic_particle_layer, sub_layer_index);
    
    // Update Dynamic Particle's Sub-Layer
    sub_layer_name = temp_dynamic_particle_layer;
    
    // Debug Flag - Unsuccessfully added Dynamic Particle to Lighting Engine Sub Layer
    if (!temp_successfully_added_particle)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Dynamic Particle System \"{object_get_name(object_index)}\" to Lighting Engine Sub Layer with name \"{sub_layer_use_default_layer ? LightingEngineDefaultLayer : temp_dynamic_particle_layer}\"");
        instance_destroy();
        return;
    }
}

// Creates a Particle System
dynamic_particle_system = part_system_create();
part_system_automatic_draw(dynamic_particle_system, false);
