/// @description Insert description here
// You can write your code in this editor

// Draw Outline Active Check
if (instance_exists(oLighting)) {
	if (!outline_draw_event) {
		return;
	}
}

// Interact Outline
if (interact_select_draw_value > 0) {
	// Surface Variables
	var temp_surface_x = 0;
	var temp_surface_y = 0;
	var temp_surface_width = 641;
	var temp_surface_height = 361;

	// Surface Position & Dimensions
	if (instance_exists(oGameManager)) {
		var temp_gamemanager = instance_find(oGameManager, 0);
		temp_surface_width = (temp_gamemanager.game_width + 1);
		temp_surface_height = (temp_gamemanager.game_height + 1);
	}
	if (instance_exists(oCamera)) {
		var temp_camera = instance_find(oCamera, 0);
		temp_surface_x = floor(temp_camera.x);
		temp_surface_y = floor(temp_camera.y);
	}
	
	// Create Surfaces
	if (!surface_exists(temp_surface)) {
		temp_surface = surface_create(temp_surface_width, temp_surface_height);
	}
	if (!surface_exists(interact_surface)) {
		interact_surface = surface_create(temp_surface_width, temp_surface_height);
	}
	
	// Draw Interact Object Surface
	surface_set_target(interact_surface);
	draw_clear_alpha(interact_select_outline_color, 0);
	
	// Draw Instance
	with (interact_obj) {
		// Set Position
		x = x - temp_surface_x;
		y = y - temp_surface_y;
					
		// Draw Object
		if (object_is_ancestor(object_index, oBasic) or object_index == oBasic) {
			var temp_lit_draw_event = lit_draw_event;
			lit_draw_event = true;
			event_perform(ev_draw, 0);
			lit_draw_event = temp_lit_draw_event;
		}
		else {
			event_perform(ev_draw, 0);
		}
					
		// Reset Position
		x = x + temp_surface_x;
		y = y + temp_surface_y;
	}
	
	surface_reset_target();
	
	// Draw Interact Object Outline Surface
	surface_set_target(temp_surface);
	draw_clear_alpha(c_black, 0);
	
	// Generate First Outline
	var temp_outline_texel_width = texture_get_texel_width(surface_get_texture(interact_surface));
	var temp_outline_texel_height = texture_get_texel_height(surface_get_texture(interact_surface));
	
	shader_set(shd_outline);
	shader_set_uniform_f(uniform_pixel_width, temp_outline_texel_width);
	shader_set_uniform_f(uniform_pixel_height, temp_outline_texel_height);
	
	draw_set_color(interact_select_outline_color);
	draw_set_alpha(interact_select_draw_value * interact_select_draw_value);
	draw_surface(interact_surface, 0, 0);
	surface_reset_target();
	
	draw_surface(interact_surface, temp_surface_x, temp_surface_y);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	// Reset Shader
	shader_reset();
	
	// Generate Second Outline
	temp_outline_texel_width = texture_get_texel_width(surface_get_texture(temp_surface));
	temp_outline_texel_height = texture_get_texel_height(surface_get_texture(temp_surface));
	
	shader_set(shd_outline);
	shader_set_uniform_f(uniform_pixel_width, temp_outline_texel_width);
	shader_set_uniform_f(uniform_pixel_height, temp_outline_texel_height);
	
	// Draw Outer Outline
	draw_set_color(c_black);
	draw_set_alpha(interact_select_draw_value * interact_select_draw_value);
	draw_surface(temp_surface, temp_surface_x, temp_surface_y);
	draw_set_color(c_white);
	draw_set_alpha(1);
			
	// Reset Shader
	shader_reset();
}
else {
	// Free Surfaces
	if (surface_exists(temp_surface)) {
		surface_free(temp_surface);
		temp_surface = -1;
	}
	if (surface_exists(interact_surface)) {
		surface_free(interact_surface);
		interact_surface = -1;
	}
}