/// @description Outline & UI Surfaces
// Calculates and draws the outline and UI of the Squad when selected

// Draw Outline Active Check
if (!outline_draw_event) {
	return;
}
outline_draw_event = false;

// Interact Outline
if (squad_select_draw_value > 0) {
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
	if (!surface_exists(squad_surface)) {
		squad_surface = surface_create(temp_surface_width, temp_surface_height);
	}
	
	// Draw Interact Object Surface
	surface_set_target(squad_surface);
	draw_clear_alpha(squad_select_outline_color, 0);
	
	// Draw Squad Outlines
	for (var i = 0; i < ds_list_size(squad_units_list); i++) {
		// Find Squad Unit
		var temp_squad_inst = ds_list_find_value(squad_units_list, i);
		
		// Draw Instance
		if (object_is_ancestor(temp_squad_inst.object_index, oBasic) or temp_squad_inst.object_index == oBasic) {
			// Combat Unit Draw Behaviour
			if (object_is_ancestor(temp_squad_inst.object_index, oUnitCombat) or (temp_squad_inst.object_index == oUnitCombat)) {
				// Limb Draw Behaviour
				for (var q = 0; q < temp_squad_inst.limbs; q++) {
					// Draw Limbs
					with (temp_squad_inst.limb[q]) {
						var temp_lit_draw_event = lit_draw_event;
						lit_draw_event = true;
						event_perform(ev_draw, 0);
						lit_draw_event = temp_lit_draw_event;
					}
				}
			
				// Weapon Draw Behaviour
				for (var p = 0; p < ds_list_size(temp_squad_inst.inventory.weapons); p++) {
					// Find Indexed Weapon
					var temp_weapon_index = ds_list_find_value(temp_squad_inst.inventory.weapons, p);
					with (temp_weapon_index) {
						// Set Position
						x = x - temp_surface_x;
						y = y - temp_surface_y;
			
						var temp_lit_draw_event = lit_draw_event;
						lit_draw_event = true;
						event_perform(ev_draw, 0);
						lit_draw_event = temp_lit_draw_event;
					
						// Reset Position
						x = x + temp_surface_x;
						y = y + temp_surface_y;
					}
				}
			}
				
			// Draw All Unit Elements
			with (temp_squad_inst) {
				// Set Position
				x = x - temp_surface_x;
				y = y - temp_surface_y;
					
				// Draw Object
				var temp_lit_draw_event = lit_draw_event;
				lit_draw_event = true;
				event_perform(ev_draw, 0);
				lit_draw_event = temp_lit_draw_event;
					
				// Reset Position
				x = x + temp_surface_x;
				y = y + temp_surface_y;
			}
		}
		else {
			// Draw Unlit Interact Object
			with (temp_squad_inst) {
				// Set Position
				x = x - temp_surface_x;
				y = y - temp_surface_y;
				
				// Draw Interact
				event_perform(ev_draw, 0);
			
				// Reset Position
				x = x + temp_surface_x;
				y = y + temp_surface_y;
			}
		}
	}
	
	// Draw Icon Selection
	if (squad_outline_icon) {
		draw_sprite(sSquadIcons, squad_icon_index, x - temp_surface_x, y - temp_surface_y);
	}
	
	surface_reset_target();
	
	// Draw Interact Object Outline Surface
	surface_set_target(temp_surface);
	draw_clear_alpha(squad_select_second_outline_color, 0);
	
	// Generate First Outline
	var temp_outline_texel_width = texture_get_texel_width(surface_get_texture(squad_surface));
	var temp_outline_texel_height = texture_get_texel_height(surface_get_texture(squad_surface));
	
	shader_set(shd_outline);
	shader_set_uniform_f(uniform_pixel_width, temp_outline_texel_width);
	shader_set_uniform_f(uniform_pixel_height, temp_outline_texel_height);
	
	draw_set_color(squad_select_outline_color);
	draw_set_alpha(squad_select_draw_value * squad_select_draw_value);
	draw_surface(squad_surface, 0, 0);
	surface_reset_target();
	
	draw_surface(squad_surface, temp_surface_x, temp_surface_y);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	// Reset Shader
	shader_reset();
	
	// Redraw unoutlined Sprite to Temp Surface
	surface_set_target(temp_surface);
	draw_surface(squad_surface, 0, 0);
	surface_reset_target();
	
	// Generate Second Outline
	temp_outline_texel_width = texture_get_texel_width(surface_get_texture(temp_surface));
	temp_outline_texel_height = texture_get_texel_height(surface_get_texture(temp_surface));
	
	shader_set(shd_outline);
	shader_set_uniform_f(uniform_pixel_width, temp_outline_texel_width);
	shader_set_uniform_f(uniform_pixel_height, temp_outline_texel_height);
	
	// Draw Outer Outline
	draw_set_color(squad_select_second_outline_color);
	draw_set_alpha(squad_select_draw_value * squad_select_draw_value);
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
	if (surface_exists(squad_surface)) {
		surface_free(squad_surface);
		squad_surface = -1;
	}
}

// Draw Following Unit
if (squad_follow) {
	if (squad_units_list != -1) {
		if (squad_follow_unit != noone) {
			if (instance_exists(squad_follow_unit)) {
				var temp_squad_unit_inst = ds_list_find_value(squad_units_list, 0);
				var temp_squad_follow_unit_x = lerp(squad_follow_unit.bbox_left, squad_follow_unit.bbox_right, 0.5);
				var temp_squad_follow_unit_y = lerp(squad_follow_unit.bbox_top, squad_follow_unit.bbox_bottom, 0.5);
				var temp_squad_center_unit_x = lerp(temp_squad_unit_inst.bbox_left, temp_squad_unit_inst.bbox_right, 0.5);
				var temp_squad_center_unit_y = lerp(temp_squad_unit_inst.bbox_top, temp_squad_unit_inst.bbox_bottom, 0.5);
				draw_set_color(squad_selected_outline_color);
				draw_line(temp_squad_follow_unit_x, temp_squad_follow_unit_y, temp_squad_center_unit_x, temp_squad_center_unit_y);
				draw_circle(temp_squad_follow_unit_x, temp_squad_follow_unit_y, 3.5, false);
				draw_circle(temp_squad_center_unit_x, temp_squad_center_unit_y, 3.5, false);
				draw_set_color(c_white);
			}
		}
	}
}

// Draw Squad Icon
draw_sprite(sSquadIcons, squad_icon_index, x, y);