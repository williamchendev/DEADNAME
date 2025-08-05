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
			default:
				// Combat Aim Weapon Behaviour
				if (pathfinding_path_ended)
				{
					input_aim = true;
				}
				else
				{
					input_aim = false;
				}
				
				// Combat Weapon Attack Behaviour
				if (input_aim)
				{
					//
					combat_target_aim_value += combat_target_aim_recovery_spd * frame_delta;
					
					//
					if (combat_target_aim_value >= 1.0)
					{
						//
						combat_attack_delay -= frame_delta;
						
						//
						if (combat_attack_delay <= 0)
						{
							//
							input_attack = true;
							
							//
							combat_target_aim_value = 0;
							combat_attack_delay = random_range(combat_attack_delay_min, combat_attack_delay_max);
						}
					}
				}
				
				// Combat Weapon Behaviours
				if (weapon_active)
				{
					switch (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
					{
					    case WeaponType.DefaultFirearm:
					    case WeaponType.BoltActionFirearm:
					        // Check Firearm Weapon Reload Behaviour
					        if (weapon_equipped.firearm_ammo <= 0 or !weapon_equipped.firearm_attack_reset)
					        {
					        	//
					        	input_reload = true;
					        	
					        	//
					        	input_aim = false;
					        	input_attack = false;
					        }
					        break;
					    default:
					        break;
					}
				}
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
	if (weapon_active)
	{
		// Unit Weapon Aiming Behaviour
		if (input_aim)
		{
			// Firearm Aiming Reload Interrupt Behaviour
			if (!weapon_aim and unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload)
			{
				// Weapon Type impacts Reload Interrupt Animation
				if (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type == WeaponType.BoltActionFirearm)
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
						unit_firearm_reload_animation_state = weapon_equipped.weapon_image_index == 1 ? UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition : UnitFirearmReloadAnimationState.InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
						
						// Set Primary Hand's Firearm Animation Path - From "any arbitrary position the primary hand was positioned during the reload animation" to Firearm's Bolt Handle Open Chamber Position
						unit_set_firearm_primary_hand_animation
						(
							lerp(firearm_weapon_primary_hand_pivot_offset_ax, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_x, 
							lerp(firearm_weapon_primary_hand_pivot_offset_ay, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_y, 
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x, 
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y, 
							0
						);
					}
				}
				else
				{
					// Default Firearm Weapon Interrupt Animation - End Reload Animation
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
					
					// Set Primary Hand's Firearm Animation Path - From "any arbitrary position the primary hand was positioned during the reload animation" to Firearm's Trigger Group Position (Inversed Path Interpolation Value)
					unit_set_firearm_primary_hand_animation
					(
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
						lerp(firearm_weapon_primary_hand_pivot_offset_ax, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_x, 
						lerp(firearm_weapon_primary_hand_pivot_offset_ay, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value) + hand_fumble_animation_offset_y, 
						1
					);
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
		if (input_reload and unit_equipment_animation_state == UnitEquipmentAnimationState.Firearm)
		{
			// Perform Firearm Reload
			unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
			
			// Reload Animation
			switch (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
			{
				case WeaponType.BoltActionFirearm:
					// Initiate Bolt Action Reload
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
					
					// Weapon Primary Hand Animation: Hand reaches from Firearm's Trigger Group Position to Firearm's Closed Bolt Handle Position
					unit_set_firearm_primary_hand_animation
					(
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
						global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y
					);
					break;
				default:
					// Initiate Default Firearm Reload
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory;
					
					// Open Firearm Chamber
					weapon_equipped.open_firearm_chamber();
					
					// Weapon Primary Hand Animation Reset
					unit_set_firearm_primary_hand_animation
					(
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
						global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y
					);
					break;
			}
			
			// Reset Primary Hand Weapon Relative Pivot Values
			firearm_weapon_primary_hand_pivot_transition_value = 0;
			
			// Reset Primary Hand Unit Inventory Pivot Values
			firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;
		}
		else if (input_attack)
		{
			// Perform Weapon Attack Behaviour
			switch(global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
			{
				// Firearm Attack Behaviours
				case WeaponType.DefaultFirearm:
				case WeaponType.BoltActionFirearm:
					// Unit cannot attack with their Firearm if they are performing their Firearm's reload animation
					if (unit_equipment_animation_state != UnitEquipmentAnimationState.FirearmReload)
					{
						// Unit must finish their Firearm's recoil animation cycle to attack again with their Firearm
						if (firearm_weapon_primary_hand_pivot_transition_value <= animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value <= animation_asymptotic_tolerance)
						{
							// Weapon Attack Behaviour - Attack with Firearm
							var temp_weapon_attack = weapon_equipped.update_weapon_attack(combat_target);
							
							// Weapon Attack Unit Behaviour
							if (temp_weapon_attack)
							{
								if (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type == WeaponType.BoltActionFirearm and weapon_equipped.firearm_ammo > 0)
								{
									// Bolt Action Recharge Animation
									unit_equipment_animation_state = UnitEquipmentAnimationState.FirearmReload;
									
									// Bolt Action Reload
									unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition;
									
									// Weapon Primary Hand Animation: Hand reaches from current position to firearm bolt handle
									unit_set_firearm_primary_hand_animation
									(
										global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
										global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, 
										global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x, 
										global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y, 
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
			// Perform Weapon Reset Behaviour
			switch(global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
			{
				// Firearm Attack Reset Behaviours
				case WeaponType.DefaultFirearm:
				case WeaponType.BoltActionFirearm:
					// Reset Firearm Attack Behaviour
					weapon_equipped.reset_firearm();
					break;
				// Default Weapon Attack Reset Behaviour
				default:
					break;
			}
		}
	}
	
	// Horizontal Movement Behaviour
	var move_spd = weapon_aim || unit_equipment_animation_state == UnitEquipmentAnimationState.FirearmReload ? walk_spd : run_spd;
	
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
	if (input_drop_down and grounded)
	{
		if (place_free(x, y + 1))
		{
			y += 2;
			y_velocity += 0.05;
			grounded = false;
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
		var temp_vspd_sign = sign(vspd);
		var v = 1;
		
		repeat(abs(vspd) - v)
		{
			var temp_vspd = (temp_vspd_sign * v);
			
			if (!platform_free(x, y + temp_vspd, platform_list))
			{
				// GROUND CONTACT
				y_velocity = temp_vspd - temp_vspd_sign;
				y += y_velocity;
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

// WEAPON //
if (weapon_active)
{
	switch (global.weapon_packs[weapon_equipped.weapon_pack].weapon_type)
	{
		// Update Firearm Recoil Behaviour & Attack Delay Timers
		case WeaponType.DefaultFirearm:
		case WeaponType.BoltActionFirearm:
			weapon_equipped.update_weapon_behaviour(firearm_recoil_recovery_spd, firearm_recoil_angle_recovery_spd);
			break;
		// Update Default Weapon Behaviour
		default:
			weapon_equipped.update_weapon_behaviour();
			break;
	}
}

// ANIMATION //
#region Animation Behaviour
var temp_unit_animation_state = UnitAnimationState.Idle;

if (x_velocity != 0)
{
	// Set Unit's Horizontal Scale to match the direction it is facing while moving
	draw_xscale = abs(draw_xscale) * sign(x_velocity);
}
	
if (grounded)
{
	// Walking or Idle Animation
	switch (unit_equipment_animation_state)
	{
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

// Calculate Unit's Inventory Position
backpack_position_x = x + (rot_point_x(global.unit_packs[unit_pack].equipment_backpack_x, global.unit_packs[unit_pack].equipment_backpack_y + (bobbing_animation_value * backpack_vertical_bobbing_height)) * draw_xscale);
backpack_position_y = y + ground_contact_vertical_offset + (rot_point_y(global.unit_packs[unit_pack].equipment_backpack_x, global.unit_packs[unit_pack].equipment_backpack_y + (bobbing_animation_value * backpack_vertical_bobbing_height)) * draw_yscale);
#endregion

// LIMBS //
#region Limb Animation Behaviour
switch (unit_equipment_animation_state)
{
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
				if (weapon_equipped.firearm_recoil_recovery_delay <= 0 and weapon_equipped.firearm_attack_delay <= 0)
				{
					// Update Unit's Primary Hand Path Animation - Fast Hand Speed for opening and closing the Firearm's Bolt Handle
					firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 1, hand_fast_movement_spd * frame_delta);
					
					// Firearm must be aimed and Unit must have finished their Primary Hand's Path Animation to perform next Animation Event
					if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 1 - animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
					{
						switch (unit_firearm_reload_animation_state)
						{
							case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
								// Bolt Action Firearm's Chamber is Opened (The Bolt Handle has been pulled backwards for a reload animation) - Begin moving primary hand to Unit's Inventory to grab individual ammo rounds
								unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToUnitInventory;
								
								// Reset Primary Hand Animation's Path Interpolation Value to begin next animation (Inversed Path Interpolation Value) 
								firearm_weapon_primary_hand_pivot_transition_value = 1;
								
								// Open Firearm Chamber
								weapon_equipped.open_firearm_chamber();
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
								weapon_equipped.open_firearm_chamber();
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Opened Bolt Position to Firearm's Closed Bolt Position
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
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
								weapon_equipped.close_firearm_chamber();
								
								// Set Primary Hand's Firearm Animation Path - From Firearm's Closed Bolt Position to Firearm's Trigger Group (Inversed Path Interpolation Value)
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
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
				if (weapon_equipped.firearm_recoil_recovery_delay <= 0 and weapon_equipped.firearm_attack_delay <= 0)
				{
					// Update Unit's Primary Hand Path Animation - Default Hand Speed
					firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
					
					// Firearm must be aimed and Unit must have finished their Primary Hand's Path Animation to perform next Animation Event
					if (firearm_weapon_hip_pivot_to_aim_pivot_transition_value >= 1 - animation_asymptotic_tolerance and firearm_weapon_primary_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
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
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
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
								unit_set_firearm_primary_hand_animation
								(
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x, 
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x,
									global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y,
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
					unit_firearm_reload_animation_state = global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_individual_rounds ? UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition : UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation;
					firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadMagazine_MagazineInsertAnimation:
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition:
				// Move Hand to Reload Firearm
				firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 1, hand_default_movement_spd * frame_delta);
				
				if (firearm_weapon_primary_hand_pivot_transition_value >= 1 - animation_asymptotic_tolerance)
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
					firearm_weapon_primary_hand_pivot_transition_value = 1;
				}
				break;
			case UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition:
				// Move Hand to Reload Individual Rounds into Firearm from Reload Offset Position - Extremely Fast Reload Animation
				firearm_weapon_primary_hand_pivot_transition_value *= power(0.5, frame_delta);
				
				if (firearm_weapon_primary_hand_pivot_transition_value <= animation_asymptotic_tolerance)
				{
					// Primary Hand is positioned at Firearm's Reload Offset Position - Begin the animation to load another round into Firearm
					unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition;
					
					// Reset Primary Hand Animation's Path Interpolation Value to begin next animation
					firearm_weapon_primary_hand_pivot_transition_value = 0;
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
						// Hand Grabs Item from Inventory
						unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_MovePrimaryHandToFirearmReloadPosition;
						limb_primary_arm.set_held_item(UnitHeldItem.FAL_Magazine); // DEBUG!!!
						//limb_primary_arm.set_held_item(UnitHeldItem.DebugHeldItem);
						
						// Configure Primary Hand Pivots to perform Magazine Animation
						unit_set_firearm_primary_hand_animation
						(
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_offset_x, 
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_offset_y,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y,
							0
						);
					}
					else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadMagazine_MagazineHandFumbleAnimation)
					{
						// End Reload Animation
						unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;
						
						// Magazine is loaded into Firearm 
						weapon_equipped.reload_firearm();
						limb_primary_arm.set_held_item();
						
						// Close Firearm Chamber
						weapon_equipped.close_firearm_chamber();
						
						// Set Primary Hand's Firearm Animation Path - From Firearm's Magazine Reload Position to Firearm's Hand Trigger Position (Inversed Path Interpolation Value)
						unit_set_firearm_primary_hand_animation
						(
							global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x,
							global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x,
							global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y,
							1
						);
					}
					else if (unit_firearm_reload_animation_state == UnitFirearmReloadAnimationState.ReloadIndividualRounds_IndividualRoundHandFumbleAnimation)
					{
						// Reload Firearm with One Round
						weapon_equipped.reload_firearm(1);
						
						// Check if Firearm is finished being reloaded
						if (weapon_equipped.firearm_ammo < global.weapon_packs[weapon_equipped.weapon_pack].firearm_max_ammo_capacity)
						{
							// Firearm is not finished being reloaded - Begin reloading another round
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition;
						}
						else
						{
							// Firearm is finished being reloaded - Move hand to close Bolt Action Chamber
							unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition;
						
							// Reset Primary Hand's Held Item
							limb_primary_arm.set_held_item();
							
							// Set Primary Hand's Firearm Animation Path - From Firearm's Reload Position to Firearm's Open Bolt Position
							unit_set_firearm_primary_hand_animation
							(
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_x, 
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_y,
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_x + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_x,
								global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_position_y + global.weapon_packs[weapon_equipped.weapon_pack].firearm_bolt_handle_charge_offset_y,
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
				limb_primary_arm.set_held_item();
				
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
	
		// Update Facing Direction
		draw_xscale = temp_firearm_is_aimed ? (abs(draw_xscale) * ((weapon_aim_x - x >= 0) ? 1 : -1)) : draw_xscale;
		var temp_firearm_facing_sign = sign(draw_xscale);
		animation_speed_direction = 1;
		
		// Pull Unit's Slope Rotation
		trig_sine = draw_angle_trig_sine;
		trig_cosine = draw_angle_trig_cosine;
	
		// Firearm Reload Animation
		var temp_firearm_ambient_angle;
		
		var temp_firearm_primary_hand_horizontal_offset = lerp(global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_x, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value);
		var temp_firearm_primary_hand_vertical_offset = lerp(global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_primary_y, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value);
		
		var temp_firearm_offhand_hand_horizontal_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_offhand_x;
		var temp_firearm_offhand_hand_vertical_offset = global.weapon_packs[weapon_equipped.weapon_pack].weapon_hand_position_offhand_y;
		
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
					temp_firearm_facing_sign = sign(draw_xscale);
					
					// Walk Backwards while Aiming
					animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_firearm_facing_sign)) ? -1 : 1;
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition:
				case UnitFirearmReloadAnimationState.ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle:
					// Point firearm at Weapon Angle previously held before reloading
					temp_firearm_ambient_angle = draw_xscale < 0 ? 180 - weapon_equipped.weapon_old_angle : weapon_equipped.weapon_old_angle;
					break;
				default:
					// Point firearm at Reload Safety Angle
					temp_firearm_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + (global.weapon_packs[weapon_equipped.weapon_pack].firearm_reload_safety_angle * temp_firearm_facing_sign);
					break;
			}
			
			// Update Unit Equipment Inventory Position
			unit_equipment_inventory_position_x = x + (rot_point_x(global.unit_packs[unit_pack].equipment_inventory_x * draw_xscale, global.unit_packs[unit_pack].equipment_inventory_y));
			unit_equipment_inventory_position_y = y + ground_contact_vertical_offset + (rot_point_y(global.unit_packs[unit_pack].equipment_inventory_x * draw_xscale, global.unit_packs[unit_pack].equipment_inventory_y) * draw_yscale);
			
			// Update Primary Hand Position
			temp_firearm_primary_hand_horizontal_offset = lerp(firearm_weapon_primary_hand_pivot_offset_ax, firearm_weapon_primary_hand_pivot_offset_bx, firearm_weapon_primary_hand_pivot_transition_value);
			temp_firearm_primary_hand_vertical_offset = lerp(firearm_weapon_primary_hand_pivot_offset_ay, firearm_weapon_primary_hand_pivot_offset_by, firearm_weapon_primary_hand_pivot_transition_value);
		}
		else
		{
			// Reset Primary Hand to Firearm Operation Position
			firearm_weapon_primary_hand_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
			firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = lerp(firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value, 0, hand_default_movement_spd * frame_delta);
			
			// Firearm Aiming & Holstered Operation Behaviour
			if (temp_firearm_is_aimed)
			{
				// Move firearm to aiming pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 1, firearm_aiming_aim_transition_spd * frame_delta);
				
				// Walk Backwards while Aiming
				animation_speed_direction = ((x_velocity != 0) and (sign(x_velocity) != temp_firearm_facing_sign)) ? -1 : 1;
				
				// Update Old Weapon Angle
				weapon_equipped.weapon_old_angle = draw_xscale < 0 ? 180 - weapon_equipped.weapon_angle : weapon_equipped.weapon_angle;
			}
			else
			{
				// Rest Gun at hip pivot
				firearm_weapon_hip_pivot_to_aim_pivot_transition_value = lerp(firearm_weapon_hip_pivot_to_aim_pivot_transition_value, 0, firearm_aiming_hip_transition_spd * frame_delta);
				
				// Point firearm at Idle Safety Angle if Idle, point firearm at Moving Safety Angle if Moving
				temp_firearm_ambient_angle = (draw_xscale < 0 ? 180 + draw_angle_value : draw_angle_value) + ((x_velocity == 0) ? (global.weapon_packs[weapon_equipped.weapon_pack].firearm_idle_safety_angle * temp_firearm_facing_sign) : (global.weapon_packs[weapon_equipped.weapon_pack].firearm_moving_safety_angle * temp_firearm_facing_sign));
			}
		}
		
		// Update Unit's Weapon Offset
		var temp_firearm_horizontal_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_x, global.unit_packs[unit_pack].equipment_firearm_aim_x, firearm_weapon_hip_pivot_to_aim_pivot_transition_value) * draw_xscale;
		var temp_firearm_vertical_offset = lerp(global.unit_packs[unit_pack].equipment_firearm_hip_y, global.unit_packs[unit_pack].equipment_firearm_aim_y, firearm_weapon_hip_pivot_to_aim_pivot_transition_value) * draw_yscale;
		
		// Update Unit Weapon Bob
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_firearm_vertical_offset += bobbing_animation_value * weapon_vertical_bobbing_height;
				break;
			default:
				break;
		}
		
		// Update Weapon Recoil
		temp_firearm_horizontal_offset += weapon_equipped.weapon_horizontal_recoil * temp_firearm_facing_sign;
		temp_firearm_vertical_offset += weapon_equipped.weapon_vertical_recoil;
		
		// Update Weapon Position
		var temp_firearm_x = x + rot_point_x(temp_firearm_horizontal_offset, temp_firearm_vertical_offset);
		var temp_firearm_y = y + ground_contact_vertical_offset + rot_point_y(temp_firearm_horizontal_offset, temp_firearm_vertical_offset);
		
		// Update Limb Pivots
		limb_primary_arm.limb_xscale = temp_firearm_facing_sign;
		limb_secondary_arm.limb_xscale = temp_firearm_facing_sign;
		
		var temp_left_arm_anchor_offset_x = limb_primary_arm.anchor_offset_x * draw_xscale;
		var temp_left_arm_anchor_offset_y = limb_primary_arm.anchor_offset_y * draw_yscale;
		
		limb_primary_arm.limb_pivot_ax = x + rot_point_x(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		limb_primary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_left_arm_anchor_offset_x, temp_left_arm_anchor_offset_y);
		
		var temp_right_arm_anchor_offset_x = limb_secondary_arm.anchor_offset_x * draw_xscale;
		var temp_right_arm_anchor_offset_y = limb_secondary_arm.anchor_offset_y * draw_yscale;
		
		limb_secondary_arm.limb_pivot_ax = x + rot_point_x(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		limb_secondary_arm.limb_pivot_ay = y + ground_contact_vertical_offset + rot_point_y(temp_right_arm_anchor_offset_x, temp_right_arm_anchor_offset_y);
		
		// Update Weapon's Angle
		var temp_firearm_angle_difference = angle_difference(weapon_equipped.weapon_angle, temp_firearm_is_aimed ? point_direction(temp_firearm_x, temp_firearm_y, weapon_aim_x, weapon_aim_y) : temp_firearm_ambient_angle);
		var temp_firearm_angle = (weapon_equipped.weapon_angle - (temp_firearm_angle_difference * firearm_aiming_angle_transition_spd * frame_delta)) mod 360;
		temp_firearm_angle = temp_firearm_angle < 0 ? temp_firearm_angle + 360 : temp_firearm_angle;
		
		// Update Weapon Position & Angle Physics
		weapon_equipped.update_weapon_physics(temp_firearm_x, temp_firearm_y, temp_firearm_angle, temp_firearm_facing_sign);
		
		// Update Weapon Limb Targets
		temp_firearm_primary_hand_vertical_offset *= weapon_equipped.weapon_facing_sign;
		temp_firearm_offhand_hand_vertical_offset *= weapon_equipped.weapon_facing_sign;
		
		rot_prefetch((weapon_equipped.weapon_angle + (weapon_equipped.weapon_angle_recoil * weapon_equipped.weapon_facing_sign)) mod 360);
		
		var temp_firearm_primary_hand_target_x = weapon_equipped.weapon_x + rot_point_x(temp_firearm_primary_hand_horizontal_offset, temp_firearm_primary_hand_vertical_offset);
		var temp_firearm_primary_hand_target_y = weapon_equipped.weapon_y + rot_point_y(temp_firearm_primary_hand_horizontal_offset, temp_firearm_primary_hand_vertical_offset);
		
		if (temp_firearm_reload)
		{
			temp_firearm_primary_hand_target_x = lerp(temp_firearm_primary_hand_target_x, unit_equipment_inventory_position_x, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_x;
			temp_firearm_primary_hand_target_y = lerp(temp_firearm_primary_hand_target_y, unit_equipment_inventory_position_y, firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value) + hand_fumble_animation_offset_y;
		}
		
		limb_primary_arm.update_target(temp_firearm_primary_hand_target_x, temp_firearm_primary_hand_target_y);
		
		var temp_firearm_offhand_hand_target_x = weapon_equipped.weapon_x + rot_point_x(temp_firearm_offhand_hand_horizontal_offset, temp_firearm_offhand_hand_vertical_offset);
		var temp_firearm_offhand_hand_target_y = weapon_equipped.weapon_y + rot_point_y(temp_firearm_offhand_hand_horizontal_offset, temp_firearm_offhand_hand_vertical_offset);
		
		limb_secondary_arm.update_target(temp_firearm_offhand_hand_target_x, temp_firearm_offhand_hand_target_y);
		break;
	default:
		// Reset Animation Speed Direction
		animation_speed_direction = 1;
		
		// Pull Unit's Slope Rotation
		trig_sine = draw_angle_trig_sine;
		trig_cosine = draw_angle_trig_cosine;
		
		// Update Limb Anchor Trig Values
		limb_primary_arm.anchor_trig_sine = trig_sine;
		limb_primary_arm.anchor_trig_cosine = trig_cosine;
		limb_secondary_arm.anchor_trig_sine = trig_sine;
		limb_secondary_arm.anchor_trig_cosine = trig_cosine;
		
		// Update Non-Weapon Unit Animations
		var temp_animation_percentage;
		
		switch (unit_animation_state)
		{
			case UnitAnimationState.Idle:
				temp_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
				limb_primary_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage);
				limb_secondary_arm.update_idle_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage);
				break;
			case UnitAnimationState.Walking:
			case UnitAnimationState.AimWalking:
				temp_animation_percentage = floor(draw_image_index) / draw_image_index_length;
				var temp_walk_animation_percentage = (floor(draw_image_index + (limb_animation_double_cycle * draw_image_index_length))) / (draw_image_index_length * 2);
				limb_primary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage, temp_walk_animation_percentage);
				limb_secondary_arm.update_walk_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale, temp_animation_percentage, temp_walk_animation_percentage);
				break;
			case UnitAnimationState.Jumping:
				limb_primary_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale);
				limb_secondary_arm.update_jump_animation(x, y + ground_contact_vertical_offset, draw_xscale, draw_yscale);
				break;
		}
		break;
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