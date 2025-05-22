/// @description Render Rain Particle Distortion Effect

// Set Additive MRT Blendmode - Add Normal Map Vectors to Directional (Single Color Channel) Surfaces
gpu_set_blendmode(bm_add);

// (Distortion Effect) Enable MRT Distortion Surfaces - Draw Normal Maps to the two Red Only Channel 16 bit Float Surfaces: The Distortion Horizontal Channel Effect Surface and The Distortion Vertical Channel Effect Surface
surface_set_target_ext(0, LightingEngine.distortion_horizontal_effect_surface);
surface_set_target_ext(1, LightingEngine.distortion_vertical_effect_surface);

// (Distortion Effect) Enable MRT Distortion Shader - Draws Normal Maps to the two Red Only Channel 16 bit Float Surfaces so the Distortion Effect Normal Map Vectors can be correctly added
shader_set(shd_mrt_distortion_sprite);

// Set Distortion Shader Camera Offset
shader_set_uniform_f(LightingEngine.mrt_distortion_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);

// MRT Render all Distortion Effects to Distortion Surfaces
part_system_drawit(dynamic_particle_system);

// Reset MRT Distortion Effect Surfaces & Shader
surface_reset_target();
shader_reset();

gpu_set_blendmode(bm_normal);
