//
enum CelestialFactionRelationshipType
{
	Neutral,
	Allied,
	Hostile
}

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

