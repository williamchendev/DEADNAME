/// @description Adobe House Update
// Calculates the behaviour of the Adobe House

// Player Check
var temp_unit_exists = false;
var temp_unit_list = ds_list_create();
var temp_unit_number = instance_place_list(floor(x), floor(y), oUnit, temp_unit_list, false);
for (var i = 0; i < temp_unit_number; i++) {
	var temp_unit_inst = ds_list_find_value(temp_unit_list, i);
	if (temp_unit_inst.player_input) {
		temp_unit_exists = true;
		break;
	}
}

// Alpha Behaviour
if (temp_unit_exists) {
	alpha_value = lerp(alpha_value, 0, alpha_lerp_spd * global.realdeltatime);
	with (oAdobeHouse_FrontPassthrough) {
		normals_image_index = 2;
	}
	with (oAdobeHouse_Door) {
		normals_image_index = 2;
	}
}
else {
	alpha_value = lerp(alpha_value, 1, alpha_lerp_spd * global.realdeltatime);
	with (oAdobeHouse_FrontPassthrough) {
		normals_image_index = 1;
	}
	with (oAdobeHouse_Door) {
		normals_image_index = 1;
	}
}

// House Parts
image_alpha = alpha_value;
var temp_front_list = noone;
temp_front_list[0] = oAdobeHouse_FrontPassthrough;
temp_front_list[1] = oAdobeHouse_Door;
temp_front_list[2] = oAdobeHouse_Ladder;
for (var i = 0; i < 3; i++) {
	var temp_front = instance_find(temp_front_list[i], 0);
	if (temp_front != noone) {
		if (instance_exists(temp_front)) {
			temp_front.image_alpha = power(alpha_value, 3);
		}
	}
}