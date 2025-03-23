/// @description 

// Check if Debug Mode is Enabled
if (!global.debug)
{
    // Debug Mode is not Enabled, Disable Menu Behaviours
    return;
}

// Reset Mouse Click Variables
ribbon_menu_tab_hover_select_index = -1;
ribbon_menu_window_option_hover_select_index = -1;

window_header_hover_select_index = -1;
window_exit_button_hover_select_index = -1;

// Set Debug Menu Font for Collision Detection
draw_set_font(debug_menu_font);

// Ribbon Menu Tab Mouse Selection
var temp_ribbon_menu_width = 0;

for (var i = 0; i < array_length(ribbon_menu_tabs); i++)
{
    // Check Mouse Point with Ribbon Menu Tab's Collision Rectangle
    var temp_ribbon_menu_tab_x = ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width - 1;
    var temp_ribbon_menu_tab_mouse_collision = point_in_rectangle
    (
        GameManager.cursor_x, 
        GameManager.cursor_y, 
        temp_ribbon_menu_tab_x - ribbon_menu_tab_selection_hitbox_padding, 
        0, 
        temp_ribbon_menu_tab_x + string_width(ribbon_menu_tabs[i].tab_name) + ribbon_menu_tab_selection_hitbox_padding, 
        ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing
    );
    
    //
    if (temp_ribbon_menu_tab_mouse_collision)
    {
        //
        if (ribbon_menu_tab_hover_select_index != i)
        {
            ribbon_menu_window_option_hover_select_index = -1;
        }
        
        //
        ribbon_menu_tab_hover_select_index = i;
    }
    
    // Check Mouse Point with Ribbon Menu Tab Window Options Collision Rectangle
    if (ribbon_menu_tab_clicked_select_index == i)
    {
        // Ribbon Menu Tab Window Option Selection
        var temp_ribbon_tab_drop_down_window_y = ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing + ribbon_menu_option_window_vertical_offset;
        
        // Draw Ribbon Menu Tab Window Options
        for (var temp_ribbon_menu_option_index = 0; temp_ribbon_menu_option_index < array_length(ribbon_menu_tabs[i].tab_options); temp_ribbon_menu_option_index++)
        {
            //
            var temp_ribbon_menu_tab_window_option_collision = point_in_rectangle
            (
                GameManager.cursor_x, 
                GameManager.cursor_y, 
                ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width - (ribbon_menu_horizontal_spacing / 2), 
                temp_ribbon_tab_drop_down_window_y - (ribbon_menu_option_window_vertical_padding / 2), 
                ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width - (ribbon_menu_horizontal_spacing / 2) + ribbon_menu_tabs[i].tab_window_width + ribbon_menu_option_window_horizontal_padding, 
                temp_ribbon_tab_drop_down_window_y + debug_menu_font_height + (ribbon_menu_option_window_vertical_padding / 2)
            );
            
            //
            if (temp_ribbon_menu_tab_window_option_collision)
            {
                //
                ribbon_menu_tab_hover_select_index = i;
                ribbon_menu_window_option_hover_select_index = temp_ribbon_menu_option_index;
                
                //
                break;
            }
            
            // Increment Option Vertical Padding
            temp_ribbon_tab_drop_down_window_y += ribbon_menu_option_window_vertical_padding + debug_menu_font_height;
        }
    }
    
    // Increment Ribbon Menu Width
    temp_ribbon_menu_width += ribbon_menu_horizontal_spacing + string_width(ribbon_menu_tabs[i].tab_name);
}

