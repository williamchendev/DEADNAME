/// @description Insert description here
// You can write your code in this editor

// Reindex Behaviour
if (weapon_reindex) {
	// Add and Destroy Weapon in Reindexing Inventory
	add_item_inventory(weapon_reindex_inventory, weapon_reindex_item_id);
	var temp_replace_weapon = ds_list_find_value(weapon_reindex_inventory.weapons, ds_list_size(weapon_reindex_inventory.weapons) - 1);
	temp_replace_weapon.active = false;
	instance_destroy(temp_replace_weapon);
	
	// Replace Slot
	ds_list_replace(weapon_reindex_inventory.weapons, ds_list_size(weapon_reindex_inventory.weapons) - 1, id);
	
	// Reset Reindex
	weapon_reindex = false;
	weapon_reindex_item_id = -1;
	weapon_reindex_inventory = -1;
}