/// @description Screen Space Culling
// Checks whether or not to display this Bulk Static Group if within range of the Camera

bulk_static_group_render_enabled = !screen_space_culling ? true : rectangle_in_rectangle
(
	LightingEngine.render_x - LightingEngine.render_border, 
	LightingEngine.render_y - LightingEngine.render_border, 
	LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
	LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border, 
	bbox_left,
	bbox_top,
	bbox_right,
	bbox_bottom
);
