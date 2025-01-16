/// @description Point Light Movement & Rendering Detection
// Updates Point Light's rendering to be culled when offscreen and detects new Solid Box Shadow Collisions

// Screen Space Culling Behaviour - Detect if Point Light is visible to the Camera
point_light_render_enabled = rectangle_in_circle
(
    LightingEngine.render_x - LightingEngine.render_border, 
    LightingEngine.render_y - LightingEngine.render_border, 
    LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
    LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border,
    x,
    y,
    point_light_radius
);

// Point Light Movement Check
if (point_light_render_enabled)
{
    // Point Light Update Collisions Behaviour
    var temp_point_light_changed = (point_light_radius != old_point_light_radius) or (x != old_point_light_position_x) or (y != old_point_light_position_y);
    
    if (temp_point_light_changed)
    {
		// Clear Previous Point Light Solid Collider List
		ds_list_clear(point_light_collisions_list);
		
		// Index all Solid Colliders for Shadow Rendering in Shadow Collision DS List
        collision_circle_list(x, y, point_light_radius, oSolid, false, false, point_light_collisions_list, false);
        
        // Update Movement Detection Variables
	    old_point_light_radius = point_light_radius;
	    old_point_light_position_x = x;
	    old_point_light_position_y = y;
    }
}