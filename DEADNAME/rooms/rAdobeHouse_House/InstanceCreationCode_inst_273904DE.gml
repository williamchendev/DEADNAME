// Interact Settings
interact = instance_create_layer(x, y, layer, oInteractDialogue);
interact.interact_obj = id;
interact.infinite_range = true;
interact.file_name = "AdobeHouse_NPC";
interact.interact_description = "Talk to William";

// Inventory
instance_destroy(inventory);
inventory = create_empty_inventory(id, 12, 8);
add_item_inventory(inventory, 9);
add_item_inventory(inventory, 12);
add_item_inventory(inventory, 8);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;

for (var i = 0; i < ds_list_size(inventory.weapons); i++) {
	// Find Indexed Weapon
	var temp_weapon_index = ds_list_find_value(inventory.weapons, i);
	temp_weapon_index.equip = false;
}