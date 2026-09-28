/// @description Default Celestial Combat Action Initialization
// Initializes the Celestial Combat Action for Celestial Simulator Behaviour and Rendering

// Battle Instance Variable
battle_instance = noone;

// Combat Unit Variable
combat_unit = noone;

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.Prop;

// Action Settings
action_perform_on_destroy = false;

// Object Depth Sorting Variables
vertical_depth = 0;

// Action Variables
action_timer = 0;

action_type = CelestialCombatUnitActionType.None;
action_accuracy = -1;

// Target Variables
target_combat_unit = noone;
target_combat_grid_side = CelestialBattleCombatGridSide.None;
target_combat_grid_column = -1;
target_combat_grid_row = -1;
