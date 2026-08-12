
// Check if Combat Action's Celestial Battle Exists
if (instance_exists(battle_instance))
{
	// Find the Combat Action's Index within the Celestial Battle's Combat Actions Array
	var temp_combat_action_index = array_get_index(battle_instance.battle_combat_actions, id);
	
	// Check if Combat Action exists in the Celestial Battle's Combat Actions Array
	if (temp_combat_action_index != -1)
	{
		// Delete Combat Action from the Celestial Battle's Combat Actions Array
		array_delete(battle_instance.battle_combat_actions, temp_combat_action_index, 1);
	}
}