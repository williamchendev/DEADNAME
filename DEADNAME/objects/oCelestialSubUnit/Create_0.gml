/// @description Default Celestial Sub-Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour

// Initialize as Persistent Object
persistent = true;

// Unit Instance Variable
unit_instance = noone;

// Micro-Unit Arrays
micro_unit_count = unit_count;
micro_unit_health = array_create(unit_count, unit_health);
micro_unit_armor = array_create(unit_count, celestial_unit_armor_stat_to_value_conversion(unit_armor));
