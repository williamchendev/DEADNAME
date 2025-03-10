/// @description Flame Movement
// Moves Point Light Source with Flame Dynamic Object

// Move Point Light with Dynamic Object
if (dynamic_movement)
{
	point_light_source.x = x;
	point_light_source.y = y;
	
	smoke_particle_source.x = x;
	smoke_particle_source.y = y;
}

// Lantern Light Source Flicker Behaviour
if (flame_flicker_range_time <= 0) 
{
	flame_flicker_range_value += random_range(-flame_flicker_range_size, flame_flicker_range_size);
	flame_flicker_range_value = clamp(flame_flicker_range_value, -flame_flicker_range_limit, flame_flicker_range_limit);
	flame_flicker_range_spd = random_range(flame_flicker_range_min_spd, flame_flicker_range_max_spd);
	flame_flicker_range_time = 1;
}
else 
{
	flame_flicker_range_time -= frame_delta * flame_flicker_range_spd;
}

point_light_source.point_light_intensity = flame_light_intensity + (flame_flicker_intensity_size * (1 - ((flame_flicker_range_value + flame_flicker_range_limit) / (flame_flicker_range_limit * 2))));
point_light_source.point_light_radius = flame_light_radius + flame_flicker_range_value;

emissive_multiplier = 0.5 + (0.5 * ((flame_flicker_range_value + flame_flicker_range_limit) / (flame_flicker_range_limit * 2)));
