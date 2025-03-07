// Lighting Engine Render Layer Types
enum LightingEngineRenderLayerType
{
	Back,
	Mid,
	Front
}

// Lighting Engine Sub Layer Types
enum LightingEngineSubLayerType
{
	Dynamic,
	BulkStatic
}

// Lighting Engine Object Types
enum LightingEngineObjectType
{
    Dynamic_Basic,
    Dynamic_Particle,
    Dynamic_Unit,
    BulkStatic_Region,
    BulkStatic_Layer
}

// Lighting Engine Layer Methods: Create Sub Layer Behaviours
/// @function lighting_engine_create_sub_layer(sub_layer_name, sub_layer_depth, sub_layer_type, render_layer_type);
/// @description Adds a new Sub-Layer to the active scene in the Lighting Engine's Rendering Pipeline with the given properties
/// @param {string} sub_layer_name - The name of the new Sub-Layer
/// @param {real} sub_layer_depth - The depth of the new Sub-Layer, on a range from -1.0 (Background) to 1.0 (Foreground)
/// @param {LightingEngineSubLayerType} sub_layer_type - The new Sub-Layer's Type, Sub-Layers are designed to make efficient batched drawing calls and a Sub-Layer type will be dedicated to drawing a single kind of object (either Dynamic or Bulk-Static, however particles ignore this)
/// @param {LightingEngineRenderLayerType} render_layer_type - The Render Layer Type of the new Sub-Layer, there are three options: Background, Midground, and Foreground (remember to set the Sub-Layer's depth in a relavent position to its Render Layer Type!)
/// @returns {bool} Returns if the Sub-Layer could be successfully created
function lighting_engine_create_sub_layer(sub_layer_name, sub_layer_depth, sub_layer_type, render_layer_type)
{
	// Check if Sub Layer already exists
	if (ds_list_find_index(LightingEngine.lighting_engine_sub_layer_name_list, sub_layer_name) != -1)
	{
		// Unsuccessfully added Sub Layer because a sub layer with the given name already exists - Return False
		return false;
	}
	
	// Clamp Layer Depth
    var temp_sub_layer_depth = clamp(sub_layer_depth, -1, 1);
    
	// Add Sub Layer based on Render Layer Type
	switch (render_layer_type)
	{
		case LightingEngineRenderLayerType.Back:
			// Find Index based on Layer Depth
			var temp_back_sub_layer_index = ds_list_size(LightingEngine.lighting_engine_back_layer_sub_layer_depth_list);
			
			for (var i = 0; i < ds_list_size(LightingEngine.lighting_engine_back_layer_sub_layer_depth_list); i++)
			{
				var temp_check_sub_layer_depth = ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_depth_list, i);
				
				if (temp_sub_layer_depth < temp_check_sub_layer_depth)
		        {
		        	temp_back_sub_layer_index = i;
		            break;
		        }
			}
			
			// Add Sub Layer's Name, Depth, and Type
        	ds_list_insert(LightingEngine.lighting_engine_back_layer_sub_layer_name_list, temp_back_sub_layer_index, sub_layer_name);
			ds_list_insert(LightingEngine.lighting_engine_back_layer_sub_layer_depth_list, temp_back_sub_layer_index, temp_sub_layer_depth);
			ds_list_insert(LightingEngine.lighting_engine_back_layer_sub_layer_type_list, temp_back_sub_layer_index, sub_layer_type);
			
			// Add Sub Layer Object and Object Type Lists
			ds_list_insert(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_back_sub_layer_index, ds_list_create());
			ds_list_mark_as_list(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_back_sub_layer_index);
			
			ds_list_insert(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list, temp_back_sub_layer_index, ds_list_create());
			ds_list_mark_as_list(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list, temp_back_sub_layer_index);
			break;
		case LightingEngineRenderLayerType.Front:
			// Find Index based on Layer Depth
			var temp_front_sub_layer_index = ds_list_size(LightingEngine.lighting_engine_front_layer_sub_layer_depth_list);
			
			for (var i = 0; i < ds_list_size(LightingEngine.lighting_engine_front_layer_sub_layer_depth_list); i++)
			{
				var temp_check_sub_layer_depth = ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_depth_list, i);
				
				if (temp_sub_layer_depth < temp_check_sub_layer_depth)
		        {
		        	temp_front_sub_layer_index = i;
		            break;
		        }
			}
			
			// Add Sub Layer's Name, Depth, and Type
        	ds_list_insert(LightingEngine.lighting_engine_front_layer_sub_layer_name_list, temp_front_sub_layer_index, sub_layer_name);
			ds_list_insert(LightingEngine.lighting_engine_front_layer_sub_layer_depth_list, temp_front_sub_layer_index, temp_sub_layer_depth);
			ds_list_insert(LightingEngine.lighting_engine_front_layer_sub_layer_type_list, temp_front_sub_layer_index, sub_layer_type);
			
			// Add Sub Layer Object and Object Type Lists
			ds_list_insert(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_front_sub_layer_index, ds_list_create());
			ds_list_mark_as_list(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_front_sub_layer_index);
			
			ds_list_insert(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list, temp_front_sub_layer_index, ds_list_create());
			ds_list_mark_as_list(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list, temp_front_sub_layer_index);
			break;
		case LightingEngineRenderLayerType.Mid:
		default:
			// Find Index based on Layer Depth
			var temp_mid_sub_layer_index = ds_list_size(LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list);
			
			for (var i = 0; i < ds_list_size(LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list); i++)
			{
				var temp_check_sub_layer_depth = ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list, i);
				
				if (temp_sub_layer_depth < temp_check_sub_layer_depth)
		        {
		        	temp_mid_sub_layer_index = i;
		            break;
		        }
			}
			
			// Add Sub Layer's Name, Depth, and Type
        	ds_list_insert(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list, temp_mid_sub_layer_index, sub_layer_name);
			ds_list_insert(LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list, temp_mid_sub_layer_index, temp_sub_layer_depth);
			ds_list_insert(LightingEngine.lighting_engine_mid_layer_sub_layer_type_list, temp_mid_sub_layer_index, sub_layer_type);
			
			// Add Sub Layer Object and Object Type Lists
			ds_list_insert(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_mid_sub_layer_index, ds_list_create());
			ds_list_mark_as_list(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_mid_sub_layer_index);
			
			ds_list_insert(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_mid_sub_layer_index, ds_list_create());
			ds_list_mark_as_list(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_mid_sub_layer_index);
			
			// Recalculate Default Layer
			LightingEngine.lighting_engine_default_layer_index = ds_list_find_index(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list, LightingEngineDefaultLayer);
			break;
	}
	
	// Add Sub Layer Name and Render Layer Type to Lists
	ds_list_add(LightingEngine.lighting_engine_sub_layer_name_list, sub_layer_name);
	ds_list_add(LightingEngine.lighting_engine_sub_layer_render_layer_type_list, render_layer_type);
	
	// Successfully added Sub Layer - Return True
	return true;
}

