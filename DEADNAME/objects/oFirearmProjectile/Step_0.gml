/// @description Firearm Projectile Update Event
// Performs the calculations and behaviours of the Firearm Projectile

// Deltatime
var temp_deltatime = global.deltatime;
if (bullet_realdeltatime) {
	temp_deltatime = global.realdeltatime;
}

// Calculate Travel
var temp_velocity_x = lengthdir_x(bullet_spd, bullet_direction) * bullet_timescale * temp_deltatime;
var temp_velocity_y = (lengthdir_y(bullet_spd, bullet_direction) + bullet_gravity_velocity) * bullet_timescale * temp_deltatime;
var temp_velocity_distance = point_distance(0, 0, temp_velocity_x, temp_velocity_y);
var temp_velocity_direction = point_direction(0, 0, temp_velocity_x, temp_velocity_y);

// Image Direction Facing
image_angle = temp_velocity_direction;

// Travel Behaviour
if (bullet_platform_check) {
	// Check to Index Viable Platforms
	if (!platform_check) {
		if (temp_velocity_y > 0) {
			for (var i = 0; i < instance_number(oPlatform); i++) {
				var temp_platform_inst = instance_find(oPlatform, i);
				if (temp_platform_inst.y > y) {
					ds_list_add(platform_list, temp_platform_inst);
				}
			}
			platform_check = true;
		}
	}
	
	// Platform Based Collision Checking
	for (var i = 1; i <= temp_velocity_distance; i++) {
		// Move Projectile Based on Velocity
		x += lengthdir_x(1, temp_velocity_direction);
		y += lengthdir_y(1, temp_velocity_direction);
		
		// Impact Fuse
		if (bullet_impact_fuse) {
			var temp_impact = false;
			if (place_meeting(x, y, oUnit)) {
				// Create Collision List
				var temp_unit_list = ds_list_create();
				var temp_unit_num = instance_place_list(x, y, oUnit, temp_unit_list, false);
				
				// Iterate Through All Colliding Units
				if (temp_unit_num > 0) {
					for (var l = 0; l < ds_list_size(temp_unit_list); l++) {
						var temp_unit_inst = ds_list_find_value(temp_unit_list, l);
						if (temp_unit_inst.team_id != ignore_id) {
							// Calculate Unit Damage
							temp_unit_inst.health_points -= bullet_impact_damage;
							temp_unit_inst.health_points = clamp(temp_unit_inst.health_points, 0, temp_unit_inst.max_health_points);
							
							// Unit Blood
							create_unit_blood(temp_unit_inst, temp_unit_inst.x, clamp(y, temp_unit_inst.bbox_top, temp_unit_inst.bbox_bottom), image_angle);
							
							// Unit Ragdoll
							if (temp_unit_inst.health_points == 0) {
								temp_unit_inst.force_applied = true;
								temp_unit_inst.force_x = temp_unit_inst.x;
								temp_unit_inst.force_y = clamp(y, temp_unit_inst.bbox_top, temp_unit_inst.bbox_bottom);
								temp_unit_inst.force_xvector = cos(degtorad(image_angle)) * bullet_spd * bullet_timescale * bullet_impact_ragdoll_force_mult;
								temp_unit_inst.force_yvector = sin(degtorad(image_angle)) * bullet_spd * bullet_timescale * bullet_impact_ragdoll_force_mult;
							}
							
							// Bullet Impact
							temp_impact = true;
							break;
						}
					}
				}
				
				// Clean Up List
				ds_list_destroy(temp_unit_list);
				temp_unit_list = -1;
			}
			
			// Destroy
			if (temp_impact) {
				instance_destroy();
				return;
			}
		}
		
		// Collision Checking
		if (!platform_free(x, y, platform_list)) {
			// Hit Viable Surface
			instance_destroy();
			return;
		}
		
		// Increment Distance Traveled
		ds_list_add(bullet_trail_list, temp_velocity_direction);
		if (ds_list_size(bullet_trail_list) >= bullet_trail_length) {
			ds_list_delete(bullet_trail_list, 0);
		}
		distance_traveled++;
	}
}
else {
	// Non-Platform Based Collision Checking
	for (var i = 1; i <= temp_velocity_distance; i++) {
		// Move Projectile Based on Velocity
		x += lengthdir_x(1, temp_velocity_direction);
		y += lengthdir_y(1, temp_velocity_direction);
		
		// Impact Fuse
		if (bullet_impact_fuse) {
			var temp_impact = false;
			if (place_meeting(x, y, oUnit)) {
				// Create Collision List
				var temp_unit_list = ds_list_create();
				var temp_unit_num = instance_place_list(x, y, oUnit, temp_unit_list, false);
				
				// Iterate Through All Colliding Units
				if (temp_unit_num > 0) {
					for (var l = 0; l < ds_list_size(temp_unit_list); l++) {
						var temp_unit_inst = ds_list_find_value(temp_unit_list, l);
						if (temp_unit_inst.team_id != ignore_id) {
							// Calculate Unit Damage
							temp_unit_inst.health_points -= bullet_impact_damage;
							temp_unit_inst.health_points = clamp(temp_unit_inst.health_points, 0, temp_unit_inst.max_health_points);
							
							// Unit Blood
							create_unit_blood(temp_unit_inst, temp_unit_inst.x, clamp(y, temp_unit_inst.bbox_top, temp_unit_inst.bbox_bottom), image_angle);
							
							// Unit Ragdoll
							if (temp_unit_inst.health_points == 0) {
								temp_unit_inst.force_applied = true;
								temp_unit_inst.force_x = temp_unit_inst.x;
								temp_unit_inst.force_y = clamp(y, temp_unit_inst.bbox_top, temp_unit_inst.bbox_bottom);
								temp_unit_inst.force_xvector = cos(degtorad(image_angle)) * bullet_spd * bullet_timescale * bullet_impact_ragdoll_force_mult;
								temp_unit_inst.force_yvector = sin(degtorad(image_angle)) * bullet_spd * bullet_timescale * bullet_impact_ragdoll_force_mult;
								x = temp_unit_inst.x;
							}
							
							// Bullet Impact
							temp_impact = true;
							break;
						}
					}
				}
				
				// Clean Up List
				ds_list_destroy(temp_unit_list);
				temp_unit_list = -1;
			}
			
			// Destroy
			if (temp_impact) {
				instance_destroy();
				return;
			}
		}
		
		// Collision Checking
		if (place_meeting(x, y, oSolid)) {
			// Hit Viable Surface
			instance_destroy();
			return;
		}
		
		// Increment Distance Traveled
		ds_list_add(bullet_trail_list, temp_velocity_direction);
		if (ds_list_size(bullet_trail_list) >= bullet_trail_length) {
			ds_list_delete(bullet_trail_list, 0);
		}
		distance_traveled++;
	}
}

// Distance Travel Limit
if (distance_traveled >= distance_travel_limit) {
	instance_destroy();
	return;
}

// Gravity
bullet_gravity_velocity += bullet_gravity * bullet_timescale * temp_deltatime;