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

// Game Manager Singleton
global.game_manager = id;

// Resolution Settings
game_width = 640;
game_height = 360;
game_scale = 2;

// System Settings
data_directory = string(program_directory +"\Data\\");

// Global Item Data

// Debug Settings
global.debug = false;
sprite_index = noone;

debug_x_offset = 4;
debug_y_offset = 0;

debug_fps = 0;
debug_fps_timer = 0;

// Player Input Management
up_check = ord("W");
down_check = ord("S");
left_check = ord("A");
right_check = ord("D");

jump_check = vk_space;
reload_check = ord("R");

shift_check = vk_shift;
interact_check = ord("E");
inventory_check = ord("I");

command_check = ord("Q");

// Cursor Variables
cursor_icon = false;
cursor_inventory = false;
cursor_index = 0;

// Scale Variables
windowed_scale = 0;