// Lighting Engine Layer Methods: Remove Objects from Sub Layer Behaviours
function lighting_engine_remove_object_from_sub_layer(sub_layer_object_list, sub_layer_object_type_list, sub_layer_object_index)
{
	// Find Object and Object Type from given Sub Layer Object and Object Type DS Lists at the Sub Layer Object Index
	var temp_sub_layer_object = ds_list_find_value(sub_layer_object_list, sub_layer_object_index);
	var temp_sub_layer_object_type = ds_list_find_value(sub_layer_object_type_list, sub_layer_object_index);
	
	// Properly Delete the given Object based on the Object's Type
	switch (temp_sub_layer_object_type)
	{
		case LightingEngineObjectType.BulkStatic_Layer:
			// Bulk Static Layer Type Condition: Destroy Vertex Buffer from Struct
			vertex_delete_buffer(temp_sub_layer_object.bulk_static_vertex_buffer);
			temp_sub_layer_object = -1;
			break;
		default:
			// Default Object Type Condition: Destroy Game Object
			instance_destroy(temp_sub_layer_object);
			break;
	}
	
	// Remove Object and Object Type at Index within Sub Layer DS Lists
	ds_list_delete(sub_layer_object_list, sub_layer_object_index);
	ds_list_delete(sub_layer_object_type_list, sub_layer_object_index);
}

