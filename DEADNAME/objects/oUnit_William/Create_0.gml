/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Animation Settings
idle_animation = sWilliam_Idle;
walk_animation = sWilliam_Run;
jump_animation = sWilliam_Jump;
aim_animation = sWilliam_Aim;
aim_walk_animation = sWilliam_Aim_Walk;
hurt_animation = sWilliam_Hurt;

idle_normals = sWilliam_Idle_NormalMap;
walk_normals = sWilliam_Run_NormalMap;
jump_normals = sWilliam_Jump_NormalMap;
aim_normals = sWilliam_Aim_NormalMap;
aim_walk_normals = sWilliam_AimWalk_NormalMap;

limb_sprite[0] = sWilliam_Arms;
limb_sprite[1] = sWilliam_Arms;

limb_normal_sprite[0] = sWilliam_Arms_NormalMap;
limb_normal_sprite[1] = sWilliam_Arms_NormalMap;

// Ragdoll Settings
ragdoll = true;
ragdoll_head_sprite = sWilliam_Head;
ragdoll_arm_left_sprite = sWilliam_Arms;
ragdoll_arm_right_sprite = sWilliam_Arms;
ragdoll_chest_top_sprite = sWilliamDS_ChestTop;
ragdoll_chest_bot_sprite = sWilliamDS_ChestBot;
ragdoll_leg_left_sprite = sWilliamDS_LeftLeg;
ragdoll_leg_right_sprite = sWilliamDS_RightLeg;
ragdoll_head_normalmap = sWilliam_Head_NormalMap;
ragdoll_arm_left_normalmap = sWilliam_Arms_NormalMap;
ragdoll_arm_right_normalmap = sWilliam_Arms_NormalMap;
ragdoll_chest_top_normalmap = sWilliamDS_ChestTop_NormalMap;
ragdoll_chest_bot_normalmap = sWilliamDS_ChestBot_NormalMap;
ragdoll_leg_left_normalmap = sWilliamDS_LeftLeg_NormalMap;
ragdoll_leg_right_normalmap = sWilliamDS_RightLeg_NormalMap;

// Physics Settings
spd = 4; // Running Speed
walk_spd = 2; // Walk Speed

jump_spd = 2; // Jumping Speed
double_jump_spd = 3.6; // Double Jumping Seed
hold_jump_spd = 0.45; // Added Jump Speed when the Jump Button is held
jump_decay = 0.81; // Decay of the Jumping Upwards Velocity

grav_spd = 0.028; // Force of Downward Gravity
grav_multiplier = 0.97; // Dampening Multiplyer of the Downward Velocity (Makes gravity smoother)
max_grav_spd = 4; // Max Speed of Unit's Downward Velocity

slope_tolerance = 3; // Tolerance for walking up slopes in pixels
slope_angle_lerp_spd = 0.1; // Speed to lerp the angle to the slope the player is standing on

// Beahviour Settings
canmove = true;

team_id = "player1";

health_show = true;
health_points = 12;
max_health_points = 12;

// Animation Settings
animation_spd = 0.18;

stats_y_offset = 8;

knockout = true;

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

limb_aim_move_offset_x = -2;

// Squad Variables
squad_aim = false;
squad_key_fire_press = false;
squad_key_aim_press = false;

// Inventory Settings
//add_item_inventory(inventory, 6);
//add_item_inventory(inventory, 4);

//add_item_inventory(inventory, 10);
//var temp_weapon = ds_list_find_value(inventory.weapons, 0);
//temp_weapon.equip = true;

instance_destroy(inventory);
inventory = create_empty_inventory(id, 10, 10);
add_item_inventory(inventory, 7, 20);
//add_item_inventory(inventory, 6);
add_item_inventory(inventory, 9);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;
add_item_inventory(inventory, 8);
add_item_inventory(inventory, 9);

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
can_die = true;
camera_debug_gif_mode = false;