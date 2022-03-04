/// @description Weapon Physics Toggle
// Sets the weapons to enable physics

// Inventory Destroy Event
event_inherited();

// Weapon Physics Behaviour
if (interact_inventory_obj != noone) {
	if (instance_exists(interact_inventory_obj)) {
		for (var i = 0; i < ds_list_size(interact_inventory_obj.weapons); i++) {
			var temp_weapon_inst = ds_list_find_value(interact_inventory_obj.weapons, i);
			if (!temp_weapon_inst.phy_active) {
				temp_weapon_inst.phy_active = true;
			}
		}
	}
}

// Outline Check
if (!interact_mirror_select_obj) {
	for (var i = ds_list_size(interact_inventory_obj_outline_list) - 1; i >= 0; i--) {
		var temp_outline_inst = ds_list_find_value(interact_inventory_obj_outline_list, i);
		if (temp_outline_inst != noone) {
			if (instance_exists(temp_outline_inst)) {
				// Remove Weapon from Inventory Outline
				if (temp_outline_inst.object_index == oWeapon or object_is_ancestor(temp_outline_inst.object_index, oWeapon)) {
					if (!temp_outline_inst.phy_active) {
						ds_list_delete(interact_inventory_obj_outline_list, i);
					}
				}
			}
			else {
				ds_list_delete(interact_inventory_obj_outline_list, i);
			}
		}
		else {
			ds_list_delete(interact_inventory_obj_outline_list, i);
		}
	}
}