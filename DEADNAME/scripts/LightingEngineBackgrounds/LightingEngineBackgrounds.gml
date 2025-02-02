

function lighting_engine_add_background(background_sprite_index, background_blend = c_white, background_offset_x = 0, background_offset_y = 0, background_horizontal_tile = true, background_vertical_tile = false, background_horizontal_speed = 0, background_vertical_speed = 0, background_horizontal_parallax_movement = 0, background_vertical_parallax_movement = 0, background_horizontal_parallax_lock = false, background_vertical_parallax_lock = false)
{
	// Create Layer
	var temp_layer_id = layer_create(LightingEngine.lighting_engine_background_depth - ds_list_size(LightingEngine.lighting_engine_backgrounds), $"LightingEngine_Background_{ds_list_size(LightingEngine.lighting_engine_backgrounds)}");
	
	// Create Background
	var temp_background_layer_id = layer_background_create(temp_layer_id, background_sprite_index);
	
	// Create Background Struct
	var temp_lighting_engine_background = 
	{
		layer_id: temp_layer_id,
		background_layer_id: temp_background_layer_id,
		offset_x: ((GameManager.game_width * 0.5) + LightingEngine.render_border) - (sprite_get_width(background_sprite_index) * 0.5) + background_offset_x,
		offset_y: ((GameManager.game_height * 0.5) + LightingEngine.render_border) - (sprite_get_height(background_sprite_index) * 0.5) + background_offset_y,
		movement_x: 0,
		movement_y: 0,
		movement_speed_x: background_horizontal_speed,
		movement_speed_y: background_vertical_speed,
		parallax_horizontal_movement: background_horizontal_parallax_movement,
		parallax_vertical_movement: background_vertical_parallax_movement,
		parallax_horizontal_lock: background_horizontal_parallax_lock,
		parallax_vertical_lock: background_vertical_parallax_lock,
		background_width: sprite_get_width(background_sprite_index),
		background_height: sprite_get_height(background_sprite_index)
	}
	
	// Set Background Properties
	layer_background_htiled(temp_background_layer_id, background_horizontal_tile);
	layer_background_vtiled(temp_background_layer_id, background_vertical_tile);
	
	layer_background_blend(temp_background_layer_id, background_blend);
	
	// Index Background in DS List
	ds_list_add(LightingEngine.lighting_engine_backgrounds, temp_lighting_engine_background);
	ds_list_add(LightingEngine.lighting_engine_background_layer_ids, temp_layer_id);
}

function lighting_engine_draw_background_begin()
{
	if (event_type == ev_draw and event_number == ev_draw_normal)
    {
        surface_set_target(LightingEngine.background_surface);
    }
}

function lighting_engine_draw_background_end()
{
	if (event_type == ev_draw and event_number == ev_draw_normal)
    {
        surface_reset_target();
    }
}

