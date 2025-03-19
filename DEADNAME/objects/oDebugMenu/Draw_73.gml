/// @description Insert description here
// You can write your code in this editor

// Check if Debug Mode is Enabled
if (!global.debug)
{
    // Debug Mode is not Enabled, Hide Menu
    return;
}

// Draw Debug Widgets to Debug Surface
if (global.debug_surface_enabled)
{
	// Check if Debug Surface Exists
	if (!surface_exists(LightingEngine.debug_surface))
	{
		return;
	}
	
	// Set Debug Surface as Surface Target
	surface_set_target(LightingEngine.debug_surface);
	
	// Draw Platforms to Debug Surface
	with (oPlatform)
	{
		draw_sprite_ext(sprite_index, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, image_xscale, image_yscale, image_angle, image_blend, 1);
	}
	
	// Draw Solid Colliders to Debug Surface
	with (oSolid)
	{
		draw_sprite_ext(sprite_index, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, image_xscale, image_yscale, image_angle, image_blend, 1);
	}
	
	// Draw Point Light Source to Debug Surface
	with (oLightingEngine_Source_PointLight)
	{
		draw_sprite_ext(sDebug_Lighting_Icon_PointLight, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, 1, 1, image_angle, image_blend, 0.5 + (image_alpha * 0.5));
	}
	
	// Draw Spot Light Source to Debug Surface
	with (oLightingEngine_Source_SpotLight)
	{
		draw_sprite_ext(sDebug_Lighting_Icon_SpotLight, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, 1, 1, image_angle, image_blend, 0.5 + (image_alpha * 0.5));
	}
	
	// Draw Ambient Light Source to Debug Surface
	with (oLightingEngine_Source_AmbientLight)
	{
		draw_sprite_ext(sDebug_Lighting_Icon_AmbientOcclusionLight, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, 1, 1, image_angle, image_blend, 0.5 + (image_alpha * 0.5));
	}
	
	// Draw Directional Light Source to Debug Surface
	with (oLightingEngine_Source_DirectionalLight)
	{
		draw_sprite_ext(sDebug_Lighting_Icon_DirectionalLight, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, 1, 1, image_angle, image_blend, 0.5 + (image_alpha * 0.5));
	}
	
	// Reset Surface Target
	surface_reset_target();
}

// Draw Debug Menu to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Draw Set Font & Top Left Font Alignment
draw_set_font(debug_menu_font);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Draw Debug Menu - Top Ribbon Menu
draw_set_color(color_indigo_blue);
draw_rectangle(0, 0, GameManager.game_width, ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing + 3, false);

draw_set_color(color_cerulean_blue);
draw_rectangle(0, 0, GameManager.game_width, ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing, false);



// Draw Debug Menu - Ribbon Menu Options
var temp_ribbon_menu_width = 0;

for (var i = 0; i < array_length(ribbon_menu_options); i++)
{
    // Check if Ribbon Menu Option was Selected
    if (ribbon_menu_option_hover_select_index == i)
    {
        //
        draw_set_color(color_light_blue);
        
        // 
        draw_rectangle
        (
            ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width - (ribbon_menu_horizontal_spacing / 2), 
            0, 
            ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width + string_width(ribbon_menu_options[i].option_name) + (ribbon_menu_horizontal_spacing / 2) - 2, 
            ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing, 
            false
        );
        
        // Hover Selected Ribbon Menu Text Color
        draw_set_color(color_cerulean_blue);
        
        // Draw Ribbon Menu Option
        draw_text(ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width, ribbon_menu_start_vertical_offset, ribbon_menu_options[i].option_name);
    }
    else
    {
        // Default Ribbon Menu Text Color
        draw_set_color(color_light_blue);
        
        // Draw Ribbon Menu Option
        draw_text(ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width, ribbon_menu_start_vertical_offset, ribbon_menu_options[i].option_name);
    }
    
    // Increment Ribbon Menu Width
    temp_ribbon_menu_width += ribbon_menu_horizontal_spacing + string_width(ribbon_menu_options[i].option_name);
}

// Draw Debug Mode Active


// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

// Draw Debug Menu Name & Version in Bottom Left Corner
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

draw_text_outline(debug_menu_info_and_version_horizontal_offset, GameManager.game_height - debug_menu_info_and_version_vertical_offset, $"{debug_menu_info_text} v{debug_menu_version_text}");

// Cursor Position
var temp_cursor_x = round(GameManager.game_width * (window_mouse_get_x() / window_get_width()));
var temp_cursor_y = round(GameManager.game_height * (window_mouse_get_y() / window_get_height()));

// Draw Cursor to Debug Menu
draw_sprite(sCursorMenu, 0, temp_cursor_x, temp_cursor_y);

// Reset Surface Target
surface_reset_target();

/*
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