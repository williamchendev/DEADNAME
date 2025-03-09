/// @description Update Backgrounds
// Updates movement for all Backgrounds Integrated with the Lighting Engine

// Background Update Behaviour
for (var temp_background_index = 0; temp_background_index < ds_list_size(lighting_engine_backgrounds); temp_background_index++)
{
	// Find Background Struct
	var temp_background_struct = ds_list_find_value(lighting_engine_backgrounds, temp_background_index);
	
	// Calculate Background Movement and Parallax
	temp_background_struct.movement_x = (temp_background_struct.movement_x + temp_background_struct.movement_speed_x * frame_delta) mod temp_background_struct.background_width;
	temp_background_struct.movement_y = (temp_background_struct.movement_y + temp_background_struct.movement_speed_y * frame_delta) mod temp_background_struct.background_height;
	
	var temp_background_parallax_x = temp_background_struct.offset_x - (render_x * temp_background_struct.parallax_horizontal_movement);
	var temp_background_parallax_y = temp_background_struct.offset_y - (render_y * temp_background_struct.parallax_vertical_movement);
	
	// Set Background Offset, Movement, and Parallax
	layer_x
	(
		temp_background_struct.layer_id, 
		temp_background_struct.parallax_horizontal_lock ? clamp(temp_background_struct.movement_x + temp_background_parallax_x, GameManager.game_width + render_border - temp_background_struct.background_width, render_border) : temp_background_struct.movement_x + temp_background_parallax_x
	);
	
	layer_y
	(
		temp_background_struct.layer_id, 
		temp_background_struct.parallax_vertical_lock ? clamp(temp_background_struct.movement_y + temp_background_parallax_y, GameManager.game_height + render_border - temp_background_struct.background_height, render_border) : temp_background_struct.movement_y + temp_background_parallax_y
	);
	
	// Set Background Color & Bloom
	layer_background_blend(temp_background_struct.layer_id, temp_background_struct.color);
	layer_background_alpha(temp_background_struct.layer_id, temp_background_struct.bloom);
}