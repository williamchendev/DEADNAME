/// @description Lighting Draw Event
// Draws the lighting surfaces and calculates the lighting math to draw the finished effect

// Surface Exists
if (!surface_exists(surface_color)) {
	surface_color = surface_create(screen_width, screen_height);
}
if (!surface_exists(surface_normals)) {
	surface_normals = surface_create(screen_width, screen_height);
}
if (!surface_exists(surface_temp)) {
	surface_temp = surface_create(screen_width, screen_height);
}
if (!surface_exists(surface_vectors)) {
	surface_vectors = surface_create(screen_width, screen_height);
}
if (!surface_exists(surface_blend)) {
	surface_blend = surface_create(screen_width, screen_height);
}
if (!surface_exists(surface_shadows)) {
	surface_shadows = surface_create(screen_width, screen_height);
}
if (!surface_exists(surface_light)) {
	surface_light = surface_create(screen_width, screen_height);
}

// Establish Surface Colors
surface_set_target(surface_color);
draw_clear_alpha(c_black, 0);

for (var i = 0; i < ds_list_size(basic_object_depth_list); i++) {
	var temp_sprite = ds_list_find_value(basic_object_depth_list, i);
	if (instance_exists(temp_sprite)) {
		with (temp_sprite) {
			// Basic Object Displacement
			x -= other.x;
			y -= other.y;
		
			// Basic Lighting Colors Draw Event
			lit_draw_event = true;
			event_perform(ev_draw, 0);
			lit_draw_event = false;
		}
	}
}

gpu_set_blendmode_ext(bm_zero, bm_zero);
with(oSolid) {
	draw_sprite_ext(sDebugSolidShadow, 0, x - other.x, y - other.y, image_xscale, image_yscale, image_angle, c_black, 1);
}
gpu_set_blendmode(bm_normal);

surface_reset_target();

// Establish Surface Normals
surface_set_target(surface_normals);
draw_clear_alpha(c_black, 0);

for (var i = 0; i < ds_list_size(basic_object_depth_list); i++) {
	var temp_sprite = ds_list_find_value(basic_object_depth_list, i);
	if (instance_exists(temp_sprite)) {
		with (temp_sprite) {
			// Basic Normals Draw Event
			normal_draw_event = true;
			event_perform(ev_draw, 0);
			normal_draw_event = false;
		
			// Reset Basic Object Displacement
			x += other.x;
			y += other.y;
		}
	}
}

gpu_set_blendmode_ext(bm_zero, bm_zero);
with(oSolid) {
	draw_sprite_ext(sDebugSolidShadow, 0, x - other.x, y - other.y, image_xscale, image_yscale, image_angle, c_white, 1);
}
gpu_set_blendmode(bm_normal);

surface_reset_target();

// Establish Surface Lighting
surface_set_target(surface_light);
draw_clear_alpha(c_black, 1);
surface_reset_target();

// Render Global Lights
for (var i = 0; i < instance_number(oGlobalLight); i++) {
	// Find Directional Light
	var temp_glight = instance_find(oGlobalLight, i);
	
	// Directional Light Variables
	var temp_light_vectorx = clamp((temp_glight.vector_x + 1.0) / 2.0, 0.0, 1.0);
	var temp_light_vectory = clamp((temp_glight.vector_y + 1.0) / 2.0, 0.0, 1.0);
	var temp_lightintensity = temp_glight.intensity;
	var temp_lightcolor = make_color_rgb(color_get_red(temp_glight.color), color_get_green(temp_glight.color), color_get_blue(temp_glight.color))
	
	// Directional Light Vectors Surface
	surface_set_target(surface_vectors);
	draw_clear_alpha(make_color_rgb(round(255 * temp_light_vectorx), round(255 * temp_light_vectory), 255), 1);
	surface_reset_target();
	
	// Directional Light Blend Surface
	surface_set_target(surface_blend);
	draw_clear(merge_color(temp_lightcolor, c_black, 1.0 - temp_lightintensity));
	surface_reset_target();
	
	// Copy Surface
	surface_set_target(surface_temp);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	surface_copy(surface_temp, 0, 0, surface_light);
	
	// Shadows Surface Calculation
	surface_set_target(surface_shadows);
	draw_clear_alpha(c_white, 0);
	with(oSolid) {
		draw_sprite_ext(sDebugSolidShadow, 0, x - other.x, y - other.y, image_xscale, image_yscale, image_angle, c_white, 1);
	}
	surface_reset_target();
	
	// Calculate Lighting
	shader_set(shd_forwardlighting);
	
	texture_set_stage(sprite_normals, surface_get_texture(surface_normals));
	texture_set_stage(light_vectors, surface_get_texture(surface_vectors));
	texture_set_stage(light_blend, surface_get_texture(surface_blend));
	texture_set_stage(light_shadows, surface_get_texture(surface_shadows));
	texture_set_stage(light_render, surface_get_texture(surface_temp));
	
	surface_set_target(surface_light);
	draw_sprite_stretched(sDebugLights, 0, 0, 0, screen_width, screen_height);
	surface_reset_target();
	
	shader_reset();
}

