/// @description Unit AI Update Event
// The AI calculations and behaviour of the Unit

// AI Behaviour
if (ai_behaviour and canmove) {
	// Reset Behaviour
	targeting = false;
	
	// Check AI Stimuli
	var temp_target_exists = false;
	if (sight_unit_nearest != noone) {
		if (instance_exists(sight_unit_nearest)) {
			temp_target_exists = true;
		}
		else {
			sight_unit_seen = false;
			sight_unit_nearest = noone;
		}
	}
	
	// AI Follow Behaviour
	if (ai_follow) {
		// Check if Follow Instance Exists
		var temp_follow_unit_exists = false;
		if (ai_follow_unit != noone) {
			if (instance_exists(ai_follow_unit)) {
				temp_follow_unit_exists = true;
			}
		}
		
		// Follow Calculations
		if (temp_follow_unit_exists) {
			// Check Distance
			if (point_distance(x, y, ai_follow_unit.x, ai_follow_unit.y) > ai_follow_start_radius) {
				// Set Following Active
				if (!ai_follow_active) {
					// Endure Combat
					if (!pathing) {
						if (temp_target_exists) {
							// Check Timer
							ai_follow_combat_timer -= global.deltatime;
							if (ai_follow_combat_timer <= 0) {
								sight_unit_seen = noone;
								ai_follow_active = true;
							}
						}
						else {
							sight_unit_seen = noone;
							ai_follow_active = true;
						}
					}
					else {
						sight_unit_seen = noone;
						ai_follow_active = true;
					}
				}
			}
		}
		else {
			// Garbage Collection
			if (!instance_exists(ai_follow_unit)) {
				pathing = false;
			}
			
			ai_follow = false;
			ai_follow_unit = noone;
			ai_follow_active = false;
		}
	}
	
	// AI Behaviour Switch
	var temp_aggro_behaviour_active = false;
	if (ai_command) {
		// Targeting Behaviour
		key_aim_press = false;
		sight_unit_seen = false;
	}
	else if (ai_follow_active) {
		// Follow Behaviour
		if (!pathing and point_distance(x, y, ai_follow_unit.x, ai_follow_unit.y) <= ai_follow_stop_radius) {
			// Check Distance Reset
			ai_follow_active = false;
			ai_follow_combat_timer = ai_follow_combat_endure_time;
		}
		else {
			// Update Follow Pathing
			if (point_distance(path_end_x, path_end_y, ai_follow_unit.x, ai_follow_unit.y) > ai_follow_stop_radius) {
				// Check if Path Creation won't interrupt Jump
				var temp_valid_edge = true;
				if (path_edge != noone) {
					if (path_edge.jump) {
						temp_valid_edge = false;
					}
				}
				
				// Path Creation
				if (temp_valid_edge) {
					// Path Timer
					ai_pathing_timer++;
					if (ai_pathing_timer >= ai_pathing_delay) {
						// Find Unit Follow Edge
						var temp_ai_follow_unit_edge_data = pathfind_get_closest_point(ai_follow_unit.x, ai_follow_unit.y);
						var temp_ai_follow_unit_edge = temp_ai_follow_unit_edge_data[2];
						
						// Find Edge Points
						var temp_edge_p1_x = temp_ai_follow_unit_edge.nodes[0].x;
						var temp_edge_p1_y = temp_ai_follow_unit_edge.nodes[0].y;
						var temp_edge_p2_x = temp_ai_follow_unit_edge.nodes[1].x;
						var temp_edge_p2_y = temp_ai_follow_unit_edge.nodes[1].y;
						
						// Get Edge Data
						var temp_edge_p1_dis = point_distance(ai_follow_unit.x, ai_follow_unit.y, temp_edge_p1_x, temp_edge_p1_y);
						var temp_edge_p2_dis = point_distance(ai_follow_unit.x, ai_follow_unit.y, temp_edge_p2_x, temp_edge_p2_y);
						var temp_edge_p1_range = max(-temp_edge_p1_dis, -ai_follow_stop_radius / 2);
						var temp_edge_p2_range = min(temp_edge_p2_dis, ai_follow_stop_radius / 2);
						
						// Create Random Point on Edge
						var temp_follow_x = ai_follow_unit.x;
						var temp_follow_y = ai_follow_unit.y;
						var temp_random_edge_placement = irandom_range(temp_edge_p1_range, temp_edge_p2_range);
						if (temp_random_edge_placement < 0) {
							temp_follow_x = lerp(ai_follow_unit.x, temp_edge_p1_x, -temp_edge_p1_range / temp_edge_p1_dis);
							temp_follow_y = lerp(ai_follow_unit.y, temp_edge_p1_y, -temp_edge_p1_range / temp_edge_p1_dis);
						}
						else if (temp_random_edge_placement >= 0) {
							temp_follow_x = lerp(ai_follow_unit.x, temp_edge_p2_x, temp_edge_p2_range / temp_edge_p2_dis);
							temp_follow_y = lerp(ai_follow_unit.y, temp_edge_p2_y, temp_edge_p2_range / temp_edge_p2_dis);
						}
						
						// Create Path
						path_create = true;
						path_end_x = temp_follow_x;
						path_end_y = temp_follow_y;
						ai_pathing_timer = 0;
					}
				}
			}
		}
	}
	else if (ai_follow and squad_aim) {
		// Aim & Fire Where Ai Follow Unit Aims & Fires
		temp_aggro_behaviour_active = false;
		if (ai_follow_unit.squad_key_aim_press) {
			targeting = true;
			key_aim_press = true;
			key_fire_press = ai_follow_unit.squad_key_fire_press;
			target_x = ai_follow_unit.cursor_x;
			target_y = ai_follow_unit.cursor_y;
		}
	}
	else if (temp_target_exists) {
		// Target Visible Movement Behaviour
		if (pathing and ai_hunt) {
			// Redirect Direction to Target if Pathing
			if (sign(target_x - x) != image_xscale) {
				if (sign(target_x - x) != 0) {
					pathing = false;
				}
			}
		}
		
		// Attack Behaviour Active
		temp_aggro_behaviour_active = true;
	}
	else if (sight_unit_seen and ai_hunt and !ai_follow) {
		// Last Seen AI Variables
		var temp_combat_unit_height = hitbox_right_bottom_y_offset - hitbox_left_top_y_offset;
		
		// Last Seen Movement Behaviour
		if (point_distance(x, y - (temp_combat_unit_height / 2), sight_unit_seen_x, sight_unit_seen_y) > ai_inspect_radius) {
			if (point_distance(path_end_x, path_end_y, sight_unit_seen_x, sight_unit_seen_y) > 1) {
				path_create = true;
				path_end_x = sight_unit_seen_x;
				path_end_y = sight_unit_seen_y;
			}
		}
		else {
			pathing = false;
		}
		
		// Targeting Behaviour
		if (point_distance(x, y - (temp_combat_unit_height / 2), sight_unit_seen_x, sight_unit_seen_y) > (sight_radius / 2)) {
			// Target Unit Last Seen
			targeting = true;
				
			target_x = sight_unit_seen_x;
			target_y = sight_unit_seen_y;
		}
	}
	else if (ai_patrol) {
		// Patrol Behaviour
		if (ai_patrol_active) {
			// AI Patrol Active
			if (ai_patrol_sustain_timer > 0) {
				// Patrol Sustain Timer
				if (!pathing) {
					ai_patrol_sustain_timer -= global.deltatime;
				}
			}
			else {
				// Find New Patrol Location
				var temp_patrol_node_list = ds_list_create();
				for (var i = 0; i < instance_number(oPatrolNode); i++) {
					var temp_patrol_node_inst = instance_find(oPatrolNode, i);
					if (ai_patrol_id == temp_patrol_node_inst.patrol_id) {
						ds_list_add(temp_patrol_node_list, temp_patrol_node_inst);
					}
				}
				if (!ds_list_empty(temp_patrol_node_list)) {
					while(ds_list_size(temp_patrol_node_list) > 0) {
						var temp_patrol_node_random_index = irandom(ds_list_size(temp_patrol_node_list) - 1);
						var temp_patrol_node_inst = ds_list_find_value(temp_patrol_node_list, temp_patrol_node_random_index);
						if (temp_patrol_node_inst != ai_patrol_node) {
							ai_patrol_node = temp_patrol_node_inst;
							break;
						}
						else {
							ds_list_delete(temp_patrol_node_list, temp_patrol_node_random_index);
						}
					}
				}
				else {
					ai_patrol_node = noone;
				}
				ds_list_destroy(temp_patrol_node_list);
				temp_patrol_node_list = -1;
			
				// Patrol Pathfinding
				var temp_patrol_path_exists = false;
				if (ai_patrol_node != noone) {
					if (instance_exists(ai_patrol_node)) {
						temp_patrol_path_exists = true;
						path_create = true;
						path_end_x = ai_patrol_node.x;
						path_end_y = ai_patrol_node.y;
						ai_patrol_sustain_timer = ai_patrol_sustain_time + irandom(ai_patrol_sustain_random_time);
					}
				}
				if (!temp_patrol_path_exists) {
					ai_patrol = false;
				}
			}
		}
		else {
			// AI Patrol Inactive Timer
			ai_patrol_inactive_timer -= global.deltatime;
			if (ai_patrol_inactive_timer <= 0) {
				ai_patrol_active = true;
			}
		}
	}
	
	// Attack Behaviour
	if (temp_aggro_behaviour_active) {
		// Targeting Behaviour
		targeting = true;
				
		// Find Target Center
		var temp_unit_height = sight_unit_nearest.hitbox_right_bottom_y_offset - sight_unit_nearest.hitbox_left_top_y_offset;
		target_x = sight_unit_nearest.x;
		target_y = sight_unit_nearest.y - (temp_unit_height / 2);
					
		// Valid Targeting Position
		if (alert >= alert_threshold) {
			if (!platform_free(x, y + 1, platform_list)) {
				// Set Aim Behaviour
				key_aim_press = true;
			}
		}
		
		// Reset AI Patrol
		ai_patrol_active = false;
		ai_patrol_inactive_timer = ai_patrol_inactive_time;
	}
	else if (ai_patrol and ai_patrol_active) {
		// Patrol Alert
		alert = clamp(alert, alert_threshold * 0.5, 1.0);
		
		// Patrol Target Position
		var temp_weapon_distance = point_distance(0, 0, (draw_xscale * image_xscale * weapon_aim_x), (draw_yscale * image_yscale * weapon_aim_y));
		var temp_weapon_direction = point_direction(0, 0, (draw_xscale * image_xscale * weapon_aim_x), (draw_yscale * image_yscale * weapon_aim_y));
		target_x = x + lengthdir_x(temp_weapon_distance, temp_weapon_direction + draw_angle) + (sign(image_xscale) * 200);
		target_y = y + lengthdir_y(temp_weapon_distance, temp_weapon_direction + draw_angle) - ((sin(degtorad(draw_angle)) * (bbox_left - bbox_right)) / 2);
		
		// Aim Walk Targeting
		if (pathing) {
			targeting = true;
			key_aim_press = true;
		}
		
		// Alert set Patrol Inactive
		if (alert >= alert_threshold) {
			ai_patrol_active = false;
		}
	}
}

// Inherit the parent event
event_inherited();