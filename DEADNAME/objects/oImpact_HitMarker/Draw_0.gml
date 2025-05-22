
if (hitmarker_destroy_timer > 0)
{
	//
	surface_set_target(LightingEngine.pbr_lighting_mid_color_surface);
	
	//
	var temp_shadow_x = x + hitmarker_dropshadow_horizontal_offset;
	var temp_shadow_y = y + hitmarker_dropshadow_vertical_offset;
	
	var temp_hit_x = x;
	var temp_hit_y = y;
	
	draw_sprite_ext(sprite_index, image_index, temp_shadow_x - LightingEngine.render_x + LightingEngine.render_border, temp_shadow_y - LightingEngine.render_y + LightingEngine.render_border, 1, 1, image_angle, c_black, 1);
	draw_sprite_ext(sprite_index, image_index, temp_hit_x - LightingEngine.render_x + LightingEngine.render_border, temp_hit_y - LightingEngine.render_y + LightingEngine.render_border, 1, 1, image_angle, c_white, 1);
	
	//
	surface_reset_target();
	
	// Draw Dynamic Object (Basic)
	surface_set_target_ext(0, LightingEngine.diffuse_mid_color_surface);
	surface_set_target_ext(1, LightingEngine.normalmap_vector_surface);
	surface_set_target_ext(2, LightingEngine.layered_prb_metalrough_emissive_depth_surface);
	
	// MRT Dynamic Sprite Layer
	shader_set(shd_mrt_deferred_lighting_dynamic_sprite);
	
	// Set Sub Layer Depth
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_layer_depth_index, 1);
	
	// Set Camera Offset
	shader_set_uniform_f(LightingEngine.mrt_deferred_lighting_dynamic_sprite_shader_camera_offset_index, LightingEngine.render_x - LightingEngine.render_border, LightingEngine.render_y - LightingEngine.render_border);

	//
	lighting_engine_render_sprite_ext
	(
		sprite_index,
		image_index,
		undefined,
		undefined,
		undefined,
		undefined,
		undefined,
		undefined,
		0,
		0,
		0,
		0,
		1,
		temp_shadow_x,
		temp_shadow_y,
		1,
		1,
		image_angle,
		c_black,
		1
	);
	
	lighting_engine_render_sprite_ext
	(
		sprite_index,
		image_index,
		undefined,
		undefined,
		undefined,
		undefined,
		undefined,
		undefined,
		0,
		0,
		0,
		0,
		1,
		x,
		y,
		1,
		1,
		image_angle,
		c_white,
		1
	);
	
	//
	shader_reset();
	
	//
	surface_reset_target();
}
