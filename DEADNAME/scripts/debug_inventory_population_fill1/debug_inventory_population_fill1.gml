/// debug_inventory_population_fill1(inventory_object);
/// @description Takes an inventory object and populates the inventory array data with random formatted indexes
/// @param {real} inventory_object The given inventory object to populate with indexes

var temp_inven_obj = argument0;

place_item_inventory(temp_inven_obj, 1, 0, 0);
place_item_inventory(temp_inven_obj, 1, 1, 0);
//place_item_inventory(temp_inven_obj, 2, 2, 2, -1);
//place_item_inventory(temp_inven_obj, 2, 1, 2);
//place_item_inventory(temp_inven_obj, 3, 4, 2);
place_item_inventory(temp_inven_obj, 4, 2, 1);
place_item_inventory(temp_inven_obj, 6, 0, 2);