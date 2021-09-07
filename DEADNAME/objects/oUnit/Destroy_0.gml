/// @description Unit Destroy Event
// Cleans up the variables and DS Structures of the Unit on the Unit's Destroy Event

// Clear Unit Layers
for (var l = array_length_1d(layers) - 1; l >= 0; l--) {
	layer_destroy(layers[l]);
}