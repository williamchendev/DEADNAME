/// @description Unit Initialization Event
// Creates all the variables necessary for the Unit character

// Singleton
game_manager = instance_find(oGameManager, 0);

// Unit Behaviour Settings
canmove = true;

// Physics Settings
run_spd = 3; // Running Speed
walk_spd = 1; // Walk Speed

jump_spd = 1.4; // Jumping Speed
double_jump_spd = 3; // Double Jumping Speed
hold_jump_spd = 0.45; // Added Jump Speed when the Jump Button is held
jump_decay = 0.81; // Decay of the Jumping Upwards Velocity

grav_spd = 0.026; // Force of Downward Gravity
grav_multiplier = 0.93; // Dampening Multiplyer of the Downward Velocity (Makes gravity smoother)
max_grav_spd = 2; // Max Speed of Unit's Downward Velocity


// Animation Settings
unit_animation_state = UnitAnimationState.Idle;
unit_sprite_pack = UnitSpritePacks.MoralistWilliam;

jump_peak_threshold = 0.8;
squash_stretch_jump_intensity = 0.5;

squash_stretch_reset_spd = 0.15;


// Unit Behaviour Variables


// Physics Variables
platform_list = ds_list_create();

grounded = false;
double_jump = false;

grav_velocity = 0;
jump_velocity = 0;

x_velocity = 0;
y_velocity = 0;

// Animation Variables
image_speed = 0.75;

draw_xscale = 1;
draw_yscale = 1;

// Input Action Variables
move_left = false;
move_right = false;

move_drop_down = false;

move_jump_hold = false;
move_double_jump = false;
