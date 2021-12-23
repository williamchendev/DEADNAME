/// @description Weapon Update
// Calculates the behaviour of the weapon object

// Weapon Physics
if (phy_active) {
	x_position = x;
	y_position = y;
	weapon_rotation = image_angle;
}

// Click Check
if (click) {
	var temp_attack = attack;
	if (click_old) {
		attack = false;
	}
	click_old = temp_attack;
}