function lighting_engine_remove_all_objects_from_sub_layer_lists(sub_layer_object_list, sub_layer_object_type_list)
{
	// Iterate through entire Sub Layer Object and Object Type DS Lists and delete every index
	for (var i = ds_list_size(sub_layer_object_list) - 1; i >= 0; i--)
	{
		lighting_engine_remove_object_from_sub_layer(sub_layer_object_list, sub_layer_object_type_list, i);
	}
}

// Lighting Engine Layer Methods: Delete Sub Layer Behaviours
/// @function lighting_engine_delete_sub_layer(sub_layer_name);
/// @description Deletes the given Sub-Layer (by the Sub-Layer's name) being used by the Lighting Engine
/// @param {string} sub_layer_name - The name of the Sub-Layer to be deleted
/// @returns {bool} Returns if the Sub-Layer could be successfully deleted
function lighting_engine_delete_sub_layer(sub_layer_name)
{
	// Check if Sub Layer exists
	var temp_sub_layer_name_index = ds_list_find_index(LightingEngine.lighting_engine_sub_layer_name_list, sub_layer_name);
	
	if (temp_sub_layer_name_index == -1)
	{
		// Unsuccessfully removed Sub Layer because a sub layer with the given name does not exists - Return False
		return false;
	}
	
	// Find Sub Layer Render Layer Type
	var temp_sub_layer_render_layer_type = ds_list_find_value(LightingEngine.lighting_engine_sub_layer_render_layer_type_list, temp_sub_layer_name_index);
	
	// Remove Sub Layer from the Render Layer Organizational DS Lists
	switch (temp_sub_layer_render_layer_type)
	{
		case LightingEngineRenderLayerType.Back:
			// Remove Sub Layer from Back Render Layer Organizational DS Lists
			var temp_back_render_layer_sub_layer_index = ds_list_find_index(LightingEngine.lighting_engine_back_layer_sub_layer_name_list, sub_layer_name);
			
			// Find Sub Layer Object and Object Type DS Lists to Delete
			var temp_back_render_layer_sub_layer_object_list_to_delete = ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_back_render_layer_sub_layer_index);
			var temp_back_render_layer_sub_layer_object_type_list_to_delete = ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list, temp_back_render_layer_sub_layer_index);
			
			// Delete all Objects on Sub Layer
			lighting_engine_remove_all_objects_from_sub_layer_lists(temp_back_render_layer_sub_layer_object_list_to_delete, temp_back_render_layer_sub_layer_object_type_list_to_delete);
			
			// Delete Sub Layer Object and Object Type DS Lists
			ds_list_destroy(temp_back_render_layer_sub_layer_object_list_to_delete);
			ds_list_delete(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_back_render_layer_sub_layer_index);
			
			ds_list_destroy(temp_back_render_layer_sub_layer_object_type_list_to_delete);
			ds_list_delete(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list, temp_back_render_layer_sub_layer_index);
			
			// Delete Indexed Sub Layer Properties (Name, Depth, and Type)
			ds_list_delete(LightingEngine.lighting_engine_back_layer_sub_layer_name_list, temp_back_render_layer_sub_layer_index);
			ds_list_delete(LightingEngine.lighting_engine_back_layer_sub_layer_depth_list, temp_back_render_layer_sub_layer_index);
			ds_list_delete(LightingEngine.lighting_engine_back_layer_sub_layer_type_list, temp_back_render_layer_sub_layer_index);
			break;
		case LightingEngineRenderLayerType.Front:
			// Remove Sub Layer from Front Render Layer Organizational DS Lists
			var temp_front_render_layer_sub_layer_index = ds_list_find_index(LightingEngine.lighting_engine_front_layer_sub_layer_name_list, sub_layer_name);
		
			// Find Sub Layer Object and Object Type DS Lists to Delete
			var temp_front_render_layer_sub_layer_object_list_to_delete = ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_front_render_layer_sub_layer_index);
			var temp_front_render_layer_sub_layer_object_type_list_to_delete = ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list, temp_front_render_layer_sub_layer_index);
			
			// Delete all Objects on Sub Layer
			lighting_engine_remove_all_objects_from_sub_layer_lists(temp_front_render_layer_sub_layer_object_list_to_delete, temp_front_render_layer_sub_layer_object_type_list_to_delete);
			
			// Delete Sub Layer Object and Object Type DS Lists
			ds_list_destroy(temp_front_render_layer_sub_layer_object_list_to_delete);
			ds_list_delete(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_front_render_layer_sub_layer_index);
			
			ds_list_destroy(temp_front_render_layer_sub_layer_object_type_list_to_delete);
			ds_list_delete(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list, temp_front_render_layer_sub_layer_index);
			
			// Delete Indexed Sub Layer Properties (Name, Depth, and Type)
			ds_list_delete(LightingEngine.lighting_engine_front_layer_sub_layer_name_list, temp_front_render_layer_sub_layer_index);
			ds_list_delete(LightingEngine.lighting_engine_front_layer_sub_layer_depth_list, temp_front_render_layer_sub_layer_index);
			ds_list_delete(LightingEngine.lighting_engine_front_layer_sub_layer_type_list, temp_front_render_layer_sub_layer_index);
			break;
		case LightingEngineRenderLayerType.Mid:
		default:
			// Remove Sub Layer from Mid Render Layer Organizational DS Lists
			var temp_mid_render_layer_sub_layer_index = ds_list_find_index(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list, sub_layer_name);
			
			// Find Sub Layer Object and Object Type DS Lists to Delete
			var temp_mid_render_layer_sub_layer_object_list_to_delete = ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_mid_render_layer_sub_layer_index);
			var temp_mid_render_layer_sub_layer_object_type_list_to_delete = ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_mid_render_layer_sub_layer_index);
			
			// Delete all Objects on Sub Layer
			lighting_engine_remove_all_objects_from_sub_layer_lists(temp_mid_render_layer_sub_layer_object_list_to_delete, temp_mid_render_layer_sub_layer_object_type_list_to_delete);
			
			// Delete Sub Layer Object and Object Type DS Lists
			ds_list_destroy(temp_mid_render_layer_sub_layer_object_list_to_delete);
			ds_list_delete(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_mid_render_layer_sub_layer_index);
			
			ds_list_destroy(temp_mid_render_layer_sub_layer_object_type_list_to_delete);
			ds_list_delete(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_mid_render_layer_sub_layer_index);
			
			// Delete Indexed Sub Layer Properties (Name, Depth, and Type)
			ds_list_delete(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list, temp_mid_render_layer_sub_layer_index);
			ds_list_delete(LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list, temp_mid_render_layer_sub_layer_index);
			ds_list_delete(LightingEngine.lighting_engine_mid_layer_sub_layer_type_list, temp_mid_render_layer_sub_layer_index);
			break;
	}
	
	// Successfully removed a Sub Layer that matched the given Sub Layer Name - Return True
	return true;
}

