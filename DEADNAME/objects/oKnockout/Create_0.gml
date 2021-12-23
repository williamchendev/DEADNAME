/// @description Knockout Init Event
// Performs the Instantiation Behaviour of the Knockout Effect

// Settings
lighting_effect = false;
if (instance_exists(oLighting)) {
	with (oLighting) {
		instance_destroy();
	}
	lighting_effect = true;
}