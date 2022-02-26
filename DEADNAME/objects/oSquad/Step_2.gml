/// @description Squad Update Event
// Performs the Squad Object's Behaviour

// Destroy Check
for (var i = ds_list_size(squad_units_list) - 1; i >= 0; i--) {
	var temp_squad_unit_inst = ds_list_find_value(squad_units_list, i);
	var temp_squad_unit_valid = false;
	if (temp_squad_unit_inst != noone) {
		if (instance_exists(temp_squad_unit_inst)) {
			if (temp_squad_unit_inst.squad_id == squad_id) {
				temp_squad_unit_valid = true;
			}
		}
	}
	if (!temp_squad_unit_valid) {
		ds_list_delete(squad_units_list, i);
	}
}

// Squad Icon Behaviour
if (ds_list_empty(squad_units_list)) {
	instance_destroy();
	return;
}
else {
	var temp_squad_unit_inst = ds_list_find_value(squad_units_list, 0);
	x = temp_squad_unit_inst.x;
	y = temp_squad_unit_inst.bbox_top - (temp_squad_unit_inst.stats_y_offset * temp_squad_unit_inst.draw_yscale);
}

// Squad Movement
if (squad_path_create) {
	// Path Target
	squad_path_create = false;
	var temp_squad_path_data = pathfind_get_closest_point(squad_path_end_x, squad_path_end_y);
	
	// Squad Units Pathing Behaviour
	for (var i = 0; i < ds_list_size(squad_units_list); i++) {
		// Determine Unit Pathing Target
		var temp_squad_path_x_offset = irandom_range(-squad_path_unit_spacing * (squad_path_unit_slots / 2), squad_path_unit_spacing * (squad_path_unit_slots / 2));
		if (i < squad_path_unit_slots) {
			temp_squad_path_x_offset = (((((i + 1) mod 2) * 2) - 1) * ((i + 1) div 2)) * squad_path_unit_spacing;
			temp_squad_path_x_offset += irandom_range(-squad_path_unit_random_spacing, squad_path_unit_random_spacing);
		}
		var temp_squad_path_new_data = pathfind_get_closest_point(squad_path_end_x + temp_squad_path_x_offset, squad_path_end_y);
		var temp_squad_path_target_x = temp_squad_path_new_data[0];
		var temp_squad_path_target_y = temp_squad_path_new_data[1];
		
		// Check New Pathing Valid
		if (temp_squad_path_data[2] != temp_squad_path_new_data[2]) {
			// Check Path Edges Connected
			var temp_squad_path_new_connected = false;
			if (temp_squad_path_data[2].nodes[0] == temp_squad_path_new_data[2].nodes[0]) {
				temp_squad_path_new_connected = true;
			}
			else if (temp_squad_path_data[2].nodes[0] == temp_squad_path_new_data[2].nodes[1]) {
				temp_squad_path_new_connected = true;
			}
			else if (temp_squad_path_data[2].nodes[1] == temp_squad_path_new_data[2].nodes[0]) {
				temp_squad_path_new_connected = true;
			}
			else if (temp_squad_path_data[2].nodes[1] == temp_squad_path_new_data[2].nodes[1]) {
				temp_squad_path_new_connected = true;
			}
			
			// Path Jump/Teleport Disqualifier
			var temp_create_new_path = false;
			if (temp_squad_path_new_connected) {
				if (!temp_squad_path_new_data[2].jump and !temp_squad_path_new_data[2].teleport) {
					temp_create_new_path = false;
				}
			}
			if (temp_create_new_path) {
				var temp_squad_path_new_new_data = pathfind_get_closest_point_edge(temp_squad_path_target_x, temp_squad_path_target_y, temp_squad_path_data[2].nodes[0], temp_squad_path_data[2].nodes[1]);
				temp_squad_path_target_x = temp_squad_path_new_new_data[0];
				temp_squad_path_target_y = temp_squad_path_new_new_data[1];
			}
		}
		
		// Create Unit Pathing
		var temp_squad_unit_inst = ds_list_find_value(squad_units_list, i);
		temp_squad_unit_inst.path_create = true;
		temp_squad_unit_inst.path_end_x = temp_squad_path_target_x;
		temp_squad_unit_inst.path_end_y = temp_squad_path_target_y;
	}
}

// Selection Behaviour
if (squad_selected) {
	squad_outline_icon = true;
	squad_select_second_outline_color = squad_selected_outline_color;
}
else {
	squad_outline_icon = false;
	squad_select_second_outline_color = squad_hover_outline_color;
}

if (squad_hover or squad_selected) {
	// Lerp Alpha to 1
	squad_select_draw_value = lerp(squad_select_draw_value, 1, global.realdeltatime * squad_select_draw_spd);
}
else {
	// Lerp Alpha to 0
	squad_select_draw_value = lerp(squad_select_draw_value, 0, global.realdeltatime * squad_select_draw_spd);
}
squad_select_draw_value = clamp(squad_select_draw_value, 0, 1);
squad_hover = false;
squad_selected = false;