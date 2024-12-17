/// @function		game_get_step();
/// @requires		obj_server_gmlp
/// @description	Returns the number of steps that have been run for the entire current game session.
///
///					While it is not strictly required, this script will not have perfect accuracy 
///					without including `obj_server_gmlp` in the current project. The `obj_server_gmlp` 
///					object will automatically track any lost steps (i.e. dropped frames) that occur as 
///					a result of system lag, window dragging, and similar events, which will then be 
///					accounted for in this script.
///
/// @example	    if (is_even(game_get_step())) {
///						//Action on even steps
///					} else {
///						//Action on odd steps
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function game_get_step() {
	// Use more accurate timing method, if available
	if (instance_exists(asset_get_index("obj_server_gmlp"))) {
		var get_timer_current = global.ds_gmlp.time.step,
			get_timer_loss = global.ds_gmlp.time.loss;
	} else {
		// Otherwise use fallback
		var get_timer_current = get_timer(),
			get_timer_loss = 0;
	}

	// Get the current session time, adjusted for lost time
	var get_timer_adjusted = (get_timer_current - get_timer_loss);

	// Return the current Step count, converted from session time
	return floor(get_timer_adjusted/game_get_speed(gamespeed_microseconds));
}


/// @function		game_get_time([type]);
/// @param			{constant}	[type]
/// @description	Returns the number of milliseconds (`gamespeed_fps`) or microseconds 
///					(`gamespeed_microseconds`) the entire current game session has been 
///					running. If no `[type]` is specified, milliseconds will be returned 
///					by default.
///
/// @example		var hours_played = floor(game_get_time()/1000/60/60);
///					var mins_played = floor(game_get_time(gamespeed_microseconds)/1000000000/60);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function game_get_time() {
	// Get arguments
	var time = current_time;
	if (argument_count > 0) {
		if (argument[0] == gamespeed_microseconds) {
			time = get_timer();
		}
	}

	// Return the current session time in the requested format
	return time;
}
