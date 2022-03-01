add_item_inventory(inventory, 5);
add_item_inventory(inventory, 6, 20);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;