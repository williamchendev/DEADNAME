/// @function find_unit_name(unit_name));
/// @description Finds a Unit Instance with the given Name
/// @param {string} unit_name - The Unit Instance with the given Name potentially in the Scene
/// @returns {?oUnit} Returns the instance of the Unit Object with the given name or the empty value noone if no Unit Instance in the Scene has a name that matches
function find_unit_name(unit_name)
{
	// Return Player Unit Instance if Unit Name is "Player"
	if (unit_name == "Player")
	{
		return GameManager.player_unit;
	}
	
	// Find Unit Object Instance by Unit's Name
	var temp_unit_count = instance_number(oUnit);
	var temp_unit_index = 0;
	
	repeat (temp_unit_count)
	{
		// Iterate through all Unit Instances
		var temp_unit_instance = instance_find(oUnit, temp_unit_index);
		
		// Compare Unit's Name
		if (temp_unit_instance.name == unit_name)
		{
			return temp_unit_instance;
		}
		
		// Increment Unit Instance Index
		temp_unit_index++;
	}
	
	// Return Empty Unit Object Instance
	return noone;
}
