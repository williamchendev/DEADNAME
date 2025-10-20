/// @description Unit Update Event

// Health & Death Behaviour //
if (unit_health <= 0)
{
	// Check if Unit is in Squad
	if (squad_id != SquadIDNull)
	{
		// Remove Unit from Squad
		GameManager.squad_behaviour_director.remove_unit_from_squad(squad_id, id);
	}
	
	// Drop Unit's Inventory Items
	unit_inventory_remove_all_slots(id);
	
	// Create Unit Ragdoll
	unit_create_ragdoll(id);
	
	// Remove Unit from Lighting Engine
	lighting_engine_remove_object(id);
	
	// Destroy Instance & Early Return
	instance_destroy(id);
	return;
}

// Unit Behaviour //
#region Unit Behaviour
if (!player_input)
{
	// Establish Behaviour Variables
	var temp_squad_properties = undefined;
	var temp_squad_leader_instance = undefined;
	
	var temp_follow_behaviour_unit_instance = undefined;
	var temp_follow_behaviour_squad_movement_position_x = x;
    var temp_follow_behaviour_squad_movement_position_y = y;
	
	// Unit Squad Behaviour
	if (squad_id != SquadIDNull)
	{
		// Establish Squad Index
		var temp_squad_index = ds_map_find_value(GameManager.squad_behaviour_director.squad_ids_map, squad_id);
		
		// Establish Squad Properties
		temp_squad_properties = ds_list_find_value(GameManager.squad_behaviour_director.squad_properties_list, temp_squad_index);
		
		// Check if Squad Index Exists
		if (!is_undefined(temp_squad_index) and ds_list_find_value(GameManager.squad_behaviour_director.squad_exists_list, temp_squad_index))
		{
			// Establish Squad Leader
			temp_squad_leader_instance = ds_list_find_value(GameManager.squad_behaviour_director.squad_leader_list, temp_squad_index);
			
			// Check if Squad Unit belongs to Player Squad Leader controlled Squad
			if (!temp_squad_leader_instance.player_input)
			{
				// Squad Unit Behaviour tree
				if (id == temp_squad_leader_instance)
				{
					// Establish Squad Behaviour Type
					var temp_squad_behaviour = ds_list_find_value(GameManager.squad_behaviour_director.squad_behaviour_list, temp_squad_index);
					
					// Squad Leader Behaviour
					switch (temp_squad_behaviour)
					{
						case SquadBehaviour.Hunting:
							break;
						case SquadBehaviour.Patrol:
							break;
						case SquadBehaviour.Sentry:
							break;
						case SquadBehaviour.Action:
							break;
						case SquadBehaviour.Idle:
						default:
							break;
					}
				}
				
				// Recalculate Non-Player Squad Leader's Squad Unit Pathfinding Behaviour
				if (pathfinding_recalculate)
				{
					// Check if Unit's Pathfinding Path Recalculation Condition is Valid
					var temp_squad_movement_recalculate_command_valid = true;
					
					if (!is_undefined(pathfinding_path) and pathfinding_path.path_size >= 1)
					{
						var temp_last_path_position_x = ds_list_find_value(pathfinding_path.position_x, pathfinding_path.path_size - 1);
						var temp_last_path_position_y = ds_list_find_value(pathfinding_path.position_y, pathfinding_path.path_size - 1);
						
						if (point_distance(pathfinding_path_end_x, pathfinding_path_end_y, temp_last_path_position_x, temp_last_path_position_y) <= 1)
						{
							temp_squad_movement_recalculate_command_valid = false;
						}
					}
					
					// Recalculate Unit's Individual Squad Path
					if (temp_squad_movement_recalculate_command_valid)
					{
						// Set Unit Pathfinding Path Start
						pathfinding_path_start_x = x;
						pathfinding_path_start_y = y;
						
						// Reset and Calculate Path Data
						if (!is_undefined(pathfinding_path))
						{
							// Create Recalculated Path
							var temp_recalculated_path = pathfinding_recalculate_path(pathfinding_path_index, pathfinding_path, pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y));
							
							// Delete and Reset Previous Path
							pathfinding_delete_path(pathfinding_path);
							pathfinding_path = undefined;
							
							// Set New Path and Reset Pathfinding Index
							pathfinding_path = temp_recalculated_path;
							pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
						}
						else
						{
							// Delete and Reset Previous Path
							pathfinding_delete_path(pathfinding_path);
							pathfinding_path = undefined;
							
							// Calculate New Path and Reset Pathfinding Index
							pathfinding_path = pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y);
							pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
						}
						
						// Reset Pathfinding Variables
						pathfinding_recalculate = false;
						pathfinding_path_ended = false;
						pathfinding_jump = true;
					}
					else
					{
						// Recalculation was invalid
						pathfinding_recalculate = false;
					}
				}
			}
			else
			{
				// Unit is matching Player Unit's Attack Behaviour - Remove Combat Assignment
				combat_target = undefined;
				combat_strategy = UnitCombatStrategy.NullStrategy;
				combat_priority_rank = UnitCombatPriorityRank.NullPriorityCombat;
				
				// Establish Player Input Squad Unit Follow Conditions
				var temp_player_input_squad_unit_follow_condition_within_range_horizontal = abs(x - temp_squad_leader_instance.x) <= temp_squad_properties.following_range_horizontal_distance;
				var temp_player_input_squad_unit_follow_condition_within_range_vertical = abs(y - temp_squad_leader_instance.y) <= temp_squad_properties.following_range_vertical_distance;
				var temp_player_input_squad_unit_follow_condition_leader_is_moving = temp_squad_leader_instance.x_velocity != 0 or temp_squad_leader_instance.y_velocity != 0;
				
				// Establish Player Input Squad Unit List
				var temp_player_input_squad_unit_instances_list = ds_list_find_value(GameManager.squad_behaviour_director.squad_units_list, temp_squad_index);
				
				// Find direction of last movement position so Squad Units are always in front of the Squad Leader to shield from danger
				var temp_player_input_squad_leader_unit_within_squad_list_index = ds_list_find_index(temp_player_input_squad_unit_instances_list, temp_squad_leader_instance);
				var temp_player_input_squad_unit_within_squad_list_index = ds_list_find_index(temp_player_input_squad_unit_instances_list, id);
				
				var temp_player_input_squad_spacing_count = -((ds_list_size(temp_player_input_squad_unit_instances_list) - 1) div 2);
				
				if ((ds_list_size(temp_player_input_squad_unit_instances_list) - 1) mod 2 == 1)
				{
					temp_player_input_squad_spacing_count += (temp_squad_leader_instance.draw_xscale == 0 ? temp_squad_properties.facing_direction : sign(temp_squad_leader_instance.draw_xscale)) == -1 ? -1 : 0;
				}
				
				temp_player_input_squad_spacing_count += temp_player_input_squad_unit_within_squad_list_index - (temp_player_input_squad_unit_within_squad_list_index < temp_player_input_squad_leader_unit_within_squad_list_index ? 0 : 1);
				temp_player_input_squad_spacing_count += temp_player_input_squad_spacing_count >= 0 ? 1 : 0;
				
				// Find movement position of Player Input Squad Unit from Squad Leader
				temp_follow_behaviour_squad_movement_position_x = temp_squad_leader_instance.x;
				temp_follow_behaviour_squad_movement_position_y = temp_squad_leader_instance.y;
				
				var temp_player_input_squad_unit_movement_closest_point = pathfinding_get_closest_point_on_edge(temp_squad_leader_instance.x + (temp_player_input_squad_spacing_count * temp_squad_properties.squad_unit_spacing), temp_squad_leader_instance.y, PathfindingEdgeType.DefaultEdge);
				temp_follow_behaviour_squad_movement_position_x = temp_player_input_squad_unit_movement_closest_point.return_x;
				temp_follow_behaviour_squad_movement_position_y = temp_player_input_squad_unit_movement_closest_point.return_y;
				
				// Player Input Squad Unit Following Behaviour
				if (temp_player_input_squad_unit_follow_condition_within_range_horizontal and temp_player_input_squad_unit_follow_condition_within_range_vertical and temp_player_input_squad_unit_follow_condition_leader_is_moving)
				{
					// Unit within follow range - Unit follows Squad Leader
					temp_follow_behaviour_unit_instance = temp_squad_leader_instance;
					
					// Unit matches Player Unit's Input Condition
					input_attack = temp_squad_leader_instance.input_attack;
					input_aim = temp_squad_leader_instance.input_aim;
					
					input_cursor_x = temp_squad_leader_instance.input_cursor_x;
					input_cursor_y = temp_squad_leader_instance.input_cursor_y;
				}
				else
				{
					// Check if Pathfinding Target is within Valid Range of Squad Leader's Movement Position
					if (!pathfinding_recalculate and !is_undefined(pathfinding_path) and pathfinding_path.path_size >= 1)
					{
						var temp_player_input_squad_unit_path_end_x = ds_list_find_value(pathfinding_path.position_x, pathfinding_path.path_size - 1);
						var temp_player_input_squad_unit_path_end_y = ds_list_find_value(pathfinding_path.position_y, pathfinding_path.path_size - 1);
						
						if (point_distance(temp_follow_behaviour_squad_movement_position_x, temp_follow_behaviour_squad_movement_position_y, temp_player_input_squad_unit_path_end_x, temp_player_input_squad_unit_path_end_y) > (temp_squad_properties.squad_random_spacing * 2) + 2)
						{
							pathfinding_recalculate = true;
						}
					}
					
					// Recalculate Pathfinding Target to Squad Leader's Movement Position
					if (pathfinding_recalculate)
					{
						// Set Unit Pathfinding Path Start & End
						pathfinding_path_start_x = x;
						pathfinding_path_start_y = y;
						
						pathfinding_path_end_x = temp_follow_behaviour_squad_movement_position_x + random_range(-temp_squad_properties.squad_random_spacing, temp_squad_properties.squad_random_spacing);
						pathfinding_path_end_y = temp_follow_behaviour_squad_movement_position_y;
						
						// Reset and Calculate Path Data
						if (!is_undefined(pathfinding_path))
						{
							// Create Recalculated Path
							var temp_recalculated_path = pathfinding_recalculate_path(pathfinding_path_index, pathfinding_path, pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y));
							
							// Delete and Reset Previous Path
							pathfinding_delete_path(pathfinding_path);
							pathfinding_path = undefined;
							
							// Set New Path and Reset Pathfinding Index
							pathfinding_path = temp_recalculated_path;
							pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
						}
						else
						{
							// Delete and Reset Previous Path
							pathfinding_delete_path(pathfinding_path);
							pathfinding_path = undefined;
							
							// Calculate New Path and Reset Pathfinding Index
							pathfinding_path = pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y);
							pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
						}
						
						// Reset Pathfinding Variables
						pathfinding_recalculate = false;
						pathfinding_path_ended = false;
						pathfinding_jump = true;
					}
					
					// Pathfinding Aim & Attack Input Behaviour
					if (is_undefined(pathfinding_path) or pathfinding_path_ended)
					{
						input_attack = temp_squad_leader_instance.input_attack;
						input_aim = temp_squad_leader_instance.input_aim;
						
						input_cursor_x = temp_squad_leader_instance.input_cursor_x;
						input_cursor_y = temp_squad_leader_instance.input_cursor_y;
					}
					else
					{
						input_attack = false;
						input_aim = false;
					}
				}
			}
		}
		else
		{
			// Squad does not exist - Remove self from Squad
			squad_id = SquadIDNull;
		}
	}
	else
	{
		// Non-Squad Unit Behaviour
	}
    
    // Universal Pathfinding Movement Behaviour
    if (!is_undefined(temp_follow_behaviour_unit_instance))
    {
		// Horizontal Movement for Unit Follow Behaviour
		input_left = temp_follow_behaviour_unit_instance.input_left;
		input_right = temp_follow_behaviour_unit_instance.input_right;
		
		// Prevent Horizontal Movement Overshoot outside range of Squad Follow Range
		var temp_hypothetical_horizontal_movement = (input_left ? -1 : 1) * (weapon_aim || unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload ? walk_spd : run_spd);
		
		if (input_left or input_right) 
		{
			// Check if Unit would move outside Horizontal Squad Follow Range
			if (abs((x + temp_hypothetical_horizontal_movement) - temp_follow_behaviour_unit_instance.x) > ds_list_find_value(GameManager.squad_behaviour_director.squad_properties_list, temp_squad_index).following_range_horizontal_distance)
			{
				// Unit would move outside Squad Horizontal Follow Range - Halt Squad Unit Horizontal Movement
				input_left = false;
				input_right = false;
				
				temp_hypothetical_horizontal_movement = 0;
			}
		}
		
		// Platform Drop-Down Movement for Unit Follow Behaviour
		input_drop_down = temp_follow_behaviour_unit_instance.input_drop_down;
		
		// Vertical Movement for Unit Follow Behaviour
		input_jump_hold = temp_follow_behaviour_unit_instance.input_jump_hold;
		input_double_jump = temp_follow_behaviour_unit_instance.input_double_jump;
		
		// Toggle Recalculate Pathfinding
		if (point_distance(x + temp_hypothetical_horizontal_movement, y, temp_follow_behaviour_squad_movement_position_x, temp_follow_behaviour_squad_movement_position_y) < (temp_squad_properties.squad_random_spacing * 2) + 2)
		{
			if (!is_undefined(pathfinding_path))
			{
				pathfinding_path_index = pathfinding_path.path_size;
				
				// Pathfinding Ended - Set Unit's Facing Direction to Path's End Direction
				switch (pathfinding_path.path_end_direction)
				{
					case PathfindingEndDirection.Left:
						draw_xscale = abs(draw_xscale) * -1;
						break;
					case PathfindingEndDirection.Right:
						draw_xscale = abs(draw_xscale);
						break;
					case PathfindingEndDirection.Random:
						draw_xscale = abs(draw_xscale) * (random(1.0) > 0.5 ? 1 : -1);
						break;
					case PathfindingEndDirection.None:
					default:
						break;
				}
			}
			
			pathfinding_path_ended = true;
			pathfinding_recalculate = false;
		}
		else
		{
			pathfinding_recalculate = true;
		}
    }
    else if (!pathfinding_path_ended and !is_undefined(pathfinding_path) and pathfinding_path_index < pathfinding_path.path_size)
    {
		// Unit Pathfinding Follow Behaviour
		while (pathfinding_path_index < pathfinding_path.path_size)
		{
			// Establish Path Target Details
			var temp_pathfinding_path_target_position_x = ds_list_find_value(pathfinding_path.position_x, pathfinding_path_index);
			var temp_pathfinding_path_target_position_y = ds_list_find_value(pathfinding_path.position_y, pathfinding_path_index);
			var temp_pathfinding_path_target_edge_id = ds_list_find_value(pathfinding_path.edge_id, pathfinding_path_index);
			var temp_pathfinding_path_target_edge_type = ds_list_find_value(pathfinding_path.edge_type, pathfinding_path_index);
			
			// Establish Path Target Variables
			var temp_pathfinding_target_horizontal_position_reached = false;
			var temp_pathfinding_target_vertical_position_reached = true;
			
			// Pathfinding Horizontal Movement Behaviour
			if (x - run_spd > temp_pathfinding_path_target_position_x)
			{
				// Left Horizontal Movement
				input_left = true;
				input_right = false;
			}
			else if (x + run_spd < temp_pathfinding_path_target_position_x)
			{
				// Right Horizontal Movement
				input_left = false;
				input_right = true;
			}
			else
			{
				// Halt Horizontal Movement
				input_left = false;
				input_right = false;
				
				// Horizontal Target Reached
				temp_pathfinding_target_horizontal_position_reached = true;
			}
			
			// Pathfinding Vertical Movement Behaviour
			if (temp_pathfinding_path_target_edge_type == PathfindingEdgeType.JumpEdge)
			{
				// Jump Edge Verical Movement Behaviour
				temp_pathfinding_target_vertical_position_reached = false;
				
				// Check if Pathfinding Target of Jump Edge is vertically above or below previous Pathfinding Target
				if (ds_list_find_value(pathfinding_path.position_y, max(0, pathfinding_path_index - 1)) > ds_list_find_value(pathfinding_path.position_y, pathfinding_path_index))
				{
					// Current Pathfinding Target is Above Previous Target - Jump is necessary
					if (y > temp_pathfinding_path_target_position_y + (grounded ? 0 : jump_pathfinding_behaviour_target_padding))
					{
						// Pathfinding Jump Behaviour
						if (!grounded)
						{
							// Hold Jump to continue upwards velocity
							input_jump_hold = true;
							pathfinding_jump = false;
							
							// Double Jump when vertical velocity reaches inevitable downwards velocity in Jump Arc
							if (y_velocity > 0) 
							{
								input_double_jump = true;
							}
						}
						else
						{
							// Begin Jump from grounded orientation or reset Jump Delay to prevent pathfinding related physics issues
							if (pathfinding_jump)
							{
								input_jump_hold = true;
								pathfinding_jump = false;
							}
							else if (alarm_get(1) == -1 || alarm_get(1) == 0)
							{
								alarm_set(1, 15);
							}
						}
					}
					else
					{
						// Current Pathfinding Target is Below Unit Vertical Position - Pathfinding Jump Target Reached
						input_jump_hold = false;
						input_double_jump = false;
						pathfinding_jump = false;
					}
				}
				else
				{
					// Current Pathfinding Target is Below Previous Target - Jump not necessary
					input_jump_hold = false;
					input_double_jump = false;
					pathfinding_jump = false;
				}
				
				// Pathfinding Platform Drop-Down Vertical Movement Behaviour
				if (y < temp_pathfinding_path_target_position_y)
				{
					if (y_velocity == 0)
					{
						input_drop_down = true;
					}
					else
					{
						input_drop_down = false;
					}
				}
				else
				{
					input_drop_down = false;
				}
				
				// Check if Pathfinding Vertical Movement Target Reached
				if (abs(y - temp_pathfinding_path_target_position_y) < 1)
				{
					// Vertical Target Reached
					temp_pathfinding_target_vertical_position_reached = true;
				}
			}
			else
			{
				// Reset Vertical Movement Behaviour
				input_jump_hold = false;
				input_double_jump = false;
				input_drop_down = false;
			}
			
			// Check if Pathfinding Target Reached
			if (temp_pathfinding_target_horizontal_position_reached and temp_pathfinding_target_vertical_position_reached)
			{
				// Reset Pathfinding Jump Delay
				pathfinding_jump = true;
				
				// Increment Pathfinding Path Index and Calculate Pathfinding Path Ended Condition
				pathfinding_path_index++;
				pathfinding_path_ended = (pathfinding_path_index == pathfinding_path.path_size);
				
				// Pathfinding Path Ended Behaviour
				if (pathfinding_path_ended)
				{
					// Path Ended Behaviour Condition Tree
					if (!is_undefined(temp_squad_leader_instance) and temp_squad_leader_instance.player_input)
					{
						// Player Squad Leader - Squad Unit Facing Direction Match Behaviour
						draw_xscale = temp_squad_leader_instance.draw_xscale != 0 ? sign(temp_squad_leader_instance.draw_xscale) * abs(draw_xscale) : draw_xscale;
					}
					else
					{
						
					}
					
					// Pathfinding Ended - Set Unit's Facing Direction to Path's End Direction
					switch (pathfinding_path.path_end_direction)
					{
						case PathfindingEndDirection.Left:
							draw_xscale = abs(draw_xscale) * -1;
							break;
						case PathfindingEndDirection.Right:
							draw_xscale = abs(draw_xscale);
							break;
						case PathfindingEndDirection.Random:
							draw_xscale = abs(draw_xscale) * (random(1.0) > 0.5 ? 1 : -1);
							break;
						case PathfindingEndDirection.None:
						default:
							break;
					}
				}
			}
			else
			{
				break;
			}
		}
    }
    else
    {
		// Reset Pathfinding Unit Movement Behaviour
		input_left = false;
		input_right = false;
		
		input_drop_down = false;
		
		input_jump_hold = false;
		input_double_jump = false;
    }
    
    // COMBAT //
	// Combat Behaviour
	if (!is_undefined(combat_target) and instance_exists(combat_target))
	{
		// Calculate Weapon's Target Vertical Interpolation Height
		var temp_combat_target_vertical_interpolation_height = lerp(combat_target.bbox_bottom, combat_target.bbox_top, combat_target_vertical_interpolation) - combat_target.y;
		
		// Pull Combat Target Unit's Pre-calc Slope Angle
		trig_sine = combat_target.draw_angle_trig_sine;
		trig_cosine = combat_target.draw_angle_trig_cosine;
		
		// Calculate Weapon's Target Position
		input_cursor_x = combat_target.x + rot_point_x(0, temp_combat_target_vertical_interpolation_height);
		input_cursor_y = combat_target.y + rot_point_y(0, temp_combat_target_vertical_interpolation_height);
		
		// Combat Weapon Behaviour
		switch (unit_equipment_animation_state)
		{
			case UnitEquipmentAnimationState.FirearmReload:
				// Reset Weapon Reload Behaviour
				input_reload = false;
				break;
			case UnitEquipmentAnimationState.Firearm:
				// Combat Aim Firearm Weapon Behaviour
				input_aim = pathfinding_path_ended;
				
				// Reset Combat Firearm Weapon Attack Condition
				input_attack = false;
				
				// Combat Firearm Weapon Attack Behaviour
				if (input_aim)
				{
					// Calculate Unit's Combat Aim Recovery
					combat_target_aim_value += combat_target_aim_recovery_spd * frame_delta;
					
					// Check if Unit has Combat Target within sight & Unit's Firearm is prepared to attack
					if (combat_target_aim_value >= 1.0 and item_equipped.weapon_attack_reset)
					{
						// Decrement Unit's Combat Attack Delay
						combat_attack_delay -= frame_delta;
						
						// Check if Unit can perform Combat Attack with their Firearm
						if (combat_attack_delay <= 0)
						{
							// Firearm Recoil Aim Adjustment
							if (item_equipped.weapon_angle_recoil > 0)
							{
								// Calculate Firearm Target Direction & Distance
								var temp_combat_firearm_recoil_angle = point_direction(item_equipped.item_x, item_equipped.item_y, input_cursor_x, input_cursor_y);
								var temp_combat_firearm_recoil_distance = point_distance(item_equipped.item_x, item_equipped.item_y, input_cursor_x, input_cursor_y);
								
								// Adjust Firearm Target Direction by the Inverse of the Firearm's Recoil Angle
								temp_combat_firearm_recoil_angle -= item_equipped.weapon_angle_recoil * item_equipped.item_facing_sign;
								
								// Calculate Firearm Recoil Target Position
								rot_prefetch(temp_combat_firearm_recoil_angle);
								
								// Adjust Firearm Aim Position by the negative of its Recoil Offset to the actual Combat Target Position
								input_cursor_x = item_equipped.item_x + rot_dist_x(temp_combat_firearm_recoil_distance);
								input_cursor_y = item_equipped.item_y + rot_dist_y(temp_combat_firearm_recoil_distance);
							}
							
							// Unit AI Behaviour - Aim Firearm
							input_attack = true;
						}
					}
				}
				
				// Combat Firearm Weapon Behaviours
				if (equipment_active)
				{
					switch (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type)
					{
						case WeaponType.Firearm:
						case WeaponType.BoltActionFirearm:
							// Check Firearm Weapon Reload Behaviour
							if (item_equipped.firearm_ammo <= 0)
							{
								// Unit AI Behaviour - Perform Firearm Reload
								input_reload = true;
								
								// Unit AI Behaviour - Reset Firearm Aim & Attack Conditions
								input_aim = false;
								input_attack = false;
							}
							break;
						default:
						    break;
					}
				}
				break;
			default:
				break;
		}
		
		// Combat Line of Sight Calculation
		if (combat_sight_calculation_delay == 0)
		{
			// Calculate Unit and Combat Target's Half Height
			var temp_unit_half_height = (bbox_bottom - bbox_top) * 0.5;
			var temp_combat_target_half_height = (combat_target.bbox_bottom - combat_target.bbox_top) * 0.5;
			
			// Calculate Sight Ignore Radius
			var temp_sight_ignore_radius = (squad_id != SquadIDNull) ? temp_squad_properties.sight_ignore_radius : sight_ignore_radius;
			
			// Check if this Unit Instance and Combat Assignment's Unit Instance share continuous Line of Sight
			if (collision_line(x, y - temp_unit_half_height, combat_target.x, combat_target.y - temp_combat_target_half_height, oSolid, false, true) or point_distance(x, y - temp_unit_half_height, combat_target.x, combat_target.y - temp_combat_target_half_height) > temp_sight_ignore_radius)
			{
				// Unit's line of sight with Combat Assignment's Unit Instance has been broken
				input_aim = false;
				input_attack = false;
				
				// Reset Combat Assignment Variables
				combat_target = undefined;
				combat_strategy = UnitCombatStrategy.NullStrategy;
				combat_priority_rank = UnitCombatPriorityRank.NullPriorityCombat;
				
				// Reset Combat Aim Variables
				combat_target_aim_value = 0;
			}
		}
	}
	else
	{
		// Combat Assignment's Unit Instance has been neutralized
		input_aim = false;
		input_attack = false;
		
		// Reset Combat Assignment Variables
		combat_target = undefined;
		combat_strategy = UnitCombatStrategy.NullStrategy;
		combat_priority_rank = UnitCombatPriorityRank.NullPriorityCombat;
		
		// Reset Combat Aim Variables
		combat_target_aim_value = 0;
	}
	
	combat_sight_calculation_delay = combat_sight_calculation_delay - 1 <= -1 ? GameManager.sight_collision_calculation_frame_delay : combat_sight_calculation_delay - 1;
}

