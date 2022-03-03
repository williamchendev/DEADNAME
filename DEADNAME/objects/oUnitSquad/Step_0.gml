/// @description Unit Update Event
// performs the calculations necessary for the Unit's behavior

// Key Checks (Player Input)
if (player_input) {
	// Preset Player Controls
	if (game_manager != noone) {
		key_left = keyboard_check(game_manager.left_check);
		key_right = keyboard_check(game_manager.right_check);
		key_up = keyboard_check(game_manager.up_check);
		key_down = keyboard_check(game_manager.down_check);

		key_left_press = keyboard_check_pressed(game_manager.left_check);
		key_right_press = keyboard_check_pressed(game_manager.right_check);
		key_up_press = keyboard_check_pressed(game_manager.up_check);
		key_down_press = keyboard_check_pressed(game_manager.down_check);
		
		key_jump = keyboard_check(game_manager.jump_check);
		key_jump_press = keyboard_check_pressed(game_manager.jump_check);
		
		key_shift = keyboard_check(game_manager.shift_check);
		key_interact_press = keyboard_check_pressed(game_manager.interact_check);
		key_inventory_press = keyboard_check_pressed(game_manager.inventory_check);
		
		key_fire_press = mouse_check_button(mb_left);
		key_aim_press = mouse_check_button(mb_right);
		key_reload_press = keyboard_check_pressed(game_manager.reload_check);
		
		key_command = keyboard_check_pressed(game_manager.command_check);
		
		cursor_x = mouse_get_x();
		cursor_y = mouse_get_y();
	}
	
	// Player Input break from Interact Pathing
	if (path_interact) {
		if (key_left or key_right or key_jump_press) {
			path_interact_inst = noone;
		}
	}
}
else {
	// Squad Behaviour
	var temp_ai_follow_valid = false;
	if (ai_behaviour) {
		// Squad Follow Behaviour
		if (ai_follow) {
			if (ai_follow_unit != noone) {
				if (instance_exists(ai_follow_unit)) {
					// Squad Unit is Valid & Exists
					temp_ai_follow_valid = true;
					
					// Squad Unit is Player
					if (ai_follow_unit.player_input) {
						squad_aim = true;
					}
				}
			}
		}
	}
	
	// Physics & Combat & Unit Behaviour Inheritance
	event_inherited();
	
	// Reset Squad Aim
	squad_aim = false;
	
	// End Event
	return;
}

// Infinite Range Interact Select
if (canmove and interact_active) {
	// Check Interact Objects with Infinite Range
	if (position_meeting(cursor_x, cursor_y, oInteract)) {
		var temp_interact_number = array_length_1d(interact_collision_list);
		var temp_interact_ir_list = ds_list_create();
		var temp_interact_ir_number = collision_point_list(cursor_x, cursor_y, oInteract, false, true, temp_interact_ir_list, false);
		for (var i = 0; i < temp_interact_ir_number; i++) {
			var temp_interact_object = ds_list_find_value(temp_interact_ir_list, i);
			if (temp_interact_object.active and temp_interact_object.interact_unit == noone) {
				if (temp_interact_object.infinite_range) {
					interact_collision_list[i + temp_interact_number] = temp_interact_object;
				}
			}
		}
		ds_list_destroy(temp_interact_ir_list);
	}
}

// Reset Interact Section
with (oInteract) {
	interact_select = false;
}