// Render Directional Lights
for (var i = 0; i < instance_number(oDirectionalLight); i++) {
	// Find Directional Light
	var temp_dlight = instance_find(oDirectionalLight, i);
	
	// Directional Light Variables
	var temp_lightangle = degtorad(temp_dlight.angle);
	var temp_lightintensity = temp_dlight.intensity;
	var temp_lightcolor = make_color_rgb(color_get_red(temp_dlight.color), color_get_green(temp_dlight.color), color_get_blue(temp_dlight.color))
	
	// Directional Light Vectors Surface
	surface_set_target(surface_vectors);
	var temp_dlight_vector_x = round(127 + (85 * -cos(temp_lightangle)));
	var temp_dlight_vector_y = round(127 + (85 * sin(temp_lightangle)));
	draw_clear_alpha(make_color_rgb(temp_dlight_vector_x, temp_dlight_vector_y, 255), 1);
	surface_reset_target();
	
	// Directional Light Blend Surface
	surface_set_target(surface_blend);
	draw_clear(merge_color(temp_lightcolor, c_black, 1.0 - temp_lightintensity));
	surface_reset_target();
	
	// Copy Surface
	surface_set_target(surface_temp);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	surface_copy(surface_temp, 0, 0, surface_light);
	
	// Shadows Surface Calculation
	surface_set_target(surface_shadows);
	draw_clear_alpha(c_white, 0);
	
	shader_set(shd_directionallightshadows);
	shader_set_uniform_f(shadow_directionallight_angle, temp_lightangle);
	vertex_submit(shadows_vertex_buffer, pr_trianglelist, -1);
	shader_reset();
	
	with(oSolid) {
		draw_sprite_ext(sDebugSolidShadow, 0, x - other.x, y - other.y, image_xscale, image_yscale, image_angle, c_white, 1);
	}
	
	surface_reset_target();
	
	// Calculate Lighting
	shader_set(shd_forwardlighting);
	
	texture_set_stage(sprite_normals, surface_get_texture(surface_normals));
	texture_set_stage(light_vectors, surface_get_texture(surface_vectors));
	texture_set_stage(light_blend, surface_get_texture(surface_blend));
	texture_set_stage(light_shadows, surface_get_texture(surface_shadows));
	texture_set_stage(light_render, surface_get_texture(surface_temp));
	
	surface_set_target(surface_light);
	draw_sprite_stretched(sDebugLights, 0, 0, 0, screen_width, screen_height);
	surface_reset_target();
	
	shader_reset();
}

// Render Point Lights
for (var i = 0; i < instance_number(oPointLight); i++) {
	// Find Point Light
	var temp_plight = instance_find(oPointLight, i);
	
	// Point Light Variables
	var temp_lightrange = (temp_plight.range / 32) * 2;
	var temp_lightintensity = temp_plight.intensity;
	var temp_lightcolor = make_color_rgb(color_get_red(temp_plight.color), color_get_green(temp_plight.color), color_get_blue(temp_plight.color));
	
	// Point Light Vectors Surface
	surface_set_target(surface_vectors);
	draw_clear_alpha(make_color_rgb(127, 127, 255), 1);
	
	shader_set(shd_pointlightvector);
	draw_sprite_ext(sDebugLights, 0, temp_plight.x - x, temp_plight.y - y, temp_lightrange, temp_lightrange, 0, c_white, 1);
	shader_reset();
	
	surface_reset_target();
	
	// Point Light Blend Surface
	surface_set_target(surface_blend);
	draw_clear_alpha(c_black, 0);
	
	shader_set(shd_pointlightfade);
	draw_sprite_ext(sDebugLights, 0, temp_plight.x - x, temp_plight.y - y, temp_lightrange, temp_lightrange, 0, temp_lightcolor, temp_lightintensity);
	shader_reset();
	
	surface_reset_target();
	
	// Copy Surface
	surface_set_target(surface_temp);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	surface_copy(surface_temp, 0, 0, surface_light);
	
	// Shadows Surface Calculation
	surface_set_target(surface_shadows);
	draw_clear_alpha(c_white, 0);
	
	shader_set(shd_pointlightshadows);
	shader_set_uniform_f(shadow_pointlight_position, temp_plight.x - x, temp_plight.y - y);
	vertex_submit(shadows_vertex_buffer, pr_trianglelist, -1);
	shader_reset();
	
	with(oSolid) {
		draw_sprite_ext(sDebugSolidShadow, 0, x - other.x, y - other.y, image_xscale, image_yscale, image_angle, c_white, 1);
	}
	
	surface_reset_target();
	
	// Calculate Lighting
	shader_set(shd_forwardlighting);
	
	texture_set_stage(sprite_normals, surface_get_texture(surface_normals));
	texture_set_stage(light_vectors, surface_get_texture(surface_vectors));
	texture_set_stage(light_blend, surface_get_texture(surface_blend));
	texture_set_stage(light_shadows, surface_get_texture(surface_shadows));
	texture_set_stage(light_render, surface_get_texture(surface_temp));
	
	surface_set_target(surface_light);
	draw_sprite_stretched(sDebugLights, 0, 0, 0, screen_width, screen_height);
	surface_reset_target();
	
	shader_reset();
}

// Draw Lighting Background
//draw_set_color(c_black);
//draw_rectangle(x - 10, y - 10, x + screen_width + 10, y + screen_height + 10, false);

// Draw Black Objects Background Surface
//shader_set(shd_black);
//draw_surface(surface_color, x, y);
//shader_reset();

// Draw Lighting Surface
shader_set(shd_drawlitsurface);

texture_set_stage(light_texture, surface_get_texture(surface_light));

draw_set_color(tint);
draw_surface(surface_color, x, y);
draw_set_color(c_white);

shader_reset();