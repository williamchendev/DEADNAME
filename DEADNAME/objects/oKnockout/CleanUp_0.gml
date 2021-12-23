/// @description Knockout Clean Up Event
// Performs the Clean Up Behaviour of the Knockout Effect

// Recreate Lighting
if (lighting_effect) {
	instance_create_layer(0, 0, layer_get_id("Instances"), oLighting);
}