/// @description Cutscene Init Event
// Creates the Properties and Settings of the Cutscene Object

// Disable Object Rendering
visible = false;
sprite_index = -1;

// Cutscene Events
cutscene_events = array_create(0);

cutscene_add_delay(id, 180);
cutscene_add_dialogue(id, "We found contraband materials in the depths of the temple.", "Mel", -20);
cutscene_add_dialogue(id, "It seems our friend's little story is a bit...", "Mel", -20);
cutscene_add_dialogue(id, "Fake?", "Charn", 20);
cutscene_add_dialogue(id, "Yeah", "Mel", -20);
cutscene_add_dialogue_clear(id);
cutscene_add_dialogue(id, "Very well, I'll alert the crews for the evacuation and removal of the temple.", "Charn", 20);
cutscene_add_dialogue(id, "I think I should mention this now... this is not a normal temple.", "Mel", -20);
cutscene_add_dialogue(id, "The lower levels are some kind of bunker, loaded to the brim with weapons.", "Mel", -20);
cutscene_add_dialogue(id, "What kind of weapons?", "Charn", 20);
cutscene_add_dialogue_clear(id);
cutscene_add_dialogue(id, "The crews that returned found marked vials of the disease, weaponized rot.", "Mel", -20);
cutscene_add_dialogue_clear(id);
cutscene_add_dialogue(id, ". . .", "Charn", 20);
cutscene_add_dialogue_clear(id);
cutscene_add_dialogue(id, "This is... terrible.", "Charn", 20);
cutscene_add_dialogue(id, "Evacuate the city, I want all medical personnel working on this round the clock.", "Charn", 20);
cutscene_add_dialogue(id, "Of course.", "Mel", -20);
cutscene_add_dialogue(id, "Message the Director, we need to see if the origin of the bunker is of a divine nature.", "Charn", 20);
cutscene_add_dialogue_clear(id);
cutscene_add_dialogue(id, ". . .", "Mel", -20);
cutscene_add_dialogue_clear(id);
cutscene_add_dialogue(id, "Divine?", "Mel", -20);

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

// Trigonometry Variables
trig_cosine = 1;
trig_sine = 0;

// Check if Cutscene should be played
if (play_cutscene_on_create)
{
	cutscene_continue_event(id);
}
