/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Sub Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Sub Object Type
celestial_sub_object_type = CelestialSubObjectType.Unit;

// Emotion Settings
emotion_retreat_sprite = sOverworld_Emotion_Retreat;
emotion_retreat_image_spd = 0.18;

emotion_battle_popup_duration = 40;
emotion_battle_popup_vertical_movement = 7;
emotion_battle_popup_initial_scale = 1.6;
emotion_battle_popup_animation_multiplier = 3;

// Initialize Unit Faction
unit_faction = noone;

// Initialize Unit Sub-Units
sub_units = array_create(0);

repeat (irandom_range(3, 8))
{
	//celestial_unit_add_subunit(id, instance_create_depth(0, 0, 0, oCelestial_CombatUnit_Artillery));
}
repeat (irandom_range(3, 8))
{
	celestial_unit_add_subunit(id, instance_create_depth(0, 0, 0, oCelestial_CombatUnit_Tank));
}
repeat (irandom_range(3, 8))
{
	celestial_unit_add_subunit(id, instance_create_depth(0, 0, 0, oCelestial_CombatUnit_Infantry));
}

// Solar Variables
unit_solar = CelestialSolarType.Twilight;

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = 0;

pathfinding_position_x = 0;
pathfinding_position_y = 0;
pathfinding_position_z = 0;
pathfinding_position_elevation = 0;

// Collision Variables
unit_collision_threshold = 2;

unit_collision_check_timer = random(CelestialSimulator.global_collision_check_interval);

unit_battle_within_timed_collision_check_battles = array_create(0);
unit_battle_within_timed_collision_check_timers = array_create(0);

// Combat Variables
engaged_in_battle = false;

battle_action_stun_timer = -1;

// Willpower Variables
willpower_sun = 3;
willpower_moon = 1;

// Behaviour Variables
unit_behaviour = CelestialUnitBehaviourType.None;

unit_behaviour_target_instance = noone;
unit_behaviour_target_node_index = -1;

// Emotion Variables
emotion_sprite_index = -1;
emotion_image_index = 0;
emotion_draw_image_index = 0;

emotion_battle_popup_timer = 0;

// Status Effect Variables
status_effect_array = array_create(0);
status_effect_duration_array = array_create(0);

// Randomize Sprite Facing Direction
image_xscale = random(1.0) < 0.5 ? -1 : 1;