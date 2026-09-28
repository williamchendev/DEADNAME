/// @description Celestial Combat Unit Cleanup Event
// Clears the Celestial Combat Unit's Inventory Struct Array

// Clear Combat Unit's Inventory
var temp_combat_unit_inventory_count = array_length(item_inventory);
var temp_combat_unit_inventory_index = temp_combat_unit_inventory_count - 1;

repeat (temp_combat_unit_inventory_count)
{
	// Clear Inventory Slot Struct
	delete item_inventory[temp_combat_unit_inventory_index];
	item_inventory[temp_combat_unit_inventory_index] = -1;
	
	// Decrement Combat Unit Inventory Index
	temp_combat_unit_inventory_index--;
}

array_resize(item_inventory, 0);

// Reset Combat Unit's Inventory Index
item_inventory_index = -1;

