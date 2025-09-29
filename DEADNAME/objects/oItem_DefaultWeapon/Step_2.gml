/// @description Dynamic Weapon Item Instance Behaviour
// Calculates and performs the Dynamic Weapon Item Instance's Physics and Weapon Behaviour

// Update Weapon Instance's Behaviour
item_instance.update_weapon_behaviour();

// Update Weapon Instance's Physics
item_instance.update_item_physics(x, y, image_angle, item_instance.item_facing_sign);
