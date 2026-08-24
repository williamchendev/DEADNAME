/// @description Celestial Combat Unit Destroy Event
// Performs the Celestial Combat Unit's Deletion Behaviour

// Check if Combat Unit Instance has a Celestial Battle they are participating in
if (instance_exists(battle_instance))
{
	// Remove Combat Unit Instance from their Celestial Battle
	celestial_battle_remove_combat_unit(battle_instance, id);
}

// Check if Combat Unit Instance has a Celestial Unit they belong to
if (instance_exists(unit_instance))
{
	// Remove Combat Unit Instance from their Celestial Unit
	celestial_unit_remove_combat_unit(unit_instance, id);
}


