/// @description Paragon Rifle Init

// Inherit the parent event
event_inherited();

// Weapon Settings
weapon_ammo_id = 10;

bullets_max = 5;

// Sprite Settings
weapon_sprite = sArkov_ParagonRifle;
weapon_normal_sprite = sArkov_ParagonRifle_NormalMap;

// Bullet Settings
projectiles = 1;

burst = 0;
burst_delay = 0.1;

flash_delay = 7;

// Combat Settings
damage = 3;
material_damage_sprite = sMatDmg_Small_2;

// Position Settings
muzzle_x = 28;
muzzle_y = -2;

reload_x = 6;
reload_y = 0;

reload_offset_y = 6;

// Reload Settings
magazine_obj = oGun_Arkov_ParagonRifle_Mag;

// Arm Settings
swap_action_hand = true;

arm_x[0] = 2;
arm_y[0] = 1;

arm_x[1] = 16;
arm_y[1] = 0;

// Bullet Case Settings
bulletcase_obj = oBulletCase_Medium;
case_eject_x = 1;
case_eject_y = -1;
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