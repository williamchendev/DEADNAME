/// @description Rain Particle Clean Up Event
// Destroys the Rain Effect's Particle System, Particle Type, and Particle Emitter

// Destroy Particle Type
part_type_destroy(rain_particle);
rain_particle = -1;

// Destroy Particle Emitter
part_emitter_destroy_all(dynamic_particle_system);
rain_particle_emitter = -1;

// Destroy Particle System
event_inherited();
