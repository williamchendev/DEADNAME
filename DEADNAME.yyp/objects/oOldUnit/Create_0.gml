/// @description Insert description here
// Creates all the variables necessary for the Unit character

// Physics Settings
spd = 3; // Running Speed
walk_spd = 1; // Walk Speed

jump_spd = 1.4; // Jumping Speed
double_jump_spd = 3; // Double Jumping Speed
hold_jump_spd = 0.45; // Added Jump Speed when the Jump Button is held
jump_decay = 0.81; // Decay of the Jumping Upwards Velocity

grav_spd = 0.026; // Force of Downward Gravity
grav_multiplier = 0.93; // Dampening Multiplyer of the Downward Velocity (Makes gravity smoother)
max_grav_spd = 2; // Max Speed of Unit's Downward Velocity

slope_tolerance = 3; // Tolerance for walking up slopes in pixels
slope_angle_lerp_spd = 0.1; // Speed to lerp the angle to the slope the player is standing on

// Beahviour Settings
canmove = true;

// Player Settings
player_input = false;

firearm = false;
reload = false;
action = noone;
scale_reset_spd = 0.1;
draw_xscale = 1;
draw_yscale = 1;
jump_peak_threshold = 0.8;
draw_color = c_white;
draw_index = 0;
animation_spd = 0.18;
squash_stretch = 0.12;

// Physics Variables
platform_list = ds_list_create();

x_velocity = 0;
y_velocity = 0;

double_jump = false;

grav_velocity = 0;
jump_velocity = 0;

slope_angle = 0;
slope_offset = 0;

// Sprite Variables
idle_animation = sWilliam_CapitalLoyalist_Idle;
walk_animation = sWilliam_CapitalLoyalist_Run;
jump_animation = sWilliam_CapitalLoyalist_Jump;
aim_animation = sWilliam_CapitalLoyalist_Aim;
aim_walk_animation = sWilliam_CapitalLoyalist_AimWalk;

idle_normals = sWilliam_CapitalLoyalist_Idle_NormalMap;
walk_normals = sWilliam_CapitalLoyalist_Run_NormalMap;
jump_normals = sWilliam_CapitalLoyalist_Jump_NormalMap;
aim_normals = sWilliam_CapitalLoyalist_Aim_NormalMap;
aim_walk_normals = sWilliam_CapitalLoyalist_AimWalk_NormalMap;

// Input Variables
key_left = false;
key_right = false;
key_up = false;
key_down = false;

key_left_press = false;
key_right_press = false;
key_up_press = false;
key_down_press = false;

key_jump = false;
key_jump_press = false;

key_shift = false;
key_interact_press = false;
key_inventory_press = false;

key_fire_press = false;
key_aim_press = false;
key_reload_press = false;

key_command = false;

// Singleton
game_manager = instance_find(oGameManager, 0);

// Layers
layer_id = -1;
