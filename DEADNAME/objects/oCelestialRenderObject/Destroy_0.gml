/// @description Destroy Event
// Removes the Celestial Render Object from the Celestial Simulator Behaviour and Rendering

// Check if Render Object belongs to a Celestial Body Instance and must delete itself from Celestial Body Instance's Render Object Behaviour Systems
if (instance_exists(celestial_body_instance))
{
	// Remove Render Object from Celestial Body Instance's Celestial Render Object Instance Arrays
	switch (celestial_render_object_type)
	{
		case CelestialRenderObjectType.Unit:
			// Find Index of Unit Instance within Celestial Body Instance's Render Object Unit Array
			var temp_celestial_body_inst_unit_index = array_get_index(celestial_body_instance.units, id);
			
			// Check if Unit Instance was Indexed in Celestial Body Instance's Render Object Unit Array
			if (temp_celestial_body_inst_unit_index != -1)
			{
				// Remove Unit Instance from Celestial Body Instance's Render Object Unit Array
				array_delete(celestial_body_instance.units, temp_celestial_body_inst_unit_index, 1);
			}
			
			// Check if Celestial Body's Pathfinding Grid exists and Render Object's Pathfinding Node Index is valid
			if (celestial_body_instance.pathfinding_enabled and pathfinding_node_index >= 0 and pathfinding_node_index < celestial_body_instance.pathfinding_nodes_count)
			{
				// Find Index of Unit Instance within Celestial Body's Pathfinding Node Unit Arrays
				var temp_celestial_body_pathfinding_node_unit_array_index = array_get_index(celestial_body_instance.pathfinding_node_units_array[pathfinding_node_index], id);
				
				// Check if Unit Instance's Index within Celestial Body's Pathfinding Node Unit Array is valid
				if (temp_celestial_body_pathfinding_node_unit_array_index != -1)
				{
					// Delete Unit Instance from Celestial Body's Pathfinding Node Unit Array
					array_delete(celestial_body_instance.pathfinding_node_units_array[pathfinding_node_index], temp_celestial_body_pathfinding_node_unit_array_index, 1);
				}
			}
			break;
		case CelestialRenderObjectType.City:
			// Find Index of City Instance within Celestial Body Instance's Render Object City Array
			var temp_celestial_body_inst_city_index = array_get_index(celestial_body_instance.cities, id);
			
			// Check if City Instance was Indexed in Celestial Body Instance's Render Object City Array
			if (temp_celestial_body_inst_city_index != -1)
			{
				// Remove City Instance from Celestial Body Instance's Render Object City Array
				array_delete(celestial_body_instance.cities, temp_celestial_body_inst_city_index, 1);
			}
			
			// Check if Celestial Body's Pathfinding Grid exists and Render Object's Pathfinding Node Index is valid
			if (celestial_body_instance.pathfinding_enabled and pathfinding_node_index >= 0 and pathfinding_node_index < celestial_body_instance.pathfinding_nodes_count)
			{
				// Remove City Instance from the Pathfinding Node Index's City Array
				if (celestial_body_instance.pathfinding_node_city_array[pathfinding_node_index] == id)
				{
					celestial_body_instance.pathfinding_node_city_array[pathfinding_node_index] = noone;
				}
			}
			break;
		case CelestialRenderObjectType.Satellite:
			// Find Index of Satellite Instance within Celestial Body Instance's Render Object Satellite Array
			var temp_celestial_body_inst_satellite_index = array_get_index(celestial_body_instance.satellites, id);
			
			// Check if Satellite Instance was Indexed in Celestial Body Instance's Render Object Satellite Array
			if (temp_celestial_body_inst_satellite_index != -1)
			{
				// Remove Satellite Instance from Celestial Body Instance's Render Object Satellite Array
				array_delete(celestial_body_instance.satellites, temp_celestial_body_inst_satellite_index, 1);
			}
			break;
		default:
			break;
	}
	
	// Check if Celestial Body Instance has Render Objects Enabled
	if (celestial_body_instance.render_objects_enabled)
	{
		// Find Index of Render Object Instance within Celestial Body Instance's Depth Sorted Render Object Arrays
		var temp_celestial_body_inst_render_object_back_layer_index = array_get_index(celestial_body_instance.render_objects_back_layer_instance_array, id);
		var temp_celestial_body_inst_render_object_front_layer_index = array_get_index(celestial_body_instance.render_objects_front_layer_instance_array, id);
		
		// Check if Render Object Instance was Indexed in Celestial Body Instance's Depth Sorted Render Object Arrays
		if (temp_celestial_body_inst_render_object_back_layer_index != -1)
		{
			// Remove Render Object Instance from Celestial Body Instance's Depth Sorted Render Object Arrays
			array_delete(celestial_body_instance.render_objects_back_layer_depth_array, temp_celestial_body_inst_render_object_back_layer_index, 1);
			array_delete(celestial_body_instance.render_objects_back_layer_instance_array, temp_celestial_body_inst_render_object_back_layer_index, 1);
			array_delete(celestial_body_instance.render_objects_back_layer_index_array, array_get_index(celestial_body_instance.render_objects_back_layer_index_array, temp_celestial_body_inst_render_object_back_layer_index), 1);
		}
		
		if (temp_celestial_body_inst_render_object_front_layer_index != -1)
		{
			// Remove Render Object Instance from Celestial Body Instance's Depth Sorted Render Object Arrays
			array_delete(celestial_body_instance.render_objects_front_layer_depth_array, temp_celestial_body_inst_render_object_front_layer_index, 1);
			array_delete(celestial_body_instance.render_objects_front_layer_instance_array, temp_celestial_body_inst_render_object_front_layer_index, 1);
			array_delete(celestial_body_instance.render_objects_front_layer_index_array, array_get_index(celestial_body_instance.render_objects_front_layer_index_array, temp_celestial_body_inst_render_object_front_layer_index), 1);
		}
	}
}
