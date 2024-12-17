/// @function		timer_get_time(name, [instance]);
/// @param			{string}	name
/// @param			{instance}	[instance]
/// @description	Returns the time remaining for the timer running in the current or 
///					specified instance, as a value of seconds. If the instance or timer 
///					does not exist, -1 will be returned instead.
///
/// @example		var inst_streetlight = instance_find(obj_streetlight, 0);
///				    var race_started = (timer_get_time("t_streetlight", inst_streetlight) == 0);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer_get_time() {
	// Get timer id
	var _timer = argument[0];
	
	// Get instance to check for timer
	var _inst = id;
	if (argument_count > 1) {
		_inst = argument[1];
	}

	// Return current time, if timer exists
	if (variable_instance_exists(_inst, "timers")) {
		if (is_struct(_inst.timers)) {
			// Get timer sub-struct
			_timer = variable_struct_get(_inst.timers, _timer);
		
			// Return time remaining
			return _timer.time;
		}
	}

	// Otherwise return -1 if instance or timer could not be found
	return -1;
}


/// @function		timer_get_pause(name, [instance]);
/// @param			{string}	name
/// @param			{instance}	[instance]
/// @description	Returns the pause state for the timer running in the current or specified
///					instance. If the instance or timer does not exist, `true` will be returned,
///					as the timer is not running.
///
/// @example		if (timer_get_pause("my_timer")) {
///						timer_set_time("my_timer", 5);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer_get_pause() {
	// Get timer id
	var _timer = argument[0];
	
	// Get instance to check for timer
	var _inst = id;
	if (argument_count > 1) {
		_inst = argument[1];
	}
	
	// Return current pause state, if timer exists
	if (variable_instance_exists(_inst, "timers")) {
		if (is_struct(_inst.timers)) {
			// Get timer sub-struct
			_timer = variable_struct_get(_inst.timers, _timer);
		
			// Return pause state
			return _timer.time;
		}
	}

	// Otherwise return `true` if instance or timer could not be found
	return true;
}


/// @function		timer_get_speed(name, [instance]);
/// @param			{string}	name
/// @param			{instance}	[instance]
/// @description	Returns the speed multiplier for the timer running in the current or 
///					specified instance, where a value of 1 is real time. If the instance 
///					or timer does not exist, 0 will be returned instead.
///
/// @example		var my_timer_speed = timer_get_speed("my_timer");
///	
///					my_timer_speed += (3 - my_timer_speed)*0.25;
///	
///					timer_set_speed("my_timer", my_timer_speed);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function timer_get_speed() {
	// Get timer id
	var _timer = argument[0];
	
	// Get instance to check for timer
	var _inst = id;
	if (argument_count > 1) {
		_inst = argument[1];
	}
	
	// Return current speed multiplier, if timer exists
	if (variable_instance_exists(_inst, "timers")) {
		if (is_struct(_inst.timers)) {
			// Get timer sub-struct
			_timer = variable_struct_get(_inst.timers, _timer);
		
			// Return pause state
			return _timer.speed;
		}
	}

	// Otherwise return 0 if instance or timer could not be found
	return 0;
}
