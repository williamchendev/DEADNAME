/// @description Ragdoll Entity Update Event
// Performs calculations for the Ragdoll Entity Object

// Physics Movement Behaviour
if (held) 
{
	var px = ((mouse_x + LightingEngine.render_x) - x);
	var py = ((mouse_y + LightingEngine.render_y) - y);
	
	phy_speed_x = px;
	phy_speed_y = py;
	
	if (!mouse_check_button(mb_left)) 
	{
		held = false;
	}
}
else 
{
	if (mouse_check_button_pressed(mb_left)) 
	{
		if (position_meeting((mouse_x + LightingEngine.render_x), (mouse_y + LightingEngine.render_y), self)) 
		{
			with (oRagdollEntity) 
			{
				held = false;
			}
			
			held = true;
		}
	}
}

// Physics Object Culling
if (ragdoll_culled)
{
	// Check within Screen Space Rendering Bounds
	var temp_physics_object_within_rendering_bounds = collision_rectangle
	(
		LightingEngine.render_x - LightingEngine.render_border, 
		LightingEngine.render_y - LightingEngine.render_border, 
		LightingEngine.render_x + GameManager.game_width + LightingEngine.render_border, 
		LightingEngine.render_y + GameManager.game_height + LightingEngine.render_border,
		id,
		false,
		false
	);

	// Toggle Physics & Rendering if within Rendering Bounds
	physics_enabled = temp_physics_object_within_rendering_bounds;
	render_enabled = temp_physics_object_within_rendering_bounds;
}

if (phy_active != physics_enabled)
{
	phy_active = physics_enabled;
}

// Deltatime Physics
var temp_speed_change_x = phy_linear_velocity_x - phy_speed_old_x;
var temp_speed_change_y = phy_linear_velocity_y - phy_speed_old_y;
phy_linear_velocity_x = phy_speed_old_x + (temp_speed_change_x * frame_delta);
phy_linear_velocity_y = phy_speed_old_y + (temp_speed_change_y * frame_delta);

if (frame_delta < old_delta_time) 
{
	var temp_delta_delta_time = old_delta_time - frame_delta;
	
	phy_speed_x_bank += temp_delta_delta_time * phy_linear_velocity_x;
	phy_speed_y_bank += temp_delta_delta_time * phy_linear_velocity_y;
	
	phy_linear_velocity_x -= temp_delta_delta_time * phy_linear_velocity_x;
	phy_linear_velocity_y -= temp_delta_delta_time * phy_linear_velocity_y;
}
else if (frame_delta > old_delta_time) 
{
	var temp_bank_return = clamp((frame_delta - old_delta_time) / (1 - old_delta_time), 0.0, 1.0);
	
	phy_linear_velocity_x += phy_speed_x_bank * temp_bank_return;
	phy_linear_velocity_y += phy_speed_y_bank * temp_bank_return;
	
	phy_speed_x_bank -= phy_speed_x_bank * temp_bank_return;
	phy_speed_y_bank -= phy_speed_y_bank * temp_bank_return;
}

phy_speed_old_x = phy_linear_velocity_x;
phy_speed_old_y = phy_linear_velocity_y;

old_delta_time = frame_delta;
