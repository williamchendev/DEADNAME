/// @description Asset Organization & Creation
// Iterates through the organized Lighting Engine Objects and performs their behaviours in order, then destroys the worker

// Iterate Initialization Behaviour for Bulk Static Layers
for (var temp_bulk_static_layer_index = 0; temp_bulk_static_layer_index < ds_list_size(bulk_static_layers_list); temp_bulk_static_layer_index++)
{
    // Find Bulk Static Region at Index
    var temp_bulk_static_sublayer_name = ds_list_find_value(bulk_static_layers_list, temp_bulk_static_layer_index);
    
    // Create Temporary List of Bulk Static Objects that exist on Sub-Layer
    var temp_bulk_static_sublayer_objects_list = ds_list_create();
    
    // Select for Bulk Static Objects that share the same Sub-Layer Name as the Indexed Sub-Layer Name
    with (oLightingEngine_BulkStatic_Object)
    {
        var temp_sub_layer_name = sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(layer) : sub_layer_name;
        
        if (temp_sub_layer_name == temp_bulk_static_sublayer_name)
        {
            ds_list_add(temp_bulk_static_sublayer_objects_list, id);
        }
    }
    
    // Skip Vertex Buffer Creation if Sub-Layer contains no Bulk Static Objects
    if (ds_list_size(temp_bulk_static_sublayer_objects_list) < 1)
    {
        ds_list_destroy(temp_bulk_static_sublayer_objects_list);
        temp_bulk_static_sublayer_objects_list = -1;
        continue;
    }
    
    // Sort Bulk Static Objects
    ds_list_sort(temp_bulk_static_sublayer_objects_list, true);
	
	// Begin Initialize Vertex Buffer & Texture Struct Pair
	var temp_bulk_static_object_from_layer_list = ds_list_find_value(temp_bulk_static_sublayer_objects_list, 0);
	
	var temp_bulk_static_layer_vertex_buffer_and_texture_struct = 
	{
	    bulk_static_vertex_buffer: create_bulk_sprite_vertex_buffer(temp_bulk_static_sublayer_objects_list),
	    bulk_static_texture: sprite_get_texture(temp_bulk_static_object_from_layer_list.sprite_index, temp_bulk_static_object_from_layer_list.image_index)
	}
	
	// Add Bulk Static Layer Vertex Buffer and Texture Struct to Lighting Engine Layers
	var temp_successfully_added_bulk_static_layer = lighting_engine_add_object(temp_bulk_static_layer_vertex_buffer_and_texture_struct, LightingEngineObjectType.BulkStatic_Layer, temp_bulk_static_sublayer_name);
	
	// Debug Flag - Unsuccessfully added Bulk Static Group to Lighting Engine Sub Layer
	if (!temp_successfully_added_bulk_static_layer)
	{
		show_debug_message($"Debug Warning! - Unsuccessfully added Bulk Static Layer to Lighting Engine Sub Layer with name \"{temp_bulk_static_sublayer_name}\"");
	}
    
    // Destroy Sub-Layer Objects List
    ds_list_destroy(temp_bulk_static_sublayer_objects_list);
    temp_bulk_static_sublayer_objects_list = -1;
}

