/// @description Flame Clean Up Event
// Destroys Point Light & Smoke Particle upon Flame Deletion

// Destroys Smoke Particle Source
if (instance_exists(smoke_particle_source))
{
	instance_destroy(smoke_particle_source);
}

smoke_particle_source = -1;

// Destroys Point Light Source
if (instance_exists(point_light_source))
{
	instance_destroy(point_light_source);
}

point_light_source = -1;
