/// @description Smoke Particle Initialization
// Creates the Smoke Effect's Particle System, Particle Type, and Particle Emitter

// Inherit the parent event
event_inherited();

// Create Particle System
part_system_draw_order(dynamic_particle_system, true);
part_system_automatic_update(dynamic_particle_system, false);

// Create Particle Type
smoke_particle = part_type_create();
part_type_shape(smoke_particle, pt_shape_disk);
part_type_size(smoke_particle, 0.08, 0.1, -0.001, 0);
part_type_scale(smoke_particle, 1, 1);
part_type_speed(smoke_particle, 0.3, 1.7, -0.01, 0);
part_type_direction(smoke_particle, 80, 100, 0, 15);
part_type_gravity(smoke_particle, 0, 270);
part_type_orientation(smoke_particle, 0, 0, 0, 0, false);
part_type_colour3(smoke_particle, $1A1A1A, $333333, $999999);
part_type_alpha3(smoke_particle, 1, 1, 0.259);
part_type_blend(smoke_particle, false);
part_type_life(smoke_particle, 70, 80);

// Create Particle Emitter
smoke_particle_emitter = part_emitter_create(dynamic_particle_system);
part_emitter_region(dynamic_particle_system, smoke_particle_emitter, -0.5, 0.5, -0.5, 0.5, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(dynamic_particle_system, smoke_particle_emitter, smoke_particle, 1);
part_emitter_delay(dynamic_particle_system, smoke_particle_emitter, 60, 150, time_source_units_frames);
part_emitter_interval(dynamic_particle_system, smoke_particle_emitter, 10, 30, time_source_units_frames);
