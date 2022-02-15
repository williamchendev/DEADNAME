/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Physics Settings
spd = 2; // Running Speed
walk_spd = 1; // Walk Speed

jump_spd = 1; // Jumping Speed
double_jump_spd = 2; // Double Jumping Seed
hold_jump_spd = 0.45; // Added Jump Speed when the Jump Button is held
jump_decay = 0.81; // Decay of the Jumping Upwards Velocity

grav_spd = 0.028; // Force of Downward Gravity
grav_multiplier = 0.97; // Dampening Multiplyer of the Downward Velocity (Makes gravity smoother)
max_grav_spd = 4; // Max Speed of Unit's Downward Velocity

slope_tolerance = 3; // Tolerance for walking up slopes in pixels
slope_angle_lerp_spd = 0.1; // Speed to lerp the angle to the slope the player is standing on

// Animation Settings
idle_animation = sWilliam_HorizonBlue_MaskHat_Idle;
walk_animation = sWilliam_HorizonBlue_MaskHat_Run;
jump_animation = sWilliam_HorizonBlue_MaskHat_Jump;
aim_animation = sWilliam_HorizonBlue_MaskHat_Aim;
aim_walk_animation = sWilliam_HorizonBlue_MaskHat_AimWalk;

idle_normals = sWilliam_HorizonBlue_MaskHat_Idle_NormalMap;
walk_normals = sWilliam_HorizonBlue_MaskHat_Run_NormalMap;
jump_normals = sWilliam_HorizonBlue_MaskHat_Jump_NormalMap;
aim_normals = sWilliam_HorizonBlue_MaskHat_Aim_NormalMap;
aim_walk_normals = sWilliam_HorizonBlue_MaskHat_AimWalk_NormalMap;

idle_animation = sWilliam_HorizonBlue_Hat_Idle;
walk_animation = sWilliam_HorizonBlue_Hat_Run;
jump_animation = sWilliam_HorizonBlue_Hat_Jump;
aim_animation = sWilliam_HorizonBlue_Hat_Aim;
aim_walk_animation = sWilliam_HorizonBlue_Hat_AimWalk;

idle_normals = sWilliam_HorizonBlue_Hat_Idle_NormalMap;
walk_normals = sWilliam_HorizonBlue_Hat_Run_NormalMap;
jump_normals = sWilliam_HorizonBlue_Hat_Jump_NormalMap;
aim_normals = sWilliam_HorizonBlue_Hat_Aim_NormalMap;
aim_walk_normals = sWilliam_HorizonBlue_Hat_AimWalk_NormalMap;

/*
idle_animation = sWilliam_HorizonBlue_MaskUpHat_Idle;
walk_animation = sWilliam_HorizonBlue_MaskUpHat_Run;
jump_animation = sWilliam_HorizonBlue_MaskUpHat_Jump;
aim_animation = sWilliam_HorizonBlue_MaskUpHat_Aim;
aim_walk_animation = sWilliam_HorizonBlue_MaskUpHat_AimWalk;

idle_normals = sWilliam_HorizonBlue_MaskUpHat_Idle_NormalMap;
walk_normals = sWilliam_HorizonBlue_MaskUpHat_Run_NormalMap;
jump_normals = sWilliam_HorizonBlue_MaskUpHat_Jump_NormalMap;
aim_normals = sWilliam_HorizonBlue_MaskUpHat_Aim_NormalMap;
aim_walk_normals = sWilliam_HorizonBlue_MaskUpHat_AimWalk_NormalMap;
*/

animation_spd = 0.18;
action_spd = 0.20;
squash_stretch = 0.3;
scale_reset_spd = 0.15;

stats_y_offset = 8;

// Ragdoll Settings
ragdoll = true;
ragdoll_head_sprite = sWilliam_HorizonBlue_Hat_Head;
ragdoll_arm_left_sprite = sWilliam_HorizonBlue_Arms;
ragdoll_arm_right_sprite = sWilliam_HorizonBlue_Arms;
ragdoll_chest_top_sprite = sWilliam_HorizonBlue_ChestTop;
ragdoll_chest_bot_sprite = sWilliam_HorizonBlue_ChestBot;
ragdoll_leg_left_sprite = sWilliam_HorizonBlue_LeftLeg;
ragdoll_leg_right_sprite = sWilliam_HorizonBlue_RightLeg;
ragdoll_head_normalmap = sWilliam_HorizonBlue_Hat_Head_NormalMap;
ragdoll_arm_left_normalmap = sWilliam_HorizonBlue_Arms_NormalMap;
ragdoll_arm_right_normalmap = sWilliam_HorizonBlue_Arms_NormalMap;
ragdoll_chest_top_normalmap = sWilliam_HorizonBlue_ChestTop_NormalMap;
ragdoll_chest_bot_normalmap = sWilliam_HorizonBlue_ChestBot_NormalMap;
ragdoll_leg_left_normalmap = sWilliam_HorizonBlue_LeftLeg_NormalMap;
ragdoll_leg_right_normalmap = sWilliam_HorizonBlue_RightLeg_NormalMap;

// Limb Settings
limbs = 2;

limb_x[0] = -5;
limb_y[0] = -36;

limb_x[1] = 5;
limb_y[1] = -34;

limb_aim_move_offset_x = -3;
limb_aim_offset_y = 1;

limb_sprite[0] = sWilliam_HorizonBlue_Arms;  // Right Arm
limb_sprite[1] = sWilliam_HorizonBlue_Arms;  // Left Arm

limb_normal_sprite[0] = sWilliam_HorizonBlue_Arms_NormalMap;  // Right Arm
limb_normal_sprite[1] = sWilliam_HorizonBlue_Arms_NormalMap;  // Left Arm

// Health Settings
health_points = 3;
max_health_points = 3;
health_show = false;

// Inventory Settings
add_item_inventory(inventory, 5);
add_item_inventory(inventory, 6, 24);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;