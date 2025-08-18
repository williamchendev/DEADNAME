/// @description Cutscene Init Event
// Creates the Properties and Settings of the Cutscene Object

// Disable Object Rendering
visible = false;
sprite_index = -1;

// Cutscene Events
cutscene_events = array_create(0);
cutscene_add_delay(id, 1);

// Create Cutscene
cutscene_add_dialogue(id, "Wow did you get the idea for this from Minecraft", "Charn", -20);
cutscene_add_dialogue(id, "No", "Player", -20);

// Cutscene Settings
cutscene_active = false;
cutscene_event_index = -1;

cutscene_dialogue_box = noone;
cutscene_dialogue_boxes = ds_list_create();

cutscene_units = ds_list_create();

// Dialogue Settings
dialogue_fade_delay_offset = 4;
dialogue_box_animation_offset = -0.25;

// Cutscene Variables
cutscene_waiting_behaviour = false;

cutscene_waiting_for_delay_duration = false;
cutscene_waiting_for_dialogue_boxes_to_deinstantiate_to_continue = false;

cutscene_delay_timer = 0;

cutscene_waiting_for_units_to_finish_moving = false;
cutscene_moving_units_list = ds_list_create();

cutscene_ended = false;

// Trigonometry Variables
trig_cosine = 1;
trig_sine = 0;

// Check if Cutscene should be played
if (play_cutscene_on_create)
{
	cutscene_continue_event(id);
}
