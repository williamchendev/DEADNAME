/// @description Unit Clean Up Event
// Cleans up the variables and DS Structures of the Unit on the Unit's Destroy Event

// Inherit the parent event
event_inherited();

// Clear Squad Selection List
if (ds_exists(squads_selected_list, ds_type_list)) {
	ds_list_destroy(squads_selected_list);
}
squads_selected_list = -1;