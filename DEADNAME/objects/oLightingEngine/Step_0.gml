/// @description Update Event
// You can write your code in this editor

//
ds_list_clear(directional_light_collisions_list);

if (instance_exists(oLightingEngine_Source_DirectionalLight))
{
	directional_light_collisions_exist = 0 < collision_rectangle_list
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
}
