/// @description Squad Update Event
// Performs the Squad Object's Behaviour

// Squad Sprite
sprite_index = squad_icon_sprite;

// Squad Unit Behaviour
for (var i = ds_list_size(squad_units_list) - 1; i >= 0; i--) {
	// Find Unit
	var temp_squad_unit_inst = ds_list_find_value(squad_units_list, i);
	var temp_squad_unit_valid = false;
	if (temp_squad_unit_inst != noone) {
		if (instance_exists(temp_squad_unit_inst)) {
			if (temp_squad_unit_inst.squad_id == squad_id) {
				// Determine Unit Valid
				temp_squad_unit_valid = true;
			}
		}
	}
	
	// Destroy Check
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
	team_id = temp_squad_unit_inst.team_id;
	x = temp_squad_unit_inst.x;
	y = temp_squad_unit_inst.bbox_top - (temp_squad_unit_inst.stats_y_offset * temp_squad_unit_inst.draw_yscale);
}

// Squad Movement
if (squad_path_create) {
	// Path Target
	squad_path_create = false;
	var temp_squad_path_data = pathfind_get_closest_point(squad_path_end_x, squad_path_end_y);
	var temp_squad_path_distance = point_distance(temp_squad_path_data[2].nodes[0].x, temp_squad_path_data[2].nodes[0].y, temp_squad_path_data[2].nodes[1].x, temp_squad_path_data[2].nodes[1].y);
	var temp_squad_path_edge_value = point_distance(temp_squad_path_data[2].nodes[0].x, temp_squad_path_data[2].nodes[0].y, temp_squad_path_data[0], temp_squad_path_data[1]) / temp_squad_path_distance;
	
	// Path Cover Check
	var temp_squad_cover = false;
	var temp_squad_main_cover_inst = collision_circle(temp_squad_path_data[0], temp_squad_path_data[1], squad_path_cover_check_radius, oMaterial, false, true);
	if (temp_squad_main_cover_inst != noone) {
		if (instance_exists(temp_squad_main_cover_inst)) {
			if ((temp_squad_main_cover_inst.object_index != oMaterialDoor) and (!object_is_ancestor(temp_squad_main_cover_inst.object_index, oMaterialDoor))) {
				temp_squad_cover = true;
			}
		}
	}
	
	// Squad Units Pathing Behaviour
	for (var i = 0; i < ds_list_size(squad_units_list); i++) {
		// Find Squad Unit Inst
		var temp_squad_unit_inst = ds_list_find_value(squad_units_list, i);
		
		// Determine Unit Pathing Target
		var temp_squad_path_offset_dis = irandom_range(-squad_path_unit_spacing * (squad_path_unit_slots / 2), squad_path_unit_spacing * (squad_path_unit_slots / 2));
		if (i < squad_path_unit_slots) {
			temp_squad_path_offset_dis = (((((i + 1) mod 2) * 2) - 1) * ((i + 1) div 2)) * squad_path_unit_spacing;
			temp_squad_path_offset_dis += irandom_range(-squad_path_unit_random_spacing, squad_path_unit_random_spacing);
		}
		var temp_path_edge_value = clamp(temp_squad_path_edge_value + (temp_squad_path_offset_dis / temp_squad_path_distance), 0, 1);
		var temp_squad_path_target_x = lerp(temp_squad_path_data[2].nodes[0].x, temp_squad_path_data[2].nodes[1].x, temp_path_edge_value);
		var temp_squad_path_target_y = lerp(temp_squad_path_data[2].nodes[0].y, temp_squad_path_data[2].nodes[1].y, temp_path_edge_value);
		
		// Squad Unit Cover Check
		var temp_squad_unit_cover = false;
		var temp_squad_unit_cover_inst = collision_circle(temp_squad_path_target_x, temp_squad_path_target_y, squad_path_cover_check_radius, oMaterial, false, true);
		if (temp_squad_unit_cover_inst != noone) {
			if (instance_exists(temp_squad_unit_cover_inst)) {
				if ((temp_squad_unit_cover_inst.object_index != oMaterialDoor) and (!object_is_ancestor(temp_squad_unit_cover_inst.object_index, oMaterialDoor))) {
					temp_squad_unit_cover = true;
				}
			}
		}
		
		// Squad Pathfind Cover
		if (temp_squad_cover or temp_squad_unit_cover) {
			// Set Unit Cover
			if (!temp_squad_unit_cover) {
				temp_squad_unit_cover_inst = temp_squad_main_cover_inst;
			}
			
			// Move to Cover
			var temp_squad_unit_bbox_width = sprite_get_bbox_right(temp_squad_unit_inst.sprite_index) - sprite_get_bbox_left(temp_squad_unit_inst.sprite_index);
			temp_squad_path_target_x = lerp(temp_squad_unit_cover_inst.bbox_left + (temp_squad_unit_bbox_width / 2), temp_squad_unit_cover_inst.bbox_right - (temp_squad_unit_bbox_width / 2), random(1));
			temp_squad_path_target_y = temp_squad_unit_cover_inst.y;
		}
		
		// Create Unit Pathing
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