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
	alpha_value = lerp(alpha_value, 0, alpha_zero_lerp_spd * global.realdeltatime);
	with (oGodKingBunker_SwitchHouseFront) {
		image_alpha = power(other.alpha_value, 2);
	}
}
else {
	alpha_value = lerp(alpha_value, 1, alpha_one_lerp_spd * global.realdeltatime);
	with (oGodKingBunker_SwitchHouseFront) {
		image_alpha = power(other.alpha_value, 2);
	}
}