/// @function lighting_engine_delete_all_sub_layers();
/// @description Deletes all Sub-Layers being used by the Lighting Engine, intended to be used when switching Scenes or even closing the Game
function lighting_engine_delete_all_sub_layers()
{
	// Iterate through and delete all Sub Layers
	for (var temp_back_layer_names_index = ds_list_size(LightingEngine.lighting_engine_back_layer_sub_layer_name_list) - 1; temp_back_layer_names_index >= 0; temp_back_layer_names_index--)
	{
		// Find Layer Name from Index
		var temp_back_layer_name = ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_name_list, temp_back_layer_names_index);
		
		// Remove and Delete Sub Layer
		lighting_engine_delete_sub_layer(temp_back_layer_name);
	}
	
	for (var temp_mid_layer_names_index = ds_list_size(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list) - 1; temp_mid_layer_names_index >= 0; temp_mid_layer_names_index--)
	{
		// Find Layer Name from Index
		var temp_mid_layer_name = ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list, temp_mid_layer_names_index);
		
		// Remove and Delete Sub Layer
		lighting_engine_delete_sub_layer(temp_mid_layer_name);
	}
	
	for (var temp_front_layer_names_index = ds_list_size(LightingEngine.lighting_engine_front_layer_sub_layer_name_list) - 1; temp_front_layer_names_index >= 0; temp_front_layer_names_index--)
	{
		// Find Layer Name from Index
		var temp_front_layer_name = ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_name_list, temp_front_layer_names_index);
		
		// Remove and Delete Sub Layer
		lighting_engine_delete_sub_layer(temp_front_layer_name);
	}
	
	// Clear and Reset Sub Layer Organization DS Lists
	ds_list_clear(LightingEngine.lighting_engine_sub_layer_name_list);
	ds_list_clear(LightingEngine.lighting_engine_sub_layer_render_layer_type_list);
	
	ds_list_clear(LightingEngine.lighting_engine_back_layer_sub_layer_name_list);
	ds_list_clear(LightingEngine.lighting_engine_back_layer_sub_layer_depth_list);
	ds_list_clear(LightingEngine.lighting_engine_back_layer_sub_layer_type_list);
	ds_list_clear(LightingEngine.lighting_engine_back_layer_sub_layer_object_list);
	ds_list_clear(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list);
	
	ds_list_clear(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list);
	ds_list_clear(LightingEngine.lighting_engine_mid_layer_sub_layer_depth_list);
	ds_list_clear(LightingEngine.lighting_engine_mid_layer_sub_layer_type_list);
	ds_list_clear(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list);
	ds_list_clear(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list);
	
	ds_list_clear(LightingEngine.lighting_engine_front_layer_sub_layer_name_list);
	ds_list_clear(LightingEngine.lighting_engine_front_layer_sub_layer_depth_list);
	ds_list_clear(LightingEngine.lighting_engine_front_layer_sub_layer_type_list);
	ds_list_clear(LightingEngine.lighting_engine_front_layer_sub_layer_object_list);
	ds_list_clear(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list);
}

