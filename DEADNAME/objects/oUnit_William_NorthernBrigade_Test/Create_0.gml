/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Physics Settings
spd = 3; // Running Speed
walk_spd = 1; // Walk Speed

jump_spd = 1.3; // Jumping Speed
double_jump_spd = 2.5; // Double Jumping Speed
hold_jump_spd = 0.45; // Added Jump Speed when the Jump Button is held
jump_decay = 0.81; // Decay of the Jumping Upwards Velocity

grav_spd = 0.028; // Force of Downward Gravity
grav_multiplier = 0.97; // Dampening Multiplyer of the Downward Velocity (Makes gravity smoother)
max_grav_spd = 4; // Max Speed of Unit's Downward Velocity

slope_tolerance = 3; // Tolerance for walking up slopes in pixels
slope_angle_lerp_spd = 0.1; // Speed to lerp the angle to the slope the player is standing on

// Beahviour Settings
canmove = true;

team_id = "player";

health_show = true;
health_points = 12;
max_health_points = 12;

can_die = true;

// Animation Settings
idle_animation = sWilliam_Knives_Idle;
walk_animation = sWilliam_Knives_Run;
jump_animation = sWilliam_Knives_Jump;
aim_animation = sWilliam_Knives_Aim;
aim_walk_animation = sWilliam_Knives_AimWalk;

idle_normals = sWilliam_Knives_Idle_NormalMap;
walk_normals = sWilliam_Knives_Run_NormalMap;
jump_normals = sWilliam_Knives_Jump_NormalMap;
aim_normals = sWilliam_Knives_Aim_NormalMap;
aim_walk_normals = sWilliam_Knives_AimWalk_NormalMap;

animation_spd = 0.18;
action_spd = 0.18;
squash_stretch = 0.3;
scale_reset_spd = 0.15;

stats_y_offset = 8;

knockout = true;

// Ragdoll Settings
ragdoll = true;
ragdoll_head_sprite = sWilliam_NorthernBrigade_Soldat_Head;
ragdoll_arm_left_sprite = sWilliam_NorthernBrigade_Arms;
ragdoll_arm_right_sprite = sWilliam_NorthernBrigade_Arms;
ragdoll_chest_top_sprite = sWilliam_NorthernBrigade_Soldat_ChestTop;
ragdoll_chest_bot_sprite = sWilliam_NorthernBrigade_Soldat_ChestBot;
ragdoll_leg_left_sprite = sWilliam_NorthernBrigade_LeftLeg;
ragdoll_leg_right_sprite = sWilliam_NorthernBrigade_RightLeg;
ragdoll_head_normalmap = sWilliam_NorthernBrigade_Soldat_Head_NormalMap;
ragdoll_arm_left_normalmap = sWilliam_NorthernBrigade_Arms_NormalMap;
ragdoll_arm_right_normalmap = sWilliam_NorthernBrigade_Arms_NormalMap;
ragdoll_chest_top_normalmap = sWilliam_NorthernBrigade_Soldat_ChestTop_NormalMap;
ragdoll_chest_bot_normalmap = sWilliam_NorthernBrigade_Soldat_ChestBot_NormalMap;
ragdoll_leg_left_normalmap = sWilliam_NorthernBrigade_LeftLeg_NormalMap;
ragdoll_leg_right_normalmap = sWilliam_NorthernBrigade_RightLeg_NormalMap;

// Sight Settings
sight = true;

alert = 0;
alert_spd = 0.005;
alert_threshold = 0.8;

sight_origin_x = 0;
sight_origin_y = -40;

sight_unalert_radius = 280;
sight_unalert_arc = 15;

sight_alert_radius = 340;
sight_alert_arc = 30;

// Pathfinding Settings
path_x_delta_tolerance = 3;
path_increment_index_radius = 5;

// Combat Variables
target_x = 0;
target_y = 0;
targeting = false;

target_aim_threshold = 0.85;

// Squad Variables
squad_aim = false;
squad_key_fire_press = false;
squad_key_aim_press = false;

// Weapon Settings
weapon_hip_x = -4;
weapon_hip_y = -28;

weapon_aim_x = 5;
weapon_aim_y = -38;

inventory_x = -6;
inventory_y = -21;

weapon_holster_ambient_move_size = 2;

// Limb Settings
limbs = 2;

limb_x[0] = -5;
limb_y[0] = -34;
limb_angle[0] = -5;

limb_x[1] = 5;
limb_y[1] = -34;
limb_angle[1] = 18;

limb_ambient_idle_rotate_radius = 1;
limb_ambient_idle_length_offset = 0.1;

limb_ambient_move_width = 5;
limb_ambient_move_height = 7;
limb_ambient_move_angle_offset = 20;
limb_ambient_move_length_offset = 0.5;

limb_aim_move_offset_x = 0;
limb_aim_offset_y = -1;

limb_sprite[0] = sWilliam_Knives_Arms;  // Right Arm
limb_sprite[1] = sWilliam_Knives_Arms;  // Left Arm

limb_normal_sprite[0] = sWilliam_Knives_Arms_NormalMap;  // Right Arm
limb_normal_sprite[1] = sWilliam_Knives_Arms_NormalMap;  // Left Arm

// Inventory Settings
add_item_inventory(inventory, 18);
add_item_inventory(inventory, 19, 20);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;

// Player Settings
player_input = true;
ai_behaviour = false;
camera_follow = true;

// Crunch Settings
crunch_weapon_move_spd = 0.6;
crunch_weapon_move_range = 4;
crunch_weapon_recoil_resist = 0.7;

// Crunch Variables
crunch = false;
crunch_player_input = false;
crunch_x = 0;
crunch_y = 0;
crunch_bursts = 0;
crunch_weapon_move_timer = 0;

// Screen Shake Variables
screen_shake_shots = 0;

// Debug
//can_die = true;
camera_debug_gif_mode = false;