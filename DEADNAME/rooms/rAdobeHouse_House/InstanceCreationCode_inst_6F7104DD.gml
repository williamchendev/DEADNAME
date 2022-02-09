player_input = false;
ai_behaviour = true;
camera_follow = false;

for (var i = 0; i < ds_list_size(inventory.weapons); i++) {
	// Find Indexed Weapon
	var temp_weapon_index = ds_list_find_value(inventory.weapons, i);
	temp_weapon_index.equip = false;
}

limb_ambient_idle_length_offset = 0.2;