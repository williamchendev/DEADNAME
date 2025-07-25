/// @description Dialogue Box Update Event
// Updates the Diaglogue Box's Text Behaviour

// Update Dialogue Text Behaviour
if (dialogue_text_value < string_length(dialogue_text))
{
	// Update Dialogue Text
	dialogue_raw_value += dialogue_text_speed * frame_delta;
	
	// Iterate through all Dialogue Text Split Array's End Positions to find where the Dialogue Raw Value matches
	for (var i = 0; i < array_length(dialogue_word_end_positions_array); i++)
	{
		// Comparison of Dialogue Position Raw Value to Dialogue Text Split Array's End Position
		if (dialogue_raw_value >= dialogue_word_end_positions_array[i])
		{
			// Dialogue Position Raw Value is beyond this Dialogue Text Split Array's End Position - Update Dialogue's Position Value
			dialogue_text_value = dialogue_word_end_positions_array[i];
		}
		else
		{
			// Dialogue Position Raw Value is before this Dialogue Text Split Array's End Position - Do not update Dialogue's Position Value
			break;
		}
	}
	
	// Dialogue Continue Behaviour
	if (dialogue_continue)
	{
		// Check Skip Dialogue Event
		if (dialogue_text_value == string_length(dialogue_text))
		{
			// Dialogue is Finished State - Show Continue Triangle
			dialogue_triangle = true;
		}
		else if (keyboard_check_pressed(GameManager.interact_check))
		{
			// Dialogue Skip Behaviour - Set Dialogue Finished and show Continue Triangle
			dialogue_text_value = string_length(dialogue_text);
			dialogue_triangle = true;
		}
	}
}
else if (dialogue_continue)
{
	// Dialogue Continue Behaviour
	if (keyboard_check_pressed(GameManager.interact_check))
	{
		// Disable Dialogue Continue & Continue Triangle Behaviours
		dialogue_continue = false;
		dialogue_triangle = false;
		
		// Check if Cutscene Exists
		if (instance_exists(cutscene_instance))
		{
			// Continue Cutscene Behaviour
			cutscene_continue_event(cutscene_instance);
		}
		else
		{
			// Activate Dialogue Box's Fade Destroy Behaviour
			dialogue_fade = true;
		}
	}
}

// Update Position Behaviour
if (!cutscene_dialogue and instance_exists(dialogue_unit))
{
	// Dialogue Box Facing Direction match Unit's Facing Direction Behaviour
	image_xscale = sign(dialogue_unit.draw_xscale) != 0 ? sign(dialogue_unit.draw_xscale) : image_xscale;
	
	// Find Unit Rotation Angle
	trig_sine = dialogue_unit.draw_angle_trig_sine;
	trig_cosine = dialogue_unit.draw_angle_trig_cosine;
	
	// Find Unit Orientations
	var temp_unit_height = (dialogue_unit.bbox_bottom - dialogue_unit.bbox_top) * dialogue_unit.draw_yscale;
	var temp_unit_x_offset = dialogue_unit.x + rot_point_x(0, -temp_unit_height);
	var temp_unit_y_offset = dialogue_unit.y + rot_point_y(0, -temp_unit_height);
	
	// Set Dialogue Box Position and Dialogue Tail Endpoint
	x = temp_unit_x_offset;
	y = temp_unit_y_offset - dialogue_tail_height - dialogue_unit_padding;
	
	dialogue_tail_end_x = temp_unit_x_offset;
	dialogue_tail_end_y = temp_unit_y_offset - dialogue_unit_padding;
}

// Dialogue Fade Behaviour
if (dialogue_fade)
{
	// Dialogue Box Fade Destroy Behaviour
	dialogue_fade_timer -= frame_delta;

	// Transparency Fade Behaviour
	image_alpha = clamp(dialogue_fade_timer / dialogue_fade_duration, 0, 1);

	// Destroy Dialogue Box
	if (image_alpha == 0)
	{
		instance_destroy();
		return;
	}
}
else if (dialogue_triangle)
{
	// Dialogue Box Triangle Behaviour
	tri_x_1 = rot_dist_x(dialogue_triangle_radius, dialogue_triangle_draw_angle);
	tri_y_1 = rot_dist_y(dialogue_triangle_radius);
	tri_x_2 = rot_dist_x(dialogue_triangle_radius, dialogue_triangle_draw_angle + 120);
	tri_y_2 = rot_dist_y(dialogue_triangle_radius);
	tri_x_3 = rot_dist_x(dialogue_triangle_radius, dialogue_triangle_draw_angle + 240);
	tri_y_3 = rot_dist_y(dialogue_triangle_radius);
}

// Update Animation Behaviour
dialogue_box_animation_value += dialogue_animation_speed * frame_delta;
dialogue_box_animation_value = dialogue_box_animation_value mod 1;

dialogue_box_breath_value = clamp(dialogue_breath_padding * ((sin(dialogue_box_animation_value * 2 * pi) * 0.5) + 0.5), dialogue_breath_edge_clamp, dialogue_breath_padding - dialogue_breath_edge_clamp);
dialogue_triangle_draw_angle = dialogue_triangle_angle + (dialogue_triangle_rotate_range * ((sin(dialogue_box_animation_value * 2 * pi * dialogue_triangle_rotate_spd) * 0.5) + 0.5));
