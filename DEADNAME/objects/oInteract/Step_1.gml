/// @description Insert description here
// You can write your code in this editor

// Interact Behaviour
interact_destroy = true;
var temp_interact_behaviour_active = false
if (interact_obj != noone) {
	if (instance_exists(interact_obj)) {
		// Check if Interact Unit is Active
		if (interact_unit != noone) {
			if (instance_exists(interact_unit)) {
				// Interact Behaviour
				temp_interact_behaviour_active = true;
			}
			else {
				// Remove Unit
				interact_unit = noone;
			}
		}
		
		// Do not Destroy Interact
		interact_destroy = false;
	}
}

interact_action = temp_interact_behaviour_active;