/// @description Celestial Sub-Unit Cleanup Event
// Celestial Sub-Unit Cleanup Behaviour Event

// Delete all Micro-Units
micro_unit_count = unit_count;
array_resize(micro_unit_health, 0);
array_resize(micro_unit_armor, 0);

