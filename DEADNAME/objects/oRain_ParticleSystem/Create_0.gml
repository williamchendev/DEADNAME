/// @description Rain Particle Initialization
// Creates the Rain Effect's Particle System, Particle Type, and Particle Emitter

// Inherit the parent event
event_inherited();

// Allow Distortion Effect
visible = true;

// Create Particle System
part_system_draw_order(dynamic_particle_system, true);
part_system_automatic_update(dynamic_particle_system, false);

// Create Particle Type
rain_particle = part_type_create();
part_type_shape(rain_particle, pt_shape_line);
part_type_size(rain_particle, 0.1, 0.3, -0.001, 0.01);
part_type_scale(rain_particle, 3, 1);
part_type_speed(rain_particle, 1, 1, 0, 0);
part_type_direction(rain_particle, 270, 360, 0, 0);
part_type_gravity(rain_particle, 0.4, 270);
part_type_orientation(rain_particle, 0, 0, 0, 0, true);
part_type_colour3(rain_particle, rain_color, rain_color, rain_color);
part_type_alpha3(rain_particle, 0.8, 0.6, 0.3);
part_type_blend(rain_particle, false);
part_type_life(rain_particle, 38, 48);

// Create Particle Emitter
rain_particle_emitter = part_emitter_create(dynamic_particle_system);
part_emitter_region(dynamic_particle_system, rain_particle_emitter, -600, 600, 0, 0, ps_shape_line, ps_distr_linear);
part_emitter_stream(dynamic_particle_system, rain_particle_emitter, rain_particle, 32);


