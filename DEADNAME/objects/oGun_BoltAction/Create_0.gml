/// @description Bolt Action Init

// Inherit the parent event
event_inherited();

// Sprite Settings
weapon_sprite = sBoltActionRifle;
weapon_normal_sprite = sBoltActionRifle_NormalMap;

// Bullet Settings
projectiles = 1;

burst = 0;
burst_delay = 0.1;

flash_delay = 7;
bullet_path_line_width = 2;

// Combat Settings
damage = 12;
material_damage_sprite = sMatDmg_Small_2;

// Position Settings
muzzle_x = 39;
muzzle_y = 0;

reload_x = 3;
reload_y = 0;

reload_offset_y = -8;

// Reload Settings
magazine_obj = noone;
reload_individual_rounds = true;

bolt_action = true;

bolt_action_start_x = 2;
bolt_action_start_y = -2;

bolt_action_end_x = -6;
bolt_action_end_y = -2;

// Arm Settings
swap_action_hand = true;

arm_x[0] = 3;
arm_y[0] = 3;

arm_x[1] = 19;
arm_y[1] = 2;

// Bullet Case Settings
bulletcase_obj = oBulletCase_Large;
case_eject_x = 4;
case_eject_y = -2;
case_spd = 0.7;
case_angle_spd = 0.1;
case_direction = 30;

// Behaviour Settings
aim_spd = 0.04;
lerp_spd = 0.12;
angle_adjust_spd = 0.1;

recoil_spd = 3;
recoil_angle = 10;
recoil_direction = 6;
recoil_delay = 8;
recoil_clamp = 12;

click = true;

// Aiming Settings
sniper = true;

accuracy = 10;
accuracy_peak = 1;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 1.0;
far_range_hit_chance = 1.0;
sniper_range_hit_chance = 1.0;