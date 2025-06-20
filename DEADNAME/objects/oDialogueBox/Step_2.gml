/// @description Dialogue Box Update Event
// Updates the Diaglogue Box's Text Behaviour

// Update Dialogue Text Behaviour
if (dialogue_text_value < string_length(dialogue_text))
{
	//
	dialogue_text_value += dialogue_text_speed * frame_delta;
	dialogue_text_value = clamp(dialogue_text_value, 0, string_length(dialogue_text));
	
	//
	if (dialogue_continue and dialogue_text_value == string_length(dialogue_text))
	{
		dialogue_triangle = true;
	}
}
else if (dialogue_continue)
{
	//
	if (keyboard_check_pressed(GameManager.interact_check))
	{
		//
		dialogue_continue = false;
		dialogue_triangle = false;
		
		//
		if (instance_exists(cutscene_instance))
		{
			// 
			with (cutscene_instance)
			{
				continue_cutscene_event();
			}
		}
		else
		{
			dialogue_fade = true;
		}
	}
}

// Update Position Behaviour
if (!instance_exists(cutscene_instance) and instance_exists(dialogue_unit))
{
	// Dialogue Box Facing Direction match Unit's Facing Direction Behaviour
	image_xscale = sign(dialogue_unit.draw_xscale) != 0 ? sign(dialogue_unit.draw_xscale) : image_xscale;
	
	// Find Unit Rotation Angle
	trig_sine = dialogue_unit.draw_angle_trig_sine;
	trig_cosine = dialogue_unit.draw_angle_trig_cosine;
	
	// Find Unit Height
	var temp_unit_height = (dialogue_unit.bbox_bottom - dialogue_unit.bbox_top) * dialogue_unit.draw_yscale;
	
	x = dialogue_unit.x + rot_point_x(0, -temp_unit_height);
	y = dialogue_unit.y + rot_point_y(0, -temp_unit_height) - dialogue_tail_height - dialogue_unit_padding;
}

//
if (dialogue_fade)
{
	// Dialogue Box Fade Destroy Behaviour
	dialogue_fade_timer -= frame_delta;
	
	//
	image_alpha = clamp(dialogue_fade_timer / dialogue_fade_duration, 0, 1);
	
	//
	if (image_alpha == 0)
	{
		instance_destroy();
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
