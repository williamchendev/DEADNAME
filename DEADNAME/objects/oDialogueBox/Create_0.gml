/// @description Dialogue Box Init Event
// Initializes the Dialogue Box's Settings and Variables

// Dialogue Box's Lighting Engine UI Object Type & Depth
object_type = LightingEngineUIObjectType.Dialogue;
object_depth = LightingEngineUIObjectType.Dialogue;

// Default Lighting Engine UI Object Initialization Behaviour
event_inherited();

// Cutscene Settings
cutscene_dialogue = false;
cutscene_instance = noone;

// Dialogue Box Settings
dialogue_unit = noone;
dialogue_text = "";
dialogue_text_array = undefined;

dialogue_box_instance_following = noone;
dialogue_box_instance_following_chain_max = 20;
dialogue_box_instance_following_separation = 6;

// Dialogue Tail Settings
dialogue_tail_instance = instance_create_depth(0, 0, 0, oBezierCurve);
dialogue_tail_instance.image_blend = dialogue_box_color;

dialogue_tail_start_horizontal_vector = 55;
dialogue_tail_start_vertical_vector = 0;
dialogue_tail_start_thickness = 1.8;

dialogue_tail_mid_horizontal_vector = 15;
dialogue_tail_mid_vertical_vector = 0;
dialogue_tail_mid_thickness = 0.6;

dialogue_tail_end_horizontal_vector = -10;
dialogue_tail_end_vertical_vector = 0;
dialogue_tail_end_thickness = 0.1;

// Dialogue Triangle Settings
dialogue_triangle_angle = -15;
dialogue_triangle_radius = 4;
dialogue_triangle_offset = -2;

dialogue_triangle_rotate_range = 30;
dialogue_triangle_rotate_spd = 2;

// Dialogue Box Variables
dialogue_horizontal_offset = 0;

dialogue_box_animation_value = 0;
dialogue_box_breath_value = 0;

// Dialogue Tail Variables
dialogue_tail_end_x = 0;
dialogue_tail_end_y = 0;

dialogue_tail_start_position = 0;
dialogue_tail_end_position = 0;

// Dialogue Text Variables
dialogue_raw_value = 0;
dialogue_text_value = 0;

dialogue_word_end_positions_array = array_create(0);

// Dialogue Triangle Variables
dialogue_triangle = false;

dialogue_triangle_draw_angle = 0;

tri_x_1 = 0;
tri_y_1 = 0;
tri_x_2 = 0;
tri_y_2 = 0;
tri_x_3 = 0;
tri_y_3 = 0;

// Fade Destroy Variables
dialogue_fade = false;
dialogue_fade_timer = dialogue_fade_duration;

// Trigonometry Variables
trig_sine = 0;
trig_cosine = 1;

// Dialogue Functions
set_dialogue_text = function(text)
{
	// Set Dialogue Text
	if (is_array(text))
	{
		// Pass Dialogue Box Text Array
		var temp_dialogue_array_length = array_length(text);
		dialogue_text_array = array_create(temp_dialogue_array_length - 1);
		array_copy(dialogue_text_array, 0, text, 1, temp_dialogue_array_length - 1);
		dialogue_text = text[0];
	}
	else
	{
		// Pass Default Dialogue Text
		dialogue_text = text;
	}
	
	// Reset Dialogue World End Positions Array
	dialogue_word_end_positions_array = array_create(0);
	
	// Split Dialogue Text by Vowels and Punctuations to create the naturalistic text-speech typewriter effect
	var temp_dialogue_words_array = string_split_ext(string_lower(dialogue_text), [ "a", "e", "i", "o", "u", " ", ",", ".", "!", "?", "-" ], false);
	
	// Iterate through Dialogue Text Split Array to find their end point positions within the Dialogue Text's Full String
	var temp_dialogue_text_length = 0;
	
	for (var i = 0; i < array_length(temp_dialogue_words_array); i++)
	{
		dialogue_word_end_positions_array[i] = temp_dialogue_text_length + string_length(temp_dialogue_words_array[i]);
		temp_dialogue_text_length += string_length(temp_dialogue_words_array[i]) + 1;
	}
	
	// Set the first Dialogue Text Split Array Value to appear in Dialogue Box
	dialogue_raw_value = string_length(temp_dialogue_words_array[0]);
	dialogue_text_value = string_length(temp_dialogue_words_array[0]);
}