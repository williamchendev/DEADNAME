/// @description Shotgun Init

// Inherit the parent event
event_inherited();

// Weapon Settings
weapon_ammo_id = 19;

bullets_max = 6;

// Sprite Settings
weapon_sprite = sArkov_DevotionShotgun;
weapon_normal_sprite = sArkov_DevotionShotgun_NormalMap;

// Bullet Settings
projectiles = 5;

burst = 0;
burst_delay = 0.1;

flash_delay = 9;

// Combat Settings
damage = 1;
material_damage_sprite = sMatDmg_Small_3;

// Position Settings
muzzle_x = 23;
muzzle_y = -2;

reload_x = 7;
reload_y = -1;

reload_offset_y = 8;

// Reload Settings
reload_individual_rounds = true;
magazine_obj = noone;

// Arm Settings
swap_action_hand = true;

arm_x[0] = 3;
arm_y[0] = 2;

arm_x[1] = 14;
arm_y[1] = 2;

// Bullet Case Settings
bulletcase_obj = oBulletCase_Shotgun_Medium;
case_eject_x = 8;
case_eject_y = -1;
case_direction = 30;

// Behaviour Settings
aim_spd = 0.1;
lerp_spd = 0.15;
angle_adjust_spd = 0.1;

recoil_spd = 2.5;
recoil_angle = 15;
recoil_direction = 15;
recoil_delay = 7;
recoil_clamp = 7;

click = true;

// Aiming Settings
sniper = true;

accuracy = 35;
accuracy_peak = 30;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 0.80;
far_range_hit_chance = 0.10;
sniper_range_hit_chance = 0.02;