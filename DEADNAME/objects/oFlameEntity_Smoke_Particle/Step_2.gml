/// @description Movement Event

// Move Particle Emitter
part_emitter_region(dynamic_particle_system, smoke_particle_emitter, x - 0.5, x + 0.5, y - 0.5, y + 0.5, ps_shape_ellipse, ps_distr_linear);
part_system_update(dynamic_particle_system);
