/// @description Cutscene Update Event
// Performs the Cutscene Object's Behaviour to orient Cutscene Dialogue Boxes

// Check if Cutscene is active
if (cutscene_active)
{
	// Check if waiting for all Dialogue Boxes to be removed before continuing
	if (cutscene_waiting_for_dialogue_boxes_to_deinstantiate_to_continue)
	{
		// Remove all uninstantiated Dialogue Box instances from Cutscene Dialogue Boxes DS List
		for (var i = ds_list_size(cutscene_dialogue_boxes) - 1; i >= 0; i--)
		{
			// Find Dialogue Box instance
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
			cutscene_continue_event(id);
		}
	}
	
	// Orient Dialogue Boxes in Cutscene
	cutscene_calculate_dialogue_orientation(id);
}