/// @description Dernos Needle Rifle Init

// Inherit the parent event
event_inherited();

// Weapon Settings
weapon_ammo_id = 6;

bulletcase_obj = noone;
projectile_obj = noone;

bullets_max = 1;

// Sprite Settings
weapon_sprite = sArkov_DernosNeedleRifle;
weapon_normal_sprite = sArkov_DernosNeedleRifle_NormalMap;

image_index = 0;

// Bullet Settings
projectiles = 1;

burst = 0;
burst_delay = 0.1;

flash_delay = 7;
bullet_path_line_width = 1;

// Combat Settings
damage = 3;
material_damage_sprite = sMatDmg_Small_2;

// Position Settings
muzzle_x = 29;
muzzle_y = -1;

reload_x = 5;
reload_y = 0;

reload_offset_y = -9;

// Reload Settings
magazine_obj = noone;
reload_individual_rounds = false;

bolt_action = true;

bolt_action_start_x = 3;
bolt_action_start_y = 3;

bolt_action_end_x = -1;
bolt_action_end_y = -1;

// Arm Settings
swap_action_hand = true;

arm_x[0] = 4;
arm_y[0] = 3;

arm_x[1] = 17;
arm_y[1] = 3;

// Bullet Case Settings
bulletcase_obj = noone;
case_eject_x = 6;
case_eject_y = -1;
case_spd = 0.45;
case_angle_spd = 0.1;
case_direction = 30;

// Behaviour Settings
aim_spd = 0.04;
lerp_spd = 0.12;
angle_adjust_spd = 0.1;

recoil_spd = 0.66;
recoil_angle = 8;
recoil_direction = 6;
recoil_delay = 6.6;
recoil_clamp = 6;

click = true;

// Aiming Settings
sniper = true;

accuracy = 10;
accuracy_peak = 1;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 0.7;
far_range_hit_chance = 0.4;
sniper_range_hit_chance = 0.1;