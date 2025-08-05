// Cutscene Enums
enum CutsceneDialogueOrientation
{
	Left,
	Middle,
	Right
}

/// @function cutscene_continue_event(cutscene_instance);
/// @description Advances the given Cutscene Object Instance's Cutscene Event to activate and/or continue the given Cutscene
/// @param {oCutscene} cutscene_instance - The given Cutscene Object Instance to advance the Cutscene with
function cutscene_continue_event(cutscene_instance)
{
	// Operate within scope of Cutscene Instance
	with (cutscene_instance)
	{
		// Set Cutscene Active (in case Cutscene was not active before)
		cutscene_active = true;
		
		// Increment Cutscene Index
		cutscene_event_index++;
		
		// Check if Cutscene has Ended
		if (cutscene_event_index >= array_length(cutscene_events))
		{
			// Destroy Cutscene Object and End Cutscene Event
			instance_destroy();
			return;
		}
		
		// Perform Cutscene Behaviour based on Cutscene Index's Cutscene Event Type
		switch (cutscene_events[cutscene_event_index].cutscene_type)
		{
			case CutsceneEventType.Dialogue:
				// Check if Dialogue Unit Exists
				var temp_dialogue_box_unit_instance = find_unit_name(cutscene_events[cutscene_event_index].dialogue_unit);
				
				if (!instance_exists(temp_dialogue_box_unit_instance))
				{
					// Dialogue Unit does not exist, skip dialogue box creation
					cutscene_continue_event(cutscene_instance);
					return;
				}
				
				// Dialogue Cutscene Event - Create new Dialogue Box for Cutscene
				var temp_dialogue_box = instance_create_depth(0, 0, 0, oDialogueBox);
				
				// Set Dialogue Cutscene Instance
				temp_dialogue_box.cutscene_instance = id;
				
				// Set Dialogue Text and Unit
				temp_dialogue_box.set_dialogue_text(cutscene_events[cutscene_event_index].dialogue_text);
				temp_dialogue_box.dialogue_unit = temp_dialogue_box_unit_instance;
				
				// Set Dialogue Cutscene Behaviour Properties
				temp_dialogue_box.dialogue_continue = true;
				temp_dialogue_box.cutscene_dialogue = true;
				
				// Set Dialogue Tail Settings
				temp_dialogue_box.dialogue_tail = true;
				temp_dialogue_box.dialogue_tail_instance.image_blend = temp_dialogue_box.dialogue_box_color;
				
				// Set Dialogue Tail Positions and Horizontal Offset
				temp_dialogue_box.dialogue_tail_start_position = cutscene_events[cutscene_event_index].dialogue_tail_start_position;
				temp_dialogue_box.dialogue_tail_end_position = cutscene_events[cutscene_event_index].dialogue_tail_end_position;
				temp_dialogue_box.dialogue_horizontal_offset = cutscene_events[cutscene_event_index].dialogue_horizontal_offset;
				
				// Add Previous Dialogue Box to Dialogue Box Chain
				if (instance_exists(cutscene_dialogue_box))
				{
					// Previous Dialogue Box now follows the created Dialogue Box
					cutscene_dialogue_box.dialogue_box_instance_following = temp_dialogue_box;
					cutscene_dialogue_box.dialogue_tail = false;
					
					// Create Dialogue Box Animation Offset by incrementing from the Cutscene's Last Dialogue Box's Animation Value
					temp_dialogue_box.dialogue_box_animation_value = cutscene_dialogue_box.dialogue_box_animation_value + dialogue_box_animation_offset;
				}
				
				// Update Cutscene's Last Dialogue Box Instance
				cutscene_dialogue_box = temp_dialogue_box;
				
				// Add new Dialogue Box to Cutscene's List of Dialogue Boxes
				ds_list_add(cutscene_dialogue_boxes, temp_dialogue_box);
				
				// Check if Dialogue Box's Unit is contained in Cutscene Units DS List
				if (ds_list_find_index(cutscene_units, temp_dialogue_box.dialogue_unit) == -1)
				{
					// Add Dialogue Box's Unit to Cutscene Units
					ds_list_add(cutscene_units, temp_dialogue_box.dialogue_unit);
				}
				break;
			case CutsceneEventType.DialogueClear:
				// Clear All Existing Dialogue Cutscene Event - Removes all Dialogue Boxes currently being used by this Cutscene
				cutscene_waiting_behaviour = true;
				cutscene_waiting_for_dialogue_boxes_to_deinstantiate_to_continue = true;
				
				// Perform timed destruction of Cutscene Dialogue Boxes in sequential top-to-bottom fade pattern
				var temp_dialogue_fade_delay = 1;
				
				for (var i = 0; i < ds_list_size(cutscene_dialogue_boxes); i++)
				{
					// Find Dialogue Box instance
					var temp_dialogue_box_remove = ds_list_find_value(cutscene_dialogue_boxes, i);
					
					// Check if Dialogue Box Exists
					if (instance_exists(temp_dialogue_box_remove))
					{
						// Check if Dialogue Clear Behaviour is instantaneous
						if (cutscene_events[cutscene_event_index].dialogue_clear_instant)
						{
							// Destroy Dialogue Box Instantly
							instance_destroy(temp_dialogue_box_remove);
						}
						else
						{
							// Activate Dialogue Box's Fade Destroy Behaviour
							temp_dialogue_box_remove.alarm[1] = temp_dialogue_fade_delay;
							temp_dialogue_fade_delay += dialogue_fade_delay_offset;
						}
					}
				}
				
				// If the Dialogue Clear Event is instantaneous, immediately advance to the next Cutscene Event
				if (cutscene_events[cutscene_event_index].dialogue_clear_instant)
				{
					// Continue to next Cutscene Event
					cutscene_continue_event(cutscene_instance);
				}
				break;
			case CutsceneEventType.Delay:
				// Delay Cutscene Event - Delays the advancement to the next Cutscene Event for the given Delay Duration
				cutscene_waiting_behaviour = true;
				cutscene_waiting_for_delay_duration = true;
				cutscene_delay_timer = cutscene_events[cutscene_event_index].delay_duration;
				break;
			case CutsceneEventType.UnitMovement:
				// Unit Movement Cutscene Event - Finds the given Unit by name and moves them based on the given movement position and other movement parameters
				var temp_movement_unit_instance = find_unit_name(cutscene_events[cutscene_event_index].unit_movement_name);
				
				// Check if Unit to be moved exists in the given Scene
				if (!instance_exists(temp_movement_unit_instance))
				{
					// Movement Unit does not exist, skip Unit Movement to next cutscene event
					cutscene_continue_event(cutscene_instance);
					return;
				}
				
				// Unit Movement Behaviour
				with (temp_movement_unit_instance)
				{
					// Delete and Reset Previous Path
					pathfinding_delete_path(pathfinding_path);
					pathfinding_path = undefined;
					
					// Establish Unit Path Start and End Positions
					pathfinding_path_start_x = x;
					pathfinding_path_start_y = y;
					
					pathfinding_path_end_x = (cutscene_instance.cutscene_events[cutscene_instance.cutscene_event_index].unit_movement_position_local ? x : 0) + cutscene_instance.cutscene_events[cutscene_instance.cutscene_event_index].unit_movement_x;
					pathfinding_path_end_y = (cutscene_instance.cutscene_events[cutscene_instance.cutscene_event_index].unit_movement_position_local ? y : 0) + cutscene_instance.cutscene_events[cutscene_instance.cutscene_event_index].unit_movement_y;
					
					// Establish Unit Path End Direction
					var temp_pathfinding_end_direction = cutscene_instance.cutscene_events[cutscene_instance.cutscene_event_index].unit_movement_end_direction;
					
					// Calculate New Path and Reset Pathfinding Index
					pathfinding_path = pathfinding_create_path(pathfinding_path_start_x, pathfinding_path_start_y, pathfinding_path_end_x, pathfinding_path_end_y, temp_pathfinding_end_direction);
					pathfinding_path_index = is_undefined(pathfinding_path) ? 0 : (pathfinding_path.path_size >= 2 ? 1 : 0);
					
					// Reset Pathfinding Variables
					pathfinding_recalculate = false;
					pathfinding_path_ended = false;
					pathfinding_jump = true;
				}
				
				// Unit Movement Cutscene Wait and Advancement Behaviour
				if (cutscene_events[cutscene_event_index].unit_movement_wait)
				{
					// Check for duplicate Unit Moving Instances
					if (ds_list_find_index(cutscene_moving_units_list, temp_movement_unit_instance) == -1)
					{
						// Toggle Cutscene Wait for Unit Movement to Finish Behaviour
						cutscene_waiting_behaviour = true;
						cutscene_waiting_for_units_to_finish_moving = true;
						
						// Add Unit Movement
						ds_list_add(cutscene_moving_units_list, temp_movement_unit_instance);
					}
					
					// Check if next Cutscene Event is Unit Movement and allow chained Unit Movement Wait Behaviours
					if (cutscene_event_index + 1 < array_length(cutscene_events) and cutscene_events[cutscene_event_index + 1].cutscene_type == CutsceneEventType.UnitMovement)
					{
						// Continue to next Cutscene Event
						cutscene_continue_event(cutscene_instance);
					}
				}
				else
				{
					// Continue to next Cutscene Event
					cutscene_continue_event(cutscene_instance);
				}
				return;
			case CutsceneEventType.End:
			default:
				// End Cutscene - Destroy Cutscene Object and End Cutscene Event
				instance_destroy();
				break;
		}
		
		// Update Cutscene Orientation
		cutscene_calculate_dialogue_orientation(id);
	}
}

