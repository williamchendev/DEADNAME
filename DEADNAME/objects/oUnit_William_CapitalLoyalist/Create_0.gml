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

can_die = false;

// Animation Settings
idle_animation = sWilliam_CapitalLoyalist_Idle;
walk_animation = sWilliam_CapitalLoyalist_Run;
jump_animation = sWilliam_CapitalLoyalist_Jump;
aim_animation = sWilliam_CapitalLoyalist_Aim;
aim_walk_animation = sWilliam_CapitalLoyalist_AimWalk;

idle_normals = sWilliam_CapitalLoyalist_Idle_NormalMap;
walk_normals = sWilliam_CapitalLoyalist_Run_NormalMap;
jump_normals = sWilliam_CapitalLoyalist_Jump_NormalMap;
aim_normals = sWilliam_CapitalLoyalist_Aim_NormalMap;
aim_walk_normals = sWilliam_CapitalLoyalist_AimWalk_NormalMap;

animation_spd = 0.18;
action_spd = 0.18;
action_travel_spd = 0.4;
squash_stretch = 0.5;
scale_reset_spd = 0.15;

stats_y_offset = 8;

knockout = true;

// Ragdoll Settings
ragdoll = true;
ragdoll_head_sprite = sWilliam_CapitalLoyalist_Head;
ragdoll_arm_left_sprite = sWilliam_CapitalLoyalist_Arms;
ragdoll_arm_right_sprite = sWilliam_CapitalLoyalist_Arms;
ragdoll_chest_top_sprite = sWilliam_CapitalLoyalist_ChestTop;
ragdoll_chest_bot_sprite = sWilliam_CapitalLoyalist_ChestBot;
ragdoll_leg_left_sprite = sWilliam_CapitalLoyalist_LeftLeg;
ragdoll_leg_right_sprite = sWilliam_CapitalLoyalist_RightLeg;
ragdoll_head_normalmap = sWilliam_CapitalLoyalist_Head_NormalMap;
ragdoll_arm_left_normalmap = sWilliam_CapitalLoyalist_Arms_NormalMap;
ragdoll_arm_right_normalmap = sWilliam_CapitalLoyalist_Arms_NormalMap;
ragdoll_chest_top_normalmap = sWilliam_CapitalLoyalist_ChestTop_NormalMap;
ragdoll_chest_bot_normalmap = sWilliam_CapitalLoyalist_ChestBot_NormalMap;
ragdoll_leg_left_normalmap = sWilliam_CapitalLoyalist_LeftLeg_NormalMap;
ragdoll_leg_right_normalmap = sWilliam_CapitalLoyalist_RightLeg_NormalMap;

ragdoll_leg_offset = 4;

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
weapon_hip_x = -2;
weapon_hip_y = -30;

weapon_aim_x = 3;
weapon_aim_y = -40;

inventory_x = -3;
inventory_y = -28;

weapon_holster_ambient_move_size = 2;

// Limb Settings
limbs = 2;

limb_x[0] = -7;
limb_y[0] = -34;
limb_angle[0] = 0;

limb_x[1] = 4;
limb_y[1] = -33;
limb_angle[1] = 25;

limb_ambient_idle_rotate_radius = 1;
limb_ambient_idle_length_offset = 0.15;

limb_ambient_move_width = 3;
limb_ambient_move_height = 2;
limb_ambient_move_angle_offset = -6;
limb_ambient_move_length_offset = 0.1;

limb_aim_move_offset_x = 0;
limb_aim_offset_y = 0;

limb_sprite[0] = sWilliam_CapitalLoyalist_Arms;  // Right Arm
limb_sprite[1] = sWilliam_CapitalLoyalist_Arms;  // Left Arm

limb_normal_sprite[0] = sWilliam_CapitalLoyalist_Arms_NormalMap;  // Right Arm
limb_normal_sprite[1] = sWilliam_CapitalLoyalist_Arms_NormalMap;  // Left Arm

// Inventory Settings
add_item_inventory(inventory, 5);
add_item_inventory(inventory, 6, 20);
add_item_inventory(inventory, 14);
add_item_inventory(inventory, 15, 9);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;

// Hair Ragdoll
ragdoll_hair_inst = noone;
/*
ragdoll_hair_sprite = sWilliam_Knives_Hair;
ragdoll_hair_normalmap = sWilliam_Knives_Hair_NormalMap;
ragdoll_hair_x = -2;
ragdoll_hair_y = -44;

ragdoll_hair_inst = instance_create_layer(x + ragdoll_hair_x, y + ragdoll_hair_y, layers[0], oRagdoll_Limb_Hair);
ragdoll_hair_inst.phy_fixed_rotation = true;
ragdoll_hair_inst.colors_sprite_index = ragdoll_hair_sprite;
ragdoll_hair_inst.normals_sprite_index = ragdoll_hair_normalmap;
ragdoll_hair_list[0] = ragdoll_hair_inst;
var temp_old_hair_inst = ragdoll_hair_inst;
for (var i = 1; i < sprite_get_number(ragdoll_hair_sprite); i++) {
	var temp_new_hair_inst = instance_create_layer(x + ragdoll_hair_x, y + ragdoll_hair_y + ((sprite_get_height(ragdoll_hair_sprite) * i) - 1), layers[0], oRagdoll_Limb_Hair);
	temp_new_hair_inst.image_index = i;
	temp_new_hair_inst.colors_sprite_index = ragdoll_hair_sprite;
	temp_new_hair_inst.normals_sprite_index = ragdoll_hair_normalmap;
	
	ragdoll_hair_list[i] = temp_new_hair_inst;
	physics_joint_revolute_create(temp_old_hair_inst, temp_new_hair_inst, temp_new_hair_inst.x, temp_new_hair_inst.y, -45, 45, 1, 0, 0, 0, 0); 
	temp_old_hair_inst = temp_new_hair_inst;
}
*/

// Player Settings
player_input = true;
ai_behaviour = false;
camera_follow = true;

// Debug
//can_die = true;
camera_debug_gif_mode = false;