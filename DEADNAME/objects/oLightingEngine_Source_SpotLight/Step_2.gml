/// @description Spot Light Movement & Rendering Detection
// Updates Spot Light's rendering to be culled when offscreen and detects new Solid Box Shadow Collisions

// Clamp Spot Light FOV
spot_light_fov = clamp(spot_light_fov, 0, 360);

// Screen Space Culling Behaviour - Detect if Spot Light is visible to the Camera
spot_light_render_enabled = rectangle_in_circle
(
    LightingEngine.render_x - LightingEngine.render_border, 
    LightingEngine.render_y - LightingEngine.render_border, 
    LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
    LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border,
    x,
    y,
    spot_light_radius
);

// Spot Light Movement Check
if (spot_light_render_enabled)
{
    // Spot Light Update Collisions Behaviour
    var temp_point_light_changed = (spot_light_radius != old_spot_light_radius) or (x != old_spot_light_position_x) or (y != old_spot_light_position_y) or (image_angle != old_spot_light_angle) or (spot_light_fov != old_spot_light_fov);
    
    if (temp_point_light_changed)
    {
		// Clear Previous Spot Light Solid Collider List
		ds_list_clear(spot_light_collisions_list);
		
		// Index all Solid Colliders for Shadow Rendering in Shadow Collision DS List
		collision_circle_list(x, y, spot_light_radius, oSolid, false, false, spot_light_collisions_list, false);
		
		// Update Movement Detection Variables
	    old_spot_light_radius = spot_light_radius;
	    old_spot_light_position_x = x;
	    old_spot_light_position_y = y;
	    old_spot_light_angle = image_angle;
		old_spot_light_fov = spot_light_fov;
    }
}