// Player Unit Behaviour
var temp_fire_press = key_fire_press;
var temp_aim_press = key_aim_press;
if (canmove) {
	// Command Mode Behaviour
	if (command) {
		// Time Lerp
		if (command_lerp_time) {
			game_manager.time_spd = lerp(game_manager.time_spd, 0.2, 0.3 * global.realdeltatime);
			if (game_manager.time_spd < 0.25) {
				command_lerp_time = false;
				game_manager.time_spd = 0.2;
			}
		}
		
		// Command Mode Behaviour
		if (!inventory_show) {
			// Squad Cursor Behaviour
			var temp_squad_selected = false;
			var temp_squad_selected_inst = noone;
			var temp_squad_selection_list = ds_list_create();
			var temp_squad_selection_num = instance_position_list(cursor_x, cursor_y, oSquad, temp_squad_selection_list, true);
			for (var i = 0; i < temp_squad_selection_num; i++) {
				// Find Squad Object
				var temp_squad_inst = ds_list_find_value(temp_squad_selection_list, i);
					
				// Check Through Squad Units
				if (team_id == temp_squad_inst.team_id) {
					temp_squad_selected_inst = temp_squad_inst;
					temp_squad_selected_inst.squad_hover = true;
					temp_squad_selected = true;
					break;
				}
			}
			ds_list_destroy(temp_squad_selection_list);
			
			// Squad Command Behaviour
			var temp_move_squads = false;
			if (key_fire_press and !old_fire_press) {
				// Squad Selection Behaviour
				if (temp_squad_selected) {
					var temp_squad_select_list_index = ds_list_find_index(squads_selected_list, temp_squad_selected_inst);
					if (temp_squad_select_list_index != -1) {
						ds_list_delete(squads_selected_list, temp_squad_select_list_index);
					}
					else {
						ds_list_add(squads_selected_list, temp_squad_selected_inst);
					}
				}
				else {
					// Selection Empty
					ds_list_clear(squads_selected_list);
				}
			}
			else if (key_aim_press and !old_aim_press) {
				// Move Selected Squads Behaviour
				temp_move_squads = true;
			}
			
			// Squad Selected List Behaviour
			for (var i = ds_list_size(squads_selected_list) - 1; i >= 0; i--) {
				var temp_squad_inst = ds_list_find_value(squads_selected_list, i);
				var temp_squad_exists = false;
				if (temp_squad_inst != noone) {
					if (instance_exists(temp_squad_inst)) {
						// Squad Selected
						temp_squad_exists = true;
						temp_squad_inst.squad_selected = true;
						temp_squad_inst.squad_select_draw_value = 1;
						
						// Move Squads
						if (temp_move_squads) {
							temp_squad_inst.squad_path_create = true;
							temp_squad_inst.squad_path_end_x = cursor_x;
							temp_squad_inst.squad_path_end_y = cursor_y;
							
							// Squad Follow Player
							var temp_squad_move_follow_player_command = point_in_circle(cursor_x, cursor_y, lerp(bbox_left, bbox_right, 0.5), lerp(bbox_top, bbox_bottom, 0.5), (bbox_bottom - bbox_top) / 2);
							for (var l = 0; l < ds_list_size(temp_squad_inst.squad_units_list); l++) {
								var temp_squad_unit_follow_inst = ds_list_find_value(temp_squad_inst.squad_units_list, l);
								
								// Force Movement
								temp_squad_unit_follow_inst.ai_command = true;
								
								// AI Follow
								temp_squad_unit_follow_inst.ai_follow = false;
								temp_squad_unit_follow_inst.ai_follow_unit = noone;
								temp_squad_unit_follow_inst.ai_follow_active = false;
								if (temp_squad_move_follow_player_command) {
									temp_squad_unit_follow_inst.ai_command = false
									temp_squad_unit_follow_inst.ai_follow = true;
									temp_squad_unit_follow_inst.ai_follow_unit = id;
									temp_squad_unit_follow_inst.ai_follow_active = true;
								}
							}
							temp_squad_inst.squad_follow = false;
							temp_squad_inst.squad_follow_unit = noone;
							if (temp_squad_move_follow_player_command) {
								temp_squad_inst.squad_follow = true;
								temp_squad_inst.squad_follow_unit = id;
							}
						}
					}
				}
				if (!temp_squad_exists) {
					ds_list_delete(squads_selected_list, i);
				}
			}
			if (temp_move_squads) {
				ds_list_clear(squads_selected_list);
			}
			
			// Disable Command Mode
			game_manager.cursor_inventory = true;
			if (key_command or key_inventory_press) {
				command = false;
				command_lerp_time = true;
			}
		}
		else {
			// Command Inventory Mode Behaviour
			if (player_input) {
				game_manager.cursor_inventory = true;
			}
			
			// Disable Command Mode & Inventory
			if (key_command or key_inventory_press) {
				command = false;
				command_lerp_time = true;
				inventory_show = false;
			}
		}
		
		// Apply Slow Down Effect
		command_time = true;
		global.deltatime = global.deltatime * command_time_mod;
		
		// Prevent Attacking/Jumping in Inherited Event
		key_up = false;
		key_up_press = false;
		key_down = false;
		key_down_press = false;
		
		key_fire_press = false;
		key_aim_press = false;
		key_reload_press = false;
			
		// Maintain Velocity while in Command Mode
		if (x_velocity < 0) {
			key_left = true;
			key_right = false;
		}
		else if (x_velocity > 0) {
			key_left = false;
			key_right = true;
		}
		else {
			key_left = false;
			key_right = false;
		}
	}
	else {
		// Time Lerp
		if (command_lerp_time) {
			game_manager.time_spd = lerp(game_manager.time_spd, 1, 0.1 * global.realdeltatime);
			if (game_manager.time_spd > 0.95) {
				command_lerp_time = false;
				game_manager.time_spd = 1;
			}
		}
		
		// Command Mode Disabled Behaviour
		if (key_command or key_inventory_press) {
			// Enable Command
			command = true;
			command_lerp_time = true;
			
			// Reset Squad Select
			with (oSquad) {
				squad_select_draw_value = 0;
			}
			ds_list_clear(squads_selected_list);
			
			// Enable Inventory
			if (key_inventory_press) {
				inventory_show = true;
			}
		}
		
		// Interact Behaviour
		if (interact_collision_list != noone) {
			// Interate Through Interact Objects
			for (var q = 0; q < array_length_1d(interact_collision_list); q++) {
				// Check if Object Exists
				var temp_interact_exists = false;
				if (interact_collision_list[q] != noone) {
					if (instance_exists(interact_collision_list[q])) {
						if (object_is_ancestor(interact_collision_list[q].object_index, oInteract) or interact_collision_list[q].object_index == oInteract) {
							temp_interact_exists = true;
						}
					}
				}	
						
				// Teleport Interaction Check
				if (temp_interact_exists) {
					if (interact_collision_list[q].interact_obj.object_index != oTeleport) {
						// Check Cursor Collider
						if (position_meeting(cursor_x, cursor_y, interact_collision_list[q])) {
							// Toggle Interaction Select
							interact_collision_list[q].interact_select = true;
							
							// Cursor Hover
							if (player_input) {
								if (interact_collision_list[q].interact_select_draw_value > 0) {
									game_manager.cursor_icon = true;
									game_manager.cursor_index = interact_collision_list[q].interact_icon_index;
								}
								interact_collision_list[q].interact_description_show = true;
							}
					
							// Interaction Input
							if (key_interact_press) {
								// Interaction Action & Unit Behaviour
								if (!interact_collision_list[q].interact_walk) {
									// Engage Interaction
									interact_collision_list[q].interact_unit = id;
								}
								else {
									// Interaction Walk Behaviour
									path_interact = true;
									path_interact_inst = interact_collision_list[q];
									if (player_input) {
										force_pathing = true;
									}
								}
							}
					
							// Break Loop
							break;
						}
					}
					else {
						// Interaction Input
						if (key_up_press) {
							// Teleport Interact Object Behaviour
							interact_collision_list[q].interact_unit = id;
						}
					}
				}
			}
		}
	}
	
	// Aim Behaviour
	targeting = false;
	if (key_aim_press) {
		targeting = true;
		target_x = cursor_x;
		target_y = cursor_y;
	}
	else if (!firearm and player_input) {
		//targeting = true;
		target_x = cursor_x;
		target_y = cursor_y;
	}
}

// Physics & Combat & Unit Behaviour Inheritance
event_inherited();


// Reset Command Time
if (command_time) {
	command_time = false;
	global.deltatime = global.deltatime / command_time_mod;
}

// Old Click
old_fire_press = temp_fire_press;
old_aim_press = temp_aim_press;

// DEBUG PLAYER ALERT RESET
if (player_input) {
	alert = 0;
}