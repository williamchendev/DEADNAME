/// @description Thrown Weapon Item Physics Event
// Perform Thrown Weapon Item Physics Behaviour

//
if (!projectile_physics_enabled)
{
	return;
}

// Gravity
//projectile_gravity_velocity += projectile_gravity_speed * 0.5 * frame_delta;
//projectile_gravity_velocity *= power(projectile_gravity_multiplier, frame_delta);
//projectile_gravity_velocity = min(projectile_gravity_velocity, projectile_gravity_maximum);

projectile_vertical_velocity += projectile_gravity_speed * frame_delta;

//
projectile_rotate_speed = sign(projectile_rotate_speed) * max(abs(projectile_rotate_speed) - (projectile_rotate_friction * frame_delta), 0);

//
var temp_inverse_air_resistance = 1 - projectile_air_resistance;

//
var temp_projectile_horizontal_velocity = projectile_horizontal_velocity * temp_inverse_air_resistance * frame_delta;
var temp_projectile_vertical_velocity = projectile_vertical_velocity * temp_inverse_air_resistance * frame_delta;

//
var temp_distance = point_distance(0, 0, temp_projectile_horizontal_velocity, temp_projectile_vertical_velocity);
var temp_direction = point_direction(0, 0, temp_projectile_horizontal_velocity, temp_projectile_vertical_velocity);

//
rot_prefetch(temp_direction);

//
var i = 1;
//var temp_travel_distance = min(round(temp_distance), projectile_velocity_maximum);
var temp_travel_distance = round(temp_distance);

//
var temp_original_x = phy_position_x;
var temp_original_y = phy_position_y;
var temp_original_angle = phy_rotation;

//
var temp_travel_angle_speed = (projectile_rotate_speed * frame_delta) / temp_travel_distance;

//
repeat (temp_travel_distance)
{
	//
	var temp_horizontal_offset = rot_dist_x(i);
	var temp_vertical_offset = rot_dist_y(i);
	
	//
	phy_position_x = temp_original_x + temp_horizontal_offset;
	phy_position_y = temp_original_y + temp_vertical_offset;
	
	//
	phy_rotation = temp_original_angle + (i * temp_travel_angle_speed);
	
	//
	if (place_meeting(phy_position_x, phy_position_y, oSolid))
	{
		//
		i -= 1;
		
		//
		temp_horizontal_offset = rot_dist_x(i);
		temp_vertical_offset = rot_dist_y(i);
		
		//
		phy_position_x = temp_original_x + temp_horizontal_offset;
		phy_position_y = temp_original_y + temp_vertical_offset;
		
		//
		phy_rotation = temp_original_angle + (i * temp_travel_angle_speed);
		
		//
		var temp_projectile_velocity = point_distance(0, 0, projectile_horizontal_velocity, projectile_vertical_velocity);
		
		//
		phy_active = true;
		projectile_physics_enabled = false;
		
		//
		phy_speed_x = rot_dist_x(temp_projectile_velocity) * temp_inverse_air_resistance * projectile_restitution;
		phy_speed_y = rot_dist_y(temp_projectile_velocity) * temp_inverse_air_resistance * projectile_restitution;
		
		//
		return;
	}
	
	//
	i++;
}














