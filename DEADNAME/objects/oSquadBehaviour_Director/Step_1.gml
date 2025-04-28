/// @description Insert description here
// You can write your code in this editor

// Iterate through Squads and perform Squad Behaviours
var temp_squad_index = 0;

repeat (squad_count)
{
    // Check if Squad Exists
    if (!ds_list_find_value(squad_exists_list, temp_squad_index))
    {
        // Squad does not Exist - Increment Squad Index and Continue Iterator
        temp_squad_index++;
        continue;
    }
    
    // Establish Squad Properties
    var temp_squad_properties = ds_list_find_value(squad_properties_list, temp_squad_index);
    var temp_squad_faction = ds_list_find_value(squad_faction_list, temp_squad_index);
    
    // Establish Squad Pathfinding Variables
    var temp_squad_movement_target_x = ds_list_find_value(squad_movement_target_x_list, temp_squad_index);
    var temp_squad_movement_target_y = ds_list_find_value(squad_movement_target_y_list, temp_squad_index);
    
    // Establish Squad Leader Instance and Squad Leader Variables
    var temp_squad_leader_instance = ds_list_find_value(squad_leader_list, temp_squad_index);
    var temp_squad_leader_half_height = (temp_squad_leader_instance.bbox_bottom - temp_squad_leader_instance.bbox_top) * 0.5;
    
    // Establish Squad Units List
    var temp_squad_unit_instances_list = ds_list_find_value(squad_units_list, temp_squad_index);
    
    // Calculate Squad Combat Sight Behaviour
    var temp_squad_sight_active = ds_list_find_value(squad_sight_active_list, temp_squad_index);
    var temp_sight_calculation_delay = ds_list_find_value(squad_sight_calculation_delay_list, temp_squad_index) - 1;
    
    if (temp_squad_sight_active and temp_sight_calculation_delay <= 0)
    {
    	// Calculate Squad Combat Sight Radius
    	var temp_squad_sight_value = ds_list_find_value(squad_sight_value_list, temp_squad_index);
    	var temp_squad_sight_radius = lerp(temp_squad_properties.sight_min_radius, temp_squad_properties.sight_max_radius, temp_squad_sight_value);
    	
    	// Create Squad Leader Unit Collision List
        var temp_squad_sight_collision_list = ds_list_create();
        var temp_squad_sight_collision_list_count = collision_circle_list(temp_squad_leader_instance.x, temp_squad_leader_instance.y - temp_squad_leader_half_height, temp_squad_sight_radius, oUnit, false, true, temp_squad_sight_collision_list, true);
        
        // Check if Units are within Combat Range
        var temp_hostile_unit_list = ds_list_create();
        var temp_hostile_distance_list = ds_list_create();
        
        // Iterate through Squad Leader Unit Collision List Unit Entries
        var temp_squad_sight_collision_index = 0;
        
        repeat (temp_squad_sight_collision_list_count)
        {
        	// Find Collision Unit Instance
        	var temp_squad_sight_collision_instance = ds_list_find_value(temp_squad_sight_collision_list, temp_squad_sight_collision_index);
        	
        	// Check if Collision Unit shares same Faction Allegiance
        	if (temp_squad_sight_collision_instance.faction_id == temp_squad_faction)
        	{
        		// Increment Collision Unit Index and Skip Unit
        		temp_squad_sight_collision_index++;
        		continue;
        	}
        	
        	// Find Collision Unit Squad Index
        	var temp_squad_sight_collision_instance_squad_index = ds_map_find_value(squad_ids_map, temp_squad_sight_collision_instance.squad_id);
        	
        	// Check if Collision Unit Squad Exists
        	if (!is_undefined(temp_squad_sight_collision_instance_squad_index) and ds_list_find_value(squad_exists_list, temp_squad_sight_collision_instance_squad_index))
        	{
        		// Check Relationship between Collision Unit's Faction to Squad Leader's Faction
        		var temp_squad_sight_collision_instance_squad_faction_relationship = faction_get_realtionship(temp_squad_faction, temp_squad_sight_collision_instance.faction_id);
        		
        		// Hostile Collision Unit Squad Faction Behaviour
        		if (temp_squad_sight_collision_instance_squad_faction_relationship == FactionRelationship.Hostile)
        		{
        			// Find Collision Center of Hostile Unit
        			var temp_hostile_unit_half_height = (temp_squad_sight_collision_instance.bbox_bottom - temp_squad_sight_collision_instance.bbox_top) * 0.5;
        			
        			// Check if Squad Leader and Hostile Unit share continuous Line of Sight
        			if (!collision_line(temp_squad_leader_instance.x, temp_squad_leader_instance.y - temp_squad_leader_half_height, temp_squad_sight_collision_instance.x, temp_squad_sight_collision_instance.y - temp_hostile_unit_half_height, oSolid, false, true))
        			{
        				// Calculate Hostile Unit's Distance from Squad Leader
	        			var temp_hostile_unit_distance = point_distance(temp_squad_leader_instance.x, temp_squad_leader_instance.y, temp_squad_sight_collision_instance.x, temp_squad_sight_collision_instance.y);
	        			
	        			// Insertion Sort Hostile Unit based on Hostile Unit's Distance to Squad Leader
	        			var temp_sorted_insert_index = 0;
	        			
	        			repeat (ds_list_size(temp_hostile_unit_list))
	        			{
	        				// Distance at Index is larger than insertion Hostile Unit's Distance
	        				if (temp_hostile_unit_distance < ds_list_find_value(temp_hostile_distance_list, temp_sorted_insert_index))
	        				{
	        					break;
	        				}
	        				
	        				// Increment Insertion Index
	        				temp_sorted_insert_index++;
	        			}
	        			
	        			// Insert Hostile Unit and Hostile Unit's Distance to Squad Leader
	        			ds_list_insert(temp_hostile_unit_list, temp_sorted_insert_index, temp_squad_sight_collision_instance);
	        			ds_list_insert(temp_hostile_distance_list, temp_sorted_insert_index, temp_hostile_unit_distance);
        			}
        		}
        	}
        	
        	// Increment Collision Unit Index
        	temp_squad_sight_collision_index++;
        }
        
        // Destroy Squad Leader Unit Collision DS List
        ds_list_destroy(temp_squad_sight_collision_list);
        temp_squad_sight_collision_list = -1;
        
        // Hostile Entities Within Squad Leader Sight Radius Behaviour
        if (ds_list_size(temp_hostile_unit_list) > 0)
        {
        	// Increase Sight Range by incrementing Sight Value
        	temp_squad_sight_value += temp_squad_properties.sight_value_increment;
        	ds_list_set(squad_sight_value_list, temp_squad_index, clamp(temp_squad_sight_value, 0, 1));
        	
        	// Duplicate Squad Units List for Combat Assignments
	        var temp_squad_combat_unit_list = ds_list_create();
	        ds_list_copy(temp_squad_combat_unit_list, temp_squad_unit_instances_list);
	        
	        // Iterate through Hostile Units and Attempt to Assign Targets based on Proximity and Priority
	        var temp_hostile_unit_index = 0;
	        
	        repeat (ds_list_size(temp_squad_unit_instances_list))
	        {
	        	// Find Hostile Unit Instance
	        	var temp_hostile_unit_instance = ds_list_find_value(temp_hostile_unit_list, temp_hostile_unit_index);
	        	
	        	// Find Collision Center of Hostile Unit
	        	var temp_hostile_unit_half_height = (temp_hostile_unit_instance.bbox_bottom - temp_hostile_unit_instance.bbox_top) * 0.5;
	        	
	        	// Establish Empty Unit Assignment
	        	var temp_hostile_unit_assigned_squad_unit = undefined;
	        	var temp_hostile_unit_assigned_squad_unit_index = -1;
	        	var temp_hostile_unit_assigned_squad_unit_distance = undefined;
	        	var temp_hostile_unit_assigned_priority_rank = UnitCombatPriorityRank.NullPriorityCombat;
	        	
	        	// Iterate through Squad Units awaiting Combat Assignments
	        	var temp_squad_combat_unit_index = 0;
	        	
	        	repeat (ds_list_size(temp_squad_combat_unit_list))
	        	{
	        		// Find Squad Unit Available to take Combat Assignment
	        		var temp_squad_combat_unit_instance = ds_list_find_value(temp_squad_combat_unit_list, temp_squad_combat_unit_index);
	        		
	        		// Find Collision Center of Squad Unit
	        		var temp_squad_unit_assignment_half_height = (temp_squad_combat_unit_instance.bbox_bottom - temp_squad_combat_unit_instance.bbox_top) * 0.5;
	        		
	        		// Check if Squad Combat Unit and Hostile Unit Assignment share continuous Line of Sight
	        		if (collision_line(temp_hostile_unit_instance.x, temp_hostile_unit_instance.y - temp_hostile_unit_half_height, temp_squad_combat_unit_instance.x, temp_squad_combat_unit_instance.y - temp_squad_unit_assignment_half_height, oSolid, false, true))
        			{
        				// No continuous Line of Sight - Skip Combat Assignment
        				temp_squad_combat_unit_index++;
        				continue;
        			}
	        		
	        		// Establish Combat Assignment's Distance and Priority Rank for Comparison with other possible Combat Assignments
	        		var temp_hostile_unit_assignment_distance = point_distance(temp_hostile_unit_instance.x, temp_hostile_unit_instance.y - temp_hostile_unit_half_height, temp_squad_combat_unit_instance.x, temp_squad_combat_unit_instance.y - temp_squad_unit_assignment_half_height);
	        		var temp_hostile_unit_assignment_priority_rank = temp_hostile_unit_assignment_distance < temp_squad_properties.close_combat_radius ? UnitCombatPriorityRank.CloseCombat : temp_squad_combat_unit_instance.unit_priority_rank;
	        		
	        		// Check if Combat Assignment is outside the sight radius and must be ignored
	        		if (temp_hostile_unit_assignment_distance > temp_squad_sight_radius)
	        		{
	        			// Combat Assignment is outside of Sight Radius and must be ignored - Skip Combat Assignment
	        			temp_squad_combat_unit_index++;
        				continue;
	        		}
	        		
	        		// Compare and Store Combat Assignment
	        		if (temp_hostile_unit_assigned_squad_unit_index == -1)
	        		{
	        			// Combat Assignment does not exist - Store Combat Assignment with no comparison
	        			temp_hostile_unit_assigned_squad_unit = temp_squad_combat_unit_instance;
	        			temp_hostile_unit_assigned_squad_unit_index = temp_squad_combat_unit_index;
	        			temp_hostile_unit_assigned_squad_unit_distance = temp_hostile_unit_assignment_distance;
	        			temp_hostile_unit_assigned_priority_rank = temp_hostile_unit_assignment_priority_rank;
	        		}
	        		else if (temp_hostile_unit_assignment_priority_rank < temp_hostile_unit_assigned_priority_rank or (temp_hostile_unit_assignment_priority_rank == temp_hostile_unit_assigned_priority_rank and temp_hostile_unit_assignment_distance < temp_hostile_unit_assigned_squad_unit_distance))
	        		{
	        			// Compare Combat Assignment - If Combat Assignment has a superior Priority or equal priority and smaller distance, store the new Combat Assignment
        				temp_hostile_unit_assigned_squad_unit = temp_squad_combat_unit_instance;
	        			temp_hostile_unit_assigned_squad_unit_index = temp_squad_combat_unit_index;
	        			temp_hostile_unit_assigned_squad_unit_distance = temp_hostile_unit_assignment_distance;
	        			temp_hostile_unit_assigned_priority_rank = temp_hostile_unit_assignment_priority_rank;
	        		}
	        		
	        		// Increment Squad Unit Index
	        		temp_squad_combat_unit_index++;
	        	}
	        	
	        	// Set Squad Unit's Combat Assignment if the Combat Assignment exists and is valid
	        	if (temp_hostile_unit_assigned_squad_unit_index != -1)
        		{
        			// Check if new Combat Assignment's Priority Rank is better than the Squad Unit's current Combat Assignment's Priority Rank
        			if (temp_hostile_unit_assigned_priority_rank < temp_hostile_unit_assigned_squad_unit.combat_priority_rank)
        			{
        				// Set Squad Unit's Combat Assignment Properties
	        			temp_hostile_unit_assigned_squad_unit.combat_target = temp_hostile_unit_instance;
	        			temp_hostile_unit_assigned_squad_unit.combat_priority_rank = temp_hostile_unit_assigned_priority_rank;
	        			
	        			// Select Combat Strategy for Squad Unit's Combat Assignment
	        			temp_hostile_unit_assigned_squad_unit.combat_strategy = UnitCombatStrategy.FireUntilNeutralized;
        			}
        			
        			// Attempted Combat Assignment - Remove Squad Unit from List of Units awaiting Combat Assignments
        			ds_list_delete(temp_squad_combat_unit_list, temp_hostile_unit_assigned_squad_unit_index);
        		}
	        	
	        	// Increment Hostile Unit Index and loop through Hostile Unit List to distribute Combat Assignments across Squad Units
	        	temp_hostile_unit_index++;
	        	
	        	if (temp_hostile_unit_index == ds_list_size(temp_hostile_unit_list))
	        	{
	        		temp_hostile_unit_index = 0;
	        	}
	        }
	        
	        // Perform Behaviour Assignment with Squad Combat Units without valid Hostile Units to target
	        if (ds_list_size(temp_squad_combat_unit_list) > 0)
	        {
	        	
	        }
	        
	        // Clear Squad Combat Unit Instances DS Lists
	        ds_list_destroy(temp_squad_combat_unit_list);
	        temp_squad_combat_unit_list = -1;
        }
        else
        {
        	// No Hostile Units Within Squad Leader's Sight Range - Decrease Sight Range by decrementing Sight Value
        	temp_squad_sight_value -= temp_squad_properties.sight_value_decrement;
        	ds_list_set(squad_sight_value_list, temp_squad_index, clamp(temp_squad_sight_value, 0, 1));
        }
        
        // Clear Hostile Collision DS Lists
        ds_list_destroy(temp_hostile_unit_list);
        temp_hostile_unit_list = -1;
        
        ds_list_destroy(temp_hostile_distance_list);
        temp_hostile_distance_list = -1;
    }
    else if (!temp_squad_sight_active)
    {
    	// Combat Sight Disabled - Reset Squad Sight Value
    	ds_list_set(squad_sight_value_list, temp_squad_index, 0);
    }
    
    ds_list_set(squad_sight_calculation_delay_list, temp_squad_index, temp_sight_calculation_delay <= 0 ? GameManager.sight_collision_calculation_frame_delay : temp_sight_calculation_delay);
    
    // Determine Squad Behaviour if Squad Leader is the Player or not
    if (!temp_squad_leader_instance.player_input)
    {
        // Establish Squad Leader Direction Variables
        var temp_calculate_squad_pathfinding_targets = false;
        
        // Squad Leader Finite State Direction Behaviour Tree
        switch (ds_list_find_value(squad_behaviour_list, temp_squad_index))
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
	    
	    /// @DEBUG IF YOU COULD NOT GUESS
        if (mouse_check_button_pressed(mb_left) and temp_squad_faction == "Moralists")
        {
            temp_calculate_squad_pathfinding_targets = true;
            
            // Set Squad Movement Target
            temp_squad_movement_target_x = GameManager.cursor_x + LightingEngine.render_x;
            temp_squad_movement_target_y = GameManager.cursor_y + LightingEngine.render_y;
        }
        else if (mouse_check_button_pressed(mb_right) and temp_squad_faction == "Evil")
        {
        	temp_calculate_squad_pathfinding_targets = true;
            
            // Set Squad Movement Target
            temp_squad_movement_target_x = GameManager.cursor_x + LightingEngine.render_x;
            temp_squad_movement_target_y = GameManager.cursor_y + LightingEngine.render_y;
        }
        
        // Squad Movement Behaviour
        switch (ds_list_find_value(squad_movement_list, temp_squad_index))
        {
            case SquadMovement.Moving:
                // Iterate through all Units in Squad to check if their Movement is Finished
                var temp_moving_squad_unit_index = 0;
                var temp_squad_units_finished_moving_count = 0;
                
                repeat (ds_list_size(temp_squad_unit_instances_list))
                {
                    // Add up count of all Squad Unit Instances that have finished Pathfinding
                    temp_squad_units_finished_moving_count += ds_list_find_value(temp_squad_unit_instances_list, temp_moving_squad_unit_index).pathfinding_path_ended ? 1 : 0;
                    
                    // Increment Unit Index
                    temp_moving_squad_unit_index++;
                }
                
                // Check if count of Squad Unit Instances that have finished their Pathfinding matches Squad Unit Count
                if (temp_squad_units_finished_moving_count == ds_list_size(temp_squad_unit_instances_list))
                {
                	// Squad Movement is Finished
                    ds_list_set(squad_movement_list, temp_squad_index, SquadMovement.Finished);
                }
                break;
            case SquadMovement.Finished:
                // Perform Behaviour upon Finishing Movement
                ds_list_set(squad_movement_list, temp_squad_index, SquadMovement.None);
                break;
            case SquadMovement.None:
            default:
                break;
        }
        
        // Calculate Squad Pathfinding Targets
        if (temp_calculate_squad_pathfinding_targets)
        {
        	// Set Squad Movement Behaviour State
        	ds_list_set(squad_movement_list, temp_squad_index, SquadMovement.Moving);
        	
        	// Confirm Squad Movement Target in Squad DS Lists
        	ds_list_set(squad_movement_target_x_list, temp_squad_index, temp_squad_movement_target_x);
    		ds_list_set(squad_movement_target_y_list, temp_squad_index, temp_squad_movement_target_y);
    		
            // Set Squad Leader's Pathfinding to Squad Movement Target
            if (point_distance(temp_squad_leader_instance.pathfinding_path_end_x, temp_squad_leader_instance.pathfinding_path_end_y, temp_squad_movement_target_x, temp_squad_movement_target_y) > 1)
            {
            	with (temp_squad_leader_instance)
	            {
	            	// Set Unit Pathfinding Path Start & End
	                pathfinding_path_start_x = x;
	                pathfinding_path_start_y = y;
	                
	                pathfinding_path_end_x = temp_squad_movement_target_x;
	                pathfinding_path_end_y = temp_squad_movement_target_y;
	                
	                // Reset and Calculate Path Data
	                if (!is_undefined(pathfinding_path) and (!pathfinding_path_ended or pathfinding_recalculate))
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
            }
            
            // Establish Squad Spacing Variables
            var temp_squad_spacing_count = -((ds_list_size(temp_squad_unit_instances_list) - 1) div 2);
            
            // Find direction of last movement position so Squad Units are always in front of the Squad Leader to shield from danger
            if ((ds_list_size(temp_squad_unit_instances_list) - 1) mod 2 == 1)
            {
            	if (!is_undefined(temp_squad_leader_instance.pathfinding_path) and temp_squad_leader_instance.pathfinding_path.path_size >= 2)
	            {
	            	var temp_squad_spacing_last_path_position_x = ds_list_find_value(temp_squad_leader_instance.pathfinding_path.position_x, temp_squad_leader_instance.pathfinding_path.path_size - 1);
	            	var temp_squad_spacing_second_to_last_path_position_x = ds_list_find_value(temp_squad_leader_instance.pathfinding_path.position_x, temp_squad_leader_instance.pathfinding_path.path_size - 2);
	            	var temp_squad_spacing_last_path_position_direction = sign(temp_squad_spacing_last_path_position_x - temp_squad_spacing_second_to_last_path_position_x);
	            	temp_squad_spacing_count += (temp_squad_spacing_last_path_position_direction == 0 ? temp_squad_properties.facing_direction : temp_squad_spacing_last_path_position_direction) == -1 ? -1 : 0;
	            }
            }
            
            // Set Squad Unit Pathfinding to be spaced out around Squad Leader at the Squad Movement Target
            for (var temp_pathfinding_squad_unit_index = 0; temp_pathfinding_squad_unit_index < ds_list_size(temp_squad_unit_instances_list); temp_pathfinding_squad_unit_index++)
            {
                // Find Squad Unit Instance
                var temp_pathfinding_squad_unit_instance = ds_list_find_value(temp_squad_unit_instances_list, temp_pathfinding_squad_unit_index);
                
                // Skip setting Squad Leader's Pathfinding
                if (temp_squad_leader_instance == temp_pathfinding_squad_unit_instance)
                {
                    continue;
                }
                
                // Check to see if Unit Path Recalculation is Valid - Both Unit Pathfinding Path Exists and Unit is moving conditions must be met
                if (!is_undefined(temp_pathfinding_squad_unit_instance.pathfinding_path) and temp_pathfinding_squad_unit_instance.pathfinding_path.path_size >= 1 and !temp_pathfinding_squad_unit_instance.pathfinding_path_ended)
                {
                	temp_pathfinding_squad_unit_instance.pathfinding_recalculate = true;
                }
                
                // Set Squad Unit's Pathfinding to match Squad Leader
                with (temp_pathfinding_squad_unit_instance)
                {
                	// Set Unit Pathfinding Path Start & End
                    pathfinding_path_start_x = x;
                    pathfinding_path_start_y = y;
                    
                    pathfinding_path_end_x = temp_squad_leader_instance.pathfinding_path_end_x + (temp_squad_spacing_count * temp_squad_properties.squad_unit_spacing) + random_range(-temp_squad_properties.squad_random_spacing, temp_squad_properties.squad_random_spacing);
                    pathfinding_path_end_y = temp_squad_leader_instance.pathfinding_path_end_y;
                    
                    // Reset and Calculate Path Data
                    if (!is_undefined(pathfinding_path) and pathfinding_recalculate)
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
                
                // Increment Squad Spacing Count
                temp_squad_spacing_count++;
                
                if (temp_squad_spacing_count == 0)
                {
                	// Skip Center because Squad Leader should always be in the Center
                    temp_squad_spacing_count++;
                }
            }
        }
    }
    
    // Increment Squad Index
    temp_squad_index++;
}
