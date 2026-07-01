// Celestial Faction Enums
enum CelestialFactionRelationshipType
{
	Neutral,
	Allied,
	Hostile
}

// Celestial Faction Methods
/// @function celestial_faction_set_relationship(first_faction_instance_id, second_faction_instance_id, faction_relationship_type);
/// @description Sets the Relationship Type between the two given Celestial Faction Instances
/// @param {real:Id.Instance<oCelestialFaction>} first_faction_instance_id The first Celestial Faction to set the Relationship to the second of
/// @param {real:Id.Instance<oCelestialFaction>} second_faction_instance_id The second Celestial Faction to set the Relationship to the second of
/// @param {int<CelestialFactionRelationshipType>} faction_relationship_type The Faction Relationship type to set as the relationship as between the two given Factions 
function celestial_faction_set_relationship(first_faction_instance_id, second_faction_instance_id, faction_relationship_type)
{
	// Check if Relationship Exists with other Faction
	if (ds_map_exists(first_faction_instance_id.relationships, second_faction_instance_id))
	{
		// Set Faction Relationship
		ds_map_set(first_faction_instance_id.relationships, second_faction_instance_id, faction_relationship_type);
	}
	else
	{
		// Add Faction Relationship
		ds_map_add(first_faction_instance_id.relationships, second_faction_instance_id, faction_relationship_type);
	}
	
	// Check if Relationship Exists with other Faction
	if (ds_map_exists(second_faction_instance_id.relationships, first_faction_instance_id))
	{
		// Set Faction Relationship
		ds_map_set(second_faction_instance_id.relationships, first_faction_instance_id, faction_relationship_type);
	}
	else
	{
		// Add Faction Relationship
		ds_map_add(second_faction_instance_id.relationships, first_faction_instance_id, faction_relationship_type);
	}
}

