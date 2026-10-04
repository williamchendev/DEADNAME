/// @description Linear Projectile Combat Action Initialization
// Initializes the Linear Projectile Combat Action for Celestial Simulator Behaviour and Rendering

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.LinearProjectile;

// Linear Projectile's Line Variables
linear_projectile_start_x = 0;
linear_projectile_start_y = 0;
linear_projectile_end_x = 0;
linear_projectile_end_y = 0;

// Linear Projectile's Transparency Variables
linear_projectile_alpha = 1;

// Linear Projectile's Depth Variables
linear_projectile_vertical_depth_y = 0;
linear_projectile_vertical_depth_offset = 0;

