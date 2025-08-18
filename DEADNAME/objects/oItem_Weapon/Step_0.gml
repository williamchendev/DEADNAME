/// @description Dynamic Weapon Item Instance Behaviour
// Calculates and performs the Dynamic Weapon Item Instance's Physics and Weapon Behaviour

// Update Weapon Instance's Behaviour
weapon_instance.update_weapon_behaviour();

// Update Weapon Instance's Physics
weapon_instance.update_weapon_physics(x, y, image_angle, weapon_instance.weapon_facing_sign);
