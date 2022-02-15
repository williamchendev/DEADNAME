/// @description Inventory Update Event
// performs all the calculations for the inventory behavior & draw events

// Inventory Menu Calculations
if (draw_inventory) {
	// Sin Radial Calculations
	sin_val += radial_spd;
	if (sin_val > 1) {
		sin_val = 0;
	}
	var draw_sin = (sin(sin_val * 2 * pi) / 2) + 1;
	
	// Set Inventory Menu Alpha
	draw_alpha = lerp(draw_alpha, 1, draw_lerp_spd);
	
	// Calculate Inventory Position & Properties
	if (inventory_other_swap and !inventory_other_swap_master) {
		x = inventory_other_swap_master_obj.x;
		y = inventory_other_swap_master_obj.y;
	}
	draw_inventory_x = x + (-32 * (1 - (draw_alpha * draw_alpha)));
	draw_inventory_y = y - ((inventory_height / 2) * inventory_grid_size) - inventory_offset_size - inventory_outline_size;
	draw_inventory_outline_size = (inventory_offset_size * draw_sin) + inventory_outline_size;
	if (inventory_other_swap) {
		if (inventory_other_swap_master) {
			// Inventory Swap Positioning
			var temp_inventory_other_swap_yoffset = ((inventory_other_swap_sub_obj.inventory_height / 2) * inventory_other_swap_sub_obj.inventory_grid_size) + ((inventory_other_swap_sub_obj.inventory_offset_size + inventory_other_swap_sub_obj.inventory_outline_size) * 2);
			draw_inventory_y -= temp_inventory_other_swap_yoffset;
		}
		else {
			var temp_inventory_other_swap_yoffset = ((inventory_other_swap_master_obj.inventory_height / 2) * inventory_other_swap_master_obj.inventory_grid_size) + ((inventory_other_swap_master_obj.inventory_offset_size + inventory_other_swap_master_obj.inventory_outline_size) * 2);
			draw_inventory_y += temp_inventory_other_swap_yoffset;
		}
	}
	
	// Check Unit Exists
	var temp_unit_exists = false;
	if (unit_id != noone) {
		if (instance_exists(unit_id)) {
			temp_unit_exists = true;
		}
	}
	
	// Player Input
	var key_left_press = false;
	var key_right_press = false;
	var key_up_press = false;
	var key_down_press = false;

	var key_select_press = false;
	var key_halfselect_press = false;
	
	var key_interact_press = false;
	var key_drop_press = false;
	
	var temp_cursor_x = 0;
	var temp_cursor_y = 0;

	if (game_manager != noone) {
		if (draw_inventory_open) {
			key_left_press = keyboard_check_pressed(game_manager.left_check);
			key_right_press = keyboard_check_pressed(game_manager.right_check);
			key_up_press = keyboard_check_pressed(game_manager.up_check);
			key_down_press = keyboard_check_pressed(game_manager.down_check);
		
			key_select_press = false;
			key_halfselect_press = false;
			key_drop_press = keyboard_check_pressed(game_manager.reload_check);
			
			key_interact_press = keyboard_check_pressed(game_manager.interact_check);
		}
	}
	if (!console_input) {
		key_select_press = mouse_check_button_pressed(mb_left);
		key_halfselect_press = mouse_check_button_pressed(mb_right);
		
		temp_cursor_x = mouse_get_x();
		temp_cursor_y = mouse_get_y();
		
		if (inventory_other_swap) {
			if (inventory_other_swap_master) {
				var temp_inventory_other_swap_height = (inventory_height * inventory_grid_size) + ((inventory_offset_size + inventory_outline_size) * 3);
				if (temp_cursor_y > draw_inventory_y + temp_inventory_other_swap_height) {
					select_show_cursor = false;
				}
			}
			else {
				var temp_inventory_other_swap_height = (inventory_other_swap_master_obj.inventory_height * inventory_other_swap_master_obj.inventory_grid_size) + ((inventory_other_swap_master_obj.inventory_offset_size + inventory_other_swap_master_obj.inventory_outline_size) * 3);
				if (temp_cursor_y <= inventory_other_swap_master_obj.draw_inventory_y + temp_inventory_other_swap_height) {
					select_show_cursor = false;
				}
			}
		}
	}
	
	// Select position variables
	var select_x = select_index % inventory_width;
	var select_y = select_index div inventory_width;
	var temp_selected_width = 1;
	var temp_selected_height = 1;
	if (inventory[select_x, select_y] != 0) {
		temp_selected_width = select_target_width;
		temp_selected_height = select_target_height;
	}
	
	// Input Calculations
	var update_inventory = false;
	if (select_show_cursor) {
		if (key_interact_press) {
			// Use or Equip Behaviour
			if (inventory[select_x, select_y] > 0) {
				// Type Behaviour
				if (global.item_data[inventory[select_x, select_y], itemstats.type] == itemtypes.weapon) {
					// Weapon Equip Behaviour
					if (!inventory_other_swap or inventory_other_swap_master) {
						var temp_inven_weapon_index = ds_list_find_index(weapons_index, select_index);
						if (temp_inven_weapon_index != -1) {
							var temp_inven_weapon_obj = ds_list_find_value(weapons, temp_inven_weapon_index);
							if (temp_inven_weapon_obj.equip) {
								temp_inven_weapon_obj.equip = false;
							}
							else {
								for (var l = 0; l < ds_list_size(weapons); l++) {
									var temp_inven_weapon_inst = ds_list_find_value(weapons, l);
									temp_inven_weapon_inst.equip = false;
								}
								temp_inven_weapon_obj.equip = true;
							}
						}
					}
				}
				else {
					// Consumable Behaviour
				}
			}
		}
		if (key_select_press or key_halfselect_press) {
			// Moving around Items in Inventory
			if (draw_inventory_open) {
				if (select_item_id == 0) {
					// Pick up Item from Slot
					if (inventory[select_x, select_y] > 0) {
						// Set select item properties
						select_item_id = inventory[select_x, select_y];
						select_item_stacks = inventory_stacks[select_x, select_y];
						if (key_halfselect_press) {
							select_item_stacks = max(inventory_stacks[select_x, select_y] div 2, 1);
						}
					
						select_item_width = temp_selected_width;
						select_item_height = temp_selected_height;
						
						// Set select Weapon properties
						if (global.item_data[select_item_id, itemstats.type] == itemtypes.weapon) {
							weapon_place_list = weapons;
							weapon_place_index_list = weapons_index;
							for (var q = 0; q < ds_list_size(weapons_index); q++) {
								if (ds_list_find_value(weapons_index, q) == select_index) {
									weapon_place_index = q;
									break;
								}
							}
						}
					
						// Reset inventory spaces
						inventory_stacks[select_x, select_y] = inventory_stacks[select_x, select_y] - select_item_stacks;
						if (inventory_stacks[select_x, select_y] <= 0) {
							for (var h = 0; h < select_item_height; h++) {
								for (var w = 0; w < select_item_width; w++) {
									inventory[w + select_x, h + select_y] = 0;
								}
							}
						}
						update_inventory = true;
					}
				}
				else if (!no_placement or (no_placement_allow_id == select_item_id)) {
					// Check how many to place in Slot
					select_place_num = select_item_stacks;
					if (key_halfselect_press) {
						select_place_num = 1;
					}
					else {
						if (inventory[select_x, select_y] > 0) {
							select_place_num = min(select_item_stacks, global.item_data[inventory[select_x, select_y], itemstats.stack_limit] - inventory_stacks[select_x, select_y]);
						}
					}
		
					// Put down Item into Slot
					if (select_place_num != 0) {
						if (check_item_inventory(id, select_x, select_y, select_item_width, select_item_height, select_item_id, select_place_num)) {
							// Place Item in empty inventory space
							place_item_inventory(id, select_item_id, select_x, select_y, select_place_num);
							select_item_stacks -= select_place_num;
							
							// Weapon Placement Behaviour
							if (global.item_data[select_item_id, itemstats.type] == itemtypes.weapon) {
								if (weapon_place_list == weapons) {
									ds_list_replace(weapons_index, weapon_place_index, select_index);
								}
								else {
									var temp_weapon_other_obj = ds_list_find_value(weapon_place_list, weapon_place_index);
									temp_weapon_other_obj.equip = false;
									if (!hide_items) {
										if (temp_unit_exists) {
											temp_weapon_other_obj.phy_position_x = lerp(unit_id.bbox_left, unit_id.bbox_right, 0.5);
											temp_weapon_other_obj.phy_position_y = lerp(unit_id.bbox_top, unit_id.bbox_bottom, 0.5);
											temp_weapon_other_obj.x_position = lerp(unit_id.bbox_left, unit_id.bbox_right, 0.5);
											temp_weapon_other_obj.y_position = lerp(unit_id.bbox_top, unit_id.bbox_bottom, 0.5);
											temp_weapon_other_obj.phy_active = true;
										}
									}
									else {
										temp_weapon_other_obj.active = false;
									}
									ds_list_add(weapons, temp_weapon_other_obj);
									ds_list_add(weapons_index, select_index);
									ds_list_delete(weapon_place_list, weapon_place_index);
									ds_list_delete(weapon_place_index_list, weapon_place_index);
								}
							}
				
							// Reset select item properties
							if (select_item_stacks <= 0) {
								select_item_id = 0;
								select_item_stacks = 0;
					
								select_item_width = 0;
								select_item_height = 0;
							}
							select_place = false;
							select_place_num = 0;
						}
					}
					update_inventory = true;
				}
			}
		}
		else if (key_drop_press and (select_item_id == 0) and (!no_placement) and (!hide_items) and temp_unit_exists) {
			// Drop Item Behaviour
			if (inventory[select_x, select_y] > 0) {
				// Set select item properties
				select_item_id = inventory[select_x, select_y];
				select_item_stacks = inventory_stacks[select_x, select_y];
					
				select_item_width = temp_selected_width;
				select_item_height = temp_selected_height;
						
				// Set select Weapon properties
				if (global.item_data[select_item_id, itemstats.type] == itemtypes.weapon) {
					for (var q = 0; q < ds_list_size(weapons_index); q++) {
						if (ds_list_find_value(weapons_index, q) == select_index) {
							// Unequip Weapon
							var temp_weapon_obj = ds_list_find_value(weapons, q);
							temp_weapon_obj.equip = false;
							temp_weapon_obj.phy_active = true;
							
							// Create Interact Item
							var temp_weapon_interact_inst = instance_create_layer(x, y, layer_get_id("Instances"), oInteractItem);
							temp_weapon_interact_inst.interact_obj = temp_weapon_obj;
							temp_weapon_interact_inst.interact_image_xscale = 1.75;
							temp_weapon_interact_inst.interact_image_yscale = 2.25;
							temp_weapon_interact_inst.interact_inventory_weapon_destroy = true;
							temp_weapon_interact_inst.interact_inventory_obj = create_empty_inventory(noone, select_item_width, select_item_height);
							temp_weapon_interact_inst.interact_inventory_obj.no_placement = true;
							temp_weapon_interact_inst.interact_inventory_obj.no_placement_allow_id = select_item_id;
							temp_weapon_interact_inst.interact_description = "Equip " + global.item_data[select_item_id, itemstats.name];
							add_item_inventory(temp_weapon_interact_inst.interact_inventory_obj, select_item_id);
							var temp_replace_weapon = ds_list_find_value(temp_weapon_interact_inst.interact_inventory_obj.weapons, ds_list_size(temp_weapon_interact_inst.interact_inventory_obj.weapons) - 1);
							temp_replace_weapon.active = false;
							instance_destroy(temp_replace_weapon);
							ds_list_replace(temp_weapon_interact_inst.interact_inventory_obj.weapons, ds_list_size(temp_weapon_interact_inst.interact_inventory_obj.weapons) - 1, temp_weapon_obj);
							
							// Delete Index
							ds_list_delete(weapons, q);
							ds_list_delete(weapons_index, q);
							break;
						}
					}
				}
				else {
					// Create Ragdoll Dropped Item Container
					if (temp_unit_exists) {
						drop_item_inventory(id, unit_id.x, lerp(unit_id.bbox_top, unit_id.bbox_bottom, 0.5), select_x, select_y);
					}
				}
					
				// Reset inventory spaces
				inventory_stacks[select_x, select_y] = 0;
				for (var h = 0; h < select_item_height; h++) {
					for (var w = 0; w < select_item_width; w++) {
						inventory[w + select_x, h + select_y] = 0;
					}
				}
				
				// Reset Select Data
				select_item_id = 0;
				select_item_stacks = 0;
					
				select_item_width = 0;
				select_item_height = 0;
			
				select_place = false;
				select_place_num = 0;
				
				update_inventory = true;
			}
		}
		else {
			// Move Inventory Selection Index
			if (select_item_id == 0) {
				// Move Select Cursor when nothing is selected
				if (console_input) {
					// Console Input
					if (key_up_press) {
						select_y--;
						if (select_y < 0) {
							select_y = inventory_height - 1;
						}
					}
					else if (key_down_press) {
						select_y += temp_selected_height;
						if (select_y >= inventory_height) {
							select_y = 0;
						}
					}
	
					if (key_left_press) {
						select_x--;
						if (select_x < 0) {
							select_x = inventory_width - 1;
						}
					}
					else if (key_right_press) {
						select_x += temp_selected_width;
						if (select_x >= inventory_width) {
							select_x = 0;
						}
					}
				}
				else {
					// Mouse Input
					inventory_cursor_xoffset = 0;
					inventory_cursor_yoffset = 0;
					select_x = clamp((temp_cursor_x - (draw_inventory_x + inventory_offset_size + inventory_outline_size)) div inventory_grid_size, 0, inventory_width - 1);
					select_y = clamp((temp_cursor_y - (draw_inventory_y + inventory_offset_size + inventory_outline_size)) div inventory_grid_size, 0, inventory_height - 1);
				}
	
				if (inventory[select_x, select_y] < 0) {
					var temp_select_x = select_x;
					var temp_select_y = select_y;
					select_x = (-1 * (inventory[temp_select_x, temp_select_y] + 1)) % inventory_width;
					select_y = (-1 * (inventory[temp_select_x, temp_select_y] + 1)) div inventory_width;
					
					if (!console_input) {
						inventory_cursor_xoffset = select_x - temp_select_x;
						inventory_cursor_yoffset = select_y - temp_select_y;
					}
				}
			}
			else {
				// Move Select Cursor when something is selected
				if (console_input) {
					// Console Input
					if (key_up_press) {
						select_y--;
						if (select_y < 0) {
							select_y = inventory_height - select_item_height;
						}
					}
					else if (key_down_press) {
						select_y++;
						if (select_y + select_item_height - 1 >= inventory_height) {
							select_y = 0;
						}
					}
	
					if (key_left_press) {
						select_x--;
						if (select_x < 0) {
							select_x = inventory_width - select_item_width;
						}
					}
					else if (key_right_press) {
						select_x++;
						if (select_x + select_item_width - 1 >= inventory_width) {
							select_x = 0;
						}
					}
				}
				else {
					// Mouse Input
					select_x = max(clamp(((temp_cursor_x - (draw_inventory_x + inventory_offset_size + inventory_outline_size)) div inventory_grid_size) + inventory_cursor_xoffset, 0, inventory_width - select_item_width), 0);
					select_y = max(clamp(((temp_cursor_y - (draw_inventory_y + inventory_offset_size + inventory_outline_size)) div inventory_grid_size) + inventory_cursor_yoffset, 0, inventory_height - select_item_height), 0);
				}
			}
		}
	}
	else {
		// Cursor Inactive Behaviour
		if (inventory_other_swap) {
			if (inventory_other_swap_master) {
				if (inventory_other_swap_sub_obj.select_item_id != 0) {
					inventory_cursor_xoffset = inventory_other_swap_sub_obj.inventory_cursor_xoffset;
					inventory_cursor_yoffset = inventory_other_swap_sub_obj.inventory_cursor_yoffset;
						
					select_item_id = inventory_other_swap_sub_obj.select_item_id;
					select_item_stacks = inventory_other_swap_sub_obj.select_item_stacks;
					select_item_width = inventory_other_swap_sub_obj.select_item_width;
					select_item_height = inventory_other_swap_sub_obj.select_item_height;
					weapon_place_index = inventory_other_swap_sub_obj.weapon_place_index;
					weapon_place_list = inventory_other_swap_sub_obj.weapon_place_list;
					weapon_place_index_list = inventory_other_swap_sub_obj.weapon_place_index_list;
				}
				else {
					select_item_id = 0;
					select_item_stacks = 0;
					select_item_width = 0;
					select_item_height = 0;
					weapon_place_index = 0;
					weapon_place_list = noone;
					weapon_place_index_list = noone;
				}
			}
			else {
				if (inventory_other_swap_master_obj.select_item_id != 0) {
					inventory_cursor_xoffset = inventory_other_swap_master_obj.inventory_cursor_xoffset;
					inventory_cursor_yoffset = inventory_other_swap_master_obj.inventory_cursor_yoffset;
					
					select_item_id = inventory_other_swap_master_obj.select_item_id;
					select_item_stacks = inventory_other_swap_master_obj.select_item_stacks;
					select_item_width = inventory_other_swap_master_obj.select_item_width;
					select_item_height = inventory_other_swap_master_obj.select_item_height;
					weapon_place_index = inventory_other_swap_master_obj.weapon_place_index;
					weapon_place_list = inventory_other_swap_master_obj.weapon_place_list;
					weapon_place_index_list = inventory_other_swap_master_obj.weapon_place_index_list;
				}
				else {
					select_item_id = 0;
					select_item_stacks = 0;
					select_item_width = 0;
					select_item_height = 0;
					weapon_place_index = 0;
					weapon_place_list = noone;
					weapon_place_index_list = noone;
				}
			}
		}
		
		// Inactive Cursor Move Behaviour
		if (!console_input) {
			if (select_item_id == 0) {
				select_x = clamp((temp_cursor_x - (draw_inventory_x + inventory_offset_size + inventory_outline_size)) div inventory_grid_size, 0, inventory_width - 1);
				select_y = clamp((temp_cursor_y - (draw_inventory_y + inventory_offset_size + inventory_outline_size)) div inventory_grid_size, 0, inventory_height - 1);
			}
			else {
				select_x = max(clamp(((temp_cursor_x - (draw_inventory_x + inventory_offset_size + inventory_outline_size)) div inventory_grid_size) + inventory_cursor_xoffset, 0, inventory_width - select_item_width), 0);
				select_y = max(clamp(((temp_cursor_y - (draw_inventory_y + inventory_offset_size + inventory_outline_size)) div inventory_grid_size) + inventory_cursor_yoffset, 0, inventory_height - select_item_height), 0);
			}
		}
	}
	
	var temp_early_index = select_index;
	select_index = select_x + (select_y * inventory_width);
	if (!draw_inventory_open or update_inventory) {
		temp_early_index = select_index + 1;
	}
	
	// Update Select Index & Select movement targets
	if (temp_early_index != select_index) {
		// Update Sizes of Select Target Width & Height
		var temp_select_width = 1;
		var temp_select_height = 1;
		if (inventory[select_x, select_y] != 0) {
			for (var w = select_x + 1; w < inventory_width; w++) {
				if (inventory[w, select_y] == (-1 * select_index) - 1) {
					temp_select_width++;
				}
				else {
					break;
				}
			}
			for (var h = select_y + 1; h < inventory_height; h++) {
				if (inventory[select_x, h] == (-1 * select_index) - 1) {
					temp_select_height++;
				}
				else {
					break;
				}
			}
		}
		
		select_target_width = temp_select_width;
		select_target_height = temp_select_height;
	}
	select_xpos = lerp(select_xpos, (select_x * inventory_grid_size), draw_lerp_spd);
	select_ypos = lerp(select_ypos, (select_y * inventory_grid_size), draw_lerp_spd);
	select_width = lerp(select_width, select_target_width * inventory_grid_size, draw_lerp_spd);
	select_height = lerp(select_height, select_target_height * inventory_grid_size, draw_lerp_spd);
	if (select_item_id != 0) {
		select_can_place = check_item_inventory(id, select_x, select_y, select_item_width, select_item_height, select_item_id, 1);
	}
	
	// Open Inventory Initialization & Reset
	if (!draw_inventory_open) {
		select_xpos = (select_x * inventory_grid_size);
		select_ypos = (select_y * inventory_grid_size);
		select_width = select_target_width * inventory_grid_size;
		select_height = select_target_height * inventory_grid_size;
		draw_inventory_open = true;
	}
}
else {
	// Set Inventory Menu Alpha
	draw_alpha = lerp(draw_alpha, 0, draw_lerp_spd);
	
	// Reset Inventory Initialization
	if (draw_inventory_open) {
		// Reset Item Select Behaviour
		if (select_item_id != 0) {
			// Place Item back into inventory
			if (inventory_other_swap) {
				if (inventory_other_swap_master) {
					if (global.item_data[select_item_id, itemstats.type] == itemtypes.weapon) {
						// Unequip Weapon
						var temp_weapon_obj = ds_list_find_value(weapon_place_list, weapon_place_index);
						temp_weapon_obj.equip = false;
						temp_weapon_obj.active = true;
						temp_weapon_obj.phy_active = true;
						temp_weapon_obj.x_position = unit_id.x;
						temp_weapon_obj.y_position = lerp(unit_id.bbox_top, unit_id.bbox_bottom, 0.5);
						temp_weapon_obj.phy_position_x = unit_id.x;
						temp_weapon_obj.phy_position_y = lerp(unit_id.bbox_top, unit_id.bbox_bottom, 0.5);
							
						// Create Interact Item
						var temp_weapon_interact_inst = instance_create_layer(x, y, layer_get_id("Instances"), oInteractItem);
						temp_weapon_interact_inst.interact_obj = temp_weapon_obj;
						temp_weapon_interact_inst.interact_image_xscale = 1.75;
						temp_weapon_interact_inst.interact_image_yscale = 2.25;
						temp_weapon_interact_inst.interact_inventory_weapon_destroy = true;
						temp_weapon_interact_inst.interact_inventory_obj = create_empty_inventory(noone, select_item_width, select_item_height);
						temp_weapon_interact_inst.interact_inventory_obj.no_placement = true;
						temp_weapon_interact_inst.interact_inventory_obj.no_placement_allow_id = select_item_id;
						temp_weapon_interact_inst.interact_description = "Equip " + global.item_data[select_item_id, itemstats.name];
						add_item_inventory(temp_weapon_interact_inst.interact_inventory_obj, select_item_id);
						var temp_replace_weapon = ds_list_find_value(temp_weapon_interact_inst.interact_inventory_obj.weapons, ds_list_size(temp_weapon_interact_inst.interact_inventory_obj.weapons) - 1);
						temp_replace_weapon.active = false;
						instance_destroy(temp_replace_weapon);
						ds_list_replace(temp_weapon_interact_inst.interact_inventory_obj.weapons, ds_list_size(temp_weapon_interact_inst.interact_inventory_obj.weapons) - 1, temp_weapon_obj);
							
						// Delete Index
						ds_list_delete(weapon_place_list, weapon_place_index);
						ds_list_delete(weapon_place_index_list, weapon_place_index);
					}
					else {
						// Create Ragdoll Dropped Item Container
						var temp_item_container_inst = instance_create_layer(unit_id.x, lerp(unit_id.bbox_top, unit_id.bbox_bottom, 0.5), layer_get_id("Instances"), oItem_DropContainer);
						temp_item_container_inst.interact.interact_inventory_obj = create_empty_inventory(noone, select_item_width, select_item_height);
						temp_item_container_inst.interact.interact_inventory_obj.no_placement = true;
						temp_item_container_inst.interact.interact_inventory_obj.no_placement_allow_id = select_item_id;
						temp_item_container_inst.interact.interact_description += global.item_data[select_item_id, itemstats.name];
						add_item_inventory(temp_item_container_inst.interact.interact_inventory_obj, select_item_id, select_item_stacks);
					}
				}
			}
			
			// Reset select item properties
			select_item_id = 0;
			select_item_stacks = 0;
					
			select_item_width = 0;
			select_item_height = 0;
			
			update_inventory = true;
		}
		select_place = false;
		
		// Reset Item Swap Behaviour
		if (inventory_other_swap) {
			if (inventory_other_swap_sub_obj!= noone) {
				if (instance_exists(inventory_other_swap_sub_obj)) {
					inventory_other_swap_sub_obj.draw_inventory = false;
				}
			}
		}
		inventory_other_swap = false;
		inventory_other_swap_master = false
		inventory_other_swap_master_obj = noone;
		inventory_other_swap_sub_obj = noone;
	}
	draw_inventory_open = false;
}