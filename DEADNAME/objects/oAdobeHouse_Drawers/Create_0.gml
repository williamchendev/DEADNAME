/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Interact Settings
interact = instance_create_layer(x, y, layer, oInteractInventory);
interact.interact_obj = id;
interact.interact_inventory_obj = create_empty_inventory(noone, 8, 4);
interact.interact_inventory_obj.hide_items = true;
add_item_inventory(interact.interact_inventory_obj, 12);