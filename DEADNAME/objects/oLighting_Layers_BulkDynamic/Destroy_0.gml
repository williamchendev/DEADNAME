/// @description Bulk Dynamic Layer Destroy Event
// Destroy's Bulk Dynamic Layer's Lighting Engine Object and Sub-Layer

// Removes the Bulk Dynamic Layer Object & its Sub-Layer from the Lighting Engine
if (instance_exists(LightingEngine))
{
	// Remove Bulk Dynamic Layer Object from Lighting Engine
	lighting_engine_remove_object(id);
	
	// Check if Sub-Layer Exists in the Lighting Engine
	if (ds_list_find_index(LightingEngine.lighting_engine_sub_layer_name_list, sub_layer_name) != -1)
	{
		// Remove Sub-Layer from Lighting Engine
		lighting_engine_delete_sub_layer(sub_layer_name);
	}
}