// MOVEMENT //
// Movement Behaviour
if (canmove)
{
	// Unit Weapon Behaviour
	if (equipment_active)
	{
		// Unit Weapon Aiming Behaviour
		if (input_aim)
		{
			// Firearm Aiming Reload Interrupt Behaviour
			if (!weapon_aim and global.item_packs[item_equipped.item_pack].item_type == ItemType.Weapon)
			{
				// Weapon Type impacts Reload Interrupt Animation
				if (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.Firearm)
				{
					// Default Firearm Weapon Interrupt Animation - End Reload Animation
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
					
					// End Firearm Spin Reload Behaviour
					item_equipped.firearm_spin_reload = false;
					item_equipped.firearm_spin_reload_angle = 0;
					
					// Drop all Held Items in Unit's Hands
					limb_primary_arm.drop_all_held_items();
					limb_secondary_arm.drop_all_held_items();
					
					// Set Primary Hand's Firearm Animation Path - From "any arbitrary position the primary hand was positioned during the reload animation" to Firearm's Trigger Group Position (Inversed Path Interpolation Value)
					unit_set_firearm_hand_animation
					(
						global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand ? global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_x : global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x, 
						global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand ? global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_y : global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y, 
						lerp(firearm_weapon_hand_pivot_offset_ax, firearm_weapon_hand_pivot_offset_bx, firearm_weapon_hand_pivot_transition_value) + hand_fumble_animation_offset_x, 
						lerp(firearm_weapon_hand_pivot_offset_ay, firearm_weapon_hand_pivot_offset_by, firearm_weapon_hand_pivot_transition_value) + hand_fumble_animation_offset_y, 
						1
					);
				}
				else if (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.BoltActionFirearm)
				{
					// Check if Reload Animation State is Interruptable
					var temp_bolt_action_firearm_reload_animation_is_interruptable;
					
					switch (unit_firearm_reload_animation_state)
					{
						case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
						case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
						case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
						case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
						case UnitFirearmReloadAnimationState.ReloadBoltHandle_End:
							temp_bolt_action_firearm_reload_animation_is_interruptable = false;
							break;
						default:
							temp_bolt_action_firearm_reload_animation_is_interruptable = true;
							break;
					}
					
					// Bolt Action Firearm Reload Interrupt
					if (temp_bolt_action_firearm_reload_animation_is_interruptable)
					{
						// Bolt Action Firearm Weapon Interrupt Animation - End Reload Animation but close Bolt Action Firearm's Chamber to be ready to fire the next shot
						unit_firearm_reload_animation_state = item_equipped.item_image_index == 1 ? UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition : UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
						
						// Drop all Held Items in Unit's Hands
						limb_primary_arm.drop_all_held_items();
						limb_secondary_arm.drop_all_held_items();
						
						// Set Primary Hand's Firearm Animation Path - From "any arbitrary position the primary hand was positioned during the reload animation" to Firearm's Bolt Handle Open Chamber Position
						unit_set_firearm_hand_animation
						(
							lerp(firearm_weapon_hand_pivot_offset_ax, firearm_weapon_hand_pivot_offset_bx, firearm_weapon_hand_pivot_transition_value) + hand_fumble_animation_offset_x, 
							lerp(firearm_weapon_hand_pivot_offset_ay, firearm_weapon_hand_pivot_offset_by, firearm_weapon_hand_pivot_transition_value) + hand_fumble_animation_offset_y, 
							global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_x, 
							global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_y, 
							0
						);
					}
				}
				
				// Reset Hand Fumble Animation Values
				hand_fumble_animation_offset_x = 0;
				hand_fumble_animation_offset_y = 0;
			}
			
			// Enable Unit Weapon Aim
			weapon_aim = true;
			weapon_aim_x = input_cursor_x;
			weapon_aim_y = input_cursor_y;
		}
		else
		{
			// Disable Unit Weapon Aim
			weapon_aim = false;
			weapon_aim_x = x + (sign(draw_xscale) * 320);
			weapon_aim_y = y - global.unit_packs[unit_pack].equipment_firearm_hip_y;
		}

		// Unit Weapon Operation Behaviour
		if (global.item_packs[item_equipped.item_pack].item_type == ItemType.Weapon)
		{
			if (input_reload)
			{
				// Weapon Reload Action Behaviour
				if (unit_equipment_animation_state == UnitEquipmentAnimationState.Thrown and (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.Molotov or global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.Grenade))
				{
					// Check if Thrown Weapon Instance's Safety is Engaged
					if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowWindup and item_equipped.thrown_weapon_safety_active)
					{
						// Perform Operate Grenade Pin Pull or Molotov Ignition Animation
						unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.OperateAction_MoveHandsToReadyWeapon;
						
						// Reset Thrown Weapon's Operate Animation Value
						thrown_weapon_operate_transition_value = 0;
					}
				}
				else if (unit_equipment_animation_state == UnitEquipmentAnimationState.Firearm and item_equipped.firearm_ammo < global.item_packs[item_equipped.item_pack].weapon_data.firearm_ammo_max_capacity)
				{
					// Check if Firearm Ammo Item Pack Exists
					var temp_firearm_reload_ammo_item_pack_exists = unit_inventory_check_item(id, global.item_packs[item_equipped.item_pack].weapon_data.firearm_ammo_item_pack);
					
					if (temp_firearm_reload_ammo_item_pack_exists)
					{
						// Perform Firearm Reload
						unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
						
						// Firearm Drop Magazine Animation
						if (global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_magazine and item_equipped.firearm_magazine_inserted)
						{
							item_equipped.eject_magazine();
						}
						
						// Reload Animation
						switch (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type)
						{
							case WeaponType.BoltActionFirearm:
								// Initiate Bolt Action Reload
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
								
								// Weapon Primary Hand Animation: Hand reaches from Firearm's Trigger Group Position to Firearm's Closed Bolt Handle Position
								unit_set_firearm_hand_animation
								(
									global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x, 
									global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y, 
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x, 
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y
								);
								break;
							default:
								// Initiate Default Firearm Reload
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory;
								
								// Open Firearm Chamber
								if (!global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_spin)
								{
									item_equipped.open_firearm_chamber();
								}
								
								// Weapon Hand Animation Reset
								if (!global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
								{
									// Primary Hand Reload Animation Reset
									unit_set_firearm_hand_animation
									(
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x,
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y,
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x,
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y,
									);
								}
								else
								{
									// Secondary Hand Reload Animation Reset
									unit_set_firearm_hand_animation
									(
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_x, 
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_y, 
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_x, 
										global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_y, 
									);
								}
								break;
						}
						
						// Firearm Reload Spin Animation Behaviour
						item_equipped.firearm_spin_reload = global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_spin;
						
						// Reset Primary Hand Weapon Relative Pivot Values
						firearm_weapon_hand_pivot_transition_value = 0;
						
						// Reset Primary Hand Unit Inventory Pivot Values
						firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;
					}
				}
			}
			else if (input_attack)
			{
				// Perform Weapon Attack Behaviour
				switch(global.item_packs[item_equipped.item_pack].weapon_data.weapon_type)
				{
					case WeaponType.Thrown:
					case WeaponType.Grenade:
					case WeaponType.Molotov:
						// Throwable Weapon Attack Behaviour
						var temp_thrown_weapon_attack_animation_states_condition = unit_equipment_animation_state == UnitEquipmentAnimationState.Thrown and unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowWindup;
						var temp_thrown_weapon_attack_animation_values_condition = thrown_weapon_aim_transition_value >= (1 - thrown_weapon_lerp_threshold) and thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value >= (1 - thrown_weapon_lerp_threshold);
						
						// Begin Throw Swing Animation for Throwable Weapon
						if (temp_thrown_weapon_attack_animation_states_condition and temp_thrown_weapon_attack_animation_values_condition and thrown_weapon_operate_transition_value <= thrown_weapon_lerp_threshold)
						{
							// Set Throw Swing Thrown Weapon Animation State
							unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.ThrowSwing;
							
							// Update Thrown Weapon's Facing Direction
							item_equipped.thrown_weapon_direction = sign(draw_xscale);
							
							// Reset Throw Swing Animation Values
							thrown_weapon_swing_climax_angle = 0;
							thrown_weapon_swing_transition_value = 0;
							
							// Reset Throw Aiming Animation Values
							thrown_weapon_aim_transition_value = 1;
							thrown_weapon_operate_transition_value = 0;
							thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = 1;
						}
						break;
					case WeaponType.Firearm:
					case WeaponType.BoltActionFirearm:
						// Unit cannot attack with their Firearm if they are performing their Firearm's reload animation
						if (unit_equipment_animation_state != UnitEquipmentAnimationState.FirearmReload)
						{
							// Unit must finish their Firearm's recoil animation cycle to attack again with their Firearm
							if (firearm_weapon_hand_pivot_transition_value <= animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value <= animation_asymptotic_tolerance)
							{
								// Weapon Attack Behaviour - Attack with Firearm
								var temp_weapon_attack = item_equipped.update_weapon_attack(combat_target);
								
								// Weapon Attack Unit Behaviour
								if (temp_weapon_attack)
								{
									if (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.BoltActionFirearm and item_equipped.firearm_ammo > 0)
									{
										// Bolt Action Recharge Animation
										unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
										
										// Bolt Action Reload
										unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
										
										// Weapon Primary Hand Animation: Hand reaches from current position to firearm bolt handle
										unit_set_firearm_hand_animation
										(
											global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x, 
											global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y, 
											global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x, 
											global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y, 
											0
										);
									}
								}
							}
						}
						break;
					// Default Weapon Attack Behaviour
					default:
						break;
				}
			}
			else 
			{
				// Reset Weapon Attack Behaviour
				item_equipped.reset_weapon();
			}
		}
	}
	
	// Horizontal Movement Behaviour
	var move_spd = run_spd;
	
	switch (unit_equipment_animation_state)
	{
		case UnitEquipmentAnimationState.Thrown:
			switch (unit_thrown_weapon_animation_state)
			{
				case UnitThrownWeaponAnimationState.ThrowWindup:
					move_spd = weapon_aim ? walk_spd : run_spd;
					break;
				case UnitThrownWeaponAnimationState.ThrowSwing:
				case UnitThrownWeaponAnimationState.ThrowSwingClimax:
				case UnitThrownWeaponAnimationState.ThrowSwingClimaxNoItemLeft:
					move_spd = 0;
					break;
				default:
					move_spd = walk_spd;
					break;
			}
			break;
		case UnitEquipmentAnimationState.Firearm:
			move_spd = weapon_aim ? walk_spd : run_spd;
			break;
		case UnitEquipmentAnimationState.FirearmReload:
			move_spd = walk_spd;
			break;
		default:
			break;
	}
	
	if (input_left) 
	{
		move_spd = -move_spd;
	}
	else if (!input_right)
	{
		move_spd = 0;
		x_velocity = 0;
		x = round(x);
	}
	
	x_velocity = move_spd;
	
	// Vertical Movement Behaviour
	if (input_jump_hold) 
	{
		if (grounded) 
		{
			// First Jump
			y_velocity = 0;
			y_velocity -= jump_spd;
			jump_velocity = hold_jump_spd;
			double_jump = true;
			
			// Squash and Stretch
			draw_xscale = sign(draw_xscale) * (1 - squash_stretch_jump_intensity);
			draw_yscale = 1 + squash_stretch_jump_intensity;
			
			// Reset Ground Contact
			grounded = false;
		}
		else if (input_double_jump)
		{
			// Second Jump
			if (double_jump)
			{
				y_velocity = 0;
				y_velocity -= double_jump_spd;
				jump_velocity = hold_jump_spd;
				double_jump = false;
				
				// Squash and Stretch
				draw_xscale -= sign(draw_xscale) * squash_stretch_jump_intensity;
				draw_yscale += squash_stretch_jump_intensity;
			}
		}
		else if (y_velocity < 0)
		{
			// Variable Jump Height
			y_velocity -= jump_velocity * frame_delta;
			jump_velocity *= power(jump_decay, frame_delta);
		}
	}
	
	// Jumping Down (Platforms)
	if (input_drop_down)
	{
		// Check if Unit is standing above a Platform Collider
		if (grounded and place_free(x, y + 1))
		{
			// Establish Platform Iteration Variables
			var temp_platform_index = ds_list_size(platform_list) - 1;
			
			// Iterate through Unit's Platform List to remove all Platform Instances that share Unit's Vertical Position
			repeat (ds_list_size(platform_list))
			{
				// Find Platform Instance
				var temp_platform_instance = ds_list_find_value(platform_list, temp_platform_index);
				
				// Compare Vertical Position
				if (temp_platform_instance.y == y)
				{
					// Remove Platform Instance the Unit is standing on from Unit's Platform Collisions List
					ds_list_delete(temp_platform_instance.units, ds_list_find_index(temp_platform_instance.units, id));
					ds_list_delete(platform_list, temp_platform_index);
				}
				
				// Decrement Platform Index
				temp_platform_index--;
			}
			
			// Set Unit's Platform Drop Down Physics Movement Behaviour
			y += 2;
			y_velocity += 0.05;
			grounded = false;
		}
	}
	
	// Unit Drop Behaviour
	if (input_drop)
	{
		// Establish Dropped Item Physics Variables
		var temp_item_drop_base_horizontal_power = item_drop_base_horizontal_power;
		var temp_item_drop_base_vertical_power = item_drop_base_vertical_power;
		
		var temp_item_drop_movement_horizontal_power = item_drop_movement_horizontal_power;
		var temp_item_drop_movement_vertical_power = item_drop_movement_vertical_power;
		
		var temp_item_drop_random_horizontal_power = item_drop_random_horizontal_power;
		var temp_item_drop_random_vertical_power = item_drop_random_vertical_power;
		
		// Establish Dropped Item Object Instance
		var temp_unit_dropped_item_instance = noone;
		
		// Create Dropped Item Object Instance based on Equipped Item Behaviour and Properties
		switch (unit_equipment_animation_state)
		{
			case UnitEquipmentAnimationState.Thrown:
				// Create Dropped Item if Thrown Weapon is currently Equipped in Hand (Otherwise you should just Throw the Thrown Weapon lol)
				temp_unit_dropped_item_instance = limb_primary_arm.limb_held_item_exists ? unit_inventory_drop_item_instance(id, inventory_index, 1) : noone;
				
				// Disable Item Drop Unit Velocity being applied to Drop Physics Forces
				temp_item_drop_movement_horizontal_power = 0;
				temp_item_drop_movement_vertical_power = 0;
				break;
			default:
				// Create Dropped Item from Equipped Item Default Behaviour
				temp_unit_dropped_item_instance = unit_inventory_drop_item_instance(id, inventory_index, 1);
				break;
		}
		
		// Check if Dropped Item was created Successfully
		if (instance_exists(temp_unit_dropped_item_instance))
		{
			// Apply Physics Force to "Tossed" Dropped Item Instance
			with (temp_unit_dropped_item_instance)
			{
				var temp_item_horizontal_drop_power = random_range(-temp_item_drop_random_horizontal_power, temp_item_drop_random_horizontal_power) + (other.draw_xscale * temp_item_drop_base_horizontal_power) + (other.x_velocity * temp_item_drop_movement_horizontal_power);
				var temp_item_vertical_drop_power = random_range(-temp_item_drop_random_vertical_power, temp_item_drop_random_vertical_power) + temp_item_drop_base_vertical_power + (other.y_velocity * temp_item_drop_movement_vertical_power);
				physics_apply_impulse(x, y, temp_item_horizontal_drop_power, temp_item_vertical_drop_power);
			}
			
			// Check if Unit has Player Input
			if (player_input)
			{
				// Reset Player Inventory UI Transparency and Fade Timer
				player_inventory_ui_alpha = 1;
				player_inventory_ui_fade_timer = player_inventory_ui_fade_delay * 0.5;
			}
			
			// Set Unit's Hand Position Item Drop Animation
			item_drop_offset_transition_value = 1;
		}
	}
}
else
{
	x_velocity = 0;
	y_velocity = 0;
}
#endregion

