/// @description Arc Projectile Combat Action Initialization
// Initializes the Arc Projectile Combat Action for Celestial Simulator Behaviour and Rendering

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.ArcProjectile;

// Action Settings
action_perform_on_destroy = true;

// Arc Projectile's Physics Variables
arc_projectile_speed = 0;
arc_projectile_gravity = 0;
arc_projectile_air_resistance = 0;

arc_projectile_x_velocity = 0;
arc_projectile_y_velocity = 0;

// Arc Projectile's Position Variables
arc_projectile_start_x = 0;
arc_projectile_start_y = 0;

arc_projectile_end_x = 0;
arc_projectile_end_y = 0;

arc_projectile_old_x = 0;
arc_projectile_old_y = 0;

arc_projectile_new_x = 0;
arc_projectile_new_y = 0;

// Arc Projectile's Depth Variables
arc_projectile_start_vertical_depth_y = 0;
arc_projectile_end_vertical_depth_y = 0;
arc_projectile_vertical_depth_offset = 0;

// Arc Projectile Functions
combat_action_end = function()
{
	// Check if Combat Action's Battle Instance still exists and Combat Action has a Hitmarker Object Assigned
	if (instance_exists(battle_instance) and hitmarker_ground_collision_object != noone)
	{
		// Initialize Arc Projectile's Hitmarker Combat Action Instance
		var temp_hitmarker_instance = instance_create_depth(arc_projectile_end_x, arc_projectile_end_y, 0, hitmarker_ground_collision_object);
		
		// Index Arc Projectile's Hitmarker Combat Action Instance within the Celestial Battle's Combat Actions Array
		array_push(battle_instance.battle_combat_actions, temp_hitmarker_instance);
		temp_hitmarker_instance.battle_instance = battle_instance;
		
		// Set the Arc Projectile's Hitmarker Vertical Depth
		temp_hitmarker_instance.hitmarker_vertical_depth_y = arc_projectile_end_y;
		temp_hitmarker_instance.hitmarker_vertical_depth_offset = 2;
	}
}

