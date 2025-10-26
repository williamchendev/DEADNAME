/// @description Default Dynamic Cloud Initialization
// Initializes the Dynamic Cloud for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds Dynamic Cloud to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Dynamic Cloud to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.Dynamic_Cloud);
}
else
{
    // Add Dynamic Cloud to Sub Layer by Sub Layer Name
    var temp_dynamic_cloud_layer = sub_layer_use_default_layer ? LightingEngineDefaultLayer : (sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name);
    var temp_successfully_added_cloud = lighting_engine_add_object(id, LightingEngineObjectType.Dynamic_Cloud, temp_dynamic_cloud_layer, sub_layer_index);
    
    // Update Dynamic Cloud's Sub-Layer
    sub_layer_name = temp_dynamic_cloud_layer;
    
    // Debug Flag - Unsuccessfully added Dynamic Cloud to Lighting Engine Sub Layer
    if (!temp_successfully_added_cloud)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Dynamic Object (Cloud) \"{object_get_name(object_index)}\" to Lighting Engine Sub Layer with name \"{temp_dynamic_cloud_layer}\"");
        instance_destroy();
        return;
    }
}

// Initialize Dynamic Cloud DS Lists
clouds_image_index_list = ds_list_create();

clouds_rotation_list = ds_list_create();

clouds_horizontal_offset_list = ds_list_create();
clouds_vertical_offset_list = ds_list_create();

clouds_horizontal_scale_list = ds_list_create();
clouds_vertical_scale_list = ds_list_create();

clouds_alpha_list = ds_list_create();
clouds_alpha_filter_list = ds_list_create();

clouds_color_list = ds_list_create();

// Initialize Dynamic Cloud Textures & UVs
normalmap_spritepack = normal_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, normal_map);
metallicroughnessmap_spritepack = metallicroughness_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, metallicroughness_map);
emissivemap_spritepack = emissive_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, emissive_map);
alphafiltermap_spritepack = spritepack_get_uvs_transformed(sprite_index, alphafilter_map);