/// @function cutscene_calculate_dialogue_orientation(cutscene_instance);
/// @description Calculates the position and orientation of every Dialogue Box and Dialogue Box's Tail based on their Dialogue Chain and Dialogue Unit with the given Cutscene Instance
/// @param {oCutscene} cutscene_instance - The given Cutscene Object Instance to calculate and align Dialogue Boxes with their Unit Instances
function cutscene_calculate_dialogue_orientation(cutscene_instance)
{
	// Find Unit Dialogue Orientations and Positions
	var temp_cutscene_unit_h_positions = ds_list_create();
	var temp_cutscene_unit_v_positions = ds_list_create();
	
	for (var temp_unit_index = 0; temp_unit_index < ds_list_size(cutscene_instance.cutscene_units); temp_unit_index++)
	{
		// Find Cutscene Unit
		var temp_unit_inst = ds_list_find_value(cutscene_instance.cutscene_units, temp_unit_index);
		
		// Find Unit Rotation Angle
		cutscene_instance.trig_sine = temp_unit_inst.draw_angle_trig_sine;
		cutscene_instance.trig_cosine = temp_unit_inst.draw_angle_trig_cosine;
		
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
	for (var temp_dialogue_box_index = ds_list_size(cutscene_instance.cutscene_dialogue_boxes) - 1; temp_dialogue_box_index >= 0; temp_dialogue_box_index--)
	{
		// Find the Cutscene's Dialogue Box Instance
		var temp_dialogue_box_inst = ds_list_find_value(cutscene_instance.cutscene_dialogue_boxes, temp_dialogue_box_index);
		
		// Check if Dialogue Box exists
		if (!instance_exists(temp_dialogue_box_inst))
		{
			// Remove Instance of Dialogue Box from Cutscene Dialogue Box DS List
			ds_list_delete(cutscene_instance.cutscene_dialogue_boxes, temp_dialogue_box_index);
			
			// Skip Dialogue Box Instance
			continue;
		}
		
		// Check if Dialogue Box's Unit still exists
		if (instance_exists(temp_dialogue_box_inst.dialogue_unit))
		{
			// Dialogue Box Facing Direction match Unit's Facing Direction Behaviour
			temp_dialogue_box_inst.image_xscale = sign(temp_dialogue_box_inst.dialogue_unit.draw_xscale) != 0 ? sign(temp_dialogue_box_inst.dialogue_unit.draw_xscale) : temp_dialogue_box_inst.image_xscale;
			
			// Find Dialogue Unit
			var temp_dialogue_unit_index = ds_list_find_index(cutscene_instance.cutscene_units, temp_dialogue_box_inst.dialogue_unit);
			temp_dialogue_unit_index = temp_dialogue_unit_index == -1 ? 0 : temp_dialogue_unit_index;
			
			// Find Dialogue Box's position oriented above Dialogue Unit
			temp_dialogue_box_inst.x = ds_list_find_value(temp_cutscene_unit_h_positions, temp_dialogue_unit_index) + (temp_dialogue_box_inst.dialogue_tail ? 0 : temp_dialogue_box_inst.dialogue_horizontal_offset * temp_dialogue_box_inst.image_xscale);
			temp_dialogue_box_inst.y = ds_list_find_value(temp_cutscene_unit_v_positions, temp_dialogue_unit_index) - temp_dialogue_box_inst.dialogue_tail_height - temp_dialogue_box_inst.dialogue_unit_padding;
			
			temp_dialogue_box_inst.dialogue_tail_end_x = ds_list_find_value(temp_cutscene_unit_h_positions, temp_dialogue_unit_index);
			temp_dialogue_box_inst.dialogue_tail_end_y = ds_list_find_value(temp_cutscene_unit_v_positions, temp_dialogue_unit_index) - temp_dialogue_box_inst.dialogue_unit_padding;
			
			// Establish Dialogue Box (Texting Stack Style) Vertical Offset
			var temp_vertical_offset = 0;
			
			// Find Comic Book Style Vertical Offset from Dialogue Box Instance Following Chain's Cumulative Height
			if (instance_exists(temp_dialogue_box_inst.dialogue_box_instance_following))
			{
				// Establish Variables for Dialogue Box Chain and Dialogue Box Unit Comparison
				var temp_dialogue_box_instance_following = temp_dialogue_box_inst.dialogue_box_instance_following;
				var temp_dialogue_box_unit = temp_dialogue_box_inst.dialogue_unit;
				
				// Iterate through Dialogue Box Chain
				var temp_dialogue_box_chain_length = 0;
				
				while (temp_dialogue_box_chain_length < temp_dialogue_box_inst.dialogue_box_instance_following_chain_max)
				{
					// Establish Variables and check Dialogue Box Dimensions
					var temp_dialogue_text_width = 0;
					var temp_dialogue_text_height = 0;
					
					with (temp_dialogue_box_instance_following)
					{
						// Set Font for Dialogue Width & Height Calculation
						draw_set_font(dialogue_font);
						
						// Calculate Dialogue Box Width & Height
						var temp_dialogue_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
						temp_dialogue_text_width = string_width_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_horizontal_padding;
						temp_dialogue_text_height = string_height_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_vertical_padding;
						
						// Calculate and add to Dialogue Box Cumulative Vertical Offset
						temp_vertical_offset += temp_dialogue_text_height + (dialogue_breath_padding * 2) + (dialogue_box_instance_following_separation * (dialogue_unit == temp_dialogue_box_unit ? 0.5 : 1.0));
					}
					
					// Check if Dialogue Box Chain continues
					if (!instance_exists(temp_dialogue_box_instance_following.dialogue_box_instance_following))
					{
						// Dialogue Box Chain does not continue - Break Loop
						break;
					}
					else
					{
						// Dialogue Box Chain Continues - Set Dialogue Box Chain Instance and Dialogue Unit for comparison
						temp_dialogue_box_unit = temp_dialogue_box_instance_following.dialogue_unit;
						temp_dialogue_box_instance_following = temp_dialogue_box_instance_following.dialogue_box_instance_following;
					}
					
					// Increment Dialogue Box Chain Length
					temp_dialogue_box_chain_length++;
				}
			}
			
			// Add Dialogue Box Vertical Offset to Dialogue Box's Position
			temp_dialogue_box_inst.y -= temp_vertical_offset;
			
			// Check Dialogue Box Max Vertical Offset
			if (!temp_dialogue_box_inst.dialogue_fade and temp_vertical_offset >= temp_dialogue_box_inst.dialogue_box_max_vertical_offset)
			{
				// Dialogue Box's Vertical Offset has exceeded max Vertical Offset - Set Dialogue Box to fade and destroy itself
				temp_dialogue_box_inst.dialogue_fade = true;
			}
		}
	}
	
	// Iterate through all Dialogue Boxes to place their Dialogue Box Tails
	for (var temp_dialogue_box_index = ds_list_size(cutscene_instance.cutscene_dialogue_boxes) - 1; temp_dialogue_box_index >= 0; temp_dialogue_box_index--)
	{
		// Find the Cutscene's Dialogue Box Instance
		var temp_dialogue_box_inst = ds_list_find_value(cutscene_instance.cutscene_dialogue_boxes, temp_dialogue_box_index);
		
		// Remove all Bezier Curve Points
		bezier_curve_clear_all_points(temp_dialogue_box_inst.dialogue_tail_instance);
		
		// Establish Variables for Dialogue Box Chain and Dialogue Box Unit Comparison
		var temp_dialogue_box_chain_inst = temp_dialogue_box_inst;
		var temp_dialogue_box_unit = temp_dialogue_box_inst.dialogue_unit;
		
		// Iterate through Dialogue Box Chain
		var temp_dialogue_box_chain_length = 0;
		var temp_dialogue_box_chain_ends_with_unit_dialogue = false;
		
		while (temp_dialogue_box_chain_length < temp_dialogue_box_inst.dialogue_box_instance_following_chain_max)
		{
			// Check if this Dialogue Box's Unit matches starting Dialogue Box's Unit in Dialogue Box Chain
			if (temp_dialogue_box_inst.dialogue_unit == temp_dialogue_box_chain_inst.dialogue_unit)
			{
				// Establish Variables and check Dialogue Box Dimensions
				var temp_dialogue_text_width = 0;
				var temp_dialogue_text_height = 0;
				
				with (temp_dialogue_box_chain_inst)
				{
					// Set Font for Dialogue Width & Height Calculation
					draw_set_font(dialogue_font);
					
					// Calculate Dialogue Box Width & Height
					var temp_dialogue_text = string_copy(dialogue_text, 0, round(dialogue_text_value));
					temp_dialogue_text_width = string_width_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) * 0.5;
					temp_dialogue_text_height = string_height_ext(temp_dialogue_text, dialogue_font_separation + dialogue_font_height, dialogue_font_wrap_width) + dialogue_box_vertical_padding;
					temp_dialogue_text_height += (dialogue_breath_padding * 2) + (dialogue_box_instance_following_separation * (dialogue_unit == temp_dialogue_box_unit ? 0.5 : 1.0));
				}
				
				// Add Path Point to Dialogue Box's Tail Bezier Curve
				if (temp_dialogue_box_inst == temp_dialogue_box_chain_inst)
				{
					// Path Point is added from inside the starting Dialogue Box
					var temp_dialogue_tail_start_horizontal_offset = temp_dialogue_text_width * temp_dialogue_box_inst.dialogue_tail_start_position * temp_dialogue_box_inst.image_xscale;
					var temp_dialogue_tail_start_horizontal_vector = temp_dialogue_box_inst.dialogue_tail_start_horizontal_vector * sign(temp_dialogue_box_inst.dialogue_tail_start_position) * temp_dialogue_box_inst.image_xscale;
					
					var temp_dialogue_tail_start_point_x = temp_dialogue_box_chain_inst.x + temp_dialogue_tail_start_horizontal_offset;
					var temp_dialogue_tail_start_point_y = temp_dialogue_box_chain_inst.y - (temp_dialogue_text_height * 0.5);
					
					bezier_curve_add_path_point
					(
						temp_dialogue_box_inst.dialogue_tail_instance, 
						temp_dialogue_tail_start_point_x, 
						temp_dialogue_tail_start_point_y, 
						temp_dialogue_tail_start_horizontal_vector, 
						temp_dialogue_box_inst.dialogue_tail_start_vertical_vector, 
						temp_dialogue_box_inst.dialogue_tail_start_thickness
					);
				}
				else
				{
					// Path Point is added from inside the next Dialogue Box that shares the Chain's Starting Dialogue Box's Unit
					temp_dialogue_box_chain_ends_with_unit_dialogue = true;
					
					var temp_dialogue_tail_mid_horizontal_offset = temp_dialogue_text_width * temp_dialogue_box_inst.dialogue_tail_end_position * temp_dialogue_box_inst.image_xscale;
					var temp_dialogue_tail_mid_horizontal_vector = temp_dialogue_box_inst.dialogue_tail_mid_horizontal_vector * sign(temp_dialogue_box_inst.dialogue_tail_end_position) * temp_dialogue_box_inst.image_xscale;
					
					var temp_dialogue_tail_mid_point_x = temp_dialogue_box_chain_inst.x + temp_dialogue_tail_mid_horizontal_offset;
					var temp_dialogue_tail_mid_point_y = temp_dialogue_box_chain_inst.y - (temp_dialogue_text_height * 0.5);
					
					bezier_curve_add_path_point
					(
						temp_dialogue_box_inst.dialogue_tail_instance, 
						temp_dialogue_tail_mid_point_x, 
						temp_dialogue_tail_mid_point_y, 
						temp_dialogue_tail_mid_horizontal_vector, 
						temp_dialogue_box_inst.dialogue_tail_mid_vertical_vector, 
						temp_dialogue_box_inst.dialogue_tail_mid_thickness
					);
					break;
				}
			}
			
			// Check if Dialogue Box Chain continues
			if (!instance_exists(temp_dialogue_box_chain_inst.dialogue_box_instance_following))
			{
				// Dialogue Box Chain does not continue - Break Loop
				temp_dialogue_box_chain_ends_with_unit_dialogue = temp_dialogue_box_inst.dialogue_unit == temp_dialogue_box_chain_inst.dialogue_unit;
				break;
			}
			else
			{
				// Dialogue Box Chain Continues - Set Dialogue Box Chain Instance and Dialogue Unit for comparison
				temp_dialogue_box_unit = temp_dialogue_box_chain_inst.dialogue_unit;
				temp_dialogue_box_chain_inst = temp_dialogue_box_chain_inst.dialogue_box_instance_following;
			}
			
			// Increment Dialogue Box Chain Length
			temp_dialogue_box_chain_length++;
		}
		
		// Add Final Point if Dialogue Box is closest to Unit in Dialogue Box Chain
		if (!temp_dialogue_box_chain_ends_with_unit_dialogue)
		{
			// Path Point is added right above the Dialogue Box's Unit
			var temp_dialogue_tail_end_horizontal_vector = temp_dialogue_box_inst.dialogue_tail_end_horizontal_vector * sign(temp_dialogue_box_inst.dialogue_tail_end_position) * temp_dialogue_box_inst.image_xscale;
			
			bezier_curve_add_path_point
			(
				temp_dialogue_box_inst.dialogue_tail_instance, 
				temp_dialogue_box_inst.dialogue_tail_end_x, 
				temp_dialogue_box_inst.dialogue_tail_end_y, 
				temp_dialogue_tail_end_horizontal_vector, 
				temp_dialogue_box_inst.dialogue_tail_end_vertical_vector, 
				temp_dialogue_box_inst.dialogue_tail_end_thickness
			);
		}
	}
	
	// Destroy Temporary Cutscene Unit Dialogue Box Position DS Lists
	ds_list_destroy(temp_cutscene_unit_h_positions);
	temp_cutscene_unit_h_positions = -1;
	
	ds_list_destroy(temp_cutscene_unit_v_positions);
	temp_cutscene_unit_v_positions = -1;
}
