/// @description Cutscene Update Event
// Performs the Cutscene Object's Behaviour to orient Cutscene Dialogue Boxes

// Check if Cutscene is active
if (cutscene_active)
{
	// Cutscene Waiting Behaviour
	if (cutscene_waiting_behaviour)
	{
		// Check for Cutscene Waiting Condition
		if (cutscene_waiting_for_delay_duration)
		{
			// Waiting for Delay Duration to end
			cutscene_delay_timer -= frame_delta;
			
			// Check if Delay Timer has ended
			if (cutscene_delay_timer <= 0)
			{
				// Reset Cutscene's Delay Duration Waiting Behaviour
				cutscene_delay_timer = 0;
				cutscene_waiting_for_delay_duration = false;
				
				// Continue to next Cutscene Event
				cutscene_waiting_behaviour = false;
				cutscene_continue_event(id);
			}
		}
		else if (cutscene_waiting_for_dialogue_boxes_to_deinstantiate_to_continue)
		{
			// Waiting for all Dialogue Boxes to be removed before continuing
			for (var i = ds_list_size(cutscene_dialogue_boxes) - 1; i >= 0; i--)
			{
				// Remove all uninstantiated Dialogue Box instances from Cutscene Dialogue Boxes DS List
				var temp_dialogue_box = ds_list_find_value(cutscene_dialogue_boxes, i);
				
				// Check if Dialogue Box Exists
				if (!instance_exists(temp_dialogue_box))
				{
					ds_list_delete(cutscene_dialogue_boxes, i);
				}
			}
			
			// Check if all remaining Dialogue Boxes are gone to continue cutscene
			if (ds_list_size(cutscene_dialogue_boxes) <= 0)
			{
				// Stop waiting for all Cutscene Dialogue Boxes to be removed
				cutscene_waiting_for_dialogue_boxes_to_deinstantiate_to_continue = false;
				
				// Continue to next Cutscene Event
				cutscene_waiting_behaviour = false;
				cutscene_continue_event(id);
			}
		}
		else if (cutscene_waiting_for_units_to_finish_moving)
		{
			// Check all Moving Units to see if they have finished their pathfinding
			for (var i = ds_list_size(cutscene_moving_units_list) - 1; i >= 0; i--)
			{
				// Remove all uninstantiated Dialogue Box instances from Cutscene Dialogue Boxes DS List
				var temp_movement_unit = ds_list_find_value(cutscene_moving_units_list, i);
				
				// Check if Cutscene's Moving Unit exists or has finished their pathfinding movement behaviour
				if (!instance_exists(temp_movement_unit))
				{
					// Unit does not exist - Remove Unit from Moving Units List
					ds_list_delete(cutscene_moving_units_list, i);
				}
				else if (temp_movement_unit.pathfinding_path_ended)
				{
					// Unit has finished their pathfinding movement behaviour - Remove Unit from Moving Units List
					ds_list_delete(cutscene_moving_units_list, i);
				}
			}
			
			// Check for Units have finished moving Cutscene Advancement Condition
			if (ds_list_size(cutscene_moving_units_list) <= 0)
			{
				// Stop waiting for all Cutscene Moving Units to finish moving
				cutscene_waiting_for_units_to_finish_moving = false;
				
				// Continue to next Cutscene Event
				cutscene_waiting_behaviour = false;
				cutscene_continue_event(id);
			}
		}
	}
	
	// Orient Dialogue Boxes in Cutscene
	cutscene_calculate_dialogue_orientation(id);
}