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
    
    // Establish Squad Pathfinding Variables
    var temp_squad_movement_target_x = ds_list_find_value(squad_movement_target_x_list, temp_squad_index);
    var temp_squad_movement_target_y = ds_list_find_value(squad_movement_target_y_list, temp_squad_index);
    
    // Find Squad Units List
    var temp_squad_leader_instance = ds_list_find_value(squad_leader_list, temp_squad_index);
    var temp_squad_unit_instances_list = ds_list_find_value(squad_units_list, temp_squad_index);
    
    // Determine Squad Behaviour if Squad Leader is the Player or not
    if (temp_squad_leader_instance.player_input)
    {
        
    }
    else
    {
        // Squad Leader Directed Movement
        var temp_calculate_squad_pathfinding_targets = false;
        
        switch (ds_list_find_value(squad_movement_list, temp_squad_index))
        {
            case SquadMovement.Moving:
                // Check to Recalculate Squad Path if Squad Leader has changed Movement Target
                if (point_distance(temp_squad_leader_instance.pathfinding_path_end_x, temp_squad_leader_instance.pathfinding_path_end_y, temp_squad_movement_target_x, temp_squad_movement_target_y) > 1)
                {
                    // Calculate Movement to Target Position
                    temp_calculate_squad_pathfinding_targets = true;
                    temp_squad_movement_target_x = temp_squad_leader_instance.pathfinding_path_end_x;
                    temp_squad_movement_target_y = temp_squad_leader_instance.pathfinding_path_end_y;
                    
                    // Set Movement Recalculate
                    for (var temp_recalculate_moving_squad_unit_index = 0; temp_recalculate_moving_squad_unit_index < ds_list_size(temp_squad_unit_instances_list); temp_recalculate_moving_squad_unit_index++)
	                {
	                    // Find Squad Unit Instance
	                    var temp_recalculate_moving_squad_unit_instance = ds_list_find_value(temp_squad_unit_instances_list, temp_recalculate_moving_squad_unit_index);
	                    
	                    // Set Unit to Recalculate Pathfinding
	                    if (!is_undefined(temp_recalculate_moving_squad_unit_instance.pathfinding_path) and temp_recalculate_moving_squad_unit_instance.pathfinding_path.path_size >= 1 and !temp_recalculate_moving_squad_unit_instance.pathfinding_path_ended)
	                    {
	                    	temp_recalculate_moving_squad_unit_instance.pathfinding_recalculate = true;
	                    }
	                }
                    break;
                }
            
                // Check if Movement is Finished
                var temp_squad_units_finished_moving_count = 0;
                
                for (var temp_moving_squad_unit_index = 0; temp_moving_squad_unit_index < ds_list_size(temp_squad_unit_instances_list); temp_moving_squad_unit_index++)
                {
                    // Find Squad Unit Instance
                    var temp_moving_squad_unit_instance = ds_list_find_value(temp_squad_unit_instances_list, temp_moving_squad_unit_index);
                    
                    // Add up count of all Squad Unit Instances that have finished Pathfinding
                    if (temp_moving_squad_unit_instance.pathfinding_path_ended)
                    {
                        temp_squad_units_finished_moving_count++;
                    }
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
        
        /// @DEBUG IF YOU COULD NOT GUESS
        if (mouse_check_button_pressed(mb_left))
        {
            temp_calculate_squad_pathfinding_targets = true;
            temp_squad_movement_target_x = GameManager.cursor_x + LightingEngine.render_x;
            temp_squad_movement_target_y = GameManager.cursor_y + LightingEngine.render_y;
        }
        
        // Calculate Squad Pathfinding Targets
        if (temp_calculate_squad_pathfinding_targets)
        {
        	// Set Squad Movement Target
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
    
    // Increment Squad Index
    temp_squad_index++;
}
