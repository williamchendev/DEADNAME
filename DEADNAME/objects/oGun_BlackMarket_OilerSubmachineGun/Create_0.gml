/// @description Oiler Submachine Init

// Inherit the parent event
event_inherited();

// Sprite Settings
weapon_sprite = sBlackMarket_OilerSubmachineGun;
weapon_normal_sprite = sBlackMarket_OilerSubmachineGun_NormalMap;

// Weapon Settings
weapon_ammo_id = 13;

bullets = 0;
bullets_max = 16;

// Combat Settings
damage = 1;
material_damage_sprite = sMatDmg_Small_1;

// Bullet Settings
projectiles = 1;

burst = 0;
burst_delay = 2.3;

flash_delay = 7;

// Position Settings
muzzle_x = 17;
muzzle_y = 0;

reload_x = 8;
reload_y = 2;

reload_offset_y = 6;

// Reload Settings
magazine_obj = oGun_BlackMarket_OilerSubmachineGun_Mag;

// Arm Settings
swap_action_hand = true;

arm_x[0] = 2;
arm_y[0] = 3;

arm_x[1] = 12;
arm_y[1] = 1;

// Bullet Case Settings
bulletcase_obj = oBulletCase_Small;
case_eject_x = 2;
case_eject_y = -1;
case_direction = 30;

// Behaviour Settings
aim_spd = 0.08;
lerp_spd = 0.15;
angle_adjust_spd = 0.1;

recoil_spd = 2;
recoil_angle = 9;
recoil_direction = 12;
recoil_delay = 0.01;
recoil_clamp = 8;

click = false;

// Aiming Settings
sniper = true;

accuracy = 30;
accuracy_peak = 20;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 0.70;
far_range_hit_chance = 0.20;
sniper_range_hit_chance = 0.05;