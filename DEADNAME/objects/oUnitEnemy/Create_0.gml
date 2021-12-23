/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

team_id = "enemy";

// Debug
idle_animation = sWilliamDS_Idle;
walk_animation = sWilliamDS_Run;
jump_animation = sWilliamDS_Jump;
aim_animation = sWilliamDS_Aim;
aim_walk_animation = sWilliamDS_AimWalk;

idle_normals = sWilliamDS_Idle_NormalMap;
walk_normals = sWilliamDS_Run_NormalMap;
jump_normals = sWilliamDS_Jump_NormalMap;
aim_normals = sWilliamDS_Aim_NormalMap;
aim_walk_normals = sWilliamDS_AimWalk_NormalMap;

limb_sprite[0] = sWilliamDS_Arms;
limb_sprite[1] = sWilliam_Arms;

limb_normal_sprite[0] = sWilliamDS_Arms_NormalMap;
limb_normal_sprite[1] = sWilliam_Arms_NormalMap;

health_points = 3;
max_health_points = 3;
health_show = false;

// Death Dialogue Settings
death_dialogue = true;
death_dialogue_chance = 0.4;
death_dialogue_text = noone;

// Inventory
add_item_inventory(inventory, 7, 10);