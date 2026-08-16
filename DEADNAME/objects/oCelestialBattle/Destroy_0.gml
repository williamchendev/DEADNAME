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

// Increment through Battle's Combat Grid Arrays and clear all Column Arrays
var temp_battle_combat_grid_column_index = CelestialBattleCombatGridColumns - 1;

repeat (CelestialBattleCombatGridColumns)
{
	// Increment through Battle's Combat Grid Arrays and clear all Row Structs
	var temp_battle_combat_grid_row_index = CelestialBattleCombatGridRows - 1;
	
	repeat (CelestialBattleCombatGridRows)
	{
		// Establish Structs
		var temp_battle_combat_grid_struct_a = array_get(battle_combat_grid_a_structs[temp_battle_combat_grid_column_index], temp_battle_combat_grid_row_index);
		var temp_battle_combat_grid_struct_b = array_get(battle_combat_grid_b_structs[temp_battle_combat_grid_column_index], temp_battle_combat_grid_row_index);
		
		// Delete Structs
		delete temp_battle_combat_grid_struct_a;
		delete temp_battle_combat_grid_struct_b;
		
		// Decrement Combat Grid Row Index
		temp_battle_combat_grid_row_index--;
	}
	
	// Clear Battle Combat Grid's Column Arrays
	array_resize(battle_combat_grid_a[temp_battle_combat_grid_column_index], 0);
	array_resize(battle_combat_grid_b[temp_battle_combat_grid_column_index], 0);
	
	array_resize(battle_combat_grid_instances_a[temp_battle_combat_grid_column_index], 0);
	array_resize(battle_combat_grid_instances_b[temp_battle_combat_grid_column_index], 0);
	
	array_resize(battle_combat_grid_a_structs[temp_battle_combat_grid_column_index], 0);
	array_resize(battle_combat_grid_b_structs[temp_battle_combat_grid_column_index], 0);
	
	// Delete Battle Combat Grid's Column Arrays from Battle Combat Grid Arrays
	array_delete(battle_combat_grid_a, temp_battle_combat_grid_column_index, 1);
	array_delete(battle_combat_grid_b, temp_battle_combat_grid_column_index, 1);
	
	array_delete(battle_combat_grid_instances_a, temp_battle_combat_grid_column_index, 1);
	array_delete(battle_combat_grid_instances_b, temp_battle_combat_grid_column_index, 1);
	
	array_delete(battle_combat_grid_a_structs, temp_battle_combat_grid_column_index, 1);
	array_delete(battle_combat_grid_b_structs, temp_battle_combat_grid_column_index, 1);
	
	// Decrement Combat Grid Column Index
	temp_battle_combat_grid_column_index--;
}
