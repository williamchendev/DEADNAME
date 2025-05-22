/// @description Movement Event

// Move Particle Emitter
part_emitter_region(dynamic_particle_system, rain_particle_emitter, LightingEngine.render_x - LightingEngine.render_border - 200, LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border + 200, LightingEngine.render_y - 100, LightingEngine.render_y - 32, ps_shape_line, ps_distr_linear);
part_system_update(dynamic_particle_system);
