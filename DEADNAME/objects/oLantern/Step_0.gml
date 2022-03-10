/// @description Lantern Update
// Calculates and performs the Lantern's Behaviours

// Lantern Light Source Position
lantern_light_source.x = x;
lantern_light_source.y = y;

// Lantern Light Source Properties
lantern_light_source.range = lantern_range;
lantern_light_source.intensity = lantern_intensity;
lantern_light_source.color = lantern_color;

// Lantern Light Source Flicker Behaviour
if (lantern_flicker_range_time <= 0) {
	lantern_flicker_range_value += random_range(-lantern_flicker_range_size, lantern_flicker_range_size);
	lantern_flicker_range_value = clamp(lantern_flicker_range_value, -lantern_flicker_range_limit, lantern_flicker_range_limit);
	lantern_flicker_range_spd = random_range(lantern_flicker_range_min_spd, lantern_flicker_range_max_spd);
	lantern_flicker_range_time = 1;
}
else {
	lantern_flicker_range_time -= global.deltatime * lantern_flicker_range_spd;
}
lantern_light_source.intensity -= lantern_flicker_intensity_size * (1 - ((lantern_flicker_range_value + lantern_flicker_range_limit) / (lantern_flicker_range_limit * 2)));
lantern_light_source.intensity = clamp(lantern_light_source.intensity, 0, 1);
lantern_light_source.range += lantern_flicker_range_value;