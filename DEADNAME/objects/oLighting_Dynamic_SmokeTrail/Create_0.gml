/// @description Default Dynamic Smoke Trail Initialization
// Initializes Dynamic Smoke Trail for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds Dynamic Object to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Dynamic Particle to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.Dynamic_SmokeTrail);
}
else
{
    // Add Dynamic Smoke Trail to Sub Layer by Sub Layer Name
    var temp_dynamic_object_layer = sub_layer_use_default_layer ? LightingEngineDefaultLayer : (sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name);
    var temp_successfully_added_object = lighting_engine_add_object(id, LightingEngineObjectType.Dynamic_SmokeTrail, temp_dynamic_object_layer);
    
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

// Smoke Trail Direction
trail_vector_h = dcos(image_angle);
trail_vector_v = dsin(image_angle);

// Smoke Trail Settings
trail_movement_spd = 0.15;

trail_wind_spd = 0.2;

trail_wind_direction_h = -0.7;
trail_wind_direction_v = -0.5;

trail_weight_spd = 1;
trail_weight_mult = 0.97;

trail_thickness_decay_spd = 1;
trail_thickness_decay_mult = 0.98;

// Smoke Trail Variables
trail_segment_position_x = array_create(trail_segments);
trail_segment_position_y = array_create(trail_segments);

trail_segment_movement_spd = array_create(trail_segments);

trail_segment_movement_h = array_create(trail_segments);
trail_segment_movement_v = array_create(trail_segments);

trail_segment_bezier_weight_h = array_create(trail_segments);
trail_segment_bezier_weight_v = array_create(trail_segments);

trail_segment_bezier_spd_h = array_create(trail_segments);
trail_segment_bezier_spd_v = array_create(trail_segments);

trail_segment_thickness = array_create(trail_segments);
trail_segment_thickness_decay = array_create(trail_segments);

trail_direction = random(1.0) > 0.5 ? 1 : -1;

for (var i = 0; i < trail_segments; i++)
{
	trail_segment_position_x[i] = 0;
	trail_segment_position_y[i] = 0;
	
	trail_segment_movement_spd[i] = random_range(0, 0.25);
	
	trail_segment_movement_h[i] = random_range(-1, 1);
	trail_segment_movement_v[i] = random_range(-1, 1);
	
	trail_segment_bezier_weight_h[i] = 0;
	trail_segment_bezier_weight_v[i] = random_range(-1, 1);
	
	trail_segment_bezier_spd_h[i] = random_range(-1, 1);
	trail_segment_bezier_spd_v[i] = random_range(-0.5, 0.5) + (random_range(1, 3) * power(random(1.0), 2) * trail_direction);
	
	trail_segment_thickness[i] = trail_thickness + random_range(trail_thickness_additive_min, trail_thickness_additive_max);
	trail_segment_thickness_decay[i] = random_range(trail_thickness_decay_min, trail_thickness_decay_max);
	
	trail_direction *= -1;
}

trail_alpha = trail_start_alpha;
