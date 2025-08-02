/// @description Dynamic Weapon Item Instance Behaviour
// Calculates and performs the Dynamic Weapon Item Instance's Physics and Weapon Behaviour

//
sprite_index = weapon_instance.weapon_sprite;
image_index = weapon_instance.weapon_image_index;
		
//
weapon_instance.update_weapon_behaviour();

//
weapon_instance.update_weapon_physics(x, y, image_angle, weapon_instance.weapon_facing_sign);
