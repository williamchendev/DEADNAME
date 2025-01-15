/// @description Debug Draw Event
// Draws Game Manager Debug Info to the screen

// Cursor Position
var temp_cursor_x = round(game_width * (window_mouse_get_x() / window_get_width()));
var temp_cursor_y = round(game_height * (window_mouse_get_y() / window_get_height()));

//
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

if (cursor_inventory) 
{
	draw_sprite(sCursorMenu, 0, temp_cursor_x, temp_cursor_y);
	cursor_inventory = false;
}
else if (cursor_icon) 
{
	// Draw Cursor Icon
	draw_sprite(sInteractCursorIcons, cursor_index, temp_cursor_x, temp_cursor_y);
	cursor_icon = false;
}
else 
{
	// Draw Cursor Crosshair
	draw_sprite(sCursorCrosshairIcons, 1, temp_cursor_x, temp_cursor_y);
}

//
surface_reset_target();

// Check if Debugging mode is active 
if (global.debug and global.debug_surface_enabled) 
{
	//
	surface_set_target(LightingEngine.debug_surface);
	
	// Camera GUI Layer
	var temp_camera_x = 0;
	var temp_camera_y = 0;
	
	temp_camera_x = camera_get_view_x(view_camera[view_current]);
	temp_camera_y = camera_get_view_y(view_camera[view_current]);
	
	// Draw Set Font
	draw_set_font(font_Inno);
	
	// Draw Debug Mode Active
	draw_text_outline(temp_camera_x + debug_x_offset, temp_camera_y + debug_y_offset, "Debug Mode Active");
	
	// Draw Debug Variable Bracket
	draw_set_color(c_black);
	draw_line(temp_camera_x + debug_x_offset - 2, temp_camera_y + debug_y_offset + 15, temp_camera_x + debug_x_offset + 97, temp_camera_y + debug_y_offset + 15);
	draw_line(temp_camera_x + debug_x_offset - 3, temp_camera_y + debug_y_offset + 16, temp_camera_x + debug_x_offset + 98, temp_camera_y + debug_y_offset + 16);
	draw_line(temp_camera_x + debug_x_offset - 2, temp_camera_y + debug_y_offset + 17, temp_camera_x + debug_x_offset + 97, temp_camera_y + debug_y_offset + 17);
	draw_set_color(c_white);
	draw_line(temp_camera_x + debug_x_offset - 2, temp_camera_y + debug_y_offset + 16, temp_camera_x + debug_x_offset + 97, temp_camera_y + debug_y_offset + 16);
	
	// Draw Time Modifier
	debug_fps_timer -= frame_delta;
	
	if (debug_fps_timer <= 0) 
	{
		debug_fps = round(fps_real);
		debug_fps_timer = 2;
	}
	
	draw_text_outline(temp_camera_x + debug_x_offset, temp_camera_y + debug_y_offset + 17, $"DeltaTime: {frame_delta}");
	draw_text_outline(temp_camera_x + debug_x_offset, temp_camera_y + debug_y_offset + 28, $"Target FPS: {game_get_speed(gamespeed_fps)}");
	draw_text_outline(temp_camera_x + debug_x_offset, temp_camera_y + debug_y_offset + 39, $"Real FPS: {debug_fps}");
	
	//
	surface_reset_target();
}
