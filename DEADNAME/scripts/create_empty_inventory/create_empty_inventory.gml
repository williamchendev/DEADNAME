/// create_empty_inventory(width,height);
/// @description Creates an empty inventory from the given width and height and returns the object id
/// @param {real} unit The given instance id of the Unit Object the inventory pertains to
/// @param {integer} width The given width of the Inventory Array
/// @param {integer} height The given height of the Inventory Array
/// @returns {real} id of the empty inventory object

// Creates Inventory Game Object
var temp_inventory_obj = instance_create_depth(0, 0, -5000, oUnitInventory);

// Creates Inventory Array
var temp_inven_unit = argument0;
var temp_inven_width = argument1;
var temp_inven_height = argument2;

var temp_inventory;
var temp_inventory_stacks;
for (var h = 0; h < temp_inven_height; h++) {
	for (var w = 0; w < temp_inven_width; w++) {
		temp_inventory[w, h] = 0;
		temp_inventory_stacks[w, h] = 0;
	}
}

// Assigns inventory data to inventory object
temp_inventory_obj.unit_id = temp_inven_unit;
temp_inventory_obj.inventory = temp_inventory;
temp_inventory_obj.inventory_stacks = temp_inventory_stacks;
temp_inventory_obj.inventory_width = temp_inven_width;
temp_inventory_obj.inventory_height = temp_inven_height;

// Returns empty inventory game object
return temp_inventory_obj;