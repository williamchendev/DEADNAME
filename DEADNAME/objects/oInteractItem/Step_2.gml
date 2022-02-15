/// @description Destroy Event
// Check if weapon has been picked up

// Check Action
if (interact_inventory_player_action) {
	interact_item_destroy_check = true;
}

// Inherit the parent event
event_inherited();

// Destroy Behaviour
if (interact_item_destroy_check and !interact_inventory_player_action) {
	interact_item_destroy_check = false;
	if (interact_inventory_weapon_destroy) {
		if (ds_list_find_index(interact_inventory_obj.weapons, interact_obj) == -1) {
			instance_destroy(interact_inventory_obj);
			instance_destroy();
		}
	}
	else {
		if (interact_inventory_obj.inventory[0, 0] == 0) {
			instance_destroy(interact_inventory_obj);
			instance_destroy();
		}
	}
}