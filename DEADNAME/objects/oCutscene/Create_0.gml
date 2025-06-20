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

enum CutsceneDialogueOrientation
{
	Left,
	Middle,
	Right
}

// Cutscene Events
cutscene_events[0] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "Frrankly, You should be disgusted.",
	dialogue_unit: "Mel"
};

cutscene_events[1] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "Our society is deeply fixated on shallow materialism, we don't have to keep killing each other.",
	dialogue_unit: "Mel"
};

cutscene_events[2] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "At least... we can work together, tackle all the lowest hanging fruit, namely hunger.",
	dialogue_unit: "Mel"
};

cutscene_events[3] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "Listen after the Vampires are dead you're next.",
	dialogue_unit: "Charn"
};

cutscene_events[4] = 
{
	cutscene_type: CutsceneEventType.Dialogue,
	
	dialogue_text: "Capitalism may be the disease of the Skin, but you Communists are the disease of the Heart.",
	dialogue_unit: "Charn"
};

// Cutscene Settings
cutscene_active = false;
cutscene_event_index = -1;

cutscene_dialogue_box = noone;
cutscene_dialogue_boxes = ds_list_create();

cutscene_units = ds_list_create();

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
			temp_dialogue_box.dialogue_tail = false;
			temp_dialogue_box.dialogue_tail_instance = instance_create_depth(x, y, 0, oDialogueTail);
			temp_dialogue_box.dialogue_continue = true;
			temp_dialogue_box.cutscene_instance = id;
			
			// Add Previous Dialogue Box to Dialogue Box Chain
			if (instance_exists(cutscene_dialogue_box))
			{
				// Previous Dialogue Box now follows the created Dialogue Box
				cutscene_dialogue_box.dialogue_box_instance_following = temp_dialogue_box;
				
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
	var temp_cutscene_dialogue_box_tail_connections = ds_list_create();
	
	for (var temp_dialogue_box_index = ds_list_size(cutscene_dialogue_boxes) - 1; temp_dialogue_box_index >= 0; temp_dialogue_box_index--)
	{
		// 
		var temp_dialogue_box_inst = ds_list_find_value(cutscene_dialogue_boxes, temp_dialogue_box_index);
		
		//
		var temp_dialogue_box_tail_connection_found = false;
		
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
				//
				var temp_dialogue_box_instance_following = temp_dialogue_box_inst.dialogue_box_instance_following;
				var temp_dialogue_box_unit = temp_dialogue_box_inst.dialogue_unit;
				
				//
				var i = 0;
				
				while (i < temp_dialogue_box_inst.dialogue_box_instance_following_chain_max)
				{
					//
					var temp_dialogue_text_width = 0;
					var temp_dialogue_text_height = 0;
					
					with (temp_dialogue_box_instance_following)
					{
						//
						var temp_dialogue_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
						temp_dialogue_text_width = (string_width_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_horizontal_padding) * 0.5;
						temp_dialogue_text_height = string_height_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_vertical_padding;
						
						//
						temp_vertical_offset -= temp_dialogue_text_height + (dialogue_breath_padding * 2) + (dialogue_box_instance_following_separation * (dialogue_unit == temp_dialogue_box_unit ? 0.5 : 1.0));
					}
					
					//
					if (!temp_dialogue_box_tail_connection_found)
					{
						if (temp_dialogue_box_inst.dialogue_unit == temp_dialogue_box_instance_following.dialogue_unit)
						{
							temp_dialogue_box_tail_connection_found = true;
							ds_list_insert(temp_cutscene_dialogue_box_tail_connections, 0, temp_dialogue_box_instance_following);
						}
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
		}
		
		//
		if (!temp_dialogue_box_tail_connection_found)
		{
			ds_list_insert(temp_cutscene_dialogue_box_tail_connections, 0, noone);
		}
	}
	
	// Iterate through all Dialogue Boxes to orient their Tails
	for (var temp_dialogue_box_index = 0; temp_dialogue_box_index < ds_list_size(cutscene_dialogue_boxes); temp_dialogue_box_index++)
	{
		// 
		var temp_dialogue_box_inst = ds_list_find_value(cutscene_dialogue_boxes, temp_dialogue_box_index);
		var temp_dialogue_box_connection_inst = ds_list_find_value(temp_cutscene_dialogue_box_tail_connections, temp_dialogue_box_index);
		
		//
		temp_dialogue_box_inst.dialogue_tail_instance.clear_all_points();
		
		//
		var temp_dialogue_box_inst_text_width = 0;
		var temp_dialogue_box_inst_text_height = 0;
		
		with (temp_dialogue_box_inst)
		{
			// Create Dialogue Box's Display Text Sub-String
			var temp_dialogue_box_inst_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
			
			// Find Dialogue Box's Width and Height
			temp_dialogue_box_inst_text_width = (string_width_ext(temp_dialogue_box_inst_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_horizontal_padding) * 0.5;
			temp_dialogue_box_inst_text_height = string_height_ext(temp_dialogue_box_inst_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_vertical_padding + (dialogue_breath_padding * 2);
		}
		
		//
		var temp_dialogue_box_y = temp_dialogue_box_inst.y + temp_dialogue_box_inst.dialogue_box_instance_chain_vertical_offset;
		
		//
		if (instance_exists(temp_dialogue_box_connection_inst))
		{
			//
			var temp_dialogue_box_connection_inst_text_width = 0;
			var temp_dialogue_box_connection_inst_text_height = 0;
			
			with (temp_dialogue_box_connection_inst)
			{
				// Create Dialogue Box's Display Text Sub-String
				var temp_dialogue_box_connection_inst_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
				
				// Find Dialogue Box's Width and Height
				temp_dialogue_box_connection_inst_text_width = (string_width_ext(temp_dialogue_box_connection_inst_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_horizontal_padding) * 0.5;
				temp_dialogue_box_connection_inst_text_height = string_height_ext(temp_dialogue_box_connection_inst_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_vertical_padding + (dialogue_breath_padding * 2);
			}
			
			//
			var temp_dialogue_box_connection_y = temp_dialogue_box_connection_inst.y + temp_dialogue_box_connection_inst.dialogue_box_instance_chain_vertical_offset;
			
			//
			temp_dialogue_box_inst.dialogue_tail_instance.add_path_point(temp_dialogue_box_inst.x, temp_dialogue_box_y - (temp_dialogue_box_inst_text_height * 0.5), 50, 0, 1);
			temp_dialogue_box_inst.dialogue_tail_instance.add_path_point(temp_dialogue_box_inst.x, temp_dialogue_box_connection_y - (temp_dialogue_box_connection_inst_text_height * 0.5), 50, 0, 1);
		}
		else
		{
			//
			temp_dialogue_box_inst.dialogue_tail_instance.add_path_point(temp_dialogue_box_inst.x, temp_dialogue_box_y - (temp_dialogue_box_inst_text_height * 0.5), 50, 0, 1);
			temp_dialogue_box_inst.dialogue_tail_instance.add_path_point(temp_dialogue_box_inst.x, lerp(temp_dialogue_box_y - (temp_dialogue_box_inst_text_height * 0.5), temp_dialogue_box_inst.y, 0.7), 0, 0, 1);
			temp_dialogue_box_inst.dialogue_tail_instance.add_path_point(temp_dialogue_box_inst.x, temp_dialogue_box_inst.y + temp_dialogue_box_inst.dialogue_tail_height, -50, 0, 0);
		}
	}
	
	//
	ds_list_destroy(temp_cutscene_unit_h_positions);
	temp_cutscene_unit_h_positions = -1;
	
	ds_list_destroy(temp_cutscene_unit_v_positions);
	temp_cutscene_unit_v_positions = -1;
	
	//
	ds_list_destroy(temp_cutscene_dialogue_box_tail_connections);
	temp_cutscene_dialogue_box_tail_connections = -1;
}

//
if (play_cutscene_on_create)
{
	continue_cutscene_event();
}