// PHYSICS //
#region Collision & Physics Behaviour
if (grounded)
{
	// Disable Gravity
	grav_velocity = 0;
	y_velocity = 0;
	y = round(y);
	
	// Delta Time Adjustment
	var hspd = clamp(x_velocity * frame_delta, -max_velocity, max_velocity);
	var vspd = clamp(y_velocity * frame_delta, -max_velocity, max_velocity);
	
	// Grounded Physics (Horizontal) Collisions
	if (hspd != 0)
	{
		if (place_free(x + hspd, y)) 
		{
			// Move Unit with horizontal velocity
			x_velocity = hspd;
			x += x_velocity;
			
			// Grounded Slope Hugging Logic
			if (platform_free(x, y + 1, platform_list)) 
			{
				// Downward Slope Collision Check
				if (!place_free(x, y + slope_tolerance)) 
				{
					var	v = 1;
					
					repeat(slope_tolerance)
					{
						if (!place_free(x, y + v)) 
						{
							// GROUND CONTACT
							y_velocity = v - 1;
							y += y_velocity;
							
							unit_ground_contact_behaviour();
							break;
						}
						
						v++;
					}
				}
				else
				{
					// End Grounded Condition - Walked off side of Platform
					y += 1;
					grounded = false;
				}
			}
			else if (place_free(x, y + 1))
			{
				// Walking across Platform - Reset Ground Contact State
				ground_contact_vertical_offset = 0;
				draw_angle = 0;
			}
		}
		else if (place_free(x + hspd, y - slope_tolerance))
		{
			// Grounded Slope Hugging Logic
			var v = 1;
			
			repeat(slope_tolerance)
			{
				// Upwards Slope Collision Check
				if (place_free(x + hspd, y - v)) 
				{
					// GROUND CONTACT
					x_velocity = hspd;
					x += x_velocity;
					
					y_velocity = -v;
					y += y_velocity;
					
					unit_ground_contact_behaviour();
					break;
				}
				
				v++;
			}
		}
		else
		{
			// Horizontal Contact with Solid Collider
			x_velocity = 0;
			
			var temp_hspd_sign = sign(hspd);
			var h = 1;
			
			repeat(abs(hspd))
			{
				var temp_hspd = (temp_hspd_sign * h);
				
				if (!place_free(x + temp_hspd, y))
				{
					// GROUND CONTACT
					x_velocity = (temp_hspd_sign * (h - 1));
				
					x += x_velocity;
					x = round(x);
					
					// End Grounded Condition - Walked off side of Platform
					if (platform_free(x, y + 1, platform_list)) 
					{
						y += 1;
						grounded = false;
					}
					
					unit_ground_contact_behaviour();
					break;
				}
				
				h++;
			}
		}
	}
}
else
{
	// Gravity
	grav_velocity += (grav_spd * frame_delta);
	grav_velocity *= power(grav_multiplier, frame_delta);
	grav_velocity = min(grav_velocity, max_grav_spd);
	y_velocity += (grav_velocity * frame_delta);
	
	// Delta Time Adjustment
	var hspd = clamp(x_velocity * frame_delta, -max_velocity, max_velocity);
	var vspd = clamp(y_velocity * frame_delta, -max_velocity, max_velocity);
	
	// Airborne Ground Contact Reset
	ground_contact_vertical_offset = 0;
	draw_angle = 0;
	
	// Airborne Physics (Horizontal) Collisions
	if (hspd != 0)
	{
		if (place_free(x + hspd, y))
		{
			x_velocity = hspd;
			x += x_velocity;
			x = round(x);
		}
		else
		{
			var temp_hspd_sign = sign(hspd);
			var h = abs(hspd);
			
			repeat (h)
			{
				var temp_hspd = (temp_hspd_sign * h);
				
				if (place_free(x + temp_hspd, y))
				{
					// GROUND CONTACT
					x_velocity = temp_hspd;
					x += x_velocity;
					x = round(x);
					break;
				}
				
				h--;
			}
		}
	}
	
	// Airborne Physics (Vertical) Collisions
	if (platform_free(x, y + vspd, platform_list))
	{
		y_velocity = vspd;
		y += y_velocity;
		y = round(y);
	}
	else
	{
		// Establish Airborne Unit Physics Variables
		var temp_unit_old_y = y;
		var temp_vspd_sign = sign(vspd) == 0 ? 1 : sign(vspd);
		
		// Iterate through Length of Unit's Vertical Speed Physics Raycast
		var v = 1;
		
		repeat(max(abs(vspd) - v, 1))
		{
			// Check for Physics Collision in the Direction of Unit's Vertical Speed
			if (platform_free(x, y + temp_vspd_sign, platform_list))
			{
				// AIRBORNE MOVEMENT
				y += temp_vspd_sign;
			}
			else
			{
				// GROUND CONTACT
				y_velocity = temp_vspd_sign * (v - 1);
				y = temp_unit_old_y + y_velocity;
				y = round(y);
				
				if (!platform_free(x, y + 1, platform_list))
				{
					// Reset Velocities
					y_velocity = 0;
					grav_velocity = 0;
					
					// Hit collider below Unit
					grounded = true;
					double_jump = true;
					
					draw_xscale = sign(draw_xscale) * (1 + squash_stretch_jump_intensity);
					draw_yscale = 1 - squash_stretch_jump_intensity;
					
					unit_ground_contact_behaviour();
				}
				else
				{
					// Hit collider above Unit
					draw_xscale = sign(draw_xscale);
					draw_yscale = 1;
				}
				break;
			}
			
			// Increment Vertical Physics Check
			v++;
		}
	}
}

// Update Unit Scale & Angle
draw_xscale = lerp(draw_xscale, sign(draw_xscale), squash_stretch_reset_spd * frame_delta);
draw_yscale = lerp(draw_yscale, 1, squash_stretch_reset_spd * frame_delta);
draw_angle_value = lerp(draw_angle_value, draw_angle, slope_angle_lerp_spd * frame_delta);

// Pre-calc Unit's Slope Rotation
rot_prefetch(draw_angle_value);
draw_angle_trig_sine = trig_sine;
draw_angle_trig_cosine = trig_cosine;
#endregion

// ANIMATION //
#region Animation Behaviour
var temp_unit_animation_state = UnitAnimationState.Idle;

// Unit Facing Direction
if (x_velocity != 0)
{
	// Set Unit's Horizontal Scale to match the direction it is facing while moving
	draw_xscale = abs(draw_xscale) * sign(x_velocity);
}

var temp_unit_direction = sign(draw_xscale);

// Animation State Behaviour Tree
if (grounded)
{
	// Walking or Idle Animation
	switch (unit_equipment_animation_state)
	{
		case UnitEquipmentAnimationState.Thrown:
			// Operating Thrown Weapon Movement Animations
			switch (unit_thrown_weapon_animation_state)
			{
				case UnitThrownWeaponAnimationState.ThrowSwing:
				case UnitThrownWeaponAnimationState.ThrowSwingClimax:
				case UnitThrownWeaponAnimationState.ThrowSwingClimaxNoItemLeft:
					temp_unit_animation_state = UnitAnimationState.Aiming;
					break;
				case UnitThrownWeaponAnimationState.ThrowWindup:
					temp_unit_animation_state = x_velocity != 0 ? (weapon_aim ? UnitAnimationState.AimWalking : UnitAnimationState.Walking) : (weapon_aim ? UnitAnimationState.Aiming : UnitAnimationState.Idle);
					break;
				default:
					temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.AimWalking : UnitAnimationState.Aiming;
					break;
			}
			break;
		case UnitEquipmentAnimationState.Firearm:
			// Operating Firearm Movement Animations
			var temp_unit_firearm_aimed_animation = weapon_aim and firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 0.5;
			temp_unit_animation_state = x_velocity != 0 ? (temp_unit_firearm_aimed_animation ? UnitAnimationState.AimWalking : UnitAnimationState.Walking) : (temp_unit_firearm_aimed_animation ? UnitAnimationState.Aiming : UnitAnimationState.Idle);
			break;
		case UnitEquipmentAnimationState.FirearmReload:
			// Reloading Firearm Movement Animations
			switch (unit_firearm_reload_animation_state)
			{
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
					temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.AimWalking : UnitAnimationState.Aiming;
					break;
				default:
					var temp_unit_firearm_reload_aimed_animation = firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 0.5;
					temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.AimWalking : (temp_unit_firearm_reload_aimed_animation ? UnitAnimationState.Aiming : UnitAnimationState.Idle);
					break;
			}
			break;
		default:
			// Default Unholstered Movement Animations
			temp_unit_animation_state = x_velocity != 0 ? UnitAnimationState.Walking : UnitAnimationState.Idle;
			break;
	}
}
else 
{
	// Jump Animation
	temp_unit_animation_state = UnitAnimationState.Jumping;
	image_index = ((abs(y_velocity) - jump_peak_threshold >= 0) * sign(y_velocity)) + 1;
}

