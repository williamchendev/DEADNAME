/// @description Thrown Weapon Fuze Behaviour
// Update Thrown Weapon Item's Fuze Timer and Behaviour

// Inherited Dyanmic Item Physics Behaviour Event
event_inherited();

// Update Thrown Weapon's Fuze Behaviour
var temp_thrown_weapon_fuze_condition = item_instance.update_fuze();

// Check if Thrown Weapon's Fuze has gone off
if (temp_thrown_weapon_fuze_condition)
{
	item_instance.trigger_fuze();
}
