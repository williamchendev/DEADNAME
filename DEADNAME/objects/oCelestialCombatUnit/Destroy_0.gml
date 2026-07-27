/// @description Celestial Combat Unit Destroy Event
// Celestial Combat Unit Destroy Behaviour Event

// Delete Combat Unit from Unit Instance
if (instance_exists(unit_instance))
{
	// Find Combat Unit's Index within Unit Instance's Combat Unit Array
	var temp_combat_unit_index = array_get_index(unit_instance.combat_units, id);
	
	// Delete Combat Unit from Unit Instance's Combat Unit Array
	if (temp_combat_unit_index != -1)
	{
		array_delete(unit_instance.combat_units, temp_combat_unit_index, 1);
	}
}