// Window Behaviour
for (var w = 0; w < ds_list_size(windows_ds_list); w++)
{
	// Find Window
	var temp_window = ds_list_find_value(windows_ds_list, w);
	
	// Window Header Drag
	if (window_header_clicked_select_index == w and mouse_check_button(mb_left))
	{
		temp_window.window_x = round(GameManager.cursor_x + window_cursor_x_offset);
		temp_window.window_y = round(GameManager.cursor_y + window_cursor_y_offset);
	}
	
	// Clamp Window Position
	temp_window.window_x = clamp(temp_window.window_x, 0, GameManager.game_width - temp_window.window_width - (window_border * 2));
	temp_window.window_y = clamp(temp_window.window_y, ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing + 1, GameManager.game_height - temp_window.window_height - (window_border * 2) - window_header);
	
	//
	var temp_window_collision = point_in_rectangle
    (
        GameManager.cursor_x, 
        GameManager.cursor_y, 
        temp_window.window_x, 
        temp_window.window_y, 
        temp_window.window_x + temp_window.window_width + (window_border * 2), 
        temp_window.window_y + temp_window.window_height + (window_border * 2) + window_header
    );
	
	var temp_window_header_collision = point_in_rectangle
    (
        GameManager.cursor_x, 
        GameManager.cursor_y, 
        temp_window.window_x, 
        temp_window.window_y, 
        temp_window.window_x + temp_window.window_width + (window_border * 2), 
        temp_window.window_y + window_header
    );
    
    var temp_window_exit_button_collision = point_in_rectangle
    (
        GameManager.cursor_x, 
        GameManager.cursor_y, 
        temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset - (window_exit_button_size / 2), 
		temp_window.window_y + (window_header / 2) - (window_exit_button_size / 2) + 1,
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset + (window_exit_button_size / 2), 
		temp_window.window_y + (window_header / 2) + (window_exit_button_size / 2) + 1,
    );
    
    if (temp_window_exit_button_collision)
    {
    	window_exit_button_hover_select_index = w;
    }
    else if (temp_window_header_collision)
    {
    	window_header_hover_select_index = w;
    }
    else if (temp_window_collision)
    {
    	window_header_hover_select_index = -1;
    	window_exit_button_hover_select_index = -1;
    	
    	if (temp_window.window_type == DebugMenuWindowType.ContentScroll)
    	{
    		if (mouse_wheel_up())
	    	{
	    		temp_window.window_scroll_index--;
	    	}
	    	else if (mouse_wheel_down())
	    	{
	    		temp_window.window_scroll_index++;
	    	}
	    	
	    	temp_window.window_scroll_index = clamp(temp_window, 0, array_length(temp_window.window_scroll_text) - 1);
    	}
    }
}