// Iterate Initialization Behaviour for Bulk Static Regions
for (var temp_bulk_static_region_index = 0; temp_bulk_static_region_index < ds_list_size(bulk_static_regions_list); temp_bulk_static_region_index++)
{
    // Find Bulk Static Region at Index
    var temp_bulk_static_region_instance = ds_list_find_value(bulk_static_regions_list, temp_bulk_static_region_index);
    
    // Bulk Static Region - Layered Region Vertex Buffer Creation
    with (temp_bulk_static_region_instance)
    {
        // Index all Bulk Static Objects in Vertex Buffer
        var temp_bulk_static_objects_list = ds_list_create();
        var temp_bulk_static_objects_count = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oLightingEngine_BulkStatic_Object, false, true, temp_bulk_static_objects_list, false);
        
        if (temp_bulk_static_objects_count > 0)
        {
        	// Create DS Map List of Layers
        	var temp_bulk_static_layers_map = ds_map_create();
        	
        	// Organize Bulk Static Objects into Layers
        	for (var i = 0; i < ds_list_size(temp_bulk_static_objects_list); i++)
        	{
        		// Find Bulk Static Object at Index
        		var temp_bulk_static_object = ds_list_find_value(temp_bulk_static_objects_list, i);
        		var temp_bulk_static_object_layer = temp_bulk_static_object.sub_layer_name == LightingEngineUseGameMakerLayerName ? layer_get_name(temp_bulk_static_object.layer) : temp_bulk_static_object.sub_layer_name;
        		
        		// Find Layer List & Create Layer List if Layer List does not exist
        		var temp_bulk_static_layer_list = ds_map_find_value(temp_bulk_static_layers_map, temp_bulk_static_object_layer);
        		
        		if (is_undefined(temp_bulk_static_layer_list))
        		{
        			// Add Layer List to Layers DS Map
        			temp_bulk_static_layer_list = ds_list_create();
        			ds_map_add_list(temp_bulk_static_layers_map, temp_bulk_static_object_layer, temp_bulk_static_layer_list);
        		}
        		
        		// Add Bulk Static Object to Bulk Static Group's Layer DS List
        		ds_list_add(temp_bulk_static_layer_list, temp_bulk_static_object);
        	}
        	
        	// Iterate through DS Map Layer Lists containing all Bulk Static Objects
        	for (var temp_bulk_static_layers_map_key = ds_map_find_first(temp_bulk_static_layers_map); !is_undefined(temp_bulk_static_layers_map_key); temp_bulk_static_layers_map_key = ds_map_find_next(temp_bulk_static_layers_map, temp_bulk_static_layers_map_key)) 
        	{
        		// Find Layers List from DS Map
        		var temp_bulk_static_layers_list_value = ds_map_find_value(temp_bulk_static_layers_map, temp_bulk_static_layers_map_key);
        		
        		// Sort Layers List
        		ds_list_sort(temp_bulk_static_layers_list_value, true);
        		
        		// Create Vertex Buffer 
        		if (!is_undefined(temp_bulk_static_layers_list_value))
        		{
        			// Set Bulk Static Group Texture
        			var temp_bulk_static_region_layer_texture = -1;
        			var temp_bulk_static_object = ds_list_find_value(temp_bulk_static_layers_list_value, 0);
        			temp_bulk_static_region_layer_texture = sprite_get_texture(temp_bulk_static_object.sprite_index, temp_bulk_static_object.image_index);
        			
        			// Begin Initialize Vertex Buffer
        			var temp_bulk_static_region_layer_vertex_buffer = create_bulk_sprite_vertex_buffer(temp_bulk_static_layers_list_value);
        			
        			// Index Layer's Texture and Vertex Buffer in Bulk Static Region Vertex Buffers DS Map
        			ds_map_add(bulk_static_region_texture_map, temp_bulk_static_layers_map_key, temp_bulk_static_region_layer_texture);
        			ds_map_add(bulk_static_region_vertex_buffer_map, temp_bulk_static_layers_map_key, temp_bulk_static_region_layer_vertex_buffer);
        			
        			// Add Bulk Static Region to Lighting Engine Layers
        			var temp_successfully_added_bulk_static_region_layer = lighting_engine_add_object(id, LightingEngineObjectType.BulkStatic_Region, temp_bulk_static_layers_map_key);
        			
        			// Debug Flag - Unsuccessfully added Bulk Static Group to Lighting Engine Sub Layer
        			if (!temp_successfully_added_bulk_static_region_layer)
        			{
        				show_debug_message($"Debug Warning! - Unsuccessfully added Bulk Static Region to Lighting Engine Sub Layer with name \"{temp_bulk_static_layers_map_key}\"");
        			}
        		}
        	}
        	
        	// Delete DS Map Layers List
        	ds_map_destroy(temp_bulk_static_layers_map);
        	temp_bulk_static_layers_map = -1;
        }
    }
}

// Destroy Instance
instance_destroy();