// Load Animation State
if (unit_animation_state != temp_unit_animation_state)
{
	// Set Animation State
	unit_animation_state = temp_unit_animation_state;
	
	// Set Animation State Properties
	switch (unit_animation_state)
	{
		case UnitAnimationState.Idle:
			sprite_index = global.unit_packs[unit_pack].idle_sprite;
			normalmap_spritepack = unit_spritepack_idle_normalmap;
			metallicroughnessmap_spritepack = unit_spritepack_idle_metallicroughnessmap;
			emissivemap_spritepack = unit_spritepack_idle_emissivemap;
			draw_image_index_length = 4;
			break;
		case UnitAnimationState.Walking:
			sprite_index = global.unit_packs[unit_pack].walk_sprite;
			normalmap_spritepack = unit_spritepack_walk_normalmap;
			metallicroughnessmap_spritepack = unit_spritepack_walk_metallicroughnessmap;
			emissivemap_spritepack = unit_spritepack_walk_emissivemap;
			draw_image_index_length = 5;
			break;
		case UnitAnimationState.Jumping:
			sprite_index = global.unit_packs[unit_pack].jump_sprite;
			normalmap_spritepack = unit_spritepack_jump_normalmap;
			metallicroughnessmap_spritepack = unit_spritepack_jump_metallicroughnessmap;
			emissivemap_spritepack = unit_spritepack_jump_emissivemap;
			draw_image_index_length = -1;
			break;
		case UnitAnimationState.Aiming:
			sprite_index = global.unit_packs[unit_pack].aim_sprite;
			normalmap_spritepack = unit_spritepack_aim_normalmap;
			metallicroughnessmap_spritepack = unit_spritepack_aim_metallicroughnessmap;
			emissivemap_spritepack = unit_spritepack_aim_emissivemap;
			image_index = 0;
			draw_image_index = 0;
			draw_image_index_length = -1;
			break;
		case UnitAnimationState.AimWalking:
			sprite_index = global.unit_packs[unit_pack].aim_walk_sprite;
			normalmap_spritepack = unit_spritepack_aim_walk_normalmap;
			metallicroughnessmap_spritepack = unit_spritepack_aim_walk_metallicroughnessmap;
			emissivemap_spritepack = unit_spritepack_aim_walk_emissivemap;
			draw_image_index_length = 5;
			break;
	}
}

// Calculate Unit Bobbing Animation
bobbing_animation_value = sin((((floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2)) + bobbing_animation_percent_offset) * 2 * pi);
#endregion

// EQUIPMENT //
#region Equipment Behaviour
if (equipment_active)
{
	// Equipment Behaviour
	if (global.item_packs[item_equipped.item_pack].item_type == ItemType.Weapon)
	{
		// Weapon Equipment Behaviour
		switch (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type)
		{
			case WeaponType.Thrown:
			case WeaponType.Grenade:
			case WeaponType.Molotov:
				// Weapon Throw Windup Behaviour
				if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowWindup)
				{
					// Weapon Unit Facing Direction Calculation
					draw_xscale = weapon_aim ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
					temp_unit_direction = sign(draw_xscale);
				}
				
				// Calculate and Set Limb Shoulder Pivots
				limb_primary_arm.limb_xscale = temp_unit_direction;
				limb_secondary_arm.limb_xscale = temp_unit_direction;
				
				var temp_thrown_weapon_primary_arm_anchor_offset_x = limb_primary_arm.anchor_offset_x * draw_xscale;
				var temp_thrown_weapon_primary_arm_anchor_offset_y = limb_primary_arm.anchor_offset_y * draw_yscale;
				
				limb_primary_arm.limb_pivot_ax = x + rot_point_x(temp_thrown_weapon_primary_arm_anchor_offset_x, temp_thrown_weapon_primary_arm_anchor_offset_y);
				limb_primary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_thrown_weapon_primary_arm_anchor_offset_x, temp_thrown_weapon_primary_arm_anchor_offset_y);
				
				var temp_thrown_weapon_secondary_arm_anchor_offset_x = limb_secondary_arm.anchor_offset_x * draw_xscale;
				var temp_thrown_weapon_secondary_arm_anchor_offset_y = limb_secondary_arm.anchor_offset_y * draw_yscale;
				
				limb_secondary_arm.limb_pivot_ax = x + rot_point_x(temp_thrown_weapon_secondary_arm_anchor_offset_x, temp_thrown_weapon_secondary_arm_anchor_offset_y);
				limb_secondary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_thrown_weapon_secondary_arm_anchor_offset_x, temp_thrown_weapon_secondary_arm_anchor_offset_y);
				
				if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowWindup)
				{
					// Update Thrown Weapon's Initial Velocity
					if (weapon_aim)
					{
						// Calculate Thrown Weapon Aim Pivot
						var temp_thrown_weapon_aim_pivot_x = lerp(limb_primary_arm.limb_pivot_ax, limb_secondary_arm.limb_pivot_ax, 0.5);
						var temp_thrown_weapon_aim_pivot_y = lerp(limb_primary_arm.limb_pivot_ay, limb_secondary_arm.limb_pivot_ay, 0.5);
						
						// Calculate Thrown Weapon Cursor Aim Distance's Horizontal and Vertical Displacement
						var temp_throw_distance_horizontal = clamp(abs(temp_thrown_weapon_aim_pivot_x - weapon_aim_x), 0, (GameManager.game_width * 0.5)) / (GameManager.game_width * 0.5);
						var temp_throw_distance_vertical = clamp(abs(temp_thrown_weapon_aim_pivot_y - weapon_aim_y), 0, (GameManager.game_height * 0.5)) / (GameManager.game_height * 0.5);
						
						// Calculate Thrown Weapon's Initial Throw Velocity Strength based on Elliptical Radial Distance based on the Dimensions of the Game's Width and Height
						var temp_throw_velocity_percent = clamp(point_distance(0, 0, temp_throw_distance_horizontal, temp_throw_distance_vertical), 0, 1);
						
						// Update Thrown Weapon's Intial Throw Velocity Strength with Smooth Lerp Transition Effect
						var temp_throw_init_velocity_target = lerp(global.item_packs[item_equipped.item_pack].weapon_data.projectile_initial_velocity_min, global.item_packs[item_equipped.item_pack].weapon_data.projectile_initial_velocity_max, temp_throw_velocity_percent);
						item_equipped.thrown_weapon_init_velocity = lerp(item_equipped.thrown_weapon_init_velocity, temp_throw_init_velocity_target, thrown_aiming_velocity_transition_spd * frame_delta);
					}
					else
					{
						// Thrown Weapon is no longer being actively Aimed - Return Thrown Weapon's Inital Throw Velocity to its Minimum Default Value
						item_equipped.thrown_weapon_init_velocity = global.item_packs[item_equipped.item_pack].weapon_data.projectile_initial_velocity_min;
					}
				}
				
				// Update Thrown Weapon Equipment Behaviour
				item_equipped.update_weapon_behaviour();
				break;
			// Update Firearm Recoil Behaviour & Attack Delay Timers
			case WeaponType.Firearm:
			case WeaponType.BoltActionFirearm:
				// Update Firearm Weapon Equipment Behaviour
				item_equipped.update_weapon_behaviour(firearm_recoil_recovery_spd, firearm_recoil_angle_recovery_spd);
				
				// Firearm Weapon Equipment Unit Facing Direction Calculation
				draw_xscale = (unit_equipment_animation_state != UnitEquipmentAnimationState.FirearmReload and weapon_aim) ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
				temp_unit_direction = sign(draw_xscale);
				break;
			// Update Default Weapon Behaviour
			default:
				// Update Default Weapon Equipment Behaviour
				item_equipped.update_weapon_behaviour();
				
				// Weapon Unit Facing Direction Calculation
				draw_xscale = weapon_aim ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
				temp_unit_direction = sign(draw_xscale);
				break;
		}
	}
}

// Calculate Unit's Inventory Slot Positions
var temp_inventory_slot_index = 0;

repeat (array_length(inventory_slots))
{
	// Calculate Inventory Slot Unit Offset
	var temp_inventory_slot_unit_offset_x = rot_point_x(inventory_slots[temp_inventory_slot_index].slot_unit_offset_x, inventory_slots[temp_inventory_slot_index].slot_unit_offset_y + (bobbing_animation_value * inventory_vertical_bobbing_height)) * draw_xscale;
	var temp_inventory_slot_unit_offset_y = rot_point_y(inventory_slots[temp_inventory_slot_index].slot_unit_offset_x, inventory_slots[temp_inventory_slot_index].slot_unit_offset_y + (bobbing_animation_value * inventory_vertical_bobbing_height)) * draw_yscale;
	
	// Set Inventory Slot Positions relative to Unit
	inventory_slots[temp_inventory_slot_index].slot_position_x = x + temp_inventory_slot_unit_offset_x;
	inventory_slots[temp_inventory_slot_index].slot_position_y = y + ground_contact_vertical_offset + temp_inventory_slot_unit_offset_y;
	
	// Update Inventory Slot Item Instance's Position & Angle
	if (inventory_index != temp_inventory_slot_index)
	{
		// Compare Inventory Slot Item's Type
		if (global.item_packs[inventory_slots[temp_inventory_slot_index].item_pack].item_type != ItemType.None)
		{
			// Update Inventory Slot's Item Instance based on Inventory Slot's Orientation
			var temp_inventory_slot_angle_movement_difference = angle_difference(90 + (inventory_slots[temp_inventory_slot_index].slot_angle * temp_unit_direction), inventory_slots[temp_inventory_slot_index].item_instance.item_angle);
			var temp_inventory_slot_item_angle = inventory_slots[temp_inventory_slot_index].item_instance.item_angle + (temp_inventory_slot_angle_movement_difference * inventory_item_rotate_spd * frame_delta);
			inventory_slots[temp_inventory_slot_index].item_instance.update_item_physics(inventory_slots[temp_inventory_slot_index].slot_position_x, inventory_slots[temp_inventory_slot_index].slot_position_y, temp_inventory_slot_item_angle, temp_unit_direction);
			
			// Check if Inventory Slot's Item Instance is a Weapon
			if (global.item_packs[inventory_slots[temp_inventory_slot_index].item_pack].item_type == ItemType.Weapon)
			{
				// Unequipped Weapon Item Behaviour
				switch (global.item_packs[inventory_slots[temp_inventory_slot_index].item_pack].weapon_data.weapon_type)
				{
					case WeaponType.Thrown:
					case WeaponType.Grenade:
					case WeaponType.Molotov:
						// Update Thrown Weapon's Fuze
						inventory_slots[temp_inventory_slot_index].item_instance.update_fuze();
						break;
					default:
						break;
				}
			}
		}
	}
	
	// Increment Inventory Slot Index
	temp_inventory_slot_index++;
}
#endregion

// LIMBS //
#region Limb Animation Behaviour
// Establish Limb Animation Toggle Variables
var temp_primary_limb_default_animation_active = true;
var temp_secondary_limb_default_animation_active = true;

