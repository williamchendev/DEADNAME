/// @description Inventory Destroy
// Destroys the Inventory Interact if Inventory does not exist

// Inventory Object no longer Exists
var temp_inventory_exists = false;
if (interact_inventory_obj != noone) {
	if (instance_exists(interact_inventory_obj)) {
		temp_inventory_exists = true;
	}
}
if (!temp_inventory_exists) {
	interact_destroy = true;
}

// Inherit the parent event
event_inherited();