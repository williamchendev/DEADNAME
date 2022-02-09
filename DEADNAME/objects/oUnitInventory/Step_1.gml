/// @description Reset Inventory Event
// Resets Variables and Settings for the Inventory Behaviour

// Reset Draw Cursor
select_show_cursor = true;

// Weapons Inventory Behaviour
for (var i = ds_list_size(weapons) - 1; i >= 0; i--) {
	var temp_weapon_inst = ds_list_find_value(weapons, i);
	if (temp_weapon_inst != noone) {
		if (instance_exists(temp_weapon_inst)) {
			temp_weapon_inst.active = !hide_weapons;
		}
	}
}