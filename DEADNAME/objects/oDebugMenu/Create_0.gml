/// @description Insert description here
// You can write your code in this editor

// Debug Menu Font Settings
debug_menu_font = font_Inno;

draw_set_font(debug_menu_font);
debug_menu_font_height = string_height("ABCDEFGHIJKLMNOPQRSTUVWXYZ");

// Debug Menu Spacing Settings
ribbon_menu_start_horizontal_offset = 8;
ribbon_menu_start_vertical_offset = 2;

ribbon_menu_horizontal_spacing = 20;
ribbon_menu_vertical_spacing = 3;

ribbon_menu_option_selection_hitbox_padding = 2;

// Debug Menu Info & Version Settings
debug_menu_info_text = "Capy Crucible";
debug_menu_version_text = "0.11";

debug_menu_info_and_version_horizontal_offset = 6;
debug_menu_info_and_version_vertical_offset = 6;

// Debug Menu Color Settings
color_pale_dogwood = make_color_rgb(223, 187, 177);
color_rose_taupe = make_color_rgb(150, 97, 107);

color_light_blue = make_color_rgb(193, 238, 255);
color_cerulean_blue = make_color_rgb(55, 113, 142);
color_indigo_blue = make_color_rgb(37, 78, 112);

// Debug Menu Ribbon Menu Settings
ribbon_menu_options[0] = 
{
    option_name: "File"
}

ribbon_menu_options[1] = 
{
    option_name: "Level"
}

ribbon_menu_options[2] = 
{
    option_name: "Pathfinding"
}

ribbon_menu_options[3] = 
{
    option_name: "Units"
}

ribbon_menu_options[4] = 
{
    option_name: "Entities"
}

ribbon_menu_options[5] = 
{
    option_name: "Effects"
}

// Debug Menu Ribbon Menu Variables
ribbon_menu_option_hover_select_index = -1;
ribbon_menu_option_clicked_select_index = -1;