/// @description Celestial Unit Destroy Event
// Performs the Celestial Unit's Deletion Behaviour

// Remove Unit Instance's Index from Celestial Body's Faction Unit Arrays
if (instance_exists(celestial_body_instance))
{
	// Check Unit Faction Index within Celestial Body Instance's Factions Array
	var temp_celestial_body_unit_faction_index = array_get_index(celestial_body_instance.factions, unit_faction);
	
	// Check if Unit Instance is Indexed within the Celestial Body's Faction Units Array
	if (temp_celestial_body_unit_faction_index != -1)
	{
		// Find the Index of the Unit Instance within the Celestial Body's Faction Units Array
		var temp_celestial_body_faction_units_array_unit_index = array_get_index(celestial_body_instance.faction_units[temp_celestial_body_unit_faction_index], id);
		
		// Check if the Unit Instance's Index is Valid
		if (temp_celestial_body_faction_units_array_unit_index != -1)
		{
			// Delete the Unit Instance's Index
			array_delete(celestial_body_instance.faction_units[temp_celestial_body_unit_faction_index], temp_celestial_body_faction_units_array_unit_index, 1);
			
			// Check if Faction Units Array is Empty
			if (array_length(celestial_body_instance.faction_units[temp_celestial_body_unit_faction_index]) <= 0)
			{
				// Delete Faction from Celestial Body's Faction Units Array
				array_delete(celestial_body_instance.factions, temp_celestial_body_unit_faction_index, 1);
				array_delete(celestial_body_instance.faction_units, temp_celestial_body_unit_faction_index, 1);
			}
		}
	}
}

// Inherited Celestial Sub Object Destroy Behaviour
event_inherited();