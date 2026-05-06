/// @description Faction Init Event
// Celestial Faction Init Behaviour Event

// Index Faction within Celestial Simulator
array_push(CelestialSimulator.factions, id);

// Initialize Faction Arrays
units = array_create(0);

// Initialize Faction Relationship DS Map
relationships = ds_map_create();
