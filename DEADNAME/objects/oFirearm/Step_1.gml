/// @description Gun Reset Event
// Resets properties of the Gun

// Reindexing Behaviour
event_inherited();

// Inactive Skip
if (!active) {
	return;
}

// Reset Gun Spin
gun_spin = false;