/// @description Explosion Init Event
// Creates the Explosion Effect and all of the Object Instances necessary for it

// Establish Explosion Unit List and Unit Radial Collision Data
var temp_unit_collisions_list = ds_list_create();
var temp_unit_collisions_num = collision_circle_list(x, y, explosion_attack_radius, oUnit, true, true, temp_unit_collisions_list, false);

// Iterate through Unit Impacted by the Explosion
for (var i = 0; i < temp_unit_collisions_num; i++)
{
	// Establish Collision Unit
	var temp_unit_collision = ds_list_find_value(temp_unit_collisions_list, i);
	
	// Update Unit Combat Attack Impulse Position
	temp_unit_collision.combat_attack_impulse_position_x = lerp(temp_unit_collision.bbox_left, temp_unit_collision.bbox_right, 0.5);
	temp_unit_collision.combat_attack_impulse_position_y = lerp(temp_unit_collision.bbox_top, temp_unit_collision.bbox_bottom, 0.5);
	
	// Update Unit Combat Attack Impuse Power
	temp_unit_collision.combat_attack_impulse_power = explosion_attack_impulse_power;
	
	// Update Unit Combat Attack Impuse Direction
	var temp_unit_collision_direction = point_direction(x, y, temp_unit_collision.combat_attack_impulse_position_x, temp_unit_collision.combat_attack_impulse_position_y);
	temp_unit_collision.combat_attack_impulse_horizontal_vector = dcos(temp_unit_collision_direction);
	temp_unit_collision.combat_attack_impulse_vertical_vector = -dsin(temp_unit_collision_direction);
	
	// Update Unit Health
	temp_unit_collision.unit_health -= explosion_attack_damage;
}

// Destroy Unit Collision DS List
ds_list_destroy(temp_unit_collisions_list);

// Check if Explosion is Perpendicular to Wall Collision
var temp_solid_collision = collision_circle(x, y, 12, oSolid, true, true);
var temp_explosion_collision = temp_solid_collision != noone and instance_exists(temp_solid_collision);

// Perform Explosion Perpendicular or Explosion Collisionless Behaviour
if (temp_explosion_collision)
{
	// Set Direction of Explosion to angle Perpendicular to Collision Surface
	image_angle = point_check_solid_surface_angle(x, y, temp_solid_collision);
}
else
{
	// Set Direction of Explosion to random angle
	image_angle = random(360);
}

// Create Hitmarker Instances
if (hitmarker_instance != noone)
{
	// Establish Explosion Hitmarker Var Struct
	var temp_explosion_hitmarker_inst_var_struct =  { image_xscale: 1, image_yscale: 1, image_angle: image_angle, hitmarker_collision: temp_explosion_collision };
	
	// Set Explosion Impact Scale
	if (temp_explosion_collision)
	{
		// Set Explosion Impact Random Horizontal Scale
		temp_explosion_hitmarker_inst_var_struct.image_xscale = random(1) > 0.5 ? 1 : -1;
		temp_explosion_hitmarker_inst_var_struct.image_yscale = 1;
	}
	else
	{
		// Set Explosion Impact Random Horizontal and Vertical Scale
		temp_explosion_hitmarker_inst_var_struct.image_xscale = random(1) > 0.5 ? 1 : -1;
		temp_explosion_hitmarker_inst_var_struct.image_yscale = random(1) > 0.5 ? 1 : -1;
	}
	
	// Create Explosion Impact Hitmarker Instances
	var temp_back_hitmarker = instance_create_depth(x, y, 0, hitmarker_instance, temp_explosion_hitmarker_inst_var_struct);
	var temp_front_hitmarker = instance_create_depth(x, y, 0, hitmarker_instance, temp_explosion_hitmarker_inst_var_struct);
	
	// Set Explosion Impact Hitmarkers to match each other
	temp_back_hitmarker.image_index = temp_front_hitmarker.image_index;
	
	// Set Explosion Impact Hitmarkers Colors
	temp_front_hitmarker.image_blend = c_white;
	temp_back_hitmarker.image_blend = c_black;
	
	// Set Explosion Impact Hitmarkers to have random position offset
	temp_back_hitmarker.x += (random(1) > 0.5 ? 1 : -1) * random_range(1, 3);
	temp_back_hitmarker.y += (random(1) > 0.5 ? 1 : -1) * random_range(1, 3);
}

// Create Explosion Light Effect Instance
if (light_instance != noone)
{
	instance_create_depth(x, y, 0, light_instance);
}

// Create Explosion Shockwave Effect Instance
if (shockwave_instance != noone)
{
	instance_create_depth(x, y, 0, shockwave_instance);
}

// Create Explosion Volumetric Smoke Clouds
if (cloud_instance != noone)
{
	// Establish Explosion Cloud Var Structs
	var temp_back_cloud_inst_var_struct = { sub_layer_index: 0, cloud_collision: temp_explosion_collision, image_angle: image_angle };
	var temp_front_cloud_inst_var_struct = { sub_layer_index: -1, cloud_collision: temp_explosion_collision, image_angle: image_angle };
	
	// Instantiate Explosion Cloud Instances
	instance_create_depth(x, y, 0, cloud_instance, temp_back_cloud_inst_var_struct);
	instance_create_depth(x, y, 0, cloud_instance, temp_front_cloud_inst_var_struct);
}

// Destroy Explosion Instance
instance_destroy();
