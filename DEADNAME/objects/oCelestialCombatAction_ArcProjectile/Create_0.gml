/// @description Arc Projectile Combat Action Initialization
// Initializes the Arc Projectile Combat Action for Celestial Simulator Behaviour and Rendering

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.ArcProjectile;

// Action Settings
action_perform_on_destroy = true;

//
arc_projectile_start_x = 0;
arc_projectile_start_y = 0;
arc_projectile_end_x = 0;
arc_projectile_end_y = 0;

//
arc_projectile_x_velocity = 0;
arc_projectile_y_velocity = 0;

//
arc_projectile_start_vertical_depth_y = 0;
arc_projectile_end_vertical_depth_y = 0;
arc_projectile_vertical_depth_offset = 0;

//
arc_projectile_progress_value = 0;

//
arc_projectile_old_x = 0;
arc_projectile_old_y = 0;

arc_projectile_new_x = 0;
arc_projectile_new_y = 0;

