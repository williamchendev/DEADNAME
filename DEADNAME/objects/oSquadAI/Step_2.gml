/// @description Squad AI Behaviour
// Performs the AI Behaviour of the Squad

// Inherit the parent event
event_inherited();

// AI Behaviour
if (!squad_ai_behaviour) {
	squad_alert = false;
	// Interate through Squad Units
	if (squad_units_list != -1) {
		for (var i = 0; i < ds_list_size(squad_units_list); i++) {
			var temp_squad_unit_inst = ds_list_find_value(squad_units_list, i);
			temp_squad_unit_inst.alert = 1;
		}
	}
	return;
}

// Alert Squads
if (squad_alert) {
	if (squad_units_list != -1) {
		// Interate through Squad Units
		for (var i = 0; i < ds_list_size(squad_units_list); i++) {
			var temp_squad_unit_inst = ds_list_find_value(squad_units_list, i);
			if (!temp_squad_unit_inst.sight_unit_seen) {
				temp_squad_unit_inst.sight_unit_seen = true;
				temp_squad_unit_inst.sight_unit_seen_x = squad_alert_x;
				temp_squad_unit_inst.sight_unit_seen_y = squad_alert_y;
				temp_squad_unit_inst.alert = 1;
				
				temp_squad_unit_inst.path_create = true;
				temp_squad_unit_inst.path_end_x = squad_alert_x;
				temp_squad_unit_inst.path_end_y = squad_alert_y;
			}
		}
	}
	
	// Reset Alert
	squad_alert = false;
}