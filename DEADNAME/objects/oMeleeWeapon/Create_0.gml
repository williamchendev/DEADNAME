/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Weapon Settings
weapon_type = "melee";
weapon_sprite = sAluminumBat_Arc;
weapon_idle_sprite = sAluminumBat_Idle;

// Arm Settings
double_handed = true;

arm_x = noone;
arm_y = noone;

arm_x[0] = 0;
arm_y[0] = 0;
arm_x[1] = 0;
arm_y[1] = 0;

// Behaviour Settings
click = false;

move_spd = 0.4;
lerp_spd = 0.12;

weapon_arc_forward_spd = 0.8;
weapon_arc_backward_spd = 0.2;

weapon_arc_pause_time = 6;

// Combat Settings
damage = 5;

weapon_arc_continuous = false;

// Hit Effect Settings
hit_effect = true;

hit_effect_sprite = sMeleeHitEffect1;
hit_effect_duration = 6;
hit_effect_scale_min = 0.8;
hit_effect_scale_max = 0.8;
hit_effect_random_angle = -1;

// Melee Variables
x_position = x;
y_position = y;

weapon_arc_value = 0;
weapon_arc_start = false;
weapon_arc_pause = false;
weapon_arc_end = false;
weapon_arc_damage = false;
weapon_arc_pause_timer = 0;

melee_found_hit = false;

hit_effect_timer = ds_list_create();
hit_effect_index = ds_list_create();
hit_effect_sign = ds_list_create();
hit_effect_xpos = ds_list_create();
hit_effect_ypos = ds_list_create();
hit_effect_xscale = ds_list_create();
hit_effect_yscale = ds_list_create();
hit_effect_rotation = ds_list_create();

// Debug
recoil_offset_x = 0;
recoil_offset_y = 0;

recoil_angle_shift = 0;