// Debug Menu Mouse Behaviour
if (mouse_check_button_pressed(mb_left))
{
    // Ribbon Menu Tab Selection
    if (ribbon_menu_tab_hover_select_index == -1)
    {
        //
        ribbon_menu_tab_clicked_select_index = -1;
        
        //
        ribbon_menu_window_option_clicked = false;
        ribbon_menu_window_option_clicked_select_index = -1;
        
        //
        if (window_exit_button_hover_select_index != -1)
    	{
    		//
    		window_exit_button_clicked = true;
    		window_exit_button_clicked_select_index = window_exit_button_hover_select_index;
    	}
    	else
    	{
    		//
    		window_exit_button_clicked = false;
    		window_exit_button_clicked_select_index = -1;
    		
    		//
    		if (window_header_hover_select_index != -1)
		    {
		    	//
		    	window_header_clicked_select_index = window_header_hover_select_index;
		    	
		    	//
		    	window_cursor_x_offset = ds_list_find_value(windows_ds_list, window_header_clicked_select_index).window_x - GameManager.cursor_x;
				window_cursor_y_offset = ds_list_find_value(windows_ds_list, window_header_clicked_select_index).window_y - GameManager.cursor_y;
		    }
		    else
		    {
		    	//
		    	window_header_clicked_select_index = -1;
		    }
    	}
    }
    else
    {
    	//
    	window_header_hover_select_index = -1;
    	window_header_clicked_select_index = -1;
    	
    	window_exit_button_clicked = false;
		window_exit_button_hover_select_index = -1;
		window_exit_button_clicked_select_index = -1;
		
        //
        ribbon_menu_tab_clicked_select_index = ribbon_menu_tab_hover_select_index;
        
        //
        if (ribbon_menu_window_option_hover_select_index != -1)
        {
            ribbon_menu_window_option_clicked = true;
            ribbon_menu_window_option_clicked_select_index = ribbon_menu_window_option_hover_select_index;
        }
    }
    
    // Pathfinding Debug Path Widget Behaviour
    /*
    if (pathfinding_debug_path_widgets_enabled)
    {
    	// Remove Previous Path
    	if (!is_undefined(debug_path))
    	{
    		ds_list_destroy(debug_path);
    		debug_path = -1;
    	}
    	
    	// Set New Debug Path Coordinates
    	debug_path_start_x = GameManager.cursor_x + LightingEngine.render_x;
    	debug_path_start_y = GameManager.cursor_y + LightingEngine.render_y;
    	
    	// Recalculate Path
    	debug_path = pathfinding_get_path(debug_path_start_x, debug_path_start_y, debug_path_end_x, debug_path_end_y);
    	
    	// Print Out Path Details
    	show_debug_message("// Path Details");
    	
    	if (!is_undefined(debug_path))
    	{
    		for (var temp_path_index = 0; temp_path_index < ds_list_size(debug_path); temp_path_index++)
	    	{
	    		// Find Path Point
	    		var temp_path_point = ds_list_find_value(debug_path, temp_path_index);
	    		
	    		// Print Path Details
	    		show_debug_message(string(temp_path_point));
	    	}
    	}
    	
    	show_debug_message("");
    }
    */
}
else if (mouse_check_button_pressed(mb_right))
{
    // Pathfinding Debug Path Widget Behaviour
    if (pathfinding_debug_path_widgets_enabled)
    {
    	// Remove Previous Path
    	if (!is_undefined(debug_path))
    	{
    		ds_list_destroy(debug_path);
    		debug_path = -1;
    	}
    	
    	// Set New Debug Path Coordinates
    	debug_path_end_x = GameManager.cursor_x + LightingEngine.render_x;
    	debug_path_end_y = GameManager.cursor_y + LightingEngine.render_y;
    	
    	// Recalculate Path
    	debug_path = pathfinding_get_path(debug_path_start_x, debug_path_start_y, debug_path_end_x, debug_path_end_y);
    	
    	// Print Out Path Details
    	show_debug_message("// Path Details");
    	
    	if (!is_undefined(debug_path))
    	{
    		for (var temp_path_index = 0; temp_path_index < ds_list_size(debug_path); temp_path_index++)
	    	{
	    		// Find Path Point
	    		var temp_path_point = ds_list_find_value(debug_path, temp_path_index);
	    		
	    		// Print Path Details
	    		show_debug_message(string(temp_path_point));
	    	}
    	}
    	
    	show_debug_message("");
    }
}

if (mouse_check_button_released(mb_left))
{
    //
    if (ribbon_menu_window_option_clicked and ribbon_menu_window_option_hover_select_index == ribbon_menu_window_option_clicked_select_index)
    {
        if (!is_undefined(ribbon_menu_tabs[ribbon_menu_tab_clicked_select_index].tab_options[ribbon_menu_window_option_clicked_select_index].option_function))
        {
            ribbon_menu_tabs[ribbon_menu_tab_clicked_select_index].tab_options[ribbon_menu_window_option_clicked_select_index].option_function();
        }
    }
    
    //
    ribbon_menu_window_option_clicked = false;
    
    //
    if (window_exit_button_clicked_select_index == window_exit_button_hover_select_index)
    {
    	ds_list_delete(windows_ds_list, window_exit_button_clicked_select_index);
    }
    
    //
    window_header_clicked_select_index = -1;
    window_exit_button_clicked_select_index = -1;
}

// Pathfinding Widgets
if (pathfinding_widgets_enabled)
{
	debug_pathfinding_closest_point = pathfinder_get_closest_point_on_edge(GameManager.cursor_x + LightingEngine.render_x, GameManager.cursor_y + LightingEngine.render_y);
}