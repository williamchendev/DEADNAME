/// @description Thrown Weapon Item Initialization
// Initialized Thrown Weapon Item for Thrown Weapon Physics

// Inherited Dynamic Item Rendering Initialization Event Behaviour
event_inherited();

//
if (projectile_physics_enabled)
{
	phy_active = false;
}

// Projectile Gravity Settings
projectile_gravity_speed = 0.12;

//projectile_gravity_multiplier = 0.93;
//projectile_gravity_maximum = 2.5;

// Projectile Velocity Settings
//projectile_velocity_maximum = 10;

// Projectile Physics Variables
projectile_gravity_velocity = 0;

// Establish Horizontal and Vertical Velocity from Thrown Weapon Initial Velocity and Direction
rot_prefetch(projectile_initial_direction);

projectile_horizontal_velocity = rot_dist_x(projectile_initial_velocity);
projectile_vertical_velocity = rot_dist_y(projectile_initial_velocity);
