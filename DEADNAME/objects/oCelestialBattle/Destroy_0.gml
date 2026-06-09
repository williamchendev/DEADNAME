/// @description Battle Destroy Event
// Celestial Battle Destroy Behaviour Event

// Check if Celestial Body Instance exists
if (instance_exists(celestial_body_instance))
{
	// Remove Celestial Battle Instance from Celestial Body's Battles Array
	var temp_battle_index = array_get_index(celestial_body_instance.battles, id);
	
	if (temp_battle_index != -1)
	{
		array_delete(celestial_body_instance.battles, temp_battle_index, 1);
	}
}
