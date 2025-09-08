/// @description Early Step Event

// Reset Player Input Selection
input_interaction_selection = false;

// Calculate Cursor Position
cursor_x = round(game_width * (window_mouse_get_x() / window_get_width()));
cursor_y = round(game_height * (window_mouse_get_y() / window_get_height()));

// Toggle Debug Mode
if (keyboard_check_pressed(vk_f3)) 
{
	// Toggle Behaviour
	global.debug = !global.debug;
	
	// Create & Destroy Debug Menu
	if (global.debug)
	{
		if (is_undefined(debug_menu))
		{
			// Create Debug Menu
			debug_menu = instance_create_depth(0, 0, 0, oDebugMenu);
		}
	}
	else
	{
		if (!is_undefined(debug_menu))
		{
			// Destroy all instances of the Debug Menu
			with (oDebugMenu)
			{
				instance_destroy();
			}
			
			// Debug Menu is no longer accessible
			debug_menu = undefined;
		}
	}
}

// Game Fullscreen
if (keyboard_check_pressed(vk_f11)) 
{
	if (window_get_fullscreen()) 
	{
		set_game_resolution_mode(GameResolutionMode.Default640x360);
	}
	else 
	{
		set_game_resolution_mode(GameResolutionMode.FullScreen640x360);
	}
}

// Debug Create Shell Casing
if (keyboard_check(ord("K")))
{
	for (var i = 0; i < 5; i++)
	{
		var temp_shell_casing = instance_create_depth(cursor_x + LightingEngine.render_x, cursor_y + LightingEngine.render_y, 0, oFirearm_ShellCasing);
		
		with (temp_shell_casing)
		{
			physics_apply_impulse(x, y, random_range(-5, 5), random_range(-5, 5));
			physics_apply_angular_impulse(random_range(-5, 5));
		}
	}
}