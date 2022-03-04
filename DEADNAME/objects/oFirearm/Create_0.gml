/// @description Firearm Initialization
// Creates the variables for the Firearm Object

// Inherit the parent event
event_inherited();

// Weapon Settings
weapon_type = "firearm";
weapon_ammo_id = 6;

bulletcase_obj = oBulletCase;
projectile_obj = noone;

bullets = 0;
bullets_max = 5;

close_range_radius = 100;
mid_range_radius = 220;
far_range_radius = 400;

// Sprite Settings
weapon_sprite = sArkov_ParagonRifle;
weapon_normal_sprite = sArkov_ParagonRifle_NormalMap;
muzzle_flash_sprite = sMuzzleFlash_Small;

break_action_sprite = noone;
break_action_normal_sprite = noone;

image_speed = 0;
image_index = 1;

// Bullet Settings
projectiles = 1;

projectile_spd = 5;
projectile_gravity = 0.1;

burst = 0;
burst_delay = 0.1;

flash_delay = 7;
bullet_path_line_width = 1;

// Combat Settings
damage = 1;
material_damage = 0.5;
material_damage_sprite = sMatDmg_Small_2;

// Hit Effect Settings
hit_effect = true;

hit_effect_sprite = sFirearmHitEffect1;
hit_effect_duration = 6;
hit_effect_scale_min = 0.75;
hit_effect_scale_max = 1.25;
hit_effect_random_angle = -1;

// Light Settings
light_muzzle_flash = true;
light_muzzle_flash_spd = 0.1;
light_muzzle_flash_intensity = 0.7;
light_muzzle_flash_radius = 64;
light_muzzle_flash_color = make_color_rgb(255, 185, 135);

// Position Settings
muzzle_x = 28;
muzzle_y = -2;

reload_x = 5;
reload_y = 0;
reload_offset_y = 5;

case_eject_x = 1;
case_eject_y = 1;
case_spd = 0.5;
case_angle_spd = 2;
case_direction = 90;

// Reload Settings
magazine_obj = noone;
reload_individual_rounds = false;

bolt_action = false;
break_action = false;
gun_spin_reload = false;

bolt_action_start_x = 0;
bolt_action_start_y = 0;

bolt_action_end_x = 0;
bolt_action_end_y = 0;

break_action_angle = 0;

break_action_pivot_x = 0;
break_action_pivot_y = 0;

// Arm Settings
swap_action_hand = false;

arm_x = noone;
arm_y = noone;
arm_x[0] = 0;
arm_y[0] = 0;

// Behaviour Settings
move_spd = 0.4;

aim_spd = 0.04;
lerp_spd = 0.12;
angle_adjust_spd = 0.1;

recoil_spd = 0.66;
recoil_angle = 4;
recoil_direction = 6;
recoil_delay = 4.6;
recoil_clamp = 16;

gun_spin_spd = 0.07;
gun_spin_reload_spin_times = 3;

click = true;

player_mode = false;

// Aiming Settings
sniper = true;

range = 800;
accuracy = 120;
accuracy_peak = 0.1;

close_range_hit_chance = 1.0;
mid_range_hit_chance = 1.0;
far_range_hit_chance = 1.0;
sniper_range_hit_chance = 1.0;

projectile_trajectory_distance_index = 5;
projectile_trajectory_distance_limit = 2000;

projectile_trajectory_aim_reticle_spd = 1.1;
projectile_trajectory_aim_reticle_width = 2;
projectile_trajectory_aim_reticle_height = 12;
projectile_trajectory_aim_reticle_space = 6;

// Sound Settings
silent = false;
//sound_radius = 360;
sound_radius = 480;

// Firearm Variables
x_position = x;
y_position = y;

recoil_offset_x = 0;
recoil_offset_y = 0;

aim_hip_max = 0;

recoil_timer = 0;
recoil_velocity = 0;
recoil_angle_shift = 0;
recoil_position_direction = 0;

bursts = 0;
bursts_timer = 0;
bullet_cases = 0;

bolt_action_loaded = false;

ignore_id = "unassigned";

// Draw Variables
flash_timer = ds_list_create();
flash_length = ds_list_create();
flash_direction = ds_list_create();
flash_xposition = ds_list_create();
flash_yposition = ds_list_create();

flash_imageindex = ds_list_create();

hit_effect_timer = ds_list_create();
hit_effect_index = ds_list_create();
hit_effect_sign = ds_list_create();
hit_effect_xpos = ds_list_create();
hit_effect_ypos = ds_list_create();
hit_effect_xscale = ds_list_create();
hit_effect_yscale = ds_list_create();
hit_effect_rotation = ds_list_create();

light_muzzle_flash_inst = noone;

projectile_obj_x_trajectory = ds_list_create();
projectile_obj_y_trajectory = ds_list_create();
projectile_trajectory_distance = 0;
projectile_trajectory_draw_val = 0;

knockout_hit_effect_index = -1;
knockout_hit_effect_offset = 0;
knockout_hit_effect_xscale = 1;
knockout_hit_effect_yscale = 1;
knockout_hit_effect_sign = 1;

gun_spin = false;
gun_spin_angle = 0;
gun_spin_timer = 0;

break_action_angle_val = 0;

draw_gun_effects = false;

// Collider Variables
collider_array_hit = noone;
collider_array_hit[0] = oUnit;
collider_array_hit[1] = oMaterial;

// Shader Variables
vectortransform_shader_angle = shader_get_uniform(shd_vectortransform, "vectorAngle");
vectortransform_shader_scale = shader_get_uniform(shd_vectortransform, "vectorScale");