// Perform Unit's Limb Equipment Animation Behaviour
switch (unit_equipment_animation_state)
{
	case UnitEquipmentAnimationState.Thrown:
		// Thrown Weapon Animation States
		var temp_thrown_weapon_aim = weapon_aim and unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowWindup;
		
		// Establish Thrown Weapon Limb Target Angles
		var temp_thrown_primary_limb_pivot_a_angle = thrown_idle_primary_limb_pivot_a_angle * temp_unit_direction;
		var temp_thrown_primary_limb_pivot_b_angle = thrown_idle_primary_limb_pivot_b_angle * temp_unit_direction;
		
		var temp_thrown_secondary_limb_pivot_a_angle = thrown_idle_secondary_limb_pivot_a_angle * temp_unit_direction;
		var temp_thrown_secondary_limb_pivot_b_angle = thrown_idle_secondary_limb_pivot_b_angle * temp_unit_direction;
		
		// Establish Thrown Weapon Animation Values
		var temp_thrown_weapon_primary_ambient_bob_angle = 0;
		var temp_thrown_weapon_secondary_ambient_bob_angle = 0;
		var temp_thrown_weapon_moving_bob_angle = 0;
		
		var temp_thrown_weapon_operate_transition_value = 0;
		var temp_thrown_weapon_operate_action_transition_value = 0;
		
		// Calculate Thrown Weapon Animation Behaviour - Limb Forward Kinematics & Animation States
		switch (unit_thrown_weapon_animation_state)
		{
			case UnitThrownWeaponAnimationState.ThrowSwing:
			case UnitThrownWeaponAnimationState.ThrowSwingClimax:
			case UnitThrownWeaponAnimationState.ThrowSwingClimaxNoItemLeft:
				// Calculate Thrown Weapon Swing Animation Lerp Behaviour
				thrown_weapon_swing_transition_value = lerp(thrown_weapon_swing_transition_value, 1, thrown_weapon_swing_underhand ? thrown_weapon_swing_underhand_transition_spd : thrown_weapon_swing_overhand_transition_spd * frame_delta);
				thrown_weapon_swing_transition_value *= power(thrown_weapon_swing_underhand ? thrown_weapon_swing_underhand_transition_multiplier : thrown_weapon_swing_overhand_transition_multiplier, frame_delta);
				thrown_weapon_swing_transition_value = clamp(thrown_weapon_swing_transition_value, 0, 1);
				
				// Calculate Thrown Weapon Swing Animation with Inversed Exponent Curve
				var temp_weapon_swing_transition_value = 1.0 - power(1.0 - thrown_weapon_swing_transition_value, thrown_weapon_swing_underhand ? thrown_weapon_swing_underhand_animation_curve_exponent : thrown_weapon_swing_overhand_animation_curve_exponent);
				
				// Update Thrown Weapon Limb Target Angles
				if (thrown_weapon_swing_underhand)
				{
					// Use the Primary Hand's Underhand Throw Limb Pivot Positions
					temp_thrown_primary_limb_pivot_a_angle = (lerp(thrown_swing_underhand_start_primary_limb_pivot_a_angle, thrown_swing_underhand_end_primary_limb_pivot_a_angle, temp_weapon_swing_transition_value) - thrown_weapon_swing_climax_angle) * temp_unit_direction;
					temp_thrown_primary_limb_pivot_b_angle = (lerp(thrown_swing_underhand_start_primary_limb_pivot_b_angle, thrown_swing_underhand_end_primary_limb_pivot_b_angle, temp_weapon_swing_transition_value) - thrown_weapon_swing_climax_angle) * temp_unit_direction;
				}
				else
				{
					// Use the Primary Hand's Overhand Throw Limb Pivot Positions
					temp_thrown_primary_limb_pivot_a_angle = (lerp(thrown_swing_overhand_start_primary_limb_pivot_a_angle, thrown_swing_overhand_end_primary_limb_pivot_a_angle, temp_weapon_swing_transition_value) - thrown_weapon_swing_climax_angle) * temp_unit_direction;
					temp_thrown_primary_limb_pivot_b_angle = (lerp(thrown_swing_overhand_start_primary_limb_pivot_b_angle, thrown_swing_overhand_end_primary_limb_pivot_b_angle, temp_weapon_swing_transition_value) - thrown_weapon_swing_climax_angle) * temp_unit_direction;
				}
				
				temp_thrown_secondary_limb_pivot_a_angle = lerp(thrown_aiming_secondary_limb_pivot_a_angle, thrown_swing_secondary_limb_pivot_a_angle, temp_weapon_swing_transition_value) * temp_unit_direction;
				temp_thrown_secondary_limb_pivot_b_angle = lerp(thrown_aiming_secondary_limb_pivot_b_angle, thrown_swing_secondary_limb_pivot_b_angle, temp_weapon_swing_transition_value) * temp_unit_direction;
				
				// Swing Animation State Condition Tree
				if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowSwing)
				{
					// Check if Unit has completed their Swing Animation
					if (thrown_weapon_swing_transition_value == 1)
					{
						// Advance Animation State from Throwing Thrown Weapon Swing to Post-Throw Swing Climax
						unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.ThrowSwingClimax;
						
						//
						thrown_weapon_direction = temp_unit_direction;
						
						// Set Thrown Weapon Swing Climax Timer
						thrown_weapon_swing_climax_timer = thrown_weapon_swing_underhand ? thrown_weapon_swing_underhand_climax_duration : thrown_weapon_swing_overhand_climax_duration;
						
						// Launch Thrown Weapon from Hand Behaviour
						item_equipped.update_weapon_attack(thrown_weapon_angle);
						
						//
						if (item_equipped == noone)
						{
							//
							thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = 1;
							
							//
							unit_equipment_animation_state = UnitEquipmentAnimationState.Thrown;
							unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.ThrowSwingClimaxNoItemLeft;
						}
					}
				}
				else
				{
					// Decrement Swing Climax Timer
					thrown_weapon_swing_climax_timer -= frame_delta;
					
					// Post-Throw Swing Climax Overshot Arm Animation Behaviour
					var temp_thrown_weapon_swing_climax_spd = thrown_weapon_swing_underhand ? thrown_weapon_swing_underhand_climax_angle_spd : thrown_weapon_swing_overhand_climax_angle_spd;
					var temp_thrown_weapon_swing_climax_duration = thrown_weapon_swing_underhand ? thrown_weapon_swing_underhand_climax_duration : thrown_weapon_swing_overhand_climax_duration;
					thrown_weapon_swing_climax_angle += temp_thrown_weapon_swing_climax_spd * power(clamp((thrown_weapon_swing_climax_timer - temp_thrown_weapon_swing_climax_duration * 0.5) / (temp_thrown_weapon_swing_climax_duration * 0.5), 0, 1), 4) * frame_delta;
					
					// Swing Climax Animation Finish Behaviour
					if (thrown_weapon_swing_climax_timer <= 0)
					{
						//
						if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.ThrowSwingClimax)
						{
							// Advance Animation State from Post-Throw Swing Climax to Grabbing another Thrown Weapon from Unit's Inventory
							unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.GrabWeapon;
							
							// Reset Thrown Weapon Aim & Thrown Weapon Idle Pivot to Inventory Slot Item Position Pivot Transition Animation Values
							thrown_weapon_aim_transition_value = 0;
							thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = 1;
						}
						else
						{
							// Calculate Primary Hand Transition from Thrown Weapon Idle Pivot to 
							thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = lerp(thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
							
							//
							if (thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value < 0.25)
							{
								//
								unit_equipment_animation_state = UnitEquipmentAnimationState.None;
							}
						}
					}
				}
				break;
			case UnitThrownWeaponAnimationState.ThrowWindup:
				// Throw Windup Animation Value
				if (temp_thrown_weapon_aim)
				{
					// Calculate Throw Aim Windup Posture Transition Value
					thrown_weapon_aim_transition_value = lerp(thrown_weapon_aim_transition_value, 1, thrown_aiming_aim_transition_spd * frame_delta);
					thrown_weapon_aim_transition_value *= power(thrown_aiming_aim_transition_multiplier, frame_delta);
				}
				else
				{
					// Calculate Throw Idle Posture Transition Value
					thrown_weapon_aim_transition_value = lerp(thrown_weapon_aim_transition_value, 0, thrown_aiming_hip_transition_spd * frame_delta);
					thrown_weapon_aim_transition_value *= power(thrown_aiming_hip_transition_multiplier, frame_delta);
					
					// Update Unit Holding Thrown Weapon Bobbing Animation Behaviour
					temp_thrown_weapon_primary_ambient_bob_angle = bobbing_animation_value * thrown_weapon_idle_primary_bobbing_angle;
					temp_thrown_weapon_secondary_ambient_bob_angle = bobbing_animation_value * thrown_weapon_idle_secondary_bobbing_angle;
				}
				
				// Calculate Primary Hand Transition from Thrown Weapon Idle Pivot to Inventory Slot Item Position Pivot
				thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = lerp(thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value, 1, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
				
				// Calculate Thrown Weapon's Operate Transition Movement to their Default Weapon Position
				thrown_weapon_operate_transition_value = lerp(thrown_weapon_operate_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
				thrown_weapon_operate_action_transition_value = lerp(thrown_weapon_operate_action_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
				
				// Calculate Thrown Weapon Operate Animation with Inversed Exponent Curve
				temp_thrown_weapon_operate_transition_value = power(thrown_weapon_operate_transition_value, thrown_weapon_operate_animation_curve_exponent);
				temp_thrown_weapon_operate_action_transition_value = power(thrown_weapon_operate_action_transition_value, thrown_weapon_operate_action_animation_curve_exponent);
				
				// Lerp Primary Limb's Held Item Angle to its Default Rotation
				if (ds_list_size(limb_primary_arm.limb_held_item_image_angle_list) > 0)
				{
					ds_list_set(limb_primary_arm.limb_held_item_image_angle_list, 0, lerp(0, global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_angle, temp_thrown_weapon_operate_transition_value));
				}
				
				// Calculate Thrown Weapon's Aim Exponent Animation Value
				thrown_weapon_aim_transition_value = clamp(thrown_weapon_aim_transition_value, 0, 1);
				var temp_thrown_weapon_aim_transition_value = power(thrown_weapon_aim_transition_value, thrown_aiming_animation_curve_exponent);
				
				// Update Thrown Weapon Limb Target Angles
				temp_thrown_primary_limb_pivot_a_angle = lerp(thrown_idle_primary_limb_pivot_a_angle, thrown_aiming_primary_limb_pivot_a_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				temp_thrown_primary_limb_pivot_b_angle = lerp(thrown_idle_primary_limb_pivot_b_angle, thrown_aiming_primary_limb_pivot_b_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				
				temp_thrown_secondary_limb_pivot_a_angle = lerp(thrown_idle_secondary_limb_pivot_a_angle, thrown_aiming_secondary_limb_pivot_a_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				temp_thrown_secondary_limb_pivot_b_angle = lerp(thrown_idle_secondary_limb_pivot_b_angle, thrown_aiming_secondary_limb_pivot_b_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				
				// Thrown Weapon Facing Direction Behaviour
				thrown_weapon_angle = weapon_aim ? thrown_weapon_angle : (temp_unit_direction >= 0 ? 0 : 180);
				break;
			case UnitThrownWeaponAnimationState.GrabWeapon:
			case UnitThrownWeaponAnimationState.OperateAction_MoveHandsToReadyWeapon:
			case UnitThrownWeaponAnimationState.Grenade_PinPull:
				// Calculate Thrown Weapon Swing Animation Lerp to Default Position Behaviour
				thrown_weapon_swing_transition_value = lerp(thrown_weapon_swing_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
				
				// Calculate Throw Idle Posture Transition Value
				thrown_weapon_aim_transition_value *= power(thrown_aiming_hip_transition_multiplier, frame_delta);
				thrown_weapon_aim_transition_value = lerp(thrown_weapon_aim_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
				var temp_thrown_weapon_aim_transition_value = power(thrown_weapon_aim_transition_value, thrown_aiming_animation_curve_exponent);
				
				// Update Thrown Weapon Limb Target Angles
				temp_thrown_primary_limb_pivot_a_angle = lerp(thrown_idle_primary_limb_pivot_a_angle, thrown_aiming_primary_limb_pivot_a_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				temp_thrown_primary_limb_pivot_b_angle = lerp(thrown_idle_primary_limb_pivot_b_angle, thrown_aiming_primary_limb_pivot_b_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				
				if (thrown_weapon_swing_underhand)
				{
					// Add Primary Hand's Underhand Throw Overshot Swing Angle
					temp_thrown_primary_limb_pivot_a_angle -= angle_difference(temp_thrown_primary_limb_pivot_a_angle, (thrown_swing_underhand_end_primary_limb_pivot_a_angle - thrown_weapon_swing_climax_angle) * temp_unit_direction) * thrown_weapon_swing_transition_value;
					temp_thrown_primary_limb_pivot_b_angle -= angle_difference(temp_thrown_primary_limb_pivot_b_angle, (thrown_swing_underhand_end_primary_limb_pivot_b_angle - thrown_weapon_swing_climax_angle) * temp_unit_direction) * thrown_weapon_swing_transition_value;
				}
				else
				{
					// Add Primary Hand's Overhand Throw Overshot Swing Angle
					temp_thrown_primary_limb_pivot_a_angle -= angle_difference(temp_thrown_primary_limb_pivot_a_angle, (thrown_swing_overhand_end_primary_limb_pivot_a_angle - thrown_weapon_swing_climax_angle) * temp_unit_direction) * thrown_weapon_swing_transition_value;
					temp_thrown_primary_limb_pivot_b_angle -= angle_difference(temp_thrown_primary_limb_pivot_b_angle, (thrown_swing_overhand_end_primary_limb_pivot_b_angle - thrown_weapon_swing_climax_angle) * temp_unit_direction) * thrown_weapon_swing_transition_value;
				}
				
				temp_thrown_secondary_limb_pivot_a_angle = lerp(thrown_idle_secondary_limb_pivot_a_angle, thrown_aiming_secondary_limb_pivot_a_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				temp_thrown_secondary_limb_pivot_b_angle = lerp(thrown_idle_secondary_limb_pivot_b_angle, thrown_aiming_secondary_limb_pivot_b_angle, temp_thrown_weapon_aim_transition_value) * temp_unit_direction;
				
				temp_thrown_secondary_limb_pivot_a_angle -= angle_difference(temp_thrown_secondary_limb_pivot_a_angle, thrown_swing_secondary_limb_pivot_a_angle * temp_unit_direction) * thrown_weapon_swing_transition_value;
				temp_thrown_secondary_limb_pivot_b_angle -= angle_difference(temp_thrown_secondary_limb_pivot_b_angle, thrown_swing_secondary_limb_pivot_b_angle * temp_unit_direction) * thrown_weapon_swing_transition_value;
				
				// Update Unit Holding Thrown Weapon Bobbing Animation Behaviour
				temp_thrown_weapon_primary_ambient_bob_angle = bobbing_animation_value * thrown_weapon_idle_primary_bobbing_angle;
				temp_thrown_weapon_secondary_ambient_bob_angle = bobbing_animation_value * thrown_weapon_idle_secondary_bobbing_angle;
				
				// Thrown Weapon Mid-Hand-Movement Animation State Condition Tree
				if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.GrabWeapon)
				{
					// Lerp Primary Hand from Thrown Weapon Idle Pivot to Inventory Slot Item Position Pivot
					thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = lerp(thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
					
					// Calculate Thrown Weapon Operate Hand Movement Animation Lerp to Default Position Behaviour
					thrown_weapon_operate_transition_value = lerp(thrown_weapon_operate_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
					
					// Check if Grab Weapon from Unit Inventory Primary Hand Transition Animation has Finished
					if (thrown_weapon_aim_transition_value <= thrown_weapon_lerp_threshold and thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value <= thrown_weapon_lerp_threshold)
					{
						// Advance Animation Stage from Grab Weapon Hand Fumble to Throw Windup
						unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.GrabWeapon_HandFumble;
						
						// Set Grab Thrown Weapon from Unit's Inventory Hand Fumble Animation Duration
						unit_set_hand_fumble_animation(30);
					}
				}
				else if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.OperateAction_MoveHandsToReadyWeapon)
				{
					// Lerp Hand & Thrown Weapon to Operate Position Animation Behaviour
					thrown_weapon_operate_transition_value = lerp(thrown_weapon_operate_transition_value, 1, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
					
					// Calculate Thrown Weapon Operate Animation with Exponent Curve
					temp_thrown_weapon_operate_transition_value = power(thrown_weapon_operate_transition_value, thrown_weapon_operate_animation_curve_exponent);
					
					// Lerp Primary Limb's Held Item Angle to its Thrown Weapon Operation Action Rotation
					if (ds_list_size(limb_primary_arm.limb_held_item_image_angle_list) > 0)
					{
						ds_list_set(limb_primary_arm.limb_held_item_image_angle_list, 0, lerp(0, global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_angle, temp_thrown_weapon_operate_transition_value));
					}
					
					// Calculate Primary Hand Transition from Thrown Weapon Idle Pivot to Inventory Slot Item Position Pivot
					thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = lerp(thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
					
					// Check if Hands & Thrown Weapon Movement to Operate Thrown Weapon Pivot Position Transition Animation has Finished
					if (thrown_weapon_operate_transition_value >= (1 - thrown_weapon_lerp_threshold))
					{
						// Set Unit's Thrown Weapon Animation State based on the Unit's Thrown Weapon Type
						if (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.Grenade)
						{
							// Advance Animation Stage from Moving Hands & Thrown Weapon to the Unit's Operate Weapon Pivot to Grenade's Pin Pull Animation
							unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.Grenade_PinPull;
						}
						else if (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.Molotov)
						{
							// Advance Animation Stage from Moving Hands & Thrown Weapon to the Unit's Operate Weapon Pivot to Ignite Molotov Hand Fumble Animation
							unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.Molotov_IgniteHandFumble;
							
							// Set Ignite Molotov Hand Fumble Animation Duration
							unit_set_hand_fumble_animation(40);
						}
						
						// Reset Thrown Weapon's Grenade Pin Pull Transition Animation Value
						thrown_weapon_operate_action_transition_value = 0;
						
						// Reset Thrown Weapon's Grenade Pin Pull Transition Animation Value
						thrown_weapon_operate_transition_value = 1;
						temp_thrown_weapon_operate_transition_value = 1;
						
						// Set Primary Limb's Held Item Angle to its Thrown Weapon Operation Action Angle
						if (ds_list_size(limb_primary_arm.limb_held_item_image_angle_list) > 0)
						{
							ds_list_set(limb_primary_arm.limb_held_item_image_angle_list, 0, global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_angle);
						}
					}
				}
				else if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.Grenade_PinPull)
				{
					// Update Thrown Weapon Grenade Pin Pull Animation Behaviour
					thrown_weapon_operate_action_transition_value += thrown_weapon_operate_action_spd * frame_delta;
					thrown_weapon_operate_action_transition_value = clamp(thrown_weapon_operate_action_transition_value, 0, 1);
					
					// Calculate Thrown Weapon Grenade Pin Pull Animation with Inversed Exponent Curve
					temp_thrown_weapon_operate_action_transition_value = 1 - power(1 - thrown_weapon_operate_action_transition_value, thrown_weapon_operate_action_animation_curve_exponent);
					
					// Set Thrown Weapon's Hand Movement Lerp Animation Transition Values to their Operate Thrown Weapon Pivot Position
					thrown_weapon_operate_transition_value = 1;
					temp_thrown_weapon_operate_transition_value = 1;
					
					// Calculate Primary Hand Transition from Thrown Weapon Idle Pivot to Inventory Slot Item Position Pivot
					thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = lerp(thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value, 0, thrown_item_slot_to_holding_position_transition_spd * frame_delta);
					
					// Check if Grenade Pin Pull Animation has Finished
					if (thrown_weapon_operate_action_transition_value >= 1)
					{
						// Advance Animation Stage from Grenade's Pin Pull to Throw Windup & Aiming Behaviour
						unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.ThrowWindup;
						
						// Grenade Pin is Pulled - Disable Thrown Weapon Safety
						item_equipped.disable_safety();
					}
				}
				break;
			case UnitThrownWeaponAnimationState.GrabWeapon_HandFumble:
			case UnitThrownWeaponAnimationState.Molotov_IgniteHandFumble:
				// Hand Fumble Animation Transition
				hand_fumble_animation_transition_value = lerp(hand_fumble_animation_transition_value, 0, hand_fumble_animation_travel_spd * frame_delta);
				
				if (hand_fumble_animation_transition_value <= animation_asymptotic_tolerance)
				{
					// Hand Fumble Animation Repeat Timer
					hand_fumble_animation_cycle_timer -= frame_delta;
					
					if (hand_fumble_animation_cycle_timer <= 0)
					{
						// Reset Hand Fumble Animation to next position
						hand_fumble_animation_transition_value = 1;
						
						hand_fumble_animation_cycle_timer = random_range(hand_fumble_animation_delay_min, hand_fumble_animation_delay_max);
						
						hand_fumble_animation_offset_ax = hand_fumble_animation_offset_bx;
						hand_fumble_animation_offset_ay = hand_fumble_animation_offset_by;
						
						hand_fumble_animation_offset_bx = random_range(-hand_fumble_animation_travel_size, hand_fumble_animation_travel_size);
						hand_fumble_animation_offset_by = random_range(-hand_fumble_animation_travel_size, hand_fumble_animation_travel_size);
					}
				}
				
				// Update Primary Hand Fumble Position
				hand_fumble_animation_offset_x = lerp(hand_fumble_animation_offset_bx, hand_fumble_animation_offset_ax, hand_fumble_animation_transition_value);
				hand_fumble_animation_offset_y = lerp(hand_fumble_animation_offset_by, hand_fumble_animation_offset_ay, hand_fumble_animation_transition_value);
				
				// Reset Thrown Weapon Transition Values
				thrown_weapon_aim_transition_value = 0;
				thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value = 0;
				
				// Calculate Hand Movement bringing the Thrown Weapon to the Operate Weapon Position Transition Animation
				if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.Molotov_IgniteHandFumble)
				{
					temp_thrown_weapon_operate_transition_value = power(thrown_weapon_operate_transition_value, thrown_weapon_operate_animation_curve_exponent);
					temp_thrown_weapon_operate_action_transition_value = 1 - power(1 - thrown_weapon_operate_action_transition_value, thrown_weapon_operate_action_animation_curve_exponent);
				}
				
				// Update Unit Holding Thrown Weapon Bobbing Animation Behaviour
				temp_thrown_weapon_primary_ambient_bob_angle = bobbing_animation_value * thrown_weapon_idle_primary_bobbing_angle;
				temp_thrown_weapon_secondary_ambient_bob_angle = bobbing_animation_value * thrown_weapon_idle_secondary_bobbing_angle;
				
				// Decrement Hand Fumble Timer
				hand_fumble_animation_timer -= frame_delta;
				
				// Hand Fumble Animation End Behaviour
				if (hand_fumble_animation_timer <= 0)
				{
					// Hand Fumble Finished Behaviour
					hand_fumble_animation_offset_x = 0;
					hand_fumble_animation_offset_y = 0;
					
					// Check Thrown Weapon Animation State Condition
					if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.Molotov_IgniteHandFumble)
					{
						// Advance Animation Stage from Ignite Molotov Hand Fumble to Throw Windup
						unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.ThrowWindup;
						
						// Molotov is Ignited - Disable Thrown Weapon Safety
						item_equipped.disable_safety();
						
						// DEBUG DEBUG DEBUG
						if (global.item_packs[item_equipped.item_pack].weapon_data.weapon_type == WeaponType.Molotov and ds_list_size(limb_primary_arm.limb_held_item_image_index_list) > 0)
						{
							ds_list_set(limb_primary_arm.limb_held_item_image_index_list, 0, 1);
						}
					}
					else if (unit_thrown_weapon_animation_state == UnitThrownWeaponAnimationState.GrabWeapon_HandFumble)
					{
						// Advance Animation Stage from Grab Weapon Hand Fumble to Throw Windup
						unit_thrown_weapon_animation_state = UnitThrownWeaponAnimationState.ThrowWindup;
						
						// Reset Thrown Weapon's Safety Engage - Pin is Set / Molotov is not Ignited
						item_equipped.thrown_weapon_safety_active = true;
						
						// Set Unit's Held Weapon Item
						limb_primary_arm.add_held_item(item_equipped.item_pack);
						
						// Update Holstered Stack Thrown Weapon Render Behaviour
						item_equipped.thrown_weapon_render = inventory_slots[inventory_index].item_count > 1;
					}
				}
				break;
			default:
				break;
		}
		
		// Walk Backwards while Aiming
		animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_unit_direction)) ? -1 : 1;
		
		// Check if Thrown Weapon Item still Exists and is Equipped
		if (item_equipped != noone)
		{
			// Update Unit's Thrown Weapon Holstered Angle
			var temp_thrown_weapon_holstered_angle_movement_difference = angle_difference(90 + (inventory_slots[inventory_index].slot_angle * temp_unit_direction), item_equipped.item_angle);
			var temp_thrown_weapon_holstered_item_angle = item_equipped.item_angle + (temp_thrown_weapon_holstered_angle_movement_difference * inventory_item_rotate_spd * frame_delta);
			
			// Update Thrown Weapon Instance's Physics - Holstered in Inventory Item Slot
			item_equipped.update_item_physics(inventory_slots[inventory_index].slot_position_x, inventory_slots[inventory_index].slot_position_y, temp_thrown_weapon_holstered_item_angle, temp_unit_direction);
		}
		
		// Update Unit's Weapon and Angle based on Facing Direction during Every Animation except the Weapon Throw Windup
		if (unit_thrown_weapon_animation_state != UnitThrownWeaponAnimationState.ThrowSwing and unit_thrown_weapon_animation_state != UnitThrownWeaponAnimationState.ThrowWindup and thrown_weapon_direction != temp_unit_direction)
		{
			// Thrown Weapon Facing Direction Behaviour
			thrown_weapon_direction = temp_unit_direction;
			
			// Mirror Thrown Weapon's Angle across the X Axis
			thrown_weapon_angle = ((angle_difference(thrown_weapon_angle, 270) <= 180 ? 180 : 360) - thrown_weapon_angle) mod 180;
		}
		
		// Calculate Thrown Weapon Animation Behaviour - Limb Inverse Kinematics
		if (thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value != 1)
		{
			// Establish Secondary Limb Animation Toggle
			var temp_thrown_weapon_hand_operate_secondary = false;
			
			// Establish Default Primary Limb's Inverse Kinematics Target Position
			var temp_thrown_weapon_primary_arm_target_x = inventory_slots[inventory_index].slot_position_x + hand_fumble_animation_offset_x;
			var temp_thrown_weapon_primary_arm_target_y = inventory_slots[inventory_index].slot_position_y + hand_fumble_animation_offset_y;
			
			// Thrown Weapon Animation State Condition Tree
			switch (unit_thrown_weapon_animation_state)
			{
				case UnitThrownWeaponAnimationState.ThrowWindup:
				case UnitThrownWeaponAnimationState.OperateAction_MoveHandsToReadyWeapon:
				case UnitThrownWeaponAnimationState.Grenade_PinPull:
				case UnitThrownWeaponAnimationState.Molotov_IgniteHandFumble:
					// Toggle Secondary Limb Animation Behaviour
					temp_thrown_weapon_hand_operate_secondary = true;
					
					// Establish Thrown Weapon's Operate Pivot Position
					var temp_thrown_weapon_operate_pivot_horizontal_offset = global.unit_packs[unit_pack].equipment_thrown_weapon_operate_pivot_x * draw_xscale;
					var temp_thrown_weapon_operate_pivot_vertical_offset = (global.unit_packs[unit_pack].equipment_thrown_weapon_operate_pivot_y + (bobbing_animation_value * inventory_vertical_bobbing_height)) * draw_yscale;
					
					var temp_thrown_weapon_operate_weapon_pivot_x = x + rot_point_x(temp_thrown_weapon_operate_pivot_horizontal_offset, temp_thrown_weapon_operate_pivot_vertical_offset);
					var temp_thrown_weapon_operate_weapon_pivot_y = y + ground_contact_vertical_offset + rot_point_y(temp_thrown_weapon_operate_pivot_horizontal_offset, temp_thrown_weapon_operate_pivot_vertical_offset);
					
					// Calculate Primary Limb's Inverse Kinematics Smooth Transition between the Thrown Weapon's Grab Weapon Animation State and Thrown Weapon's Operate Action Animation States
					temp_thrown_weapon_primary_arm_target_x = lerp(inventory_slots[inventory_index].slot_position_x, temp_thrown_weapon_operate_weapon_pivot_x, temp_thrown_weapon_operate_transition_value);
					temp_thrown_weapon_primary_arm_target_y = lerp(inventory_slots[inventory_index].slot_position_y, temp_thrown_weapon_operate_weapon_pivot_y, temp_thrown_weapon_operate_transition_value);
				case UnitThrownWeaponAnimationState.GrabWeapon:
				case UnitThrownWeaponAnimationState.GrabWeapon_HandFumble:
					// Thrown Weapon's Primary Limb Inverse Kinematics Behaviour
					if (thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value != 1)
					{
						// Perform Primary Limb's Inverse Kinematics Calculation
						limb_primary_arm.update_target(temp_thrown_weapon_primary_arm_target_x, temp_thrown_weapon_primary_arm_target_y);
						
						// Store Primary Limb's Upper Arm & Forearm Rotation Values
						thrown_weapon_primary_limb_pivot_a_angle = limb_primary_arm.limb_pivot_a_angle;
						thrown_weapon_primary_limb_pivot_b_angle = limb_primary_arm.limb_pivot_b_angle;
					}
					break;
				case UnitThrownWeaponAnimationState.ThrowSwingClimaxNoItemLeft:
					//
					if (thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value != 1)
					{
						// Perform Primary Limb's Inverse Kinematics Calculation
						limb_primary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, 1, 0);
						
						// Store Primary Limb's Upper Arm & Forearm Rotation Values
						thrown_weapon_primary_limb_pivot_a_angle = limb_primary_arm.limb_pivot_a_angle;
						thrown_weapon_primary_limb_pivot_b_angle = limb_primary_arm.limb_pivot_b_angle;
						
						// Perform Secondary Limb's Inverse Kinematics Calculation
						limb_secondary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, 1, 0);
						
						// Store Secondary Limb's Upper Arm & Forearm Rotation Values
						thrown_weapon_secondary_limb_pivot_a_angle = limb_secondary_arm.limb_pivot_a_angle;
						thrown_weapon_secondary_limb_pivot_b_angle = limb_secondary_arm.limb_pivot_b_angle;
					}
					
					//
					temp_thrown_weapon_operate_transition_value = 1 - thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value;
					break;
				default:
					break;
			}
			
			// Thrown Weapon's Secondary Limb Inverse Kinematics Behaviour
			if (temp_thrown_weapon_hand_operate_secondary and temp_thrown_weapon_operate_transition_value != 0)
			{
				// Calculate Angle of Thrown Weapon as Held Item in Unit's Primary Limb Hand
				var temp_thrown_weapon_held_item_angle = ds_list_size(limb_primary_arm.limb_held_item_image_angle_list) > 0 ? ds_list_find_value(limb_primary_arm.limb_held_item_image_angle_list, 0) * limb_primary_arm.limb_xscale : 0;
				var temp_thrown_weapon_primary_hand_angle = limb_primary_arm.limb_pivot_b_angle + (limb_primary_arm.limb_xscale < 0 ? 180 : 0) + temp_thrown_weapon_held_item_angle;
				
				rot_prefetch(temp_thrown_weapon_primary_hand_angle);
				
				// Calculate Secondary Limb's Inverse Kinematics Target Position as Thrown Weapon's Operate Action Position Offset
				var temp_thrown_weapon_operate_horizontal_offset = global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_position_x * temp_unit_direction;
				var temp_thrown_weapon_operate_vertical_offset = global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_position_y;
				
				temp_thrown_weapon_operate_horizontal_offset += global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_action_horizontal_offset * temp_thrown_weapon_operate_action_transition_value;
				temp_thrown_weapon_operate_vertical_offset += global.item_packs[item_equipped.item_pack].weapon_data.thrown_weapon_operate_action_vertical_offset * temp_thrown_weapon_operate_action_transition_value;
				
				// Set Secondary Limb's Thrown Weapon Inverse Kinematics Target Position
				var temp_thrown_weapon_secondary_arm_target_x = temp_thrown_weapon_operate_weapon_pivot_x + rot_point_x(temp_thrown_weapon_operate_horizontal_offset, temp_thrown_weapon_operate_vertical_offset);
				var temp_thrown_weapon_secondary_arm_target_y = temp_thrown_weapon_operate_weapon_pivot_y + rot_point_y(temp_thrown_weapon_operate_horizontal_offset, temp_thrown_weapon_operate_vertical_offset);
				
				// Perform Secondary Limb's Inverse Kinematics Calculation
				limb_secondary_arm.update_target(temp_thrown_weapon_secondary_arm_target_x + hand_fumble_animation_offset_x, temp_thrown_weapon_secondary_arm_target_y + hand_fumble_animation_offset_y);
				
				// Store Secondary Limb's Upper Arm & Forearm Rotation Values
				thrown_weapon_secondary_limb_pivot_a_angle = limb_secondary_arm.limb_pivot_a_angle;
				thrown_weapon_secondary_limb_pivot_b_angle = limb_secondary_arm.limb_pivot_b_angle;
			}
		}
		
		// Update Thrown Weapon's Aim Direction
		if (unit_thrown_weapon_animation_state != UnitThrownWeaponAnimationState.ThrowSwing and unit_thrown_weapon_animation_state != UnitThrownWeaponAnimationState.ThrowSwingClimax and unit_thrown_weapon_animation_state != UnitThrownWeaponAnimationState.ThrowSwingClimaxNoItemLeft)
		{
			// Calculate Thrown Weapon Aim Angle
			var temp_throw_aim_predict_angle = item_equipped != noone ? item_equipped.predict_angle(limb_primary_arm.limb_pivot_ax, limb_primary_arm.limb_pivot_ay, weapon_aim_x, weapon_aim_y) : (temp_unit_direction >= 0 ? 0 : 180);
			var temp_throw_aim_angle_difference = angle_difference(thrown_weapon_angle, temp_thrown_weapon_aim ? temp_throw_aim_predict_angle : (temp_unit_direction >= 0 ? 0 : 180));
			thrown_weapon_angle = (thrown_weapon_angle - (temp_throw_aim_angle_difference * thrown_aiming_angle_transition_spd * frame_delta)) mod 360;
			thrown_weapon_angle = thrown_weapon_angle < 0 ? thrown_weapon_angle + 360 : thrown_weapon_angle;
		}
		
		// Update Moving Unit's Thrown Weapon Bobbing Animation
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_thrown_weapon_moving_bob_angle = bobbing_animation_value * thrown_weapon_moving_bobbing_angle;
				break;
			default:
				break;
		}
		
		// Update Primary Arm's Upper Arm's Limb Angle
		limb_primary_arm.limb_pivot_a_angle = thrown_weapon_angle + temp_thrown_primary_limb_pivot_a_angle + temp_thrown_weapon_primary_ambient_bob_angle + temp_thrown_weapon_moving_bob_angle;
		limb_primary_arm.limb_pivot_a_angle = thrown_weapon_primary_limb_pivot_a_angle - (angle_difference(thrown_weapon_primary_limb_pivot_a_angle, limb_primary_arm.limb_pivot_a_angle) * thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value);
		limb_primary_arm.limb_pivot_a_angle = limb_primary_arm.limb_pivot_a_angle < 0 ? limb_primary_arm.limb_pivot_a_angle + 360 : limb_primary_arm.limb_pivot_a_angle;
		
		rot_prefetch(limb_primary_arm.limb_pivot_a_angle);
		
		// Update Primary Arm's Upper Arm to Forearm Pivot Position
		limb_primary_arm.limb_pivot_bx = limb_primary_arm.limb_pivot_ax + rot_point_x(limb_primary_arm.limb_length * 0.5, 0);
		limb_primary_arm.limb_pivot_by = limb_primary_arm.limb_pivot_ay + rot_point_y(limb_primary_arm.limb_length * 0.5, 0);
		
		// Update Primary Arm's Forearm's Limb Angle
		limb_primary_arm.limb_pivot_b_angle = thrown_weapon_angle + temp_thrown_primary_limb_pivot_b_angle - temp_thrown_weapon_primary_ambient_bob_angle;
		limb_primary_arm.limb_pivot_b_angle = thrown_weapon_primary_limb_pivot_b_angle - (angle_difference(thrown_weapon_primary_limb_pivot_b_angle, limb_primary_arm.limb_pivot_b_angle) * thrown_weapon_inventory_slot_pivot_to_thrown_weapon_position_pivot_transition_value);
		limb_primary_arm.limb_pivot_b_angle = limb_primary_arm.limb_pivot_b_angle < 0 ? limb_primary_arm.limb_pivot_b_angle + 360 : limb_primary_arm.limb_pivot_b_angle;
		
		rot_prefetch(limb_primary_arm.limb_pivot_b_angle);
		
		// Update Primary Arm's Held Item Position
		limb_primary_arm.limb_held_item_x = limb_primary_arm.limb_pivot_bx + rot_point_x((limb_primary_arm.limb_length * 0.5) - limb_primary_arm.limb_held_item_depth, 0);
		limb_primary_arm.limb_held_item_y = limb_primary_arm.limb_pivot_by + rot_point_y((limb_primary_arm.limb_length * 0.5) - limb_primary_arm.limb_held_item_depth, 0);
		
		// Update Secondary Arm's Upper Arm's Limb Angle
		limb_secondary_arm.limb_pivot_a_angle = thrown_weapon_angle + temp_thrown_secondary_limb_pivot_a_angle + temp_thrown_weapon_secondary_ambient_bob_angle - temp_thrown_weapon_moving_bob_angle;
		limb_secondary_arm.limb_pivot_a_angle = thrown_weapon_secondary_limb_pivot_a_angle - (angle_difference(thrown_weapon_secondary_limb_pivot_a_angle, limb_secondary_arm.limb_pivot_a_angle) * (1 - temp_thrown_weapon_operate_transition_value));
		limb_secondary_arm.limb_pivot_a_angle = limb_secondary_arm.limb_pivot_a_angle < 0 ? limb_secondary_arm.limb_pivot_a_angle + 360 : limb_secondary_arm.limb_pivot_a_angle;
		
		rot_prefetch(limb_secondary_arm.limb_pivot_a_angle);
		
		// Update Secondary Arm's Upper Arm to Forearm Pivot Position
		limb_secondary_arm.limb_pivot_bx = limb_secondary_arm.limb_pivot_ax + rot_point_x(limb_secondary_arm.limb_length * 0.5, 0);
		limb_secondary_arm.limb_pivot_by = limb_secondary_arm.limb_pivot_ay + rot_point_y(limb_secondary_arm.limb_length * 0.5, 0);
		
		// Update Secondary Arm's Forearm's Limb Angle
		limb_secondary_arm.limb_pivot_b_angle = thrown_weapon_angle + temp_thrown_secondary_limb_pivot_b_angle - temp_thrown_weapon_secondary_ambient_bob_angle;
		limb_secondary_arm.limb_pivot_b_angle = thrown_weapon_secondary_limb_pivot_b_angle - (angle_difference(thrown_weapon_secondary_limb_pivot_b_angle, limb_secondary_arm.limb_pivot_b_angle) * (1 - temp_thrown_weapon_operate_transition_value));
		limb_secondary_arm.limb_pivot_b_angle = limb_secondary_arm.limb_pivot_b_angle < 0 ? limb_secondary_arm.limb_pivot_b_angle + 360 : limb_secondary_arm.limb_pivot_b_angle;
		
		// Disable Primary & Secondary Arm Default Animations
		temp_primary_limb_default_animation_active = false;
		temp_secondary_limb_default_animation_active = false;
		break;
	case UnitEquipmentAnimationState.FirearmReload:
		// Firearm Reload Behaviour
		switch (unit_firearm_reload_animation_state)
		{
			case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
			case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				// Bolt Action Reload Events - Primary Hand operates Firearm's Bolt Handle sliding it backwards or forwards to open or close Firearm's Chamber
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Firearm must have finished its recoil animation cycle to perform Bolt Action Firearm's reload animation
				if (item_equipped.firearm_recoil_recovery_delay <= 0 and item_equipped.firearm_attack_delay <= 0)
				{
					// Update Unit's Primary Hand Path Animation - Fast Hand Speed for opening and closing the Firearm's Bolt Handle
					firearm_weapon_hand_pivot_transition_value = lerp(firearm_weapon_hand_pivot_transition_value, 1, hand_fast_movement_spd * frame_delta);
					
					// Firearm must be aimed and Unit must have finished their Primary Hand's Path Animation to perform next Animation Event
					if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 1 - animation_asymptotic_tolerance and firearm_weapon_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
					{
						switch (unit_firearm_reload_animation_state)
						{
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
								// Bolt Action Firearm's Chamber is Opened (The Bolt Handle has been pulled backwards for a reload animation) - Begin moving primary hand to Unit's Inventory to grab individual ammo rounds
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory;
								
								// Reset Primary Hand Animation's Path Interpolation Value to begin next animation (Inversed Path Interpolation Value) 
								firearm_weapon_hand_pivot_transition_value = 1;
								
								// Open Firearm Chamber
								item_equipped.open_firearm_chamber();
								break;
							case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
							case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
								// Bolt Action Firearm's Chamber is Opened (The Bolt Handle has been pulled backwards for the animation displayed between shots) - Begin pushing the Firearm's Bolt Handle forward to recharge for the next shot
								if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								}
								else
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								}
								
								// Open Firearm Chamber
								item_equipped.open_firearm_chamber();
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Opened Bolt Position to Firearm's Closed Bolt Position
								unit_set_firearm_hand_animation
								(
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_x, 
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_y,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y,
									0
								);
								break;
							case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
							case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
							default:
								// End Bolt Action Reload Animation
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadBoltHandle_End;
							
								// Close Firearm Chamber
								item_equipped.close_firearm_chamber();
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Closed Bolt Position to Firearm's Trigger Group (Inversed Path Interpolation Value)
								unit_set_firearm_hand_animation
								(
									global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x, 
									global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y,
									1
								);
								break;
						}
					}
				}
				break;
			case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
			case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
			case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				// Bolt Action Reload Events - Primary Hand moves from ambient position to operate Firearm's Bolt Handle
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Firearm must have finished its recoil animation cycle to perform Bolt Action Firearm's reload animation
				if (item_equipped.firearm_recoil_recovery_delay <= 0 and item_equipped.firearm_attack_delay <= 0)
				{
					// Update Unit's Primary Hand Path Animation - Default Hand Speed
					firearm_weapon_hand_pivot_transition_value = lerp(firearm_weapon_hand_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
					
					// Firearm must be aimed and Unit must have finished their Primary Hand's Path Animation to perform next Animation Event
					if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 1 - animation_asymptotic_tolerance and firearm_weapon_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
					{
						firearm_weapon_hip_pivot_to_aim_pivot_transition_value = 1;
						
						switch (unit_firearm_reload_animation_state)
						{
							case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
							case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
								// Bolt Action Primary Hand Animation for grabbing the Bolt Handle BACKWARDS to open the Firearm's Chamber
								if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle;
								}
								else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle;
								}
								else
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle;
								}
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Open Bolt Position to Firearm's Closed Bolt Position
								unit_set_firearm_hand_animation
								(
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x, 
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y, 
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_x,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_y,
									0
								);
								break;
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
							case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
								// Bolt Action Primary Hand Animation for grabbing the Bolt Handle FORWARD to close the Firearm's Chamber
								if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition)
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								}
								else
								{
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle;
								}
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Closed Bolt Position to Firearm's Open Bolt Position
								unit_set_firearm_hand_animation
								(
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_x, 
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_y,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x,
									global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y,
									0
								);
								break;
						}
					}
				}
				break;
			case UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory:
				// Rest Gun at hip pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 0, firearm_aiming_hip_transition_spd * frame_delta);
				firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
				
				// Progress to next Reload Animation State
				if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value <= animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value >= (1 - animation_asymptotic_tolerance))
				{
					// Set Hand Fumble Animation
					unit_set_hand_fumble_animation(30);
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_InventoryHandFumbleAnimation;
					
					// Reset Transition Values
					firearm_weapon_hip_pivot_to_aim_pivot_transition_value = 0;
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 1;
				}
				break;
			case UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToFirearmReloadPosition:
				// Move Hand to Reload Firearm
				firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
				
				if (firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value <= animation_asymptotic_tolerance)
				{
					// Set to either Magazine Insert Animation State or Reload Individual Rounds Animation State
					unit_firearm_reload_animation_state = global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_individual_rounds ? UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition : UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation;
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation:
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition:
				// Move Hand to Reload Firearm
				firearm_weapon_hand_pivot_transition_value = lerp(firearm_weapon_hand_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
				
				if (firearm_weapon_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
				{
					// Set Hand Fumble Animation
					unit_set_hand_fumble_animation(20);
					
					switch (unit_firearm_reload_animation_state)
					{
						case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition:
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation;
							break;
						case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation:
						default:
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation;
							break;
					}
					
					// Reset Primary Hand Animation's Path Interpolation Value to begin next animation (Inversed Path Interpolation Value)
					firearm_weapon_hand_pivot_transition_value = 1;
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition:
				// Move Hand to Reload Individual Rounds into Firearm from Reload Offset Position - Extremely Fast Reload Animation
				firearm_weapon_hand_pivot_transition_value *= power(0.5, frame_delta);
				
				if (firearm_weapon_hand_pivot_transition_value <= animation_asymptotic_tolerance)
				{
					// Primary Hand is positioned at Firearm's Reload Offset Position - Begin the animation to load another round into Firearm
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition;
					
					// Reset Primary Hand Animation's Path Interpolation Value to begin next animation
					firearm_weapon_hand_pivot_transition_value = 0;
				}
				break;
			case UnitFirearmReloadAnimationState.Reload_InventoryHandFumbleAnimation:
			case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation:
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation:
				// Hand Fumble Animation Transition
				hand_fumble_animation_transition_value = lerp(hand_fumble_animation_transition_value, 0, hand_fumble_animation_travel_spd * frame_delta);
				
				if (hand_fumble_animation_transition_value <= animation_asymptotic_tolerance)
				{
					// Hand Fumble Animation Repeat Timer
					hand_fumble_animation_cycle_timer -= frame_delta;
					
					if (hand_fumble_animation_cycle_timer <= 0)
					{
						// Reset Hand Fumble Animation to next position
						hand_fumble_animation_transition_value = 1;
						
						hand_fumble_animation_cycle_timer = random_range(hand_fumble_animation_delay_min, hand_fumble_animation_delay_max);
						
						hand_fumble_animation_offset_ax = hand_fumble_animation_offset_bx;
						hand_fumble_animation_offset_ay = hand_fumble_animation_offset_by;
						
						hand_fumble_animation_offset_bx = random_range(-hand_fumble_animation_travel_size, hand_fumble_animation_travel_size);
						hand_fumble_animation_offset_by = random_range(-hand_fumble_animation_travel_size, hand_fumble_animation_travel_size);
					}
				}
				
				// Update Primary Hand Fumble Position
				hand_fumble_animation_offset_x = lerp(hand_fumble_animation_offset_bx, hand_fumble_animation_offset_ax, hand_fumble_animation_transition_value);
				hand_fumble_animation_offset_y = lerp(hand_fumble_animation_offset_by, hand_fumble_animation_offset_ay, hand_fumble_animation_transition_value);
				
				// Hand Fumble Timer
				hand_fumble_animation_timer -= frame_delta;
				
				if (hand_fumble_animation_timer <= 0)
				{
					// Hand Fumble Finished Behaviour
					hand_fumble_animation_offset_x = 0;
					hand_fumble_animation_offset_y = 0;
					
					// Hand Fumble Animation End Conditions
					if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.Reload_InventoryHandFumbleAnimation)
					{
						// Remove Item from Inventory
						unit_inventory_remove_item(id, global.item_packs[item_equipped.item_pack].weapon_data.firearm_ammo_item_pack);
						
						// Hand Grabs Item from Inventory
						unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToFirearmReloadPosition;
						
						var temp_firearm_reload_held_item_count = 1;
						
						if (global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_individual_rounds)
						{
							temp_firearm_reload_held_item_count = global.item_packs[item_equipped.item_pack].weapon_data.firearm_ammo_max_capacity - item_equipped.firearm_ammo;
						}
						
						repeat (temp_firearm_reload_held_item_count)
						{
							if (!global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
							{
								limb_primary_arm.add_held_item(item_equipped.item_pack);
							}
							else
							{
								limb_secondary_arm.add_held_item(item_equipped.item_pack);
							}
						}
						
						// Configure Primary Hand Pivots to perform Magazine Animation
						unit_set_firearm_hand_animation
						(
							global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_x + global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_offset_x, 
							global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_y + global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_offset_y,
							global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_x,
							global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_y,
							0
						);
					}
					else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation)
					{
						// End Reload Animation
						unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
						
						// Insert Magazine
						if (global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_magazine and !item_equipped.firearm_magazine_inserted)
						{
							item_equipped.insert_magazine();
						}
						
						// Magazine is loaded into Firearm 
						item_equipped.reload_firearm();
						
						// Close Firearm Chamber
						item_equipped.close_firearm_chamber();
						
						// Set Hand's Firearm Animation Path - From Firearm's Magazine Reload Position to Firearm's Hand Trigger Position (Inversed Path Interpolation Value)
						if (!global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
						{
							// Reset Primary Hand's Held Item
							limb_primary_arm.remove_all_held_items();
							
							// Set Primary Hand's Firearm Animation Path
							unit_set_firearm_hand_animation
							(
								global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x,
								global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y,
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_x,
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_y,
								1
							);
						}
						else
						{
							// Reset Primary Hand's Held Item
							limb_secondary_arm.remove_all_held_items();
							
							// Set Secondary Hand's Firearm Animation Path
							unit_set_firearm_hand_animation
							(
								global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_x,
								global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_y,
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_x,
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_y,
								1
							);
						}
					}
					else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation)
					{
						// Reload Firearm with One Round
						item_equipped.reload_firearm(1);
						
						// Remove Ammo from Primary Hand's Held Item
						limb_primary_arm.remove_held_item();
						limb_secondary_arm.remove_held_item();
						
						// Check if Firearm is finished being reloaded
						if (item_equipped.firearm_ammo < global.item_packs[item_equipped.item_pack].weapon_data.firearm_ammo_max_capacity)
						{
							// Firearm is not finished being reloaded - Begin reloading another round
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition;
						}
						else
						{
							// Firearm is finished being reloaded - Move hand to close Bolt Action Chamber
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition;
						
							// Reset Primary Hand's Held Item
							limb_primary_arm.remove_all_held_items();
							limb_secondary_arm.remove_all_held_items();
							
							// Set Primary Hand's Firearm Animation Path - From Firearm's Reload Position to Firearm's Open Bolt Position
							unit_set_firearm_hand_animation
							(
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_x, 
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_y,
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_x + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_x,
								global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_position_y + global.item_packs[item_equipped.item_pack].weapon_data.firearm_bolt_handle_charge_offset_y,
								0
							);
						}
					}
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadBoltHandle_End:
			case UnitFirearmReloadAnimationState.Reload_End:
			default:
				// Reload Animation Reset Behaviour
				limb_primary_arm.remove_all_held_items();
				limb_secondary_arm.remove_all_held_items();
				
				// Close Firearm Chamber
				item_equipped.close_firearm_chamber();
				
				// End Firearm Spin Reload
				item_equipped.firearm_spin_reload = false;
				item_equipped.firearm_spin_reload_angle = 0;
				
				// Reset Unit Equipment State to Firearm
				unit_equipment_animation_state = UnitEquipmentAnimationState.Firearm;
				
				// Reset Hand Fumble Animation Values
				hand_fumble_animation_offset_x = 0;
				hand_fumble_animation_offset_y = 0;
				break;
		}
	case UnitEquipmentAnimationState.Firearm:
		// Firearm Animation States
		var temp_firearm_reload = unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload;
		var temp_firearm_is_aimed = weapon_aim and !temp_firearm_reload;
		var temp_firearm_reload_secondary_hand_limb_direction_reversed = true;
		
		// Update Facing Direction
		draw_xscale = temp_firearm_is_aimed ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
		temp_unit_direction = sign(draw_xscale);
		animation_speed_direction = 1;
		
		// Pull Unit's Slope Rotation
		trig_sine = draw_angle_trig_sine;
		trig_cosine = draw_angle_trig_cosine;
		
		// Firearm Reload Animation
		var temp_firearm_ambient_angle;
		
		var temp_firearm_primary_hand_horizontal_offset = global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_x;
		var temp_firearm_primary_hand_vertical_offset = global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_primary_y;
		
		var temp_firearm_offhand_hand_horizontal_offset = global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_x;
		var temp_firearm_offhand_hand_vertical_offset = global.item_packs[item_equipped.item_pack].weapon_data.weapon_hand_position_offhand_y;
		
		if (!global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
		{
			temp_firearm_primary_hand_horizontal_offset = lerp(temp_firearm_primary_hand_horizontal_offset, firearm_weapon_hand_pivot_offset_bx, firearm_weapon_hand_pivot_transition_value);
			temp_firearm_primary_hand_vertical_offset = lerp(temp_firearm_primary_hand_vertical_offset, firearm_weapon_hand_pivot_offset_by, firearm_weapon_hand_pivot_transition_value);
		}
		else
		{
			temp_firearm_offhand_hand_horizontal_offset = lerp(temp_firearm_offhand_hand_horizontal_offset, firearm_weapon_hand_pivot_offset_bx, firearm_weapon_hand_pivot_transition_value);
			temp_firearm_offhand_hand_vertical_offset = lerp(temp_firearm_offhand_hand_vertical_offset, firearm_weapon_hand_pivot_offset_by, firearm_weapon_hand_pivot_transition_value);
		}
		
		// Firearm Operation Behaviour
		if (temp_firearm_reload)
		{
			// Reload Animation Weapon Ambient Angle
			switch (unit_firearm_reload_animation_state)
			{
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadBoltHandle_End:
					// Reset Primary Hand to Firearm Operation Position - Reload Interrupt Hand Movement is Fast
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_fast_movement_spd * frame_delta);
					
					// Refresh Facing Direction - Reload Interrupt Allows Firearm Aiming
					temp_firearm_is_aimed = weapon_aim;
					draw_xscale = temp_firearm_is_aimed ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
					temp_unit_direction = sign(draw_xscale);
					
					// Walk Backwards while Aiming
					animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_unit_direction)) ? -1 : 1;
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
					// Point firearm at Weapon Angle previously held before reloading
					temp_firearm_ambient_angle = draw_xscale < 0 ? 180 - item_equipped.item_old_angle : item_equipped.item_old_angle;
					break;
				default:
					// Point firearm at Reload Safety Angle
					temp_firearm_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + (global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_safety_angle * temp_unit_direction);
					break;
			}
			
			// Firearm Reload Spin Animation
			if (item_equipped.firearm_spin_reload)
			{
				// Perform Firearm Spin Reload Rotation
				item_equipped.firearm_spin_reload_angle += item_equipped.firearm_spin_reload_spd * frame_delta;
				
				// Perform Firearm Spent Cartridge Eject Animation after one successful Revolution
				if (abs(item_equipped.firearm_spin_reload_angle) >= 360)
				{
					// Eject Firearm Cartridges
					if (item_equipped.firearm_eject_cartridge_num > 0)
					{
						// Remove All Ammo from Firearm
						item_equipped.firearm_eject_cartridge_num += item_equipped.firearm_ammo;
						item_equipped.firearm_ammo = 0;
						
						// Open Firearm Chamber Cartridge Eject Behaviour
						item_equipped.open_firearm_chamber();
					}
					
					// Update Firearm Image
					item_equipped.item_image_index = 1;
				}
				
				// Check if Firearm Spin Reload Animation is Finished
				if (abs(item_equipped.firearm_spin_reload_angle) >= 1080)
				{
					item_equipped.firearm_spin_reload = false;
					item_equipped.firearm_spin_reload_angle = 0;
				}
			}
			
			// Update Unit Equipment Inventory Position
			unit_equipment_position_x = x + (rot_point_x(global.unit_packs[unit_pack].equipment_inventory_x * draw_xscale, global.unit_packs[unit_pack].equipment_inventory_y));
			unit_equipment_position_y = y + ground_contact_vertical_offset + (rot_point_y(global.unit_packs[unit_pack].equipment_inventory_x * draw_xscale, global.unit_packs[unit_pack].equipment_inventory_y) * draw_yscale);
			
			// Update Reload Hand Position
			if (!global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
			{
				// Update Primary Hand Position
				temp_firearm_primary_hand_horizontal_offset = lerp(firearm_weapon_hand_pivot_offset_ax, firearm_weapon_hand_pivot_offset_bx, firearm_weapon_hand_pivot_transition_value);
				temp_firearm_primary_hand_vertical_offset = lerp(firearm_weapon_hand_pivot_offset_ay, firearm_weapon_hand_pivot_offset_by, firearm_weapon_hand_pivot_transition_value);
			}
			else
			{
				// Disable Firearm Reload Secondary Hand's Limb Direction Reversal
				switch (unit_firearm_reload_animation_state)
				{
					case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
					case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
					case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
					case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
					case UnitFirearmReloadAnimationState.ReloadBoltHandle_End:
					case UnitFirearmReloadAnimationState.Reload_End:
						temp_firearm_reload_secondary_hand_limb_direction_reversed = false;
						break;
				}
				
				// Update Secondary Hand Position
				temp_firearm_offhand_hand_horizontal_offset = lerp(firearm_weapon_hand_pivot_offset_ax, firearm_weapon_hand_pivot_offset_bx, firearm_weapon_hand_pivot_transition_value);
				temp_firearm_offhand_hand_vertical_offset = lerp(firearm_weapon_hand_pivot_offset_ay, firearm_weapon_hand_pivot_offset_by, firearm_weapon_hand_pivot_transition_value);
			}
		}
		else
		{
			// Reset Primary Hand to Firearm Operation Position
			firearm_weapon_hand_pivot_transition_value = lerp(firearm_weapon_hand_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
			firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
			
			// Firearm Aiming & Holstered Operation Behaviour
			if (temp_firearm_is_aimed)
			{
				// Move firearm to aiming pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_aim_transition_spd * frame_delta);
				
				// Walk Backwards while Aiming
				animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_unit_direction)) ? -1 : 1;
				
				// Update Old Weapon Angle
				item_equipped.item_old_angle = temp_unit_direction < 0 ? 180 - item_equipped.item_angle : item_equipped.item_angle;
			}
			else
			{
				// Rest Gun at hip pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 0, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Point firearm at Idle Safety Angle if Idle, point firearm at Moving Safety Angle if Moving
				var temp_firearm_safety_angle = x_velocity == 0 ? (global.item_packs[item_equipped.item_pack].weapon_data.firearm_idle_safety_angle * temp_unit_direction) : (global.item_packs[item_equipped.item_pack].weapon_data.firearm_moving_safety_angle * temp_unit_direction);
				temp_firearm_ambient_angle = (temp_unit_direction < 0 ? 180 + draw_angle_value : draw_angle_value) + temp_firearm_safety_angle;
			}
		}
		
		// Update Unit's Weapon Offset
		var temp_firearm_horizontal_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_x, global.unit_packs[unit_pack].equipment_firearm_aim_x, firearm_weapon_hip_pivot_to_aim_pivot_transition_value) * draw_xscale;
		var temp_firearm_vertical_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_y, global.unit_packs[unit_pack].equipment_firearm_aim_y, firearm_weapon_hip_pivot_to_aim_pivot_transition_value) * draw_yscale;
		
		// Update Moving Unit's Firearm Weapon Bobbing Animation
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_firearm_vertical_offset += bobbing_animation_value * firearm_weapon_moving_vertical_bobbing_height;
				break;
			default:
				break;
		}
		
		// Update Weapon Recoil
		temp_firearm_horizontal_offset += item_equipped.weapon_horizontal_recoil * temp_unit_direction;
		temp_firearm_vertical_offset += item_equipped.weapon_vertical_recoil;
		
		// Update Weapon Position
		var temp_firearm_x = x + rot_point_x(temp_firearm_horizontal_offset, temp_firearm_vertical_offset);
		var temp_firearm_y = y + ground_contact_vertical_offset + rot_point_y(temp_firearm_horizontal_offset, temp_firearm_vertical_offset);
		
		// Update Limb Pivots
		limb_primary_arm.limb_xscale = temp_unit_direction;
		limb_secondary_arm.limb_xscale = temp_unit_direction * (temp_firearm_reload and global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand and temp_firearm_reload_secondary_hand_limb_direction_reversed ? -1 : 1);
		
		var temp_left_arm_anchor_offset_x = limb_primary_arm.anchor_offset_x * draw_xscale;
		var temp_left_arm_anchor_offset_y = limb_primary_arm.anchor_offset_y * draw_yscale;
		
		limb_primary_arm.limb_pivot_ax = x + rot_point_x(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		limb_primary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		
		var temp_right_arm_anchor_offset_x = limb_secondary_arm.anchor_offset_x * draw_xscale;
		var temp_right_arm_anchor_offset_y = limb_secondary_arm.anchor_offset_y * draw_yscale;
		
		limb_secondary_arm.limb_pivot_ax = x + rot_point_x(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		limb_secondary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		
		// Update Weapon's Angle
		var temp_firearm_angle_difference = angle_difference(item_equipped.item_angle, temp_firearm_is_aimed ? point_direction(temp_firearm_x, temp_firearm_y, weapon_aim_x, weapon_aim_y) : temp_firearm_ambient_angle);
		var temp_firearm_angle = (item_equipped.item_angle - (temp_firearm_angle_difference * firearm_aiming_angle_transition_spd * frame_delta)) mod 360;
		temp_firearm_angle = temp_firearm_angle < 0 ? temp_firearm_angle + 360 : temp_firearm_angle;
		
		// Update Weapon Position & Angle Physics
		rot_prefetch((item_equipped.item_angle + (item_equipped.weapon_angle_recoil * item_equipped.item_facing_sign)) mod 360);
		
		temp_firearm_x += rot_point_x(global.item_packs[item_equipped.item_pack].weapon_data.weapon_position_horizontal_offset, global.item_packs[item_equipped.item_pack].weapon_data.weapon_position_vertical_offset);
		temp_firearm_y += rot_point_y(global.item_packs[item_equipped.item_pack].weapon_data.weapon_position_horizontal_offset, global.item_packs[item_equipped.item_pack].weapon_data.weapon_position_vertical_offset);
		
		item_equipped.update_item_physics(temp_firearm_x, temp_firearm_y, temp_firearm_angle, temp_unit_direction);
		
		// Update Weapon Limb Targets
		temp_firearm_primary_hand_vertical_offset *= item_equipped.item_facing_sign;
		temp_firearm_offhand_hand_vertical_offset *= item_equipped.item_facing_sign;
		
		var temp_firearm_primary_hand_target_x = item_equipped.item_x + rot_point_x(temp_firearm_primary_hand_horizontal_offset, temp_firearm_primary_hand_vertical_offset);
		var temp_firearm_primary_hand_target_y = item_equipped.item_y + rot_point_y(temp_firearm_primary_hand_horizontal_offset, temp_firearm_primary_hand_vertical_offset);
		
		if (temp_firearm_reload and !global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
		{
			temp_firearm_primary_hand_target_x = lerp(temp_firearm_primary_hand_target_x, unit_equipment_position_x, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_x;
			temp_firearm_primary_hand_target_y = lerp(temp_firearm_primary_hand_target_y, unit_equipment_position_y, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_y;
		}
		
		limb_primary_arm.update_target(temp_firearm_primary_hand_target_x, temp_firearm_primary_hand_target_y);
		temp_primary_limb_default_animation_active = false;
		
		var temp_firearm_offhand_hand_target_x = item_equipped.item_x + rot_point_x(temp_firearm_offhand_hand_horizontal_offset, temp_firearm_offhand_hand_vertical_offset);
		var temp_firearm_offhand_hand_target_y = item_equipped.item_y + rot_point_y(temp_firearm_offhand_hand_horizontal_offset, temp_firearm_offhand_hand_vertical_offset);
		
		if (temp_firearm_reload and global.item_packs[item_equipped.item_pack].weapon_data.firearm_reload_with_secondary_hand)
		{
			temp_firearm_offhand_hand_target_x = lerp(temp_firearm_offhand_hand_target_x, unit_equipment_position_x, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_x;
			temp_firearm_offhand_hand_target_y = lerp(temp_firearm_offhand_hand_target_y, unit_equipment_position_y, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_y;
		}
		
		limb_secondary_arm.update_target(temp_firearm_offhand_hand_target_x, temp_firearm_offhand_hand_target_y);
		temp_secondary_limb_default_animation_active = false;
		break;
	case UnitEquipmentAnimationState.Item:
		// Calculate Item Transition Lerp Values
		item_drop_offset_transition_value = lerp(item_drop_offset_transition_value, 0, item_drop_offset_transition_spd * frame_delta);
		item_inventory_slot_pivot_to_unit_item_position_pivot_transition_value = lerp(item_inventory_slot_pivot_to_unit_item_position_pivot_transition_value, 1, item_slot_to_holding_position_transition_spd * frame_delta);
		
		// Calculate Item Offset and Target Position
		var temp_item_equipment_horizontal_offset = global.unit_packs[unit_pack].equipment_item_x + global.item_packs[inventory_slots[inventory_index].item_pack].item_data.item_horizontal_offset;
		var temp_item_equipment_vertical_offset = global.unit_packs[unit_pack].equipment_item_y + global.item_packs[inventory_slots[inventory_index].item_pack].item_data.item_vertical_offset;
		
		var temp_unit_scaled_item_horizontal_offset = temp_item_equipment_horizontal_offset * draw_xscale;
		var temp_unit_scaled_item_vertical_offset = (temp_item_equipment_vertical_offset + (item_drop_offset_length * item_drop_offset_transition_value) + (bobbing_animation_value * inventory_vertical_bobbing_height)) * draw_yscale;
		
		var temp_item_target_position_x = x + rot_point_x(temp_unit_scaled_item_horizontal_offset, temp_unit_scaled_item_vertical_offset);
		var temp_item_target_position_y = y + ground_contact_vertical_offset + rot_point_y(temp_unit_scaled_item_horizontal_offset, temp_unit_scaled_item_vertical_offset);
		
		// Update Unit's Held Equipment Position
		unit_equipment_position_x = lerp(inventory_slots[inventory_index].slot_position_x, temp_item_target_position_x, item_inventory_slot_pivot_to_unit_item_position_pivot_transition_value);
		unit_equipment_position_y = lerp(inventory_slots[inventory_index].slot_position_y, temp_item_target_position_y, item_inventory_slot_pivot_to_unit_item_position_pivot_transition_value);
		
		// Update Weapon Position & Angle Physics
		item_equipped.update_item_physics(unit_equipment_position_x, unit_equipment_position_y, (temp_unit_direction < 0 ? 180 : 0), temp_unit_direction);
		
		// Compare Held Item's Hand Configuration
		switch (global.item_packs[inventory_slots[inventory_index].item_pack].item_hand)
		{
			case ItemHand.Primary:
				temp_primary_limb_default_animation_active = false;
				break;
			case ItemHand.Secondary:
				temp_secondary_limb_default_animation_active = false;
				break;
			case ItemHand.Both:
				temp_primary_limb_default_animation_active = false;
				temp_secondary_limb_default_animation_active = false;
				break;
		}
		
		// Perform Primary Limb's Item Held Animation
		if (!temp_primary_limb_default_animation_active)
		{
			// Match Limb's Direction with Unit's Direction
			limb_primary_arm.limb_xscale = temp_unit_direction;
			
			// Update Limb's Holding Item Arm Pivots
			var temp_left_arm_anchor_offset_x = limb_primary_arm.anchor_offset_x * draw_xscale;
			var temp_left_arm_anchor_offset_y = limb_primary_arm.anchor_offset_y * draw_yscale;
			
			limb_primary_arm.limb_pivot_ax = x + rot_point_x(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
			limb_primary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
			
			// Update Limb's Holding Item Hand Positions
			var temp_item_primary_hand_horizontal_offset = global.item_packs[inventory_slots[inventory_index].item_pack].item_data.item_primary_hand_horizontal_offset * draw_xscale;
			var temp_item_primary_hand_vertical_offset = global.item_packs[inventory_slots[inventory_index].item_pack].item_data.item_primary_hand_vertical_offset * draw_yscale;
			
			limb_primary_arm.update_target(unit_equipment_position_x + temp_item_primary_hand_horizontal_offset, unit_equipment_position_y + temp_item_primary_hand_vertical_offset);
		}
		
		// Perform Secondary Limb's Item Held Animation
		if (!temp_secondary_limb_default_animation_active)
		{
			// Match Limb's Direction with Unit's Direction
			limb_secondary_arm.limb_xscale = temp_unit_direction;
			
			// Update Limb's Holding Item Arm Pivots
			var temp_right_arm_anchor_offset_x = limb_secondary_arm.anchor_offset_x * draw_xscale;
			var temp_right_arm_anchor_offset_y = limb_secondary_arm.anchor_offset_y * draw_yscale;
			
			limb_secondary_arm.limb_pivot_ax = x + rot_point_x(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
			limb_secondary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
			
			// Update Limb's Holding Item Hand Positions
			var temp_item_secondary_hand_horizontal_offset = global.item_packs[inventory_slots[inventory_index].item_pack].item_data.item_secondary_hand_horizontal_offset * draw_xscale;
			var temp_item_secondary_hand_vertical_offset = global.item_packs[inventory_slots[inventory_index].item_pack].item_data.item_secondary_hand_vertical_offset * draw_yscale;
			
			limb_secondary_arm.update_target(unit_equipment_position_x + temp_item_secondary_hand_horizontal_offset, unit_equipment_position_y + temp_item_secondary_hand_vertical_offset);
		}
	default:
		// Reset Animation Speed Direction
		animation_speed_direction = 1;
		break;
}

// Perform Default Limb Animations
if (temp_primary_limb_default_animation_active or temp_secondary_limb_default_animation_active)
{
	// Pull Unit's Slope Rotation
	trig_sine = draw_angle_trig_sine;
	trig_cosine = draw_angle_trig_cosine;
	
	// Update Limb Anchor Trig Values
	limb_primary_arm.anchor_trig_sine = trig_sine;
	limb_primary_arm.anchor_trig_cosine = trig_cosine;
	limb_secondary_arm.anchor_trig_sine = trig_sine;
	limb_secondary_arm.anchor_trig_cosine = trig_cosine;
	
	// Update Non-Weapon Unit Animations
	var temp_animation_percentage = 0;
	
	switch (unit_animation_state)
	{
		case UnitAnimationState.Idle:
			// Calculate Unit Limb Animation Value
			temp_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
			
			// Perfrom Unequipped Idle Primary Hand Animation
			if (temp_primary_limb_default_animation_active)
			{
				limb_primary_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage);
			}
			
			// Perfrom Unequipped Idle Secondary Hand Animation
			if (temp_secondary_limb_default_animation_active)
			{
				limb_secondary_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage);
			}
			break;
		case UnitAnimationState.Walking:
		case UnitAnimationState.AimWalking:
			// Calculate Unit Limb Animation Value
			temp_animation_percentage = floor(draw_image_index) / draw_image_index_length;
			var temp_walk_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
			
			// Perfrom Unequipped Walking Primary Hand Animation
			if (temp_primary_limb_default_animation_active)
			{
				limb_primary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage, temp_walk_animation_percentage);
			}
			
			// Perfrom Unequipped Walking Secondary Hand Animation
			if (temp_secondary_limb_default_animation_active)
			{
				limb_secondary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage, temp_walk_animation_percentage);
			}
			break;
		case UnitAnimationState.Jumping:
			// Perfrom Unequipped Jumping Primary Hand Animation
			if (temp_primary_limb_default_animation_active)
			{
				limb_primary_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale);
			}
			
			// Perfrom Unequipped Jumping Secondary Hand Animation
			if (temp_secondary_limb_default_animation_active)
			{
				limb_secondary_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale);
			}
			break;
	}
}
#endregion

// Update Image Index
if (draw_image_index_length != -1)
{
	draw_image_index += (animation_speed * animation_speed_direction) * frame_delta;
	
	if (draw_image_index >= draw_image_index_length)
	{
		limb_animation_double_cycle = !limb_animation_double_cycle;
		draw_image_index = draw_image_index mod draw_image_index_length;
	}
	else if (draw_image_index < 0)
	{
		limb_animation_double_cycle = !limb_animation_double_cycle;
		draw_image_index = (draw_image_index mod draw_image_index_length) + draw_image_index_length;
	}
	
	image_index = max(floor(draw_image_index), 0);
}