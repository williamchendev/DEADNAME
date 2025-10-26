/// @description Thrown Weapon Item Physics Event
// Perform Thrown Weapon Item Physics Movement Behaviour

// Check if Custom Thrown Projectile Physics Sim is Enabled
if (!projectile_physics_enabled)
{
	// Custom Thrown Projectile Physics Sim is Disabled - Early Return
	return;
}

// Add Gravity to Vertical Velocity
projectile_vertical_velocity += projectile_gravity_speed * frame_delta;

// Apply Rotate Friction to Projectile Rotation Speed
projectile_rotate_speed = sign(projectile_rotate_speed) * max(abs(projectile_rotate_speed) - (projectile_rotate_friction * frame_delta), 0);

// Calculate Projectile's Inverse Air Resistance
var temp_inverse_air_resistance = 1 - projectile_air_resistance;

// Calculate Projectile's Horizontal and Vertical Velocity
var temp_projectile_horizontal_velocity = projectile_horizontal_velocity * temp_inverse_air_resistance * frame_delta;
var temp_projectile_vertical_velocity = projectile_vertical_velocity * temp_inverse_air_resistance * frame_delta;

// Calculate Direction & Distance of Projectile Velocity's Path of Motion
var temp_distance = point_distance(0, 0, temp_projectile_horizontal_velocity, temp_projectile_vertical_velocity);
var temp_direction = point_direction(0, 0, temp_projectile_horizontal_velocity, temp_projectile_vertical_velocity);

// Precalculate Trig Values of Projectile's Velocity Direction
rot_prefetch(temp_direction);

// Establish Iteration Variables
var i = 1;
var temp_travel_distance = round(temp_distance);

// Establish Projectile Physics Variables
var temp_original_x = phy_position_x;
var temp_original_y = phy_position_y;
var temp_original_angle = phy_rotation;

// Establish Projectile Rotation Variables
var temp_travel_angle_speed = (projectile_rotate_speed * frame_delta) / temp_travel_distance;

// Iterate through Projectile's Path of Motion
repeat (temp_travel_distance)
{
	// Establish Position Offset at point in Projectile's Path of Motion
	var temp_horizontal_offset = rot_dist_x(i);
	var temp_vertical_offset = rot_dist_y(i);
	
	// Calculate New Physics Travel Position
	phy_position_x = temp_original_x + temp_horizontal_offset;
	phy_position_y = temp_original_y + temp_vertical_offset;
	
	// Calculate New Physics Travel Rotation
	phy_rotation = temp_original_angle + (i * temp_travel_angle_speed);
	
	// Check for Collision at Position
	if (place_meeting(phy_position_x, phy_position_y, oSolid))
	{
		// Decrement Distance Traveled by a single Pixel
		i -= 1;
		
		// Establish Position Offset at point in Projectile's Path of Motion
		temp_horizontal_offset = rot_dist_x(i);
		temp_vertical_offset = rot_dist_y(i);
		
		// Calculate New Physics Travel Position
		phy_position_x = temp_original_x + temp_horizontal_offset;
		phy_position_y = temp_original_y + temp_vertical_offset;
		
		// Calculate New Physics Travel Rotation
		phy_rotation = temp_original_angle + (i * temp_travel_angle_speed);
		
		// Establish Projectile Velocity
		var temp_projectile_velocity = point_distance(0, 0, projectile_horizontal_velocity, projectile_vertical_velocity);
		
		// Disable Custom Thrown Projectile Physics Sim
		projectile_physics_enabled = false;
		
		// Enable Box2D Physics on Object Instance
		phy_active = true;
		
		// Apply Object Instance's Box2D Physics Velocity from Thrown Projectile Physics Sim's Velocity and Physics Restitution Modifier
		phy_speed_x = rot_dist_x(temp_projectile_velocity) * temp_inverse_air_resistance * projectile_restitution;
		phy_speed_y = rot_dist_y(temp_projectile_velocity) * temp_inverse_air_resistance * projectile_restitution;
		
		// Collision at Position in Projectile's Path of Motion - Early Return
		return;
	}
	
	// Increment Distance Traveled by a single Pixel
	i++;
}
