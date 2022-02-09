/// @description Action & Destroy
// Calculates the Interaction's Behaviour

// Interact Behaviour
interact_destroy = true;
interact_action = false;
if (interact_obj != noone) {
	if (instance_exists(interact_obj)) {
		// Check if Interact Unit is Active
		if (interact_unit != noone) {
			if (instance_exists(interact_unit)) {
				// Perform Interact Behaviour
				interact_action = true;
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