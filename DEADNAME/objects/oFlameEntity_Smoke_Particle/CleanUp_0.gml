/// @description Smoke Particle Clean Up Event
// Destroys the Smoke Effect's Particle System, Particle Type, and Particle Emitter

// Destroy Particle Type
part_type_destroy(smoke_particle);
smoke_particle = -1;

// Destroy Particle Emitter
part_emitter_destroy_all(dynamic_particle_system);
smoke_particle_emitter = -1;

// Destroy Particle System
event_inherited();
