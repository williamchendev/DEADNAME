/// @description Game Manager Initialization

// Global Game Manager Properties
#macro GameManager global.game_manager

// Configure Game Manager - Global Init Event
gml_pragma("global", @"room_instance_add(room_first, 0, 0, oGameManager);");

// Delete to prevent multiple Game Manager Instances
if (instance_number(object_index) > 1) 
{
	instance_destroy(id, false);
	exit;
}

//
rot_v = 0;
rot_spd = 0.001;
geo = geodesic_icosphere_create(10);

for (var q = 0; q < array_length(geo.triangles); q++)
{
	show_debug_message(geo.triangles[q]);
}

sprite_index = noone;

// Game Manager Singleton
global.game_manager = id;

// Squad Behaviour Director
squad_behaviour_director = undefined;

// Resolution Settings
enum GameResolutionMode
{
	Default640x360,
	Single640x360,
	Double640x360,
	FullScreen640x360,
	Debug1280x720
}

default_game_width = 640;
default_game_height = 360;

debug_game_width = 1280;
debug_game_height = 720;

// System Settings
data_directory = $"{program_directory}\Data\\";

// AI Calculation Settings
sight_collision_calculation_frame_delay = 5;

// UI Visual Settings
ui_inspection_text_font = font_Default;

// Debug Settings
global.debug = false;
debug_overlay_enabled = false;

// Player Input Management
input_interaction_selection = false;

up_check = ord("W");
down_check = ord("S");
left_check = ord("A");
right_check = ord("D");

jump_check = vk_space;
reload_check = ord("R");

shift_check = vk_shift;
interact_check = ord("E");
inventory_check = ord("I");

drop_check = ord("Q");

// Debug Variables
debug_menu = undefined;

// Pathfinding Node Variables
pathfinding_node_ids_map = ds_map_create();

pathfinding_node_exists_list = ds_list_create();
pathfinding_node_edges_list = ds_list_create();
pathfinding_node_struct_list = ds_list_create();
pathfinding_node_name_list = ds_list_create();

pathfinding_node_deleted_indexes_list = ds_list_create();

// Pathfinding Edge Variables
pathfinding_edge_ids_map = ds_map_create();

pathfinding_edge_exists_list = ds_list_create();
pathfinding_edge_nodes_list = ds_list_create();
pathfinding_edge_types_list = ds_list_create();
pathfinding_edge_weights_list = ds_list_create();
pathfinding_edge_name_list = ds_list_create();

pathfinding_edge_deleted_indexes_list = ds_list_create();

// Cursor Variables
cursor_x = 0;
cursor_y = 0;

cursor_interact = false;
cursor_interaction_object = noone;

cursor_icon = false;
cursor_icon_index = 0;

// Projectile Trajectory Aim Reticule Variables
projectile_trajectory_aim_reticule_horizontal_positions_list = ds_list_create();
projectile_trajectory_aim_reticule_vertical_positions_list = ds_list_create();

// Resolution Variables
game_resolution_mode = GameResolutionMode.Default640x360;

game_width = 640;
game_height = 360;
game_scale = max(1, round(display_get_width() / game_width) - 1);

// Player Unit Variables
player_unit = noone;

// Resolution Methods
set_game_resolution_mode = function(resolution_mode)
{
	// Check if changing Resolution Mode is Redundant
	if (game_resolution_mode == resolution_mode)
	{
		// Attempted to set Game's Resolution Mode to its current Resolution Mode - Early Return
		return;
	}
	
	// Fullscreen Toggle
	var temp_fullscreen = false;
	
	// Change Resolution Settings based on Resolution Mode
	switch (resolution_mode)
	{
		case GameResolutionMode.FullScreen640x360:
			temp_fullscreen = true;
			game_width = default_game_width;
			game_height = default_game_height;
			game_scale = display_get_width() / game_width;
			break;
		case GameResolutionMode.Debug1280x720:
			temp_fullscreen = true;
			game_width = debug_game_width;
			game_height = debug_game_height;
			game_scale = display_get_width() / game_width;
			break;
		case GameResolutionMode.Single640x360:
			game_width = default_game_width;
			game_height = default_game_height;
			game_scale = 1;
			break;
		case GameResolutionMode.Double640x360:
			game_width = default_game_width;
			game_height = default_game_height;
			game_scale = 2;
			break;
		case GameResolutionMode.Default640x360:
		default:
			game_width = default_game_width;
			game_height = default_game_height;
			game_scale = max(1, round(display_get_width() / game_width) - 1);
			break;
	}
	
	// Reset Viewport Variables
	view_set_xport(view_current, 0);
	view_set_yport(view_current, 0);
	
	view_set_wport(view_current, game_width);
	view_set_hport(view_current, game_height);
	
	// Set Game Window Size to Match Resolution Settings
	window_set_size(game_width * game_scale, game_height * game_scale);
	
	// Set Game Window Fullscreen Toggle (if applicable)
	if (temp_fullscreen != window_get_fullscreen())
	{
		window_set_fullscreen(temp_fullscreen);
	}
	
	// Set Game Window Centered (if applicable)
	if (!temp_fullscreen)
	{
		window_center();
	}
	
	// Clear Rendering System Surfaces
	lighting_engine_render_clear_surfaces();
	
	// Calculate Cursor Position
	cursor_x = round(game_width * (window_mouse_get_x() / window_get_width()));
	cursor_y = round(game_height * (window_mouse_get_y() / window_get_height()));
	
	// Set Game Resolution Mode enum for Redundancy Comparison
	game_resolution_mode = resolution_mode;
}