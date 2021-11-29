/// @description Firearm Projectile Init Event
// Creates the Variables and Settings necessary for the Firearm Projectile's Behaviour

// Settings
bullet_timescale = 1.5;
bullet_realdeltatime = false;

bullet_spd = 1;
bullet_direction = 0;
bullet_gravity = 0.1;

bullet_impact_damage = 10;
bullet_impact_ragdoll_force_mult = 5;

bullet_impact_fuse = true;
bullet_platform_check = false;

bullet_trail_alpha = 0.1;
bullet_trail_length = 64;

distance_travel_limit = 4000;

// Variables
weapon_obj = noone;

ignore_id = "unassigned";
distance_traveled = 0;
bullet_gravity_velocity = 0;

bullet_trail_list = ds_list_create();

// Platform Behaviour
platform_check = false;
platform_list = ds_list_create();