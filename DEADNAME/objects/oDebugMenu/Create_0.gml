/// @description Insert description here
// You can write your code in this editor

// Debug Menu Font Settings
debug_menu_font = font_Inno;

// Color Settings
color_light_blue = make_color_rgb(193, 238, 255);
color_cerulean_blue = make_color_rgb(55, 113, 142);
color_indigo_blue = make_color_rgb(37, 78, 112);

color_pale_dogwood = make_color_rgb(223, 187, 177);
color_rose_taupe = make_color_rgb(150, 97, 107);

// Info & Version Settings
debug_menu_info_text = "DEADNAME Debug Menu - Capy Crucible";
debug_menu_version_text = "0.23b";

debug_menu_info_and_version_horizontal_offset = 6;
debug_menu_info_and_version_vertical_offset = 6;

debug_menu_info_vertical_padding = 4;

// Ribbon Menu Tab Settings
ribbon_menu_start_horizontal_offset = 8;
ribbon_menu_start_vertical_offset = 2;

ribbon_menu_horizontal_spacing = 20;
ribbon_menu_vertical_spacing = 3;

ribbon_menu_tab_selection_hitbox_padding = 2;

// Ribbon Menu Option Window Settings
ribbon_menu_option_window_vertical_offset = 1;

ribbon_menu_option_window_horizontal_padding = 12;
ribbon_menu_option_window_vertical_padding = 4;

ribbon_menu_option_toggle_box_horizontal_offset = 9;
ribbon_menu_option_toggle_box_horizontal_padding = 10;

ribbon_menu_option_toggle_box_size = 7;

// Debug Menu Widget Settings
fps_counter = false;
fps_counter_width = 60;
fps_counter_height = 8;

debug_path = undefined;
debug_path_start_x = 0;
debug_path_start_y = 0;
debug_path_end_x = 0;
debug_path_end_y = 0;

level_platforms_and_collisions_widgets_enabled = false;
lighting_engine_light_sources_widgets_enabled = false;
lighting_engine_box_shadows_widgets_enabled = false;
pathfinding_widgets_enabled = false;
pathfinding_node_info_widgets_enabled = false;
pathfinding_edge_info_widgets_enabled = false;
pathfinding_debug_path_widgets_enabled = false;

// Debug Menu Rendering Settings
rendering_foreground_light_map_enabled = false;
rendering_midground_light_map_enabled = false;
rendering_background_light_map_enabled = false;

rendering_normal_map_enabled = false;
rendering_metallic_map_enabled = false;
rendering_roughness_map_enabled = false;
rendering_depth_map_enabled = false;

// Debug Menu Pathfinding Settings
pathfinding_edit_mode = false;

// Debug Menu Ribbon Menu Variables
ribbon_menu_tab_hover_select_index = -1;
ribbon_menu_tab_clicked_select_index = -1;

ribbon_menu_window_option_clicked = false;
ribbon_menu_window_option_hover_select_index = -1;
ribbon_menu_window_option_clicked_select_index = -1;

// Debug Menu Shader Indexes
debug_metallic_map_printout_normal_texture_index = shader_get_sampler_index(shd_print_metallic_map, "gm_NormalMap_Texture");
debug_roughness_map_printout_normal_texture_index = shader_get_sampler_index(shd_print_roughness_map, "gm_NormalMap_Texture");

// Debug Menu Functions
reset_rendering_options = function()
{
    rendering_foreground_light_map_enabled = false;
    rendering_midground_light_map_enabled = false;
    rendering_background_light_map_enabled = false;

    rendering_normal_map_enabled = false;
    rendering_metallic_map_enabled = false;
    rendering_roughness_map_enabled = false;
    rendering_depth_map_enabled = false;
}

