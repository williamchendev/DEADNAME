/// @description Default Celestial Combat Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour

// Initialize as Persistent Object
persistent = true;

// Unit Instance Variable
unit_instance = noone;

// Battle Variables
battle_instance = noone;

// Celestial Battle Choreography Object Type
choreography_object_type = CelestialBattleChoreographyObjectType.Actor;

// Combat Unit Properties
combat_unit_type = -1;

combat_unit_accuracy = 1;
combat_unit_evasion = 1;

// Health & Armor Variables
combat_unit_health = -1;

// Action Variables
combat_unit_action_type = CelestialCombatUnitActionType.None;
combat_unit_action_time = 0;
combat_unit_action_count = -1;
combat_unit_action_exhaustion = -1;
combat_unit_action_duration = -1;

combat_unit_action_target_inst = noone;
combat_unit_action_target_combat_grid_side = CelestialBattleCombatGridSide.None;
combat_unit_action_target_combat_grid_column = -1;
combat_unit_action_target_combat_grid_row = -1;

// Animation Variables
animation_state = CelestialCombatUnitAnimationState.EntryDelayed;

// Combat Grid Variables
combat_grid_side = CelestialBattleCombatGridSide.None;

combat_grid_column = -1;
combat_grid_row = -1;

combat_grid_tile = -1;

// Object Depth Sorting Variables
vertical_depth = 0;

// Item Settings
item_render_enabled = false;

// Inventory Variables
item_inventory_index = -1;
item_inventory = array_create(0);

// Item Variables
item_aim = 0;

item_pivot_x = 0;
item_pivot_y = 0;

item_offset_x = 0;
item_offset_y = 0;

item_target_x = 0;
item_target_y = 0;
item_target_angle = 0;

item_angle = 270;

item_angle_recoil = 0;
item_horizontal_recoil = 0;
item_vertical_recoil = 0;

item_vertical_bobbing_height = -1;
item_vertical_bobbing_y_offset = 0;

// Position Variables
random_offset_x = 0;
random_offset_y = 0;

// Combat Entry Variables
combat_entered_delay_duration = 0;
combat_entry_animation_value = 0;
combat_entry_draw_offset_x = 0;

// Draw Variables
draw_image_index_value = 0;
draw_xscale = 1;
draw_alpha = 1;

