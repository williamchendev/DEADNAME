/// @description Lighting Engine Update Event
// Lighting Engine Directional Light Shadow Collision Detection

// Clear Directional Shadow Collisions
ds_list_clear(directional_light_collisions_list);

// Update Directional Shadow Collisions
if (instance_exists(oLightingEngine_Source_DirectionalLight))
{
	var temp_directional_light_solid_collisions_exist = 0 < collision_rectangle_list
	(
		render_x - render_directional_shadows_border, 
		render_y - render_directional_shadows_border, 
		render_x + GameManager.game_width + render_directional_shadows_border, 
		render_y + GameManager.game_height + render_directional_shadows_border, 
		oSolid, 
		false, 
		true, 
		directional_light_collisions_list, 
		false
	);
	
	var temp_directional_light_box_shadows_exist = noone != collision_rectangle
	(
		render_x - render_directional_shadows_border, 
		render_y - render_directional_shadows_border, 
		render_x + GameManager.game_width + render_directional_shadows_border, 
		render_y + GameManager.game_height + render_directional_shadows_border, 
		oLightingEngine_BoxShadow_Static, 
		false, 
		true 
	);
	
	directional_light_collisions_exist = temp_directional_light_solid_collisions_exist or temp_directional_light_box_shadows_exist;
}
