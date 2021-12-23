/// add_item_inventory(inventory_object, item_id, item_stacks);
/// @description Places an item in the given inventory object's inventory array given it's size and it's item stacks and returns the amount of stacks remaining
/// @param {real} inventory_object The given inventory object to place the item
/// @param {integer} item_id The ID of the item's data index to put in the inventory array
/// @param {integer} item_stack The stack of the item to be placed at the item_x and item_y position, by default this number is one, this is an optional overloaded argument
/// @returns {integer} Returns the remaining amount of stacks of the item if they were not able to be placed

// Establish the Variables
var temp_inventory_obj = argument[0];
var temp_inventory_width = temp_inventory_obj.inventory_width;
var temp_inventory_height = temp_inventory_obj.inventory_height;

var temp_item_id = argument[1];
var temp_item_width = global.item_data[temp_item_id, itemstats.width_space];
var temp_item_height = global.item_data[temp_item_id, itemstats.height_space];
var temp_item_stack = 1;
var temp_item_stack_limit = global.item_data[temp_item_id, itemstats.stack_limit];
if (argument_count == 3) {
	temp_item_stack = argument[2];
}

// Check for places to place item stack while stack is greater than 0
for (var h = 0; h < temp_inventory_height; h++) {
	for (var w = 0; w < temp_inventory_width; w++) {
		if (temp_item_stack > 0) {
			if (check_item_inventory(temp_inventory_obj, w, h, temp_item_width, temp_item_height, temp_item_id)) {
				 var temp_can_place_num = clamp(temp_item_stack, 1, temp_item_stack_limit - temp_inventory_obj.inventory_stacks[w, h]);
				 place_item_inventory(temp_inventory_obj, temp_item_id, w, h, temp_can_place_num);
				 temp_item_stack -= temp_can_place_num;
				 
				 if (global.item_data[temp_item_id, itemstats.type] == itemtypes.weapon) {
					 if (temp_can_place_num > 0) {
						 // Spawn Weapon Variables
						 var temp_weapon_spawn_x = x;
						 var temp_weapon_spawn_y = y;
						 var temp_weapon_spawn_angle = 90;
						 
						 // Check if Inventory Unit is Valid
						 if (temp_inventory_obj.unit_id != noone) {
							if (instance_exists(temp_inventory_obj.unit_id)) {
								temp_weapon_spawn_x = temp_inventory_obj.unit_id.x;
								temp_weapon_spawn_y = lerp(temp_inventory_obj.unit_id.bbox_top, temp_inventory_obj.unit_id.bbox_bottom, 0.5);
								temp_weapon_spawn_angle = temp_inventory_obj.unit_id.draw_angle + 90;
							}
						 }
						 
						 // Spawn and Index Weapon into Inventory
						 var temp_item_init_weapon = instance_create_layer(temp_weapon_spawn_x, temp_weapon_spawn_y, layer_get_id("Instances"), global.weapon_data[global.item_data[temp_item_id, itemstats.type_index], weaponstats.object]);
						 temp_item_init_weapon.weapon_rotation = temp_weapon_spawn_angle;
						 ds_list_add(temp_inventory_obj.weapons, temp_item_init_weapon);
						 ds_list_add(temp_inventory_obj.weapons_index, (temp_inventory_width * h) + w);
					 }
				 }
			}
		}
		else {
			return 0;
		}
	}
}

// Return remaining stack
return temp_item_stack;