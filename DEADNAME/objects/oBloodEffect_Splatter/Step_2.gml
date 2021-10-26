/// @description Blood Update Event
// Calculates the behaviour of the Blood Effect for Splatters

// Blood Sticker Behaviour
if (corpse_inst != noone) {
	// Corpse Effect Lock On
	if (instance_exists(corpse_inst)) {
		// Blood on Corpse Positioning
		var temp_blood_offset_x = blood_x;
		var temp_blood_offset_y = blood_y;
		
		var temp_blood_angle = point_direction(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		var temp_blood_distance = point_distance(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		x = round(corpse_inst.x - lengthdir_x(temp_blood_distance, temp_blood_angle + corpse_inst.image_angle));
		y = round(corpse_inst.y - lengthdir_y(temp_blood_distance, temp_blood_angle + corpse_inst.image_angle));
	}
}
else if (unit_inst != noone) {
	// Unit Effect Lock On
	if (instance_exists(unit_inst)) {
		// Find Blood Offset
		var temp_blood_offset_x = blood_x;
		var temp_blood_offset_y = blood_y;
		
		// Find Blood Position
		var temp_blood_angle = point_direction(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		var temp_blood_distance = point_distance(0, 0, temp_blood_offset_x, temp_blood_offset_y);
		x = round(unit_inst.x - lengthdir_x(temp_blood_distance, temp_blood_angle + unit_inst.draw_angle));
		y = round(unit_inst.y - lengthdir_y(temp_blood_distance, temp_blood_angle + unit_inst.draw_angle));
	}
}

// Blood Timer Behaviour
blood_timer -= global.deltatime;
if (blood_timer < 0) {
	blood_timer = 0;
	instance_destroy();
}

// Blood Draw Effects
image_xscale = 0.5;
image_yscale = 0.5;
image_xscale += min(((blood_duration - blood_timer) / blood_duration), 0.75);
image_yscale += min(((blood_duration - blood_timer) / blood_duration), 0.75);
image_xscale *= blood_size;
image_yscale *= blood_size;