/// @description Default Dynamic Smoke Trail Initialization
// Initializes Dynamic Smoke Trail for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds Dynamic Object to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Dynamic Particle to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.Dynamic_Primitive);
}
else
{
    // Add Dynamic Smoke Trail to Sub Layer by Sub Layer Name
    var temp_dynamic_object_layer = sub_layer_use_default_layer ? LightingEngineDefaultLayer : (sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name);
    var temp_successfully_added_object = lighting_engine_add_object(id, LightingEngineObjectType.Dynamic_Primitive, temp_dynamic_object_layer);
    
    // Update Dynamic Smoke Trail's Sub-Layer
    sub_layer_name = temp_dynamic_object_layer;
    
    // Debug Flag - Unsuccessfully added Dynamic Smoke Trail to Lighting Engine Sub Layer
    if (!temp_successfully_added_object)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Dynamic Smoke Trail \"{object_get_name(object_index)}\" to Lighting Engine Sub Layer with name \"{temp_dynamic_object_layer}\"");
        instance_destroy();
        return;
    }
}

// Smoke Trail Settings
trail_thickness = 1;

trail_segments = 6;
trail_segment_length = 5;
trail_segment_divisions = 10;

trail_vector_h = dcos(image_angle);
trail_vector_v = dsin(image_angle);

trail_vector_dh = dcos(image_angle - 90);
trail_vector_dv = dsin(image_angle - 90);

trail_direction = random(1.0) > 0.5 ? 1 : -1;

trail_weight_spd = 1;
trail_weight_mult = 0.98;

trail_weights[0] = 0;
trail_weights[1] = 0;
trail_weights[2] = 0;
trail_weights[3] = 0;
trail_weights[4] = 0;
trail_weights[5] = 0;

trail_weights_spd[0] = random_range(0.5, 1) * trail_direction;
trail_weights_spd[1] = random_range(1, 2) * -trail_direction;
trail_weights_spd[2] = random_range(1, 2) * trail_direction;
trail_weights_spd[3] = random_range(0.5, 1) * -trail_direction;
trail_weights_spd[4] = random_range(0.5, 1) * trail_direction;
trail_weights_spd[5] = random_range(0, 0.5) * -trail_direction;

trail_start_color = merge_color(c_white, c_black, 0.1);
trail_end_color = merge_color(c_white, c_black, 0.3);

trail_start_alpha = 1;
trail_end_alpha = 0;

trail_decay = 0.0037;
trail_alpha = 1.0;
