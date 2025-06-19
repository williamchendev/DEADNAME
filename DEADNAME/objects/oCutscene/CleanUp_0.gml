/// @description Insert description here
// You can write your code in this editor

//
for (var i = ds_list_size(cutscene_dialogue_boxes) - 1; i >= 0; i--)
{
	var temp_dialogue_box = ds_list_find_value(cutscene_dialogue_boxes, i);
	
	if (instance_exists(temp_dialogue_box))
	{
		instance_destroy(temp_dialogue_box);
	}
}

//
ds_list_destroy(cutscene_dialogue_boxes);
cutscene_dialogue_boxes = -1;

ds_list_destroy(cutscene_units);
cutscene_units = -1;

ds_list_destroy(cutscene_unit_h_positions);
cutscene_unit_h_positions = -1;

ds_list_destroy(cutscene_unit_v_positions);
cutscene_unit_v_positions = -1;
