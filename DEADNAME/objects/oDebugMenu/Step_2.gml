/// @description 

// Check if Debug Mode is Enabled
if (!global.debug)
{
    // Debug Mode is not Enabled, Disable Menu Behaviours
    return;
}

// Reset Ribbon Menu Hover Selection Index
ribbon_menu_tab_hover_select_index = -1;
ribbon_menu_window_option_hover_select_index = -1;

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
    }
    else
    {
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
}