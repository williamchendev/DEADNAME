/// @description Squad Init Event
// Creates the variables and settings of the Squad Entity

// Game Manager
game_manager = instance_find(oGameManager, 0);

// Squad Settings
squad_icon_index = 0;

squad_id = "empty_squad";
player_squad = false;

// Animation Settings
squad_select_outline_color = c_black;
squad_select_second_outline_color = c_white;

squad_hover_outline_color = c_white;
squad_selected_outline_color = make_color_rgb(212, 175, 55);

squad_select_draw_spd = 0.15;

// Pathing Settings
squad_path_unit_slots = 6;
squad_path_unit_spacing = 26;
squad_path_unit_random_spacing = 4;

// Squad Variables
squad_units_list = ds_list_create();

// Animation Variables
squad_hover = false;
squad_selected = false;
squad_select_draw_value = 0;
squad_outline_icon = false;

// Pathing Variables
squad_path_create = false;
squad_path_end_x = 0;
squad_path_end_y = 0;

// Surface Variables
temp_surface = noone;
squad_surface = noone;

// Shader Variables
uniform_pixel_width = shader_get_uniform(shd_outline, "pixelW");
uniform_pixel_height = shader_get_uniform(shd_outline, "pixelH");