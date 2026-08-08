// Celestial Faction Enums
enum CelestialFactionRelationshipType
{
	Neutral,
	Allied,
	Hostile
}

// Celestial Faction Methods
/// @function celestial_faction_create(celestial_faction);
/// @description Initializes the given Celestial Faction Instance by indexing it within the Celestial Simulator
/// @param {real:Id.Instance<oCelestialFaction>} celestial_faction The Celestial Faction to initialize
function celestial_faction_init(celestial_faction)
{
	// Add Celestial Faction to Celestial Simulator's Factions Array
	array_push(CelestialSimulator.factions, celestial_faction);
	
	// Update Celestial Faction ID from Celestial Simulator's next available Faction ID
	celestial_faction.faction_id = CelestialSimulator.faction_available_id;
	
	// Increment Celestial Simulator's next available Faction ID
	CelestialSimulator.faction_available_id++;
}

/// @function celestial_faction_set_relationship(first_faction_instance, second_faction_instance, faction_relationship_type);
/// @description Sets the Relationship Type between the two given Celestial Faction Instances
/// @param {?real:Id.Instance<oCelestialFaction>} first_faction_instance The first Celestial Faction to set the Relationship to the second of
/// @param {?real:Id.Instance<oCelestialFaction>} second_faction_instance The second Celestial Faction to set the Relationship to the second of
/// @param {int<CelestialFactionRelationshipType>} faction_relationship_type The Faction Relationship type to set as the relationship as between the two given Factions 
function celestial_faction_set_relationship(first_faction_instance, second_faction_instance, faction_relationship_type)
{
	// Check if both Celestial Faction Instances exist
	if (!instance_exists(first_faction_instance) or !instance_exists(second_faction_instance))
	{
		// One or More of the Celestial Faction Instances do not exist - Early Return
		return;
	}
	
	// Calculate Faction Relationship ID
	var temp_faction_relationship_id = $"{min(first_faction_instance.faction_id, second_faction_instance.faction_id)}:{max(first_faction_instance.faction_id, second_faction_instance.faction_id)}";
	
	// Check if Relationship Exists between Factions
	if (ds_map_exists(CelestialSimulator.faction_relationships, temp_faction_relationship_id))
	{
		// Set Faction Relationship
		ds_map_set(CelestialSimulator.faction_relationships, temp_faction_relationship_id, faction_relationship_type);
	}
	else
	{
		// Add Faction Relationship
		ds_map_add(CelestialSimulator.faction_relationships, temp_faction_relationship_id, faction_relationship_type);
	}
}

/// @function celestial_faction_get_relationship(first_faction_instance, second_faction_instance);
/// @description Gets the Relationship Type between the two given Celestial Faction Instances
/// @param {?real:Id.Instance<oCelestialFaction>} first_faction_instance The first Celestial Faction to check the Relationship to the second of
/// @param {?real:Id.Instance<oCelestialFaction>} second_faction_instance The second Celestial Faction to check the Relationship to the second of
function celestial_faction_get_relationship(first_faction_instance, second_faction_instance)
{
	// Check if both Celestial Faction Instances exist
	if (!instance_exists(first_faction_instance) or !instance_exists(second_faction_instance))
	{
		// One or More of the Celestial Faction Instances do not exist - Return Default Faction Relationship Status
		return CelestialFactionRelationshipType.Neutral;
	}
	
	// Find Faction Relationship ID
	var temp_faction_relationship_id = $"{min(first_faction_instance.faction_id, second_faction_instance.faction_id)}:{max(first_faction_instance.faction_id, second_faction_instance.faction_id)}";
	
	// Find Faction Relationship Type
	var temp_faction_relationship_type = ds_map_find_value(CelestialSimulator.faction_relationships, temp_faction_relationship_id);
	
	// Check if Faction Relationship Exists
	if (is_undefined(temp_faction_relationship_type))
	{
		// Faction Relationship does not exist - Return Default Faction Relationship Status
		return CelestialFactionRelationshipType.Neutral;
	}
	
	// Return Faction Relationship Status
	return temp_faction_relationship_type;
}

/// @function celestial_faction_is_relationship_hostile(first_faction_instance, second_faction_instance);
/// @description Checks if the Relationship Type between the two given Celestial Faction Instances is Hostile
/// @param {?real:Id.Instance<oCelestialFaction>} first_faction_instance The first Celestial Faction to check the Relationship to the second of
/// @param {?real:Id.Instance<oCelestialFaction>} second_faction_instance The second Celestial Faction to check the Relationship to the second of
function celestial_faction_is_relationship_hostile(first_faction_instance, second_faction_instance)
{
	// Check if both Celestial Faction Instances exist
	if (!instance_exists(first_faction_instance) or !instance_exists(second_faction_instance))
	{
		// One or More of the Celestial Faction Instances do not exist - Return Default Faction Relationship Status
		return false
	}
	
	// Set Default Faction Relationship Status
	var temp_faction_relationship_is_hostile = false;
	
	// Find Faction Relationship ID
	var temp_faction_relationship_id = $"{min(first_faction_instance.faction_id, second_faction_instance.faction_id)}:{max(first_faction_instance.faction_id, second_faction_instance.faction_id)}";
	
	// Find Faction Relationship Type
	var temp_faction_relationship_type = ds_map_find_value(CelestialSimulator.faction_relationships, temp_faction_relationship_id);
	
	// Check Faction Relationship
	switch (temp_faction_relationship_type)
	{
		case CelestialFactionRelationshipType.Hostile:
			// Faction Relationship is Hostile
			temp_faction_relationship_is_hostile = true;
			break;
		default:
			break;
	}
	
	// Return if Faction Relationship is Hostile
	return temp_faction_relationship_is_hostile;
}


/// @function celestial_faction_is_relationship_allied(first_faction_instance, second_faction_instance);
/// @description Checks if the Relationship Type between the two given Celestial Faction Instances is Allied
/// @param {?real:Id.Instance<oCelestialFaction>} first_faction_instance The first Celestial Faction to check the Relationship to the second of
/// @param {?real:Id.Instance<oCelestialFaction>} second_faction_instance The second Celestial Faction to check the Relationship to the second of
function celestial_faction_is_relationship_allied(first_faction_instance, second_faction_instance)
{
	// Check if both Celestial Faction Instances exist
	if (!instance_exists(first_faction_instance) or !instance_exists(second_faction_instance))
	{
		// One or More of the Celestial Faction Instances do not exist - Return Default Faction Relationship Status
		return false
	}
	
	// Set Default Faction Relationship Status
	var temp_faction_relationship_is_allied = false;
	
	// Find Faction Relationship ID
	var temp_faction_relationship_id = $"{min(first_faction_instance.faction_id, second_faction_instance.faction_id)}:{max(first_faction_instance.faction_id, second_faction_instance.faction_id)}";
	
	// Find Faction Relationship Type
	var temp_faction_relationship_type = ds_map_find_value(CelestialSimulator.faction_relationships, temp_faction_relationship_id);
	
	// Check Faction Relationship
	switch (temp_faction_relationship_type)
	{
		case CelestialFactionRelationshipType.Allied:
			// Faction Relationship is Allied
			temp_faction_relationship_is_allied = true;
			break;
		default:
			break;
	}
	
	// Return if Faction Relationship is Allied
	return temp_faction_relationship_is_allied;
}
