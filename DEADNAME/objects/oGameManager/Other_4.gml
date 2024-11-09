/// @description Level Generation
// Generates the new level from the Game Manager's settings

// Game FPS Cap
game_set_speed(60, gamespeed_fps);

// Generate Level
if (generate) {
	// Set Editor Data
	init_editor_data();
	
	// Block Array Level Generation
	/*
	blocks[1] = "debug.txt";
	blocks[2] = "debug.txt";
	blocks[3] = "debug.txt";
	blocks[4] = "debug.txt";
	*/
	//generate_blocks(blocks);
	
	// Reset Editor Data
	global.editor_data = noone;
	
	// Reset Instantiated Units List
	ds_list_destroy(instantiated_units);
	instantiated_units = ds_list_create();
}

// Reset Generate Function
generate = false;

// Reset Generated Squad Counter
generated_squads = 0;

// Reset Room Speed
time_spd = 1.0;

// Init Camera