// Ribbon Menu
enum DebugMenuRibbonMenuTabs
{
    Game,
    Resolution,
    Scene,
    Lighting,
    Pathfinding,
    Rendering,
    OptionTemplate
}

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Game] = 
{
    tab_name: "Game",
    tab_options: 
    [
        {
            option_name: "Title Screen",
            option_function: function()
            {
                room_goto(_TitleScreen);
            },
            option_toggle: undefined
        },
        {
            option_name: "FPS Counter",
            option_function: function()
            {
                GameManager.debug_menu.fps_counter = !GameManager.debug_menu.fps_counter;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.fps_counter;
            }
        },
        {
            option_name: "Gamemaker Debug Overlay",
            option_function: function()
            {
                GameManager.debug_overlay_enabled = !GameManager.debug_overlay_enabled;
                show_debug_overlay(GameManager.debug_overlay_enabled);
            },
            option_toggle: function()
            {
                return GameManager.debug_overlay_enabled;
            }
        },
        {
            option_name: "Exit Game",
            option_function: function() 
            {
                // Exit Game
			    game_end();
            },
            option_toggle: undefined
        }
    ]
};

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Resolution] = 
{
    tab_name: "Resolution",
    tab_options: 
    [
        {
            option_name: "Default Resolution Mode",
            option_function: function()
            {
                GameManager.set_game_resolution_mode(GameResolutionMode.Default640x360);
            },
            option_toggle: undefined
        },
        {
            option_name: "Scale x1 Resolution Mode",
            option_function: function()
            {
                GameManager.set_game_resolution_mode(GameResolutionMode.Single640x360);
            },
            option_toggle: undefined
        },
        {
            option_name: "Scale x2 Resolution Mode",
            option_function: function()
            {
                GameManager.set_game_resolution_mode(GameResolutionMode.Double640x360);
            },
            option_toggle: undefined
        },
        {
            option_name: "Debug Wide-Screen Resolution Mode",
            option_function: function()
            {
                GameManager.set_game_resolution_mode(GameResolutionMode.Debug1280x720);
            },
            option_toggle: undefined
        }
    ]
};

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Scene] = 
{
    tab_name: "Scene",
    tab_options: 
    [
        {
            option_name: "Show/Hide Platform and Collision Widgets",
            option_function: function()
            {
                GameManager.debug_menu.level_platforms_and_collisions_widgets_enabled = !GameManager.debug_menu.level_platforms_and_collisions_widgets_enabled;
            },
            option_toggle: function()
            {
                 return GameManager.debug_menu.level_platforms_and_collisions_widgets_enabled;
            }
        },
        {
            option_name: "Reload Scene",
            option_function: function()
            {
                room_restart();
            },
            option_toggle: undefined
        }
    ]
};

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Lighting] = 
{
    tab_name: "Lighting",
    tab_options: 
    [
        {
            option_name: "Show/Hide Light Source Widgets",
            option_function: function()
            {
                GameManager.debug_menu.lighting_engine_light_sources_widgets_enabled = !GameManager.debug_menu.lighting_engine_light_sources_widgets_enabled;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.lighting_engine_light_sources_widgets_enabled;
            }
        },
        {
            option_name: "Show/Hide Box Shadow Widgets",
            option_function: function()
            {
                GameManager.debug_menu.lighting_engine_box_shadows_widgets_enabled = !GameManager.debug_menu.lighting_engine_box_shadows_widgets_enabled;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.lighting_engine_box_shadows_widgets_enabled;
            }
        }
    ]
};

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Pathfinding] = 
{
    tab_name: "Pathfinding",
    tab_options: 
    [
        {
            option_name: "Show/Hide Pathfinding Widgets",
            option_function: function()
            {
                GameManager.debug_menu.pathfinding_widgets_enabled = !GameManager.debug_menu.pathfinding_widgets_enabled;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.pathfinding_widgets_enabled;
            }
        },
        {
            option_name: "Enter Pathfinding Map Edit Mode",
            option_function: function()
            {
                GameManager.debug_menu.pathfinding_edit_mode = !GameManager.debug_menu.pathfinding_edit_mode;
                
                if (GameManager.debug_menu.pathfinding_edit_mode)
                {
                    GameManager.debug_menu.ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Pathfinding].tab_options[1].option_name = "Exit Pathfinding Map Edit Mode";
                    GameManager.debug_menu.level_platforms_and_collisions_widgets_enabled = true;
                    GameManager.debug_menu.pathfinding_widgets_enabled = true;
                }
                else
                {
                    GameManager.debug_menu.ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Pathfinding].tab_options[1].option_name = "Enter Pathfinding Map Edit Mode";
                    GameManager.debug_menu.level_platforms_and_collisions_widgets_enabled = false;
                    GameManager.debug_menu.pathfinding_widgets_enabled = false;
                }
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.pathfinding_edit_mode;
            }
        },
        {
            option_name: "Save Scene File",
            option_function: pathfinding_save_level_data,
            option_toggle: undefined
        },
        {
            option_name: "Load Scene File",
            option_function: pathfinding_load_level_data,
            option_toggle: undefined
        },
        {
            option_name: "Clear Scene Data",
            option_function: pathfinding_clear_level_data,
            option_toggle: undefined
        },
        {
            option_name: "Print Console Scene Data",
            option_function: function()
            {
            	//
                var temp_pathfinding_data_report = $"// Scene \"{room_get_name(room)}\" Pathfinding Data";
                temp_pathfinding_data_report += $"\n// File Path \"{GameManager.data_directory}Levels\\{room_get_name(room)}.txt\"";
                
                //
                temp_pathfinding_data_report += "\n\n// Scene Nodes";
                
                for (var temp_node_id = ds_map_find_first(GameManager.pathfinding_node_ids_map); !is_undefined(temp_node_id); temp_node_id = ds_map_find_next(GameManager.pathfinding_node_ids_map, temp_node_id)) 
                {
                	// Find Node Index
                	var temp_node_index = ds_map_find_value(GameManager.pathfinding_node_ids_map, temp_node_id);
                	
                	// Find Node Data
                	var temp_node_struct = ds_list_find_value(GameManager.pathfinding_node_struct_list, temp_node_index);
                	
                	// Add Node Data
                	temp_pathfinding_data_report += $"\nNode_ID:{temp_node_id}, Node_X:{temp_node_struct.node_position_x}, Node_Y:{temp_node_struct.node_position_y}";
                }
                
                //
                temp_pathfinding_data_report += "\n\n// Scene Edges";
                
                for (var temp_edge_id = ds_map_find_first(GameManager.pathfinding_edge_ids_map); !is_undefined(temp_edge_id); temp_edge_id = ds_map_find_next(GameManager.pathfinding_edge_ids_map, temp_edge_id)) 
                {
                	// Find Edge Index
                	var temp_edge_index = ds_map_find_value(GameManager.pathfinding_edge_ids_map, temp_edge_id);
                	
                	// Add Node Data
                	temp_pathfinding_data_report += $"\nEdge_ID:{temp_edge_id}, Edge_Type:{ds_list_find_value(GameManager.pathfinding_edge_types_list, temp_edge_index)}";
                }
                
                //
                temp_pathfinding_data_report += "\n";
                show_debug_message(temp_pathfinding_data_report);
            },
            option_toggle: undefined
        },
        {
            option_name: "Show Node Details",
            option_function: function()
            {
                GameManager.debug_menu.pathfinding_node_info_widgets_enabled = !GameManager.debug_menu.pathfinding_node_info_widgets_enabled;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.pathfinding_node_info_widgets_enabled;
            }
        },
        {
            option_name: "Show Edge Details",
            option_function: function()
            {
                GameManager.debug_menu.pathfinding_edge_info_widgets_enabled = !GameManager.debug_menu.pathfinding_edge_info_widgets_enabled;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.pathfinding_edge_info_widgets_enabled;
            }
        },
        {
            option_name: "Debug Path",
            option_function: function()
            {
            	// Toggle Debug Path
                GameManager.debug_menu.pathfinding_debug_path_widgets_enabled = !GameManager.debug_menu.pathfinding_debug_path_widgets_enabled;
                
                // Destroy Debug Path
                if (!is_undefined(GameManager.debug_menu.debug_path))
		    	{
		    		ds_list_destroy(GameManager.debug_menu.debug_path);
		    		GameManager.debug_menu.debug_path = -1;
		    	}
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.pathfinding_debug_path_widgets_enabled;
            }
        }
    ]
};

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Rendering] = 
{
    tab_name: "Rendering",
    tab_options: 
    [
        {
            option_name: "Enable Back-Layer Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_background_light_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_background_light_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_background_light_map_enabled;
            }
        },
        {
            option_name: "Enable Mid-Layer Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_midground_light_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_midground_light_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_midground_light_map_enabled;
            }
        },
        {
            option_name: "Enable Fore-Layer Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_foreground_light_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_foreground_light_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_foreground_light_map_enabled;
            }
        },
        {
            option_name: "Enable Normal Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_normal_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_normal_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_normal_map_enabled;
            }
        },
        {
            option_name: "Enable Metallic Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_metallic_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_metallic_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_metallic_map_enabled;
            }
        },
        {
            option_name: "Enable Roughness Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_roughness_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_roughness_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_roughness_map_enabled;
            }
        },
        {
            option_name: "Enable Depth Render",
            option_function: function()
            {
                var temp_rendering_option = GameManager.debug_menu.rendering_depth_map_enabled;
                GameManager.debug_menu.reset_rendering_options();
                GameManager.debug_menu.rendering_depth_map_enabled = !temp_rendering_option;
            },
            option_toggle: function()
            {
                return GameManager.debug_menu.rendering_depth_map_enabled;
            }
        },
        {
            option_name: "Reset Rendering Options",
            option_function: function()
            {
                GameManager.debug_menu.reset_rendering_options();
            },
            option_toggle: undefined
        },
    ]
};

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.OptionTemplate] = 
{
    tab_name: "OptionTemplate",
    tab_options: 
    [
        {
            option_name: "Option One",
            option_function: undefined,
            option_toggle: undefined
        },
        {
            option_name: "Option Two",
            option_function: undefined,
            option_toggle: undefined
        },
        {
            option_name: "Option Three",
            option_function: undefined,
            option_toggle: undefined
        }
    ]
};

// Generate Font Spacing Variables
draw_set_font(debug_menu_font);
debug_menu_font_height = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

for (var i = 0; i < array_length(ribbon_menu_tabs); i++)
{
    // Find Ribbon Menu Tab Window Max Width
    var temp_ribbon_menu_tab_window_max_text_width = 0;
    
    // Increment through all Tab Window Option Titles to find the max width out of all the Option Titles
    for (var q = 0; q < array_length(ribbon_menu_tabs[i].tab_options); q++)
    {
        var temp_ribbon_option_width = string_width(ribbon_menu_tabs[i].tab_options[q].option_name) + (is_undefined(ribbon_menu_tabs[i].tab_options[q].option_toggle) ? 0 : ribbon_menu_option_toggle_box_horizontal_offset + (ribbon_menu_option_toggle_box_horizontal_padding * 2));
        temp_ribbon_menu_tab_window_max_text_width = max(temp_ribbon_menu_tab_window_max_text_width, temp_ribbon_option_width);
    }
    
    // Set Ribbon Menu Tab Window Max Width
    ribbon_menu_tabs[i].tab_window_width = temp_ribbon_menu_tab_window_max_text_width;
}