/// @description Celestial Sub-Unit Destroy Event
// Celestial Sub-Unit Destroy Behaviour Event

// Delete Sub-Unit from Unit Instance
if (instance_exists(unit_instance))
{
	// Find Sub-Unit's Index within Unit Instance's Sub-Unit Array
	var temp_subunit_index = array_get_index(unit_instance.sub_units, id);
	
	// Delete Sub-Unit from Unit Instance's Sub-Unit Array
	if (temp_subunit_index != -1)
	{
		array_delete(unit_instance.sub_units, temp_subunit_index, 1);
	}
}
