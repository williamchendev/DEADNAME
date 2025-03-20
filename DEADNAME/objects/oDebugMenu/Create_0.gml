/// @description Insert description here
// You can write your code in this editor

// Debug Menu Font Settings
debug_menu_font = font_Inno;

// Color Settings
color_pale_dogwood = make_color_rgb(223, 187, 177);
color_rose_taupe = make_color_rgb(150, 97, 107);

color_light_blue = make_color_rgb(193, 238, 255);
color_cerulean_blue = make_color_rgb(55, 113, 142);
color_indigo_blue = make_color_rgb(37, 78, 112);

// Info & Version Settings
debug_menu_info_text = "DEADNAME Debug Menu - Capy Crucible";
debug_menu_version_text = "0.23b";

debug_menu_info_and_version_horizontal_offset = 6;
debug_menu_info_and_version_vertical_offset = 6;

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
level_platforms_and_collisions_widgets_enabled = true;
pathfinding_widgets_enabled = false;
lighting_engine_light_sources_widgets_enabled = false;

// Debug Menu Ribbon Menu Variables
ribbon_menu_tab_hover_select_index = -1;
ribbon_menu_tab_clicked_select_index = -1;

ribbon_menu_window_option_clicked = false;
ribbon_menu_window_option_hover_select_index = -1;
ribbon_menu_window_option_clicked_select_index = -1;

// Ribbon Menu
enum DebugMenuRibbonMenuTabs
{
    Game,
    Resolution,
    Scene,
    Lighting,
    Pathfinding,
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
            option_name: "Exit Game",
            option_function: function() 
            {
                // Exit Game
			    game_end();
            },
            option_toggle: undefined
        }
    ]
}

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
}

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Scene] = 
{
    tab_name: "Scene",
    tab_options: 
    [
        {
            option_name: "Show/Hide Platform and Collision Widgets",
            option_function: function()
            {
                with (oDebugMenu)
                {
                    level_platforms_and_collisions_widgets_enabled = !level_platforms_and_collisions_widgets_enabled;
                }
            },
            option_toggle: function()
            {
                with (oDebugMenu)
                {
                     return level_platforms_and_collisions_widgets_enabled;
                }
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
}

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Lighting] = 
{
    tab_name: "Lighting",
    tab_options: 
    [
        {
            option_name: "Show/Hide Light Source Widgets",
            option_function: function()
            {
                with (oDebugMenu)
                {
                    lighting_engine_light_sources_widgets_enabled = !lighting_engine_light_sources_widgets_enabled;
                }
            },
            option_toggle: function()
            {
                with (oDebugMenu)
                {
                    return lighting_engine_light_sources_widgets_enabled;
                }
            }
        }
    ]
}

ribbon_menu_tabs[DebugMenuRibbonMenuTabs.Pathfinding] = 
{
    tab_name: "Pathfinding",
    tab_options: 
    [
        {
            option_name: "Show/Hide Pathfinding Widgets",
            option_function: function()
            {
                with (oDebugMenu)
                {
                    pathfinding_widgets_enabled = !pathfinding_widgets_enabled;
                }
            },
            option_toggle: function()
            {
                with (oDebugMenu)
                {
                    return pathfinding_widgets_enabled;
                }
            }
        },
        {
            option_name: "Enter Pathfinding Map Edit Mode",
            option_function: undefined,
            option_toggle: undefined
        },
        {
            option_name: "Save Level Data",
            option_function: pathfinding_save_level_data,
            option_toggle: undefined
        },
        {
            option_name: "Load Level Data",
            option_function: pathfinding_load_level_data,
            option_toggle: undefined
        },
        {
            option_name: "Clear Scene",
            option_function: pathfinding_clear_level_data,
            option_toggle: undefined
        }
    ]
}

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
}

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