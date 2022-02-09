/// @description Cutscene Check
// Checks if Interaction's Cutscene object exists

// Check if Cutscene Object Exists
cutscene_exists = false;
if (cutscene_inst != noone) {
	if (instance_exists(cutscene_inst)) {
		delay_timer = 0;
		cutscene_exists = true;
	}
	else {
		cutscene_inst = noone;
	}
}

// Inherited Interact Action and Destroy Behaviour
event_inherited();