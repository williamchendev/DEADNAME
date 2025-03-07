/// @description Screen Space Culling
// Checks whether or not to display this Region Culling Group if within range of the Camera

region_render_enabled = rectangle_in_rectangle
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