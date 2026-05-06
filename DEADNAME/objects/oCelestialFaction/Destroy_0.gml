/// @description Faction Destroy Event
// Celestial Faction Destroy Behaviour Event

// Check if Faction was indexed within the Celestial Simulator's Faction Array
var temp_celestial_sim_faction_index = array_get_index(CelestialSimulator.factions, id);

if (temp_celestial_sim_faction_index != -1)
{
	// Delete Celestial Faction from Celestial Simulator
	array_delete(CelestialSimulator.factions, temp_celestial_sim_faction_index, 1);
	
	// Iterate through Celestial Simulator's Factions to Destroy all 
	var temp_faction_index = 0;
	
	repeat (array_length(CelestialSimulator.factions))
	{
		// Check if Relationship Exists with other Faction
		if (ds_map_exists(CelestialSimulator.factions[temp_faction_index].relationships, id))
		{
			// Delete Faction from other Faction's Relationship DS Map
			ds_map_delete(CelestialSimulator.factions[temp_faction_index].relationships, id);
		}
		
		// Increment Faction Index
		temp_faction_index++;
	}
}
