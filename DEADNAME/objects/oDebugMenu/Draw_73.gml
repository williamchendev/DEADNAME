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
	
	// Draw Level Platforms & Collision Widgets
	if (level_platforms_and_collisions_widgets_enabled)
	{
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
	}
	
	// Draw Pathfinding Widgets
	if (pathfinding_widgets_enabled)
	{
		// Centered Text Alignment
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);

	    // Draw Edges
	    for (var temp_edge_index = 0; temp_edge_index < ds_list_size(GameManager.pathfinding_edge_exists_list); temp_edge_index++)
	    {
	        // Check if Edge Exists
	        if (ds_list_find_value(GameManager.pathfinding_edge_exists_list, temp_edge_index))
	        {
	            // Edge Exists - Draw Edge Widget
	            var temp_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_edge_index);
	            var temp_edge_nodes = ds_list_find_value(GameManager.pathfinding_edge_nodes_list, temp_edge_index);
	            var temp_edge_weight = ds_list_find_value(GameManager.pathfinding_edge_weights_list, temp_edge_index);
	            
	            // Find Edge Node Indexes
	            var temp_edge_first_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_nodes.first_node_id);
	            var temp_edge_second_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_nodes.second_node_id);
	            
	            // Find Edge Node Data
	            var temp_edge_first_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_edge_first_node_index);
	            var temp_edge_second_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_edge_second_node_index);
	            
	            // Draw Edge Widget
	            draw_set_color(color_indigo_blue);
	            draw_line_width(temp_edge_first_node.node_position_x - LightingEngine.render_x, temp_edge_first_node.node_position_y - LightingEngine.render_y, temp_edge_second_node.node_position_x - LightingEngine.render_x, temp_edge_second_node.node_position_y - LightingEngine.render_y, 3);
	            
	            draw_set_color(color_cerulean_blue);
	            draw_line_width(temp_edge_first_node.node_position_x - LightingEngine.render_x, temp_edge_first_node.node_position_y - LightingEngine.render_y, temp_edge_second_node.node_position_x - LightingEngine.render_x, temp_edge_second_node.node_position_y - LightingEngine.render_y, 1);
	        }
	    }
	    
	    // Draw Nodes
	    for (var temp_node_id = ds_map_find_first(GameManager.pathfinding_node_ids_map); !is_undefined(temp_node_id); temp_node_id = ds_map_find_next(GameManager.pathfinding_node_ids_map, temp_node_id)) 
        {
        	// Find Node Index
        	var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_node_id);
        	
        	// Find Node Data
        	var temp_node_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_node_index);
        	
        	// Draw Node
        	draw_set_color(color_indigo_blue);
        	draw_line_width(temp_node_struct.anchor_position_x - LightingEngine.render_x, temp_node_struct.anchor_position_y - LightingEngine.render_y, temp_node_struct.node_position_x - LightingEngine.render_x, temp_node_struct.node_position_y - LightingEngine.render_y, 2);
        	draw_circle(temp_node_struct.anchor_position_x - LightingEngine.render_x, temp_node_struct.anchor_position_y - LightingEngine.render_y, 3, false);
        	
        	draw_set_color(color_light_blue);
        	draw_circle(temp_node_struct.node_position_x - LightingEngine.render_x, temp_node_struct.node_position_y - LightingEngine.render_y, 8, false);
        	draw_set_color(color_cerulean_blue);
        	draw_circle(temp_node_struct.node_position_x - LightingEngine.render_x, temp_node_struct.node_position_y - LightingEngine.render_y, 6, false);
        	draw_set_color(color_indigo_blue);
        	draw_circle(temp_node_struct.node_position_x - LightingEngine.render_x, temp_node_struct.node_position_y - LightingEngine.render_y, 4, false);
        }
        
        //
        if (pathfinding_node_info_widgets_enabled)
        {
        	for (var temp_node_id = ds_map_find_first(GameManager.pathfinding_node_ids_map); !is_undefined(temp_node_id); temp_node_id = ds_map_find_next(GameManager.pathfinding_node_ids_map, temp_node_id)) 
	        {
	        	// Find Node Index
	        	var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_node_id);
	        	
	        	// Find Node Data
	        	var temp_node_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_node_index);
	        	var temp_node_edges = ds_list_find_value(GameManager.pathfinding_node_edges_list, temp_node_index);
	        	
	        	//
	        	var temp_node_edges_text = "{ ";
	        	
	        	for (var q = 0; q < ds_list_size(temp_node_edges); q++)
	        	{
	        		temp_node_edges_text += $"{ds_list_find_value(temp_node_edges, q)} ";
	        	}
	        	
	        	temp_node_edges_text += "}";
	        	
	        	// Print Node Information
	            draw_text_outline(temp_node_struct.node_position_x - LightingEngine.render_x, temp_node_struct.node_position_y - LightingEngine.render_y - 60, $"Node ID: {temp_node_id}");
	            draw_text_outline(temp_node_struct.node_position_x - LightingEngine.render_x, temp_node_struct.node_position_y - LightingEngine.render_y - 58 + debug_menu_font_height, temp_node_edges_text);
	        }
        }
        
        // Draw Edges
        if (pathfinding_edge_info_widgets_enabled)
        {
        	for (var temp_edge_index = 0; temp_edge_index < ds_list_size(GameManager.pathfinding_edge_exists_list); temp_edge_index++)
		    {
		        // Check if Edge Exists
		        if (ds_list_find_value(GameManager.pathfinding_edge_exists_list, temp_edge_index))
		        {
		            // Edge Exists - Draw Edge Widget
		            var temp_edge_type = ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_edge_index);
		            var temp_edge_nodes = ds_list_find_value(GameManager.pathfinding_edge_nodes_list, temp_edge_index);
		            var temp_edge_weight = ds_list_find_value(GameManager.pathfinding_edge_weights_list, temp_edge_index);
		            
		            // Find Edge Node Indexes
		            var temp_edge_first_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_nodes.first_node_id);
		            var temp_edge_second_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_edge_nodes.second_node_id);
		            
		            // Find Edge Node Data
		            var temp_edge_first_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_edge_first_node_index);
		            var temp_edge_second_node = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_edge_second_node_index);
		            
		            // Find Midway Position between both Nodes
		            var temp_edge_center_x = lerp(temp_edge_first_node.node_position_x, temp_edge_second_node.node_position_x, 0.5) - LightingEngine.render_x;
		            var temp_edge_center_y = lerp(temp_edge_first_node.node_position_y, temp_edge_second_node.node_position_y, 0.5) - LightingEngine.render_y;
		            
		            // Print Edge Information
		            draw_text_outline(temp_edge_center_x, temp_edge_center_y, temp_edge_type == 1 ? "Jump" : $"Distance: {temp_edge_weight.distance_weight}");
		        }
		    }
        }
        
        // Draw Closest Point on Pathfinding Map to Cursor
        if (debug_pathfinding_closest_point.edge_id != undefined)
        {
            draw_set_color(color_pale_dogwood);
            draw_circle(debug_pathfinding_closest_point.return_x - LightingEngine.render_x, debug_pathfinding_closest_point.return_y - LightingEngine.render_y, 7, false);
            
            draw_set_color(color_rose_taupe);
            draw_circle(debug_pathfinding_closest_point.return_x - LightingEngine.render_x, debug_pathfinding_closest_point.return_y - LightingEngine.render_y, 5, false);
        }
	}

	if (pathfinding_debug_path_widgets_enabled and !is_undefined(debug_path))
    {
    	for (var temp_path_index = 1; temp_path_index < ds_list_size(debug_path); temp_path_index++)
    	{
    		// Find Path Points
    		var temp_path_point_a = ds_list_find_value(debug_path, temp_path_index - 1);
    		var temp_path_point_b = ds_list_find_value(debug_path, temp_path_index);
    		
    		// Draw Edge Widget
            draw_set_color(color_rose_taupe);
            draw_line_width(temp_path_point_a.position_x - LightingEngine.render_x, temp_path_point_a.position_y - LightingEngine.render_y, temp_path_point_b.position_x - LightingEngine.render_x, temp_path_point_b.position_y - LightingEngine.render_y, 4);
            
            draw_set_color(color_pale_dogwood);
            draw_line_width(temp_path_point_a.position_x - LightingEngine.render_x, temp_path_point_a.position_y - LightingEngine.render_y, temp_path_point_b.position_x - LightingEngine.render_x, temp_path_point_b.position_y - LightingEngine.render_y, 2);
    	}
    	
    	for (var temp_path_index = 0; temp_path_index < ds_list_size(debug_path); temp_path_index++)
    	{
    		// Find Path Points
    		var temp_path_point = ds_list_find_value(debug_path, temp_path_index);
    		
    		// Draw Node Widget
            draw_set_color(color_rose_taupe);
            draw_circle(temp_path_point.position_x - LightingEngine.render_x, temp_path_point.position_y - LightingEngine.render_y, 6, false);
            
            draw_set_color(color_pale_dogwood);
            draw_circle(temp_path_point.position_x - LightingEngine.render_x, temp_path_point.position_y - LightingEngine.render_y, 5, false);
    	}
    }
	
	// Draw Box Shadows Widgets
	if (lighting_engine_box_shadows_widgets_enabled)
	{
	    // Draw Box Shadows to Debug Surface
	    with (oLightingEngine_BoxShadow_Static)
	    {
	    	draw_sprite_ext(object_get_name(object_index) == "oLightingEngine_BoxShadow_Dynamic" ? sDebug_Lighting_BoxShadow_Centered : sDebug_Lighting_BoxShadow, 0, x - LightingEngine.render_x, y - LightingEngine.render_y, image_xscale, image_yscale, image_angle, image_blend, 1);
	    }
	}
	
	// Draw Lighting Engine Light Source Widgets
	if (lighting_engine_light_sources_widgets_enabled)
	{
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

// Draw Windows
for (var w = 0; w < ds_list_size(windows_ds_list); w++)
{
	// Find Window
	var temp_window = ds_list_find_value(windows_ds_list, w);
	
	// Draw Window Background
	draw_set_color(color_cerulean_blue);
	draw_rectangle(temp_window.window_x, temp_window.window_y, temp_window.window_x + temp_window.window_width + (window_border * 2), temp_window.window_y + temp_window.window_height + (window_border * 2) + window_header, false);

	draw_set_color(color_indigo_blue);
	draw_rectangle(temp_window.window_x + window_border, temp_window.window_y + window_border + window_header, temp_window.window_x + temp_window.window_width + window_border, temp_window.window_y + temp_window.window_height + window_border + window_header, false);
	
	// Draw Window Header Title
	draw_set_color(color_light_blue);
	draw_text(temp_window.window_x + window_title_horizontal_offset, temp_window.window_y + (window_header / 2) - (debug_menu_font_height / 2) + 1, temp_window.window_title);
	
	// Draw Windox Exit Button
	if (window_exit_button_clicked and window_exit_button_clicked_select_index == w and window_exit_button_hover_select_index == w)
	{
		draw_set_color(color_rose_taupe);
		draw_rectangle
		(
			temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset - (window_exit_button_size / 2) - 1, 
			temp_window.window_y + (window_header / 2) - (window_exit_button_size / 2),
			temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset + (window_exit_button_size / 2) + 1, 
			temp_window.window_y + (window_header / 2) + (window_exit_button_size / 2) + 2,
			false
		);
	}
	
	draw_set_color((window_exit_button_clicked and window_exit_button_clicked_select_index == w and window_exit_button_hover_select_index == w) ? color_pale_dogwood : color_rose_taupe);
	draw_rectangle
	(
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset - (window_exit_button_size / 2), 
		temp_window.window_y + (window_header / 2) - (window_exit_button_size / 2) + 1,
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset + (window_exit_button_size / 2), 
		temp_window.window_y + (window_header / 2) + (window_exit_button_size / 2) + 1,
		false
	);
	
	// Draw Window Exit Button Cross
	draw_set_color((window_exit_button_clicked and window_exit_button_clicked_select_index == w and window_exit_button_hover_select_index == w) ? color_rose_taupe : color_pale_dogwood);
	draw_line_width
	(
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset - (window_exit_button_size / 2) + 1, 
		temp_window.window_y + (window_header / 2) - (window_exit_button_size / 2) + 2,
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset + (window_exit_button_size / 2) - 1, 
		temp_window.window_y + (window_header / 2) + (window_exit_button_size / 2),
		2
	);
	
	draw_line_width
	(
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset + (window_exit_button_size / 2) - 1, 
		temp_window.window_y + (window_header / 2) - (window_exit_button_size / 2) + 1,
		temp_window.window_x + temp_window.window_width + (window_border * 2) - window_exit_button_horizontal_offset - (window_exit_button_size / 2) + 1, 
		temp_window.window_y + (window_header / 2) + (window_exit_button_size / 2) - 1,
		2
	);
	
	switch (temp_window.window_type)
	{
		case DebugMenuWindowType.ContentScroll:
			
		
			//
			draw_set_color(color_light_blue);
			
			for (var q = 0; q < array_length(temp_window.window_scroll_text); q++)
			{
				//
				var temp_window_scroll_text_line = temp_window.window_scroll_text[q];
				
				if (string_width(temp_window_scroll_text_line) > temp_window.window_width - (window_content_text_horizontal_padding * 2))
				{
					for (var l = string_length(temp_window_scroll_text_line); l > 0; l--)
					{
						//
						var temp_window_scroll_text_line_truncated = $"{string_copy(temp_window_scroll_text_line, 0, l)}...";
						
						if (string_width(temp_window_scroll_text_line_truncated) <= temp_window.window_width - (window_content_text_horizontal_padding * 2))
						{
							//
							temp_window_scroll_text_line = temp_window_scroll_text_line_truncated;
							break;
						}
					}
				}
				
				//
				draw_text
				(
					temp_window.window_x + window_border + window_content_text_horizontal_padding,
					temp_window.window_y + window_border + window_header + window_content_text_vertical_padding + ((q + 1) * (debug_menu_font_height + 4)),
					temp_window_scroll_text_line
				);
			}
			
			//
			draw_set_color(color_rose_taupe);
			
			draw_rectangle
			(
				temp_window.window_x + window_border, 
				temp_window.window_y + window_header + window_border,
				temp_window.window_x + temp_window.window_width + window_border, 
				temp_window.window_y + window_header + window_border + window_content_text_vertical_padding + debug_menu_font_height,
				false
			);
			
			draw_rectangle
			(
				temp_window.window_x + window_border, 
				temp_window.window_y + temp_window.window_height + window_header + window_border - window_content_text_vertical_padding,
				temp_window.window_x + temp_window.window_width + window_border, 
				temp_window.window_y + temp_window.window_height + window_header + window_border,
				false
			);
			break;
		case DebugMenuWindowType.Regular:
		default:
			break;
	}
	// Draw Window Content
	draw_set_color(color_light_blue);
	draw_text_ext
	(
		temp_window.window_x + window_border + window_content_text_horizontal_padding, 
		temp_window.window_y + window_border + window_header + window_content_text_vertical_padding,  
		temp_window.window_content,
		2,
		temp_window.window_width - (window_content_text_horizontal_padding * 2)
	);
}

// Draw Debug Menu - Ribbon Menu Tabs
var temp_ribbon_menu_width = 0;

for (var i = 0; i < array_length(ribbon_menu_tabs); i++)
{
    // Check if Ribbon Menu Tab was Selected
    if (ribbon_menu_tab_hover_select_index == i or ribbon_menu_tab_clicked_select_index == i)
    {
        // Ribbon Tab Selection Highlight Color
        draw_set_color(color_light_blue);
        
        // Draw Highlight Color Tab Rectangle Behind Ribbon Tab Title
        draw_rectangle
        (
            ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width - (ribbon_menu_horizontal_spacing / 2), 
            0, 
            ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width + string_width(ribbon_menu_tabs[i].tab_name) + (ribbon_menu_horizontal_spacing / 2) - 2, 
            ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing, 
            false
        );
        
        // Selected Ribbon Menu Text Color
        draw_set_color(color_cerulean_blue);
        
        // Draw Ribbon Menu Tab Title Text
        draw_text(ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width, ribbon_menu_start_vertical_offset, ribbon_menu_tabs[i].tab_name);
        
        // Check if Ribbon Menu Tab was Click Selected
        if (ribbon_menu_tab_clicked_select_index == i)
        {
            // Ribbon Menu Tab Window Position
            var temp_ribbon_tab_drop_down_window_x = ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width - (ribbon_menu_horizontal_spacing / 2);
            var temp_ribbon_tab_drop_down_window_y = ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing + ribbon_menu_option_window_vertical_offset;
            
            // Ribbon Window Selection Highlight Color
            draw_set_color(color_light_blue);
            
            // Draw Highlight Color Tab Rectangle Behind Ribbon Tab Title
            draw_rectangle
            (
                temp_ribbon_tab_drop_down_window_x, 
                temp_ribbon_tab_drop_down_window_y, 
                temp_ribbon_tab_drop_down_window_x + ribbon_menu_tabs[i].tab_window_width + ribbon_menu_option_window_horizontal_padding, 
                temp_ribbon_tab_drop_down_window_y + ((ribbon_menu_option_window_vertical_padding + debug_menu_font_height) * array_length(ribbon_menu_tabs[i].tab_options)), 
                false
            );
            
            // Draw Ribbon Menu Tab Window Options
            for (var temp_ribbon_menu_option_index = 0; temp_ribbon_menu_option_index < array_length(ribbon_menu_tabs[i].tab_options); temp_ribbon_menu_option_index++)
            {
                //
                var temp_ribbon_menu_option_highlighted = ribbon_menu_window_option_hover_select_index == temp_ribbon_menu_option_index;
                var temp_ribbon_menu_option_clicked = ribbon_menu_window_option_clicked and ribbon_menu_window_option_clicked_select_index == temp_ribbon_menu_option_index;
                
                if (temp_ribbon_menu_option_highlighted)
                {
                    //
                    draw_set_color(temp_ribbon_menu_option_clicked ? color_rose_taupe : color_indigo_blue);
                    
                    //
                    draw_rectangle
                    (
                        temp_ribbon_tab_drop_down_window_x, 
                        temp_ribbon_tab_drop_down_window_y, 
                        temp_ribbon_tab_drop_down_window_x + ribbon_menu_tabs[i].tab_window_width + ribbon_menu_option_window_horizontal_padding, 
                        temp_ribbon_tab_drop_down_window_y + debug_menu_font_height + ribbon_menu_option_window_vertical_padding,
                        false
                    );
                }
                
                // Tab Window Option Title Text Color
                draw_set_color(temp_ribbon_menu_option_clicked ? color_pale_dogwood : (temp_ribbon_menu_option_highlighted ? color_light_blue : color_cerulean_blue));
                
                // Draw Ribbon Menu Tab Window Option Title
                draw_text(temp_ribbon_tab_drop_down_window_x + (ribbon_menu_option_window_horizontal_padding / 2), temp_ribbon_tab_drop_down_window_y + (ribbon_menu_option_window_vertical_padding / 2), ribbon_menu_tabs[i].tab_options[temp_ribbon_menu_option_index].option_name);
                
                // Ribbon Menu Tab Window Option Toggle Box
                if (!is_undefined(ribbon_menu_tabs[i].tab_options[temp_ribbon_menu_option_index].option_toggle))
                {
                    var temp_toggle_box_x = temp_ribbon_tab_drop_down_window_x + ribbon_menu_tabs[i].tab_window_width + ribbon_menu_option_window_horizontal_padding - ribbon_menu_option_toggle_box_horizontal_padding;
                    var temp_toggle_box_y = temp_ribbon_tab_drop_down_window_y + (ribbon_menu_option_window_vertical_padding / 2) + (debug_menu_font_height / 2);
                    
                    // Draw Toggle Box Background
                    draw_set_color(color_pale_dogwood);
                    
                    draw_rectangle
                    (
                        temp_toggle_box_x - (ribbon_menu_option_toggle_box_size / 2),
                        temp_toggle_box_y - (ribbon_menu_option_toggle_box_size / 2),
                        temp_toggle_box_x + (ribbon_menu_option_toggle_box_size / 2),
                        temp_toggle_box_y + (ribbon_menu_option_toggle_box_size / 2),
                        false
                    );
                    
                    // Draw Toggle Box Outline
                    draw_set_color(color_rose_taupe);
                    
                    draw_rectangle
                    (
                        temp_toggle_box_x - (ribbon_menu_option_toggle_box_size / 2),
                        temp_toggle_box_y - (ribbon_menu_option_toggle_box_size / 2),
                        temp_toggle_box_x + (ribbon_menu_option_toggle_box_size / 2),
                        temp_toggle_box_y + (ribbon_menu_option_toggle_box_size / 2),
                        true
                    );
                    
                    // Draw Toggle Checkmark
                    if (ribbon_menu_tabs[i].tab_options[temp_ribbon_menu_option_index].option_toggle())
                    {
                        draw_line_width
                        (
                            temp_toggle_box_x,
                            temp_toggle_box_y + (ribbon_menu_option_toggle_box_size / 2) - 1,
                            temp_toggle_box_x - (ribbon_menu_option_toggle_box_size / 2) - 2,
                            temp_toggle_box_y - 3,
                            3
                        );
                        
                        draw_line_width
                        (
                            temp_toggle_box_x,
                            temp_toggle_box_y + (ribbon_menu_option_toggle_box_size / 2) - 1,
                            temp_toggle_box_x + (ribbon_menu_option_toggle_box_size / 2) + 1,
                            temp_toggle_box_y - (ribbon_menu_option_toggle_box_size / 2) - 3,
                            3
                        );
                    }
                }
                
                // Increment Option Vertical Padding
                temp_ribbon_tab_drop_down_window_y += ribbon_menu_option_window_vertical_padding + debug_menu_font_height;
            }
        }
    }
    else
    {
        // Default Ribbon Menu Text Color
        draw_set_color(color_light_blue);
        
        // Draw Ribbon Menu Tab Title Text
        draw_text(ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width, ribbon_menu_start_vertical_offset, ribbon_menu_tabs[i].tab_name);
    }
    
    // Increment Ribbon Menu Width
    temp_ribbon_menu_width += ribbon_menu_horizontal_spacing + string_width(ribbon_menu_tabs[i].tab_name);
}

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);

