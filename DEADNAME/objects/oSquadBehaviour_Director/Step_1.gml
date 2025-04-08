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
                // Check if Squad Leader has changed Movement
                var temp_squad_movement_target = ds_list_find_value(squad_movement_target_list, temp_squad_index);
                
                if (point_distance(temp_squad_leader_instance.pathfinding_path_end_x, temp_squad_leader_instance.pathfinding_path_end_y, temp_squad_movement_target.position_x, temp_squad_movement_target.position_y) > 1)
                {
                    //
                    temp_calculate_squad_pathfinding_targets = true;
                    ds_list_set(squad_movement_target_list, temp_squad_index, { position_x: temp_squad_leader_instance.pathfinding_path_end_x, position_y: temp_squad_leader_instance.pathfinding_path_end_y});
                    break;
                }
            
                // Check if Movement is Finished
                var temp_squad_units_finished_moving_count = 0;
                
                for (var temp_moving_squad_unit_index = 0; temp_moving_squad_unit_index < ds_list_size(temp_squad_unit_instances_list); temp_moving_squad_unit_index++)
                {
                    // Find Squad Unit Instance
                    var temp_moving_squad_unit_instance = ds_list_find_value(temp_squad_unit_instances_list, temp_moving_squad_unit_index);
                    
                    //
                    if (temp_moving_squad_unit_instance.pathfinding_path_ended)
                    {
                        temp_squad_units_finished_moving_count++;
                    }
                }
                
                //
                if (temp_squad_units_finished_moving_count == ds_list_size(temp_squad_unit_instances_list))
                {
                    ds_list_set(squad_movement_list, temp_squad_index, SquadMovement.Finished);
                }
                break;
            case SquadMovement.Finished:
                // Perform Behaviour upon Finishing Movement
                ds_list_set(squad_movement_list, temp_squad_index, SquadMovement.None);
                break;
            case SquadMovement.None:
            default:
                /// @DEBUG IF YOU COULD NOT GUESS
                if (mouse_check_button_pressed(mb_left))
                {
                    temp_calculate_squad_pathfinding_targets = true;
                    temp_squad_leader_instance.pathfinding_path_end_x = GameManager.cursor_x + LightingEngine.render_x;
                    temp_squad_leader_instance.pathfinding_path_end_y = GameManager.cursor_y + LightingEngine.render_y;
                    ds_list_set(squad_movement_target_list, temp_squad_index, { position_x: temp_squad_leader_instance.pathfinding_path_end_x, position_y: temp_squad_leader_instance.pathfinding_path_end_y});
                }
                break;
        }
        
        // Calculate Squad Pathfinding Targets
        if (temp_calculate_squad_pathfinding_targets)
        {
            //
            with (temp_squad_leader_instance)
            {
                pathfinding_path_start_x = x;
                pathfinding_path_start_y = y;
                
                pathfinding_recalculate = false;
                pathfinding_path_ended = false;
                
                pathfinding_path = pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y);
                pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
            }
            
            //
            var temp_squad_spacing_count = 0;
            var temp_squad_spacing_padding = 1;
            var temp_squad_spacing_direction = 1;
            
            for (var temp_pathfinding_squad_unit_index = 0; temp_pathfinding_squad_unit_index < ds_list_size(temp_squad_unit_instances_list); temp_pathfinding_squad_unit_index++)
            {
                // Find Squad Unit Instance
                var temp_pathfinding_squad_unit_instance = ds_list_find_value(temp_squad_unit_instances_list, temp_pathfinding_squad_unit_index);
                
                //
                if (temp_squad_leader_instance == temp_pathfinding_squad_unit_instance)
                {
                    continue;
                }
                
                //
                with (temp_pathfinding_squad_unit_instance)
                {
                    pathfinding_path_start_x = x;
                    pathfinding_path_start_y = y;
                    
                    pathfinding_path_end_x = temp_squad_leader_instance.pathfinding_path_end_x + (temp_squad_spacing_direction * temp_squad_spacing_padding * 24) + random_range(-8, 8);
                    pathfinding_path_end_y = temp_squad_leader_instance.pathfinding_path_end_y;
                    
                    pathfinding_recalculate = false;
                    pathfinding_path_ended = false;
                    
                    pathfinding_path = pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y);
                    pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
                }
                
                //
                temp_squad_spacing_count++;
                temp_squad_spacing_direction *= -1;
                
                if (temp_squad_spacing_count == 2)
                {
                    temp_squad_spacing_count = 0;
                    temp_squad_spacing_padding++;
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
