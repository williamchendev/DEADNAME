/// @description Dialogue Box Update Event
// Updates the Diaglogue Box's Text Behaviour

// Update Dialogue Text Behaviour
if (dialogue_text_value < string_length(dialogue_text))
{
	dialogue_text_value += dialogue_text_speed * frame_delta;
	dialogue_text_value = clamp(dialogue_text_value, 0, string_length(dialogue_text));
}

// Update Animation Behaviour
dialogue_box_animation_value += dialogue_animation_speed * frame_delta;
dialogue_box_animation_value = dialogue_box_animation_value >= 1 ? 0 : dialogue_box_animation_value;

dialogue_box_breath_value = clamp(sin(dialogue_box_animation_value * 2 * pi), dialogue_breath_edge_clamp, dialogue_breath_padding - dialogue_breath_edge_clamp);

// Update Position Behaviour
if (instance_exists(dialogue_unit))
{
	// Find Unit Rotation Angle
	trig_sine = dialogue_unit.draw_angle_trig_sine;
	trig_cosine = dialogue_unit.draw_angle_trig_cosine;
	
	// Find Unit Height
	var temp_unit_height = dialogue_unit.bbox_bottom - dialogue_unit.bbox_top;
	
	x = dialogue_unit.x + rot_point_x(0, -temp_unit_height);
	y = dialogue_unit.y + rot_point_y(0, -temp_unit_height) - dialogue_unit_padding;
}
