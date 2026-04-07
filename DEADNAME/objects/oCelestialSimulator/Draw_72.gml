/// @description Celestial UI Event
// Renders some UI for the Celestial Simulator

// Draw Selection Render Object if Celestial Simulator has a Selected Render Object Instance
if (instance_exists(render_object_selected_instance))
{
	// Set Celestial Simulator's UI Surface as Render Target
	surface_set_target(LightingEngine.ui_surface);
	
	// Check if Celestial Simulator's Selected Render Object is a City
	if (render_object_selected_instance.celestial_render_object_type == CelestialRenderObjectType.City)
	{
		// Set Draw Render Object City Name Text Alignment
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		
		// Establish Render Object City Name Position Variables
		var temp_city_name_x = render_object_selected_instance.x;
		var temp_city_name_y = render_object_selected_instance.y - (sprite_get_yoffset(render_object_selected_instance.sprite_index) - sprite_get_bbox_top(render_object_selected_instance.sprite_index)) + render_object_city_name_vertical_offset;
		
		// Draw City Name Text above Render Object City Sprite
		draw_text_outline(temp_city_name_x, temp_city_name_y, render_object_selected_instance.city_name, c_white, c_black);
	}
	
	// Draw Selected Render Object Instance
	with (render_object_selected_instance)
	{
		// Enable White Pixel Binary Shader
		shader_set(shd_white_pixel_binary);
		
		// Draw Selected Render Object's White Outline
		draw_sprite_ext(sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, image_blend, 1);
		draw_sprite_ext(sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, image_blend, 1);
		draw_sprite_ext(sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, image_blend, 1);
		draw_sprite_ext(sprite_index, image_index, x, y + 1, image_xscale, image_yscale, image_angle, image_blend, 1);
		
		// Reset Shader
		shader_reset();
		
		// Draw Selected Render Object Instance
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 1);
	}
	
	// Reset Surface Target
	surface_reset_target();
}