/// @description Default Celestial Combat Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour

// Initialize as Persistent Object
persistent = true;

// Unit Instance Variable
unit_instance = noone;

// Combat Unit Properties
combat_unit_type = -1;

// Health & Armor Variables
combat_unit_health = -1;

// Action Variables
combat_unit_action = -1;
combat_unit_action_time = 0;
combat_unit_action_count = -1;
combat_unit_action_exhaustion = -1;
combat_unit_action_duration = -1;

combat_unit_action_target_inst = noone;
combat_unit_action_target_grid_side = CelestialBattlePlatformSide.None;
combat_unit_action_target_grid_column = -1;
combat_unit_action_target_grid_row = -1;

// Combat Grid Variables
combat_grid_facing_direction = CelestialBattlePlatformSide.None;

combat_grid_column = -1;
combat_grid_row = -1;

// Object Depth Sorting Variables
vertical_depth = 0;

// Weapon Settings
item_enabled = false;
item_sprite = -1;

item_pivot_x = 0;
item_pivot_y = 0;

item_aim_pivot_x = 0;
item_aim_pivot_y = 0;

// Weapon Variables
item_aim = 0;

item_offset_x = 0;
item_offset_y = 0;

item_target_x = 0;
item_target_y = 0;

item_angle = 270;

item_angle_recoil = 0;
item_horizontal_recoil = 0;
item_vertical_recoil = 0;

item_vertical_bobbing_height = -1;
item_vertical_bobbing_y_offset = 0;

