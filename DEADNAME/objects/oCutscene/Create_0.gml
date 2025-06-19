/// @description Cutscene Init Event
// Creates the Properties and Settings of the Cutscene Object

// Disable Object Rendering
visible = false;
sprite_index = -1;

// Cutscene Enums
enum CutsceneEventType
{
	Dialogue,
	End
}

// Cutscene Events
cutscene_events[0] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "You can't do this shit to me man",
	dialogue_unit: "Mel"
};

cutscene_events[1] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "I went to college!",
	dialogue_unit: "Mel"
};

cutscene_events[2] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "I don't know what to tell you, shit is deeply fucked. Consider doing something else with your life.",
	dialogue_unit: "Charn"
};

// Cutscene Settings
cutscene_active = false;
cutscene_event_index = -1;

cutscene_dialogue_box = noone;
cutscene_dialogue_boxes = ds_list_create();

cutscene_units = ds_list_create();
cutscene_unit_h_positions = ds_list_create();
cutscene_unit_v_positions = ds_list_create();

//
trig_cosine = 1;
trig_sine = 0;

// Cutscene Functions
continue_cutscene_event = function()
{
	//
	cutscene_active = true;
	
	//
	cutscene_event_index++;
	
	//
	if (cutscene_event_index >= array_length(cutscene_events))
	{
		//
		instance_destroy();
		return;
	}
	
	//
	switch (cutscene_events[cutscene_event_index].cutscene_type)
	{
		case CutsceneEventType.Dialogue:
			//
			var temp_dialogue_box = instance_create_depth(0, 0, 0, oDialogueBox);
			temp_dialogue_box.dialogue_text = cutscene_events[cutscene_event_index].dialogue_text;
			temp_dialogue_box.dialogue_unit = find_unit_name(cutscene_events[cutscene_event_index].dialogue_unit);
			temp_dialogue_box.dialogue_continue = true;
			temp_dialogue_box.cutscene_instance = id;
			
			// Add Previous Dialogue Box to Dialogue Box Chain
			if (instance_exists(cutscene_dialogue_box))
			{
				// Previous Dialogue Box now follows the created Dialogue Box
				cutscene_dialogue_box.dialogue_box_instance_following = temp_dialogue_box;
				
				//
				var temp_dialogue_text_height = string_height_ext(temp_dialogue_box.dialogue_text, temp_dialogue_box.dialogue_font_separation + temp_dialogue_box.dialogue_font_height, temp_dialogue_box.dialogue_font_wrap_width) + temp_dialogue_box.dialogue_box_vertical_padding;
				cutscene_dialogue_box.dialogue_tail.add_path_point(0, 10 + temp_dialogue_text_height, -50, 0);
				
				// 
				temp_dialogue_box.dialogue_box_animation_value = cutscene_dialogue_box.dialogue_box_animation_value + 0.25;
			}
			
			cutscene_dialogue_box = temp_dialogue_box;
			
			//
			ds_list_add(cutscene_dialogue_boxes, temp_dialogue_box);
			
			//
			if (ds_list_find_index(cutscene_units, temp_dialogue_box.dialogue_unit) == -1)
			{
				ds_list_add(cutscene_units, temp_dialogue_box.dialogue_unit);
				ds_list_add(cutscene_unit_h_positions, temp_dialogue_box.dialogue_unit.x);
				ds_list_add(cutscene_unit_v_positions, temp_dialogue_box.dialogue_unit.y);
			}
			break;
		case CutsceneEventType.End:
		default:
			//
			instance_destroy();
			break;
	}
	
	//
	calculate_cutscene_dialogue_orientation();
}

