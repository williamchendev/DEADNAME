/// @description Insert description here
// You can write your code in this editor

//
var temp_dialogue_fade_delay = 1;

for (var i = 0; i < ds_list_size(cutscene_dialogue_boxes); i++)
{
	var temp_dialogue_box = ds_list_find_value(cutscene_dialogue_boxes, i);
	
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