// Lighting Engine Layer Method: Add Object to Sub Layer
/// @function lighting_engine_add_object(object_id, object_type, sub_layer_name, sub_layer_index);
/// @description Adds an Object to the Lighting Engine's Rendering System with the given properties
/// @param {any} object_id - The Object Instance to index into a Sub-Layer add to the Lighting Engine's Rendering System
/// @param {int<LightingEngineObjectType>} object_type - The Object's Type to determine how it will be rendering by the Lighting Engine during its rendering process
/// @param {string} sub_layer_name - The name of the Sub-Layer to add the Object Instance to as to determine the Object's order during the rendering process
/// @param {real} sub_layer_index - The index within the Sub-Layer's Object List to determine the Object's order being rendered within its own Sub-Layer, by default this is -1 which will add the Object to the front of the Sub-Layer's drawing order
/// @returns {bool} Returns if the Object could be successfully added to the given Sub-Layer within the Lighting Engine
function lighting_engine_add_object(object_id, object_type, sub_layer_name = LightingEngineDefaultLayer, sub_layer_index = -1)
{
	// Establish Default Sub Layer Index and Sub Layer Render Layer Type
	var temp_sub_layer_index = LightingEngine.lighting_engine_default_layer_index;
	var temp_sub_layer_render_layer = LightingEngineRenderLayerType.Mid;
	
	// Add to Lighting Engine's Default Layer unless given a specific Sub Layer Name to add Object to
	if (sub_layer_name != LightingEngineDefaultLayer)
	{
		// Check if Sub Layer exists
		var temp_sub_layer_name_index = ds_list_find_index(LightingEngine.lighting_engine_sub_layer_name_list, sub_layer_name);
		
		if (temp_sub_layer_name_index == -1)
		{
			// Unsuccessfully removed Sub Layer because a sub layer with the given name does not exists - Return False
			return false;
		}
		
		// Find Sub Layer Render Layer Type
		temp_sub_layer_render_layer = ds_list_find_value(LightingEngine.lighting_engine_sub_layer_render_layer_type_list, temp_sub_layer_name_index);
		
		// Add Object to Sub Layer
		switch (temp_sub_layer_render_layer)
		{
			case LightingEngineRenderLayerType.Back:
				temp_sub_layer_index = ds_list_find_index(LightingEngine.lighting_engine_back_layer_sub_layer_name_list, sub_layer_name);
				
				if (sub_layer_index == -1)
				{
					ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_sub_layer_index), object_id);
					ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type);
				}
				else
				{
					ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_sub_layer_index), object_id, sub_layer_index);
					ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type, sub_layer_index);
				}
				break;
			case LightingEngineRenderLayerType.Front:
				temp_sub_layer_index = ds_list_find_index(LightingEngine.lighting_engine_front_layer_sub_layer_name_list, sub_layer_name);
				
				if (sub_layer_index == -1)
				{
					ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_sub_layer_index), object_id);
					ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type);
				}
				else
				{
					ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_sub_layer_index), object_id, sub_layer_index);
					ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type, sub_layer_index);
				}
				break;
			case LightingEngineRenderLayerType.Mid:
			default:
				temp_sub_layer_index = ds_list_find_index(LightingEngine.lighting_engine_mid_layer_sub_layer_name_list, sub_layer_name);
				
				if (sub_layer_index == -1)
				{
					ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_sub_layer_index), object_id);
					ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type);
				}
				else
				{
					ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_sub_layer_index), object_id, sub_layer_index);
					ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type, sub_layer_index);
				}
				break;
		}
	}
	else
	{
		// Add Object to Sub Layer
		if (sub_layer_index == -1)
		{
			ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_sub_layer_index), object_id);
			ds_list_add(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type);
		}
		else
		{
			ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_sub_layer_index), object_id, sub_layer_index);
			ds_list_insert(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_type_list, temp_sub_layer_index), object_type, sub_layer_index);
		}
	}
	
	// Object was successfully added to Sub Layer - Return True
	return true;
}

