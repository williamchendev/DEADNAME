/// @description 

// Check if Debug Mode is Enabled
if (!global.debug)
{
    // Debug Mode is not Enabled, Disable Menu Behaviours
    return;
}

// Reset Ribbon Menu Hover Selection Index
ribbon_menu_option_hover_select_index = -1;

// Set Debug Menu Font for Collision Detection
draw_set_font(debug_menu_font);

// Ribbon Menu Option Mouse Selection
var temp_ribbon_menu_width = 0;

for (var i = 0; i < array_length(ribbon_menu_options); i++)
{
    // Check Mouse Point with Ribbon Menu Option's Collision Rectangle
    var temp_ribbon_menu_option_x = ribbon_menu_start_horizontal_offset + temp_ribbon_menu_width;
    var temp_ribbon_menu_option_mouse_collision = point_in_rectangle
    (
        mouse_x, 
        mouse_y, 
        temp_ribbon_menu_option_x - ribbon_menu_option_selection_hitbox_padding - 1, 
        0, 
        temp_ribbon_menu_option_x + string_width(ribbon_menu_options[i].option_name) + ribbon_menu_option_selection_hitbox_padding, 
        ribbon_menu_start_vertical_offset + debug_menu_font_height + ribbon_menu_vertical_spacing
    );
    
    if (temp_ribbon_menu_option_mouse_collision)
    {
        ribbon_menu_option_hover_select_index = i;
    }
    
    // Increment Ribbon Menu Width
    temp_ribbon_menu_width += ribbon_menu_horizontal_spacing + string_width(ribbon_menu_options[i].option_name);
}

// Debug Menu Mouse Behaviour
if (mouse_check_button_pressed(mb_left))
{
    
}
else if (mouse_check_button_pressed(mb_right))
{
    
}