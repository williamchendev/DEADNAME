/// @description Game Manager Initialization

// Singleton Function
if (instance_number(object_index) > 1) {
	instance_destroy();
	exit;
}
persistent = true;

// System Settings
game_width = 640;
game_height = 360;

data_directory = string(program_directory +"\Data\\");

// Level Generation Data
generate = false;
blocks = noone;

instantiated_units = ds_list_create();

// Global Item Data
init_item_data();
init_consumable_data();
init_weapon_data();

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

// Time Settings
time_spd = 1;
time_delta_clamp = 3;

global.deltatime = 0;
global.realdeltatime = 0;

// Camera Variables
camera_width = 640;
camera_height = 360;
camera_x = 0;
camera_y = 0;

// Cursor Variables
cursor_icon = false;
cursor_inventory = false;
cursor_index = 0;

// Squad Variables
generated_squads = 0;