/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Physics Settings
spd = 3; // Running Speed
walk_spd = 1; // Walk Speed

jump_spd = 1; // Jumping Speed
double_jump_spd = 2; // Double Jumping Speed
hold_jump_spd = 0.45; // Added Jump Speed when the Jump Button is held
jump_decay = 0.81; // Decay of the Jumping Upwards Velocity

grav_spd = 0.028; // Force of Downward Gravity
grav_multiplier = 0.97; // Dampening Multiplyer of the Downward Velocity (Makes gravity smoother)
max_grav_spd = 4; // Max Speed of Unit's Downward Velocity

slope_tolerance = 3; // Tolerance for walking up slopes in pixels
slope_angle_lerp_spd = 0.1; // Speed to lerp the angle to the slope the player is standing on

health_points = 3;
max_health_points = 3;

// Animation Settings
idle_animation = sWilliam_NorthernBrigade_Mercenary_Idle;
walk_animation = sWilliam_NorthernBrigade_Mercenary_Run;
jump_animation = sWilliam_NorthernBrigade_Mercenary_Jump;
aim_animation = sWilliam_NorthernBrigade_Mercenary_Aim;
aim_walk_animation = sWilliam_NorthernBrigade_Mercenary_AimWalk;

idle_normals = sWilliam_NorthernBrigade_Mercenary_Idle_NormalMap;
walk_normals = sWilliam_NorthernBrigade_Mercenary_Run_NormalMap;
jump_normals = sWilliam_NorthernBrigade_Mercenary_Jump_NormalMap;
aim_normals = sWilliam_NorthernBrigade_Mercenary_Aim_NormalMap;
aim_walk_normals = sWilliam_NorthernBrigade_Mercenary_AimWalk_NormalMap;

animation_spd = 0.18;
action_spd = 0.17;
squash_stretch = 0.3;
scale_reset_spd = 0.15;

stats_y_offset = 8;

// Ragdoll Settings
ragdoll = true;

ragdoll_head_sprite = sWilliam_NorthernBrigade_Merc_Head;
ragdoll_arm_left_sprite = sWilliam_NorthernBrigade_Arms;
ragdoll_arm_right_sprite = sWilliam_NorthernBrigade_Arms;
ragdoll_chest_top_sprite = sWilliam_NorthernBrigade_Merc_ChestTop;
ragdoll_chest_bot_sprite = sWilliam_NorthernBrigade_Merc_ChestBot;
ragdoll_leg_left_sprite = sWilliam_NorthernBrigade_LeftLeg;
ragdoll_leg_right_sprite = sWilliam_NorthernBrigade_RightLeg;

ragdoll_head_normalmap = sWilliam_NorthernBrigade_Merc_Head_NormalMap;
ragdoll_arm_left_normalmap = sWilliam_NorthernBrigade_Arms_NormalMap;
ragdoll_arm_right_normalmap = sWilliam_NorthernBrigade_Arms_NormalMap;
ragdoll_chest_top_normalmap = sWilliam_NorthernBrigade_Merc_ChestTop_NormalMap;
ragdoll_chest_bot_normalmap = sWilliam_NorthernBrigade_Merc_ChestBot_NormalMap;
ragdoll_leg_left_normalmap = sWilliam_NorthernBrigade_LeftLeg_NormalMap;
ragdoll_leg_right_normalmap = sWilliam_NorthernBrigade_RightLeg_NormalMap;

// Weapon Settings
weapon_hip_x = -4;
weapon_hip_y = -28;

weapon_aim_x = 5;
weapon_aim_y = -40;

inventory_x = -8;
inventory_y = -21;

weapon_holster_ambient_move_size = 2;

// Limb Settings
limbs = 2;

limb_x[0] = -6;
limb_y[0] = -32;
limb_angle[0] = -5;

limb_x[1] = 4;
limb_y[1] = -32;
limb_angle[1] = 18;

limb_ambient_idle_rotate_radius = 1;
limb_ambient_idle_length_offset = 0.1;

limb_ambient_move_width = 5;
limb_ambient_move_height = 7;
limb_ambient_move_angle_offset = 20;
limb_ambient_move_length_offset = 0.5;

limb_aim_move_offset_x = 0;
limb_aim_offset_y = -1;

limb_sprite[0] = sWilliam_NorthernBrigade_Arms;  // Right Arm
limb_sprite[1] = sWilliam_NorthernBrigade_Arms;  // Left Arm

limb_normal_sprite[0] = sWilliam_NorthernBrigade_Arms_NormalMap;  // Right Arm
limb_normal_sprite[1] = sWilliam_NorthernBrigade_Arms_NormalMap;  // Left Arm

// Health Settings
health_show = false;

// Inventory Settings
instance_destroy(inventory);
inventory = create_empty_inventory(id, 6, 8);
add_item_inventory(inventory, 12);
add_item_inventory(inventory, 5);
add_item_inventory(inventory, 18);
add_item_inventory(inventory, 6, 24);
add_item_inventory(inventory, 19, 12);
add_item_inventory(inventory, 13, 6);
var temp_weapon = ds_list_find_value(inventory.weapons, 0);
temp_weapon.equip = true;