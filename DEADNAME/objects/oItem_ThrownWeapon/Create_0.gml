/// @description Thrown Weapon Item Initialization
// Initialized Thrown Weapon Item for Thrown Weapon Physics

// Inherited Dynamic Item Rendering Initialization Event Behaviour
event_inherited();

// Thrown Weapon Settings
show_ui_fuze_timer = false;

// Disable Box2D Physics for Custom Thrown Projectile Physics Sim
if (projectile_physics_enabled)
{
	phy_active = false;
}

// Projectile Physics Variables
projectile_gravity_velocity = 0;

// Establish Horizontal and Vertical Velocity from Thrown Weapon Initial Velocity and Direction
rot_prefetch(projectile_initial_direction);

projectile_horizontal_velocity = rot_dist_x(projectile_initial_velocity);
projectile_vertical_velocity = rot_dist_y(projectile_initial_velocity);
