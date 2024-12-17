/// @function		timer(name, [duration]);
/// @param			{string}	name
/// @param			{real}		[duration]
/// @description	Sets and/or counts down a timer and returns `false` until the time has 
///					expired, after which it will return `true`. (To return the actual time 
///					value, see `timer_get_time`.)
///
///					The timer ID should be a unique string value. Timers and their IDs are 
///					local to the running instance, so multiple timers can use the same ID 
///					in different instances. However, the same ID cannot be reused within a 
///					single instance. Otherwise, there is no limit on the quantity of timers 
///					that can exist at once.
///
/// @example	    if (timer("t_alarm", 3)) {
///						//Action after 3 seconds
///				    }
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer() {
	
	/*
	INITIALIZATION
	*/
	
	// Get timer id
	var _timer = argument[0];

	// Initialize timer struct, if it doesn't exist
	if (is_undefined(variable_instance_get(id, "timers"))) {
		timers = {};
	}

	// Initialize new timer, if it doesn't exist
	if (!variable_struct_exists(timers, _timer)) {
		// Create new timer sub-struct
		variable_struct_set(timers, _timer, {});
		
		// Get timer sub-struct
		_timer = variable_struct_get(timers, _timer);
		
		// Get timer duration
		var _dur = 0;
		if (argument_count > 1) {
			// Use input duration, if supplied
			_dur = argument[1];
		}
	
		// Set timer properties
		_timer.time  = _dur;	// Countdown time
		_timer.speed = 1;		// Speed multiplier
		_timer.pause = false;	// Pause state
	
		// Return initial timer status
		return false;
	}


	/*
	PERFORM TIMER
	*/
		
	// Get timer sub-struct
	_timer = variable_struct_get(timers, _timer);

	// Decrement time, if unpaused
	if (!_timer.pause) {
		// Decrement time
		if (_timer.time > 0) {
			_timer.time -= ((delta_time*0.000001)*_timer.speed);
		
			// Clamp time to zero
			if (_timer.time < 0) {
				_timer.time = 0;
			}
		}
	}

	// Return timer status
	return (_timer.time <= 0);
}
