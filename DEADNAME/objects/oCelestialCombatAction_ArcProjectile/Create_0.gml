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
	// Check if Combat Action's Battle Instance still exists
	if (!instance_exists(battle_instance))
	{
		// Exit Arc Projectile's Impact Effect Instantiation & Behaviour
		return;
	}
	
	// Iterate and Initialize Impact Smoke Particle Layers
	var temp_smoke_particle_layer_index = smoke_particle_layer_offset;
	
	repeat (smoke_particle_layer_count)
	{
		// Establish Smoke Particle Layer Vertical Position
		var temp_smoke_particle_y = arc_projectile_end_y + temp_smoke_particle_layer_index * 3;
		
		// Instantiate Smoke Particle Layer Instance
		var temp_smoke_particle_instance = instance_create_depth(arc_projectile_end_x, temp_smoke_particle_y, 0, smoke_particle_layer_object);
		
		// Index Arc Projectile's Smoke Particle Layer Combat Action Instance within the Celestial Battle's Combat Actions Array
		array_push(battle_instance.battle_combat_actions, temp_smoke_particle_instance);
		temp_smoke_particle_instance.battle_instance = battle_instance;
		
		// Set the Arc Projectile's Smoke Particle Layer Vertical Depth
		temp_smoke_particle_instance.smoke_particle_vertical_depth_y = temp_smoke_particle_y;
		temp_smoke_particle_instance.smoke_particle_vertical_depth_offset = 2;
		
		// Increment Smoke Particle Layer Index
		temp_smoke_particle_layer_index++;
	}
	
	// Check if Combat Action has a Hitmarker Shrapnel Object Assigned
	if (hitmarker_shrapnel_object != noone)
	{
		// Initialize Arc Projectile's Hitmarker Shrapnel Combat Action Instance
		var temp_hitmarker_shrapnel_instance = instance_create_depth(arc_projectile_end_x, arc_projectile_end_y, 0, hitmarker_shrapnel_object);
		
		// Index Arc Projectile's Hitmarker Shrapnel Combat Action Instance within the Celestial Battle's Combat Actions Array
		array_push(battle_instance.battle_combat_actions, temp_hitmarker_shrapnel_instance);
		temp_hitmarker_shrapnel_instance.battle_instance = battle_instance;
		
		// Randomize Arc Projectile's Hitmarker Shrapnel Rotation
		temp_hitmarker_shrapnel_instance.image_angle = random_range(-25, 25);
		
		// Set the Arc Projectile's Hitmarker Shrapnel Vertical Depth
		temp_hitmarker_shrapnel_instance.hitmarker_vertical_depth_y = arc_projectile_end_y;
		temp_hitmarker_shrapnel_instance.hitmarker_vertical_depth_offset = 2.04;
	}
	
	// Check if Combat Action has a Hitmarker Ground Collision Object Assigned
	if (hitmarker_ground_collision_object != noone)
	{
		// Initialize Arc Projectile's Hitmarker Ground Collision Combat Action Instance
		var temp_hitmarker_ground_collision_instance = instance_create_depth(arc_projectile_end_x, arc_projectile_end_y, 0, hitmarker_ground_collision_object);
		
		// Index Arc Projectile's Hitmarker Ground Collision Combat Action Instance within the Celestial Battle's Combat Actions Array
		array_push(battle_instance.battle_combat_actions, temp_hitmarker_ground_collision_instance);
		temp_hitmarker_ground_collision_instance.battle_instance = battle_instance;
		
		// Set the Arc Projectile's Hitmarker Ground Collision Vertical Depth
		temp_hitmarker_ground_collision_instance.hitmarker_vertical_depth_y = arc_projectile_end_y;
		temp_hitmarker_ground_collision_instance.hitmarker_vertical_depth_offset = 2.05;
	}
}

