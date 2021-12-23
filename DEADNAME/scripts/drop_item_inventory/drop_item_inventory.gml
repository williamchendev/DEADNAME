/// drop_item_inventory(inventory_object, item_x, item_y, item_stack);
/// @description This method removes and drops the item at the given index from the given inventory as game objects in the world space
/// @param {real} inventory_object The given inventory object to drop an item from
/// @param {integer} item_x The starting x coordinate in the inventory array to check for empty space
/// @param {integer} item_y The starting y coordinate in the inventory array to check for empty space
/// @param {integer} item_stack The stack of the item to remove and drop at the item_x and item_y position, this is an optional overloaded argument
/// @returns {real} Returns the game object id of the item instantiated in the world space

// Assemble argument variables
var temp_inventory = argument[0];
var temp_inventory_x = argument[1];
var temp_inventory_y = argument[2];
var temp_inventory_stack = -1;

if (argument_count == 4) {
	temp_inventory_stack = argument[3];
}

