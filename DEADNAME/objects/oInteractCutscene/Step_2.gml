/// @description Cutscene Behaviour
// Creates the cutscene of the Interaction and calculates behaviour

// Check if other Interact Cutscene is Active
cutscene_other_exists = false;
for (var i = 0; i < instance_number(oInteractCutscene); i++) {
	var temp_cutscene_inst = instance_find(oInteractCutscene, i);
	if (temp_cutscene_inst.cutscene_exists) {
		cutscene_other_exists = true;
		break;
	}
}

// Inherit the parent event
event_inherited();

// Cutscene Interact Action
if (!cutscene_exists and !cutscene_other_exists) {
	// Delay Timer
	delay_timer = lerp(delay_timer, 1, delay_timer_spd * global.realdeltatime);
	
	// Create Cutscene
	if (delay_timer >= 1) {
		if (interact_action) {
			cutscene_inst = instance_create_layer(x, y, layer, oCutscene);
			cutscene_inst.file_name = file_name;
			with (cutscene_inst) {
				event_perform(ev_create, 0);
			}
		
			// Reset Interact Behaviour
			interact_action = false;
			interact_unit = noone;
		}
	}
	else {
		// Prevent Selection
		interact_unit = noone;
		interact_action = false;
		interact_select = false;
		interact_select_draw_value = 0;
	}
}
else {
	// Prevent Selection
	interact_unit = noone;
	interact_action = false;
	interact_select = false;
	interact_select_draw_value = 0;
}