/// @description Cutscene Cleanup Event
// Cleans up all of the Cutscene's Objects and DS Lists upon its removal from the active scene

// Perform timed destruction of Cutscene Dialogue Boxes in sequential top-to-bottom fade pattern
var temp_dialogue_fade_delay = 1;

for (var i = 0; i < ds_list_size(cutscene_dialogue_boxes); i++)
{
	// Find Dialogue Box instance
	var temp_dialogue_box = ds_list_find_value(cutscene_dialogue_boxes, i);
	
	// Check if Dialogue Box Exists
	if (instance_exists(temp_dialogue_box))
	{
		// Activate Dialogue Box's Fade Destroy Behaviour
		temp_dialogue_box.alarm[1] = temp_dialogue_fade_delay;
		temp_dialogue_fade_delay += dialogue_fade_delay_offset;
	}
}

// Destroy Cutscene Data Structure DS Lists
ds_list_destroy(cutscene_dialogue_boxes);
cutscene_dialogue_boxes = -1;

ds_list_destroy(cutscene_units);
cutscene_units = -1;

ds_list_destroy(cutscene_moving_units_list);
cutscene_moving_units_list = -1;

