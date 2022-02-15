/// @description Item Drop Init
// Creates the variables and settings of the Item Drop Container

// Basic Lighting and Ragdoll Behaviour
event_inherited();

// Interaction Settings
interact_description = "Take ";

interact = instance_create_layer(x, y, layer, oInteractItem);
interact.interact_obj = id;

// Destroy Settings
destroy_alpha_decay = 0.027;

// Physics
var temp_direction = random(1);
if (temp_direction <= 0.5) {
	temp_direction = -1;
}
else {
	temp_direction = 1;
}
physics_apply_local_impulse(0, 0, temp_direction * random_range(0, 15), random_range(-10, 10));
physics_apply_angular_impulse(temp_direction * random_range(0, 10));