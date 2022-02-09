/// @description Inventory Update
// Performs the behaviour of the Interact Inventory

// Manual Inventory Masking Box via Inventory Obj DS List
if (!interact_mirror_select_obj) {
	// Interaction Inventory Scale/Position Object Properties
	var temp_mask_exists = false
	for (var i = 0; i < ds_list_size(interact_inventory_obj_mask_list); i++) {
		var temp_mask_inst = ds_list_find_value(interact_inventory_obj_mask_list, i);
		if (temp_mask_inst != noone) {
			if (instance_exists(temp_mask_inst)) {
				// Corpse Mask
				if (!temp_mask_exists) {
					interact_inventory_obj_bbox_left = temp_mask_inst.bbox_left;
					interact_inventory_obj_bbox_right = temp_mask_inst.bbox_right;
					interact_inventory_obj_bbox_top = temp_mask_inst.bbox_top;
					interact_inventory_obj_bbox_bottom = temp_mask_inst.bbox_bottom;
				}
				else {
					interact_inventory_obj_bbox_left = min(interact_inventory_obj_bbox_left, temp_mask_inst.bbox_left);
					interact_inventory_obj_bbox_right = max(interact_inventory_obj_bbox_right, temp_mask_inst.bbox_right);
					interact_inventory_obj_bbox_top = min(interact_inventory_obj_bbox_top, temp_mask_inst.bbox_top);
					interact_inventory_obj_bbox_bottom = max(interact_inventory_obj_bbox_bottom, temp_mask_inst.bbox_bottom);
				}
				
				// Mask Exists
				temp_mask_exists = true;
			}
		}
	}
	
	// Check if Mask no longer Exists
	if (!temp_mask_exists) {
		// Destroy Interact
		interact_destroy = true;
	}
	else {
		// Interact Mask Properties
		sprite_index = interact_inventory_obj_sprite;
		image_index = 0;
		image_angle = 0;

		image_xscale = (abs(interact_inventory_obj_bbox_left - interact_inventory_obj_bbox_right) + interact_inventory_obj_select_mask_padding_size) / 48.0;
		image_yscale = (abs(interact_inventory_obj_bbox_top - interact_inventory_obj_bbox_bottom) + interact_inventory_obj_select_mask_padding_size) / 48.0;

		x = lerp(interact_inventory_obj_bbox_left, interact_inventory_obj_bbox_right, 0.5);
		y = lerp(interact_inventory_obj_bbox_top, interact_inventory_obj_bbox_bottom, 0.5);
	}
}

// Interaction Destroy & Select Behaviour
event_inherited();

// Interact Destroy Behaviour
if (interact_destroy) {
	return;
}

// Interact Inventory
var temp_unit_exists = false;
if (interact_unit != noone) {
	if (instance_exists(interact_unit)) {
		temp_unit_exists = true;
	}
}
if (!interact_inventory_player_action) {
	// Inventory Unit Interact Behaviour
	if (interact_action) {
		// Check Unit
		if (temp_unit_exists) {
			// Unit Behaviour
			if (interact_unit.player_input) {
				// Player Behaviour
				interact_inventory_player_action = true;
				interact_unit.command = true;
				interact_unit.command_lerp_time = true;
				interact_unit.inventory_show = true;
				
				interact_inventory_obj.draw_inventory = true;
				interact_inventory_obj.inventory_other_swap = true;
				interact_inventory_obj.inventory_other_swap_master = false;
				interact_unit.inventory.inventory_other_swap = true;
				interact_unit.inventory.inventory_other_swap_master = true;
				
				interact_unit.inventory.inventory_other_swap_sub_obj = interact_inventory_obj;
				interact_inventory_obj.inventory_other_swap_master_obj = interact_unit.inventory;
			}
			else {
				// NPC Behaviour
			}
		}
		interact_action = false;
	}
}
else {
	// Player Item Swap Behaviour
	var temp_item_swap_break = false;
	if (temp_unit_exists) {
		if (!interact_unit.inventory_show) {
			temp_item_swap_break = true;
			interact_inventory_player_action = false;
		}
	}
	else {
		temp_item_swap_break = true;
	}
	
	// Reset Interact Select Behaviour
	if (temp_item_swap_break) {
		interact_unit = noone;
		interact_action = false;
	}
	
	// Prevent Selection
	interact_select = false;
	interact_select_draw_value = 0;
}