// Draw Debug Menu Name & Version in Bottom Left Corner
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

draw_text_outline(debug_menu_info_and_version_horizontal_offset, GameManager.game_height - debug_menu_info_and_version_vertical_offset, $"{debug_menu_info_text} v{debug_menu_version_text}");

// Draw Debug FPS Counter
if (fps_counter)
{
    //
    var temp_fps_counter_x = debug_menu_info_and_version_horizontal_offset + string_width("FPS Counter: 000000");
    var temp_fps_counter_y = GameManager.game_height - debug_menu_info_and_version_vertical_offset - debug_menu_font_height - debug_menu_info_vertical_padding;
    
    //
    var temp_fps_quality = min(1.3, 60 / fps_real);
    
    //
    draw_text_outline(debug_menu_info_and_version_horizontal_offset, temp_fps_counter_y, $"FPS Counter: {floor(fps_real)}");
    
    //
    draw_set_color(c_gray);
    draw_rectangle(temp_fps_counter_x, temp_fps_counter_y - (fps_counter_height / 2) - (debug_menu_font_height / 2), temp_fps_counter_x + (fps_counter_width * 1.3), temp_fps_counter_y + (fps_counter_height / 2) - (debug_menu_font_height / 2), false);
    
    //
    draw_set_color(temp_fps_quality < 0.8 ? c_green : (temp_fps_quality <= 1.0 ? c_yellow : c_red));
    draw_rectangle(temp_fps_counter_x, temp_fps_counter_y - (fps_counter_height / 2) - (debug_menu_font_height / 2), temp_fps_counter_x + (fps_counter_width * temp_fps_quality), temp_fps_counter_y + (fps_counter_height / 2) - (debug_menu_font_height / 2), false);
    
    //
    draw_set_color(c_white);
    draw_line(temp_fps_counter_x + fps_counter_width, temp_fps_counter_y - (fps_counter_height / 2) - (debug_menu_font_height / 2) - 2, temp_fps_counter_x + fps_counter_width, temp_fps_counter_y + (fps_counter_height / 2) - (debug_menu_font_height / 2) + 1);
}

// Draw Cursor to Debug Menu
draw_sprite(sCursorMenu, 0, GameManager.cursor_x, GameManager.cursor_y);

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