/// @description Default Celestial Unit Initialization
// Initializes the Celestial Unit for Celestial Simulator Behaviour and Rendering

// Inherited Celestial Sub Object Initialization Behaviour
event_inherited();

// Initialize Unit Celestial Sub Object Type
celestial_sub_object_type = CelestialSubObjectType.Unit;

// Initialize Unit Faction
unit_faction = noone;

// Initialize Unit Sub-Units
sub_units = array_create(0);

repeat (irandom_range(3, 8))
{
	celestial_unit_add_subunit(id, instance_create_depth(0, 0, 0, oCelestial_CombatUnit_Artillery));
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

// Combat Variables
engaged_in_battle = false;

// Willpower Variables
willpower_sun = 3;
willpower_moon = 1;

// Behaviour Variables
unit_behaviour = CelestialUnitBehaviourType.None;

unit_behaviour_target_instance = noone;
unit_behaviour_target_node_index = -1;

// Randomize Sprite Facing Direction
image_xscale = random(1.0) < 0.5 ? -1 : 1;