// Inventory Settings
add_item_inventory(inventory, 9);
add_item_inventory(inventory, 10, 24);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;

// Follow Settings
ai_follow = true;
ai_command = false;
ai_follow_unit = instance_find(oUnit_Wolf, 0);
ai_follow_combat_timer = 0;