calculate_cutscene_dialogue_orientation = function()
{
	// Update Unit Positions
	var temp_cutscene_unit_h_positions = ds_list_create();
	var temp_cutscene_unit_v_positions = ds_list_create();
	
	for (var temp_unit_index = 0; temp_unit_index < ds_list_size(cutscene_units); temp_unit_index++)
	{
		// Find Cutscene Unit
		var temp_unit_inst = ds_list_find_value(cutscene_units, temp_unit_index);
		
		// Set Cutscene Unit Check Positions
		ds_list_set(cutscene_unit_h_positions, temp_unit_index, temp_unit_inst.x);
		ds_list_set(cutscene_unit_v_positions, temp_unit_index, temp_unit_inst.y);
		
		// Find Unit Rotation Angle
		trig_sine = temp_unit_inst.draw_angle_trig_sine;
		trig_cosine = temp_unit_inst.draw_angle_trig_cosine;
		
		// Find Unit Height
		var temp_unit_height = (temp_unit_inst.bbox_bottom - temp_unit_inst.bbox_top) * temp_unit_inst.draw_yscale;
		
		// Calculate Unit's Rotation to find position to place Dialogue Box above
		var temp_unit_dialogue_x = temp_unit_inst.x + rot_point_x(0, -temp_unit_height);
		var temp_unit_dialogue_y = temp_unit_inst.y + rot_point_y(0, -temp_unit_height);
		
		// Set Unit Dialogue Positions
		ds_list_add(temp_cutscene_unit_h_positions, temp_unit_dialogue_x);
		ds_list_add(temp_cutscene_unit_v_positions, temp_unit_dialogue_y);
	}
	
	// Iterate through all Dialogue Boxes to place them
	for (var temp_dialogue_box_index = ds_list_size(cutscene_dialogue_boxes) - 1; temp_dialogue_box_index >= 0; temp_dialogue_box_index--)
	{
		// 
		var temp_dialogue_box_inst = ds_list_find_value(cutscene_dialogue_boxes, temp_dialogue_box_index);
		
		//
		if (instance_exists(temp_dialogue_box_inst.dialogue_unit))
		{
			// Dialogue Box Facing Direction match Unit's Facing Direction Behaviour
			temp_dialogue_box_inst.image_xscale = sign(temp_dialogue_box_inst.dialogue_unit.draw_xscale) != 0 ? sign(temp_dialogue_box_inst.dialogue_unit.draw_xscale) : temp_dialogue_box_inst.image_xscale;
			
			// Find Dialogue Unit
			var temp_dialogue_unit_index = ds_list_find_index(cutscene_units, temp_dialogue_box_inst.dialogue_unit);
			temp_dialogue_unit_index = temp_dialogue_unit_index == -1 ? 0 : temp_dialogue_unit_index;
			
			// Find Dialogue Box's position oriented above Dialogue Unit
			temp_dialogue_box_inst.x = ds_list_find_value(temp_cutscene_unit_h_positions, temp_dialogue_unit_index);
			temp_dialogue_box_inst.y = ds_list_find_value(temp_cutscene_unit_v_positions, temp_dialogue_unit_index) - temp_dialogue_box_inst.dialogue_tail_height - temp_dialogue_box_inst.dialogue_unit_padding;
			
			//
			var temp_vertical_offset = 0;
			
			// Find Comic Book Style Vertical Offset from Dialogue Box Instance Following Chain's Cumulative Height
			if (instance_exists(temp_dialogue_box_inst.dialogue_box_instance_following))
			{
				
				var temp_dialogue_box_instance_following = temp_dialogue_box_inst.dialogue_box_instance_following;
				var temp_dialogue_box_unit = temp_dialogue_box_inst.dialogue_unit;
				
				//
				var i = 0;
				
				while (i < temp_dialogue_box_inst.dialogue_box_instance_following_chain_max)
				{
					//
					with (temp_dialogue_box_instance_following)
					{
						//
						var temp_dialogue_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
						var temp_dialogue_text_height = string_height_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_vertical_padding;
						
						//
						temp_vertical_offset -= temp_dialogue_text_height + (dialogue_breath_padding * 2) + (dialogue_box_instance_following_separation * (dialogue_unit == temp_dialogue_box_unit ? 0.5 : 1.0));
					}
					
					//
					if (!instance_exists(temp_dialogue_box_instance_following.dialogue_box_instance_following))
					{
						//
						break;
					}
					else
					{
						//
						temp_dialogue_box_unit = temp_dialogue_box_instance_following.dialogue_unit;
						temp_dialogue_box_instance_following = temp_dialogue_box_instance_following.dialogue_box_instance_following;
					}
					
					//
					i++;
				}
				
				//
				temp_dialogue_box_inst.dialogue_box_instance_chain_vertical_offset = temp_vertical_offset;
			}
			
			//
			temp_dialogue_box_inst.dialogue_tail.x = temp_dialogue_box_inst.x;
			temp_dialogue_box_inst.dialogue_tail.y = temp_dialogue_box_inst.y + temp_vertical_offset;
		}
	}
	
	//
	ds_list_destroy(temp_cutscene_unit_h_positions);
	temp_cutscene_unit_h_positions = -1;
	
	ds_list_destroy(temp_cutscene_unit_v_positions);
	temp_cutscene_unit_v_positions = -1;
}

//
if (play_cutscene_on_create)
{
	continue_cutscene_event();
}
