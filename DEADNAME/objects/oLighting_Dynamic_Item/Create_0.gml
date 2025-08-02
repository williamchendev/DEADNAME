/// @description Default Dynamic Item Initialization
// Initializes the Dynamic Item for Lighting Engine Rendering

// Disable Visibility
visible = false;

// Adds Dynamic Item to Lighting Engine
if (LightingEngine.lighting_engine_worker != -1 and instance_exists(LightingEngine.lighting_engine_worker))
{
    // Add Dynamic Item to Lighting Engine Worker to add to Layer after they have been initialized
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_object_list, id);
    ds_list_add(LightingEngine.lighting_engine_worker.dynamic_type_list, LightingEngineObjectType.Dynamic_Item);
}
else
{
    // Add Dynamic Item to Sub Layer by Sub Layer Name
    var temp_dynamic_object_layer = sub_layer_use_default_layer ? LightingEngineDefaultLayer : (sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name);
    var temp_successfully_added_object = lighting_engine_add_object(id, LightingEngineObjectType.Dynamic_Item, temp_dynamic_object_layer, sub_layer_index);
    
    // Update Dynamic Item's Sub-Layer
    sub_layer_name = temp_dynamic_object_layer;
    
    // Debug Flag - Unsuccessfully added Dynamic Item to Lighting Engine Sub Layer
    if (!temp_successfully_added_object)
    {
        show_debug_message($"Debug Warning! - Unsuccessfully added Dynamic Item \"{object_get_name(object_index)}\" to Lighting Engine Sub Layer with name \"{temp_dynamic_object_layer}\"");
        instance_destroy();
        return;
    }
}

// Initialize Dynamic Object Textures & UVs
normalmap_spritepack = normal_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, normal_map);
metallicroughnessmap_spritepack = metallicroughness_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, metallicroughness_map);
emissivemap_spritepack = emissive_map == noone ? undefined : spritepack_get_uvs_transformed(sprite_index, emissive_map);

// Initialize Item Interaction
if (item_interaction)
{
	var temp_interaction_instance = instance_create_depth(x, y, 0, oItem_Interaction);
	temp_interaction_instance.interaction_object = self;
	temp_interaction_instance.interaction_object_name = global.inventory_item_pack[item_pack].item_name;
}
