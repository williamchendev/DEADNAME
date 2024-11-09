/// @function		wait(duration, [offset]);
/// @param			{real}	duration
/// @param			{real}	[offset]
/// @description	Returns `false` for a specified interval, as a value of seconds, after which 
///					`true` will be returned for one frame. Repeats endlessly.
///
///					Note that this script's starting time is based on instance creation time, and 
///					will always return `true` at the same time for every instance of any object 
///					created in the same Step. Sometimes this synchronization is not desirable, in 
///					which case an optional offset time can also be supplied. Unlike the main time 
///					interval, the offset value can be either positive or negative. For example, to 
///					base starting time on game session time, use `-game_get_time()` (must be a 
///					variable declared in an event that is not run every Step).
///
/// @example		//STEP EVENT
///					if (x != xprevious) or (y != yprevious) {
///						if (wait(1)) {
///							stamina--;
///						}
///					} else {
///						if (wait(2)) {
///							stamina++;
///						}
///					}
///				
///					//LEFT MOUSE PRESSED EVENT
///					click_time = -game_get_time();
///				
///					//LEFT MOUSE DOWN EVENT
///					if (wait(0.15, click_time)) {
///						instance_create_layer(x, y, layer, obj_bullet);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function wait() {
	
	/*
	INITIALIZATION
	*/

	// Get timer ID
	var ar_temp = debug_get_callstack(),
		_timer = ar_temp[array_length(ar_temp) - 2];
		
	// Clear temporary array from memory
	ar_temp = 0;
	
	// Get timer duration
	var _dur = argument[0];

	// Initialize timer struct, if it doesn't exist
	if (is_undefined(variable_instance_get(id, "timers"))) {
		timers = {};
	}

	// Initialize new wait timer, if it doesn't exist
	if (!variable_struct_exists(timers, _timer)) {
		// Create new timer sub-struct
		variable_struct_set(timers, _timer, {});
		
		// Get timer sub-struct
		_timer = variable_struct_get(timers, _timer);
		
		// Set timer properties
		_timer.time = _dur;	// Countdown time
		
		// Return initial timer status
		return false;
	}
		
	// Get timer sub-struct
	_timer = variable_struct_get(timers, _timer);

	// Get user time offset, if any
	var _offset = 0;
	if (argument_count > 1) {
		_offset = (argument[1] mod _dur);
	}


	/*
	PERFORM WAIT TIMER
	*/
	
	// Decrement time
	_timer.time -= (delta_time*0.000001);
		
	// Reset and return `true` when interval is reached
	if ((_timer.time + _offset) <= 0) {
		_timer.time += _dur;
		return true;
	} else {
		return false;
	}
}
