/// @function		timer_set_time(name, duration, [instance]);
/// @param			{string}	name
/// @param			{real}		duration
/// @param			{instance}	[instance]
/// @description	Overrides the current time in the specified timer, restarting the countdown process.
///					If the timer does not exist, it will be created, but not countdown. An exception to
///					this rule applies if the keyword `all` is supplied in place of a timer name, in which
///					case only existing timers will be modified.
///
///					Note that if this script is run in an event that is executed every frame (e.g. Step),
///					the timer will be unable to countdown! If this is required, use an 'if' statement to
///					only set the timer under certain conditions.
///
/// @example		timer_set_time("t_alarm", 5);
///				    timer_set_time("t_other", 5, my_other_inst);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer_set_time() {
	// Get timer properties
	var _timer = argument[0],
		_dur = argument[1];
	
	// Get instance to check for timer
	var _inst = id;
	if (argument_count > 2) {
		_inst = argument[2];
	}
	
	// Modify the specified instance
	if (instance_exists(_inst)) {
		with (_inst) {

			// Single timer
			if (is_string(_timer)) {
				// Initialize timer struct, if it doesn't exist
				if (is_undefined(variable_instance_get(id, "timers"))) {
					variable_instance_set(id, "timers", {});
				}
		
				// Initialize new timer, if it doesn't exist
				if (!variable_struct_exists(timers, _timer)) {
					// Create new timer sub-struct
					variable_struct_set(timers, _timer, {});
			
					// Get timer sub-struct
					_timer = variable_struct_get(timers, _timer);
			
					// Set timer properties
					_timer.time  = _dur;	// Countdown time
					_timer.speed = 1;		// Speed multiplier
					_timer.pause = false;	// Pause state
				} else {
					// Otherwise get timer sub-struct
					_timer = variable_struct_get(timers, _timer);

					// Set new timer duration
					_timer.time  = _dur;
				}
	
			// All timers
			} else {
				// If timers exist in the instance...
				if (!is_undefined(variable_instance_get(id, "timers"))) {
					// Get all timers to modify
					var ar_temp = variable_struct_get_names(timers);
				
					// Set new timer duration for each timer in the instance
					for (var aindex = 0; aindex < array_length(ar_temp); aindex++) {
						// Get timer sub-struct
						_timer = variable_struct_get(timers, ar_temp[aindex]);
					
						// Set new timer duration
						_timer.time  = _dur;
					}
						
					// Clear temp struct data from memory
					ar_temp = 0;
				}
			}
		}
	}
}


/// @function		timer_set_pause(name, enable, [instance]);
/// @param			{string}	name
/// @param			{boolean}	enable
/// @param			{instance}	[instance]
/// @description	Pauses or unpauses the specified timer. Can also toggle pause state if `other`
///					is supplied instead of `true` or `false`.
///
/// @example		timer_set_pause("t_alarm", other);
///					timer_set_pause(all, true, my_other_inst);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer_set_pause() {
	// Get timer properties
	var _timer = argument[0],
		_pause = argument[1];
	
	// Get instance to check for timer
	var _inst = id;
	if (argument_count > 2) {
		_inst = argument[2];
	}
	
	// Modify the specified instance
	if (!is_undefined(variable_instance_get(_inst, "timers"))) {
		with (_inst) {

			// Single timer
			if (is_string(_timer)) {
				if (variable_struct_exists(timers, _timer)) {
					// Get timer sub-struct
					_timer = variable_struct_get(timers, _timer);
						
					// Toggle pause state, if 'other'
					if (_pause == other) {
						_pause = !_timer.pause;
					}
	
					// Set timer pause state
					_timer.pause = _pause;
				}
	
			// All timers
			} else {
				// Get all timers to modify
				var ar_temp = variable_struct_get_names(timers);
					
				// Set pause state for each timer in the instance
				for (var aindex = 0; aindex < array_length(ar_temp); aindex++) {
					// Get timer sub-struct
					_timer = variable_struct_get(timers, ar_temp[aindex]);
						
					// Toggle pause state, if 'other'
					if (_pause == other) {
						_pause = !_timer.pause;
					}
	
					// Set timer pause state
					_timer.pause = _pause;
				}
						
				// Clear temp struct data from memory
				ar_temp = 0;
			}
		}
	}
}


/// @function		timer_set_speed(name, speed, [instance]);
/// @param			{string}	name
/// @param			{real}		speed
/// @param			{instance}	[instance]
/// @description	Sets the speed multiplier for the specified timer, increasing or decreasing the
///					countdown rate. The default value of 1 equals real time.
///
/// @example		timer_set_speed("t_alarm", 0.5);
///					timer_set_speed(all, 1, my_other_inst);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer_set_speed() {
	// Get timer properties
	var _timer = argument[0],
		_speed = argument[1];
	
	// Get instance to check for timer
	var _inst = id;
	if (argument_count > 2) {
		_inst = argument[2];
	}
	
	// Modify the specified instance
	if (!is_undefined(variable_instance_get(_inst, "timers"))) {
		with (_inst) {

			// Single timer
			if (is_string(_timer)) {
				if (variable_struct_exists(timers, _timer)) {
					// Get timer sub-struct
					_timer = variable_struct_get(timers, _timer);
					
					// Set timer speed multiplier
					_timer.speed = _speed;
				}
	
			// All timers
			} else {
				// Get all timers to modify
				var ar_temp = variable_struct_get_names(timers);
				
				// Set speed multiplier for each timer in the instance
				for (var aindex = 0; aindex < array_length(ar_temp); aindex++) {
					// Get timer sub-struct
					_timer = variable_struct_get(timers, ar_temp[aindex]);
					
					// Set timer speed multiplier
					_timer.speed = _speed;
				}
						
				// Clear temp struct data from memory
				ar_temp = 0;
			}
		}
	}
}
