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