// Lighting Engine Layer Method: Find Object Index
/// @function lighting_engine_find_object_index(object_id);
/// @description Finds the given Object Instance's index within its Sub-Layer's Object List if it exists, otherwise this function returns -1 by default
/// @param {any} object_id - The Object Instance to find the index of
/// @returns {int} Returns the Object's Index within the Sub-Layer's Object List if it exists, if the Object's Index is not stored in the Lighting Engine's Sub-Layer Object Lists then this function returns -1 by default
function lighting_engine_find_object_index(object_id)
{
	// Search Midground Sub-Layers for Object Index
	for (var temp_mid_sub_layer_index = 0; temp_mid_sub_layer_index < ds_list_size(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list); temp_mid_sub_layer_index++)
	{
		// Attempt to find Object Index and Early Return Object Index if Exists
		var temp_object_index = ds_list_find_index(ds_list_find_value(LightingEngine.lighting_engine_mid_layer_sub_layer_object_list, temp_mid_sub_layer_index), object_id);
		
		if (temp_object_index != -1)
		{
			return temp_object_index;
		}
	}
	
	// Search Background Sub-Layers for Object Index
	for (var temp_back_sub_layer_index = 0; temp_back_sub_layer_index < ds_list_size(LightingEngine.lighting_engine_back_layer_sub_layer_object_list); temp_back_sub_layer_index++)
	{
		// Attempt to find Object Index and Early Return Object Index if Exists
		var temp_object_index = ds_list_find_index(ds_list_find_value(LightingEngine.lighting_engine_back_layer_sub_layer_object_list, temp_back_sub_layer_index), object_id);
		
		if (temp_object_index != -1)
		{
			return temp_object_index;
		}
	}
	
	// Search Foreground Sub-Layers for Object Index
	for (var temp_front_sub_layer_index = 0; temp_front_sub_layer_index < ds_list_size(LightingEngine.lighting_engine_front_layer_sub_layer_object_list); temp_front_sub_layer_index++)
	{
		// Attempt to find Object Index and Early Return Object Index if Exists
		var temp_object_index = ds_list_find_index(ds_list_find_value(LightingEngine.lighting_engine_front_layer_sub_layer_object_list, temp_front_sub_layer_index), object_id);
		
		if (temp_object_index != -1)
		{
			return temp_object_index;
		}
	}
	
	// Unsuccessfully Found Object Index - Return -1 as Default Result
	return -1;
}

// Lighting Engine Layer Method: Add Unit to Default Layer
/// @function lighting_engine_add_unit(unit_id, sub_layer_name);
/// @description Adds a Unit Instance to the Lighting Engine with the given Sub-Layer (by default the Unit will be added to the Lighting Engine's Default Sub-Layer in the Midground)
/// @param {oUnit} unit_id - The object instance of the Unit to add to the Lighting Engine's Sub-Layer
/// @param {string} sub_layer_name - The name of the Sub-Layer to add the Unit to (by default the Unit will be added to the Default Layer, unless you are attempting to do something specific you will most likely be adding new Units to the Lighting Engine's default layer)
function lighting_engine_add_unit(unit_id, sub_layer_name = LightingEngineDefaultLayer)
{
	lighting_engine_add_object(unit_id, LightingEngineObjectType.Dynamic_Unit, sub_layer_name);
}
