/// @description Default Dynamic Particle Clean Up
// Destroys the Default Particle System

// Destroy the Dynamic Particle System & Reset to Null
if (part_system_exists(dynamic_particle_system))
{
	part_system_destroy(dynamic_particle_system);
}

dynamic_particle_system = -1;
