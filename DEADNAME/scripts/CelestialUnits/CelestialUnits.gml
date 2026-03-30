
function instance_create_celestial_unit(x_position, y_position, z_position, solar_system_id, celestial_unit_instance)
{
	
}

function instance_create_celestial_unit_on_celestial_body(u_position, v_position, celestial_id, solar_system_id, celestial_unit_instance)
{
	
}

function celestial_body_add_celestial_unit(celestial_body, celestial_unit)
{
	// Check if Celestial Unit has already been added to this Celestial Body
	if (!array_contains(celestial_body.units, celestial_unit))
	{
		// Celestial Unit has not been added to this Celestial Body - Index Celestial Unit in Celestial Body's Unit Array
		array_push(celestial_body.units, celestial_unit);
	}
}

function celestial_body_remove_celestial_unit(celestial_body, celestial_unit)
{
	// Find Celestial Unit's Index in Celestial Body's Unit Array
	var temp_celestial_unit_index = array_get_index(celestial_body.units, celestial_unit);
	
	// Check if Celestial Unit was indexed in Celestial Body's Unit Array
	if (temp_celestial_unit_index != -1)
	{
		// Delete Celestial Unit from Celestial Body's Unit Array
		array_delete(celestial_body.units, temp_celestial_unit_index, 1);
	}
}