/// drop_item_inventory(inventory_object, x, y, item_x, item_y);
/// @description This method removes and drops the item at the given index from the given inventory as game objects in the world space
/// @param {real} inventory_object The given inventory object to drop an item from
/// @param {real} x The given x coordinate to create the dropped Item Container
/// @param {real} y The given y coordinate to create the dropped Item Container
/// @returns {real} Returns the game object id of the item instantiated in the world space

// Assemble argument variables
var temp_inventory = argument[0];
var temp_x = argument[1];
var temp_y = argument[2];
var temp_inventory_x = argument[3];
var temp_inventory_y = argument[4];

// Find Item Variables
var temp_item_id = temp_inventory.inventory[temp_inventory_x, temp_inventory_y];
var temp_item_stack = temp_inventory.inventory_stacks[temp_inventory_x, temp_inventory_y];
var temp_item_width = global.item_data[temp_item_id, itemstats.width_space];
var temp_item_height = global.item_data[temp_item_id, itemstats.height_space];

// Create the Drop Container
var temp_item_container_inst = instance_create_layer(temp_x, temp_y, layer_get_id("Instances"), oItem_DropContainer);
temp_item_container_inst.interact.interact_inventory_obj = create_empty_inventory(noone, temp_item_width, temp_item_height);
temp_item_container_inst.interact.interact_inventory_obj.no_placement = true;
temp_item_container_inst.interact.interact_inventory_obj.no_placement_allow_id = temp_item_id;
temp_item_container_inst.interact.interact_description += global.item_data[temp_item_id, itemstats.name];
add_item_inventory(temp_item_container_inst.interact.interact_inventory_obj, temp_item_id, temp_item_stack);

return temp_item_container_inst;