/// @description Grenade Launcher Init

// Inherit the parent event
event_inherited();

// Sprite Settings
weapon_sprite = sGrenadeLauncher;
weapon_normal_sprite = sGrenadeLauncher_NormalMap;
break_action_sprite = sGrenadeLauncher_BreakAction;
break_action_normal_sprite = sGrenadeLauncher_BreakAction_NormalMap;

// Weapon Settings
bullets = 0;
bullets_max = 1;

// Bullet Settings
projectiles = 1;

projectile_obj = oFirearmProjectile_Explosion;

projectile_spd = 8;
projectile_gravity = 0.1;

burst = 0;
burst_delay = 0.1;

flash_delay = 9;
bullet_path_line_width = 2;

// Combat Settings
damage = 100;
material_damage_sprite = sMatDmg_Small_3;

// Hit Effect Settings
hit_effect = false;

// Position Settings
muzzle_x = 20;
muzzle_y = 3;

reload_x = 7;
reload_y = 0;

reload_offset_y = -5;

// Reload Settings
magazine_obj = noone;
reload_individual_rounds = true;

break_action = true;
break_action_angle = -40;
break_action_pivot_x = 11;
break_action_pivot_y = 4;

// Arm Settings
swap_action_hand = true;

arm_x[0] = 2;
arm_y[0] = 6;

arm_x[1] = 14;
arm_y[1] = 5;

// Bullet Case Settings
bulletcase_obj = oBulletCase_GrenadeCanister;
case_eject_x = 6;
case_eject_y = 0;
case_spd = 0.7;
case_angle_spd = 0.3;
case_direction = 30;

// Behaviour Settings
aim_spd = 0.11;
lerp_spd = 0.11;
angle_adjust_spd = 0.11;

recoil_spd = 1;
recoil_angle = 4;
recoil_direction = 15;
recoil_delay = 15;
recoil_clamp = 3;

click = true;

// Aiming Settings
sniper = true;

accuracy = 1;
accuracy_peak = 1;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 1.0;
far_range_hit_chance = 1.0;
sniper_range_hit_chance = 1.0;

// Image Settings
image_index = 0;