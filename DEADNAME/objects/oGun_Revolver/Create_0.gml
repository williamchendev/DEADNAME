/// @description Revolver Init

// Inherit the parent event
event_inherited();

// Sprite Settings
weapon_sprite = sRevolver;
weapon_normal_sprite = sRevolver_NormalMap;

// Weapon Settings
bullets = 0;
bullets_max = 3;

// Bullet Settings
projectiles = 1;

burst = 0;
burst_delay = 0.1;

flash_delay = 9;
bullet_path_line_width = 2;

// Combat Settings
damage = 3;
material_damage_sprite = sMatDmg_Small_3;

// Position Settings
muzzle_x = 21;
muzzle_y = -2;

reload_x = 12;
reload_y = -3;

reload_offset_y = -4;

// Reload Settings
reload_individual_rounds = true;
gun_spin_reload = true;
magazine_obj = noone;

// Arm Settings
swap_action_hand = false;

arm_x[0] = 8;
arm_y[0] = 2;

arm_x[1] = 8;
arm_y[1] = 2;

// Bullet Case Settings
bulletcase_obj = oBulletCase_Pistol_Small;
case_eject_x = 8;
case_eject_y = -1;
case_direction = 30;

// Behaviour Settings
aim_spd = 0.1;
lerp_spd = 0.1;
angle_adjust_spd = 0.1;

recoil_spd = 2.5;
recoil_angle = 15;
recoil_direction = 15;
recoil_delay = 7;
recoil_clamp = 7;

click = true;

// Aiming Settings
sniper = false;

accuracy = 10;
accuracy_peak = 1;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 1.0;
far_range_hit_chance = 1.0;
sniper_range_hit_chance = 1.0;