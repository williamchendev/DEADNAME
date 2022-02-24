/// @description Combat Unit Initialization
// The variable and settings initialization for the Combat Unit

// Inherit Unit Initialization
event_inherited();

// Combat Variables
target_x = 0;
target_y = 0;
targeting = false;

target_aim_threshold = 0.85;
target_aim_fullauto_threshold = 0.5;

// Squad Variables
squad_aim = false;
squad_key_fire_press = false;
squad_key_aim_press = false;

// Weapon Settings
weapon_hip_x = -1;
weapon_hip_y = -24;

weapon_aim_x = 4;
weapon_aim_y = -32;

weapon_melee_x = 1;
weapon_melee_y = 2;

inventory_x = -1;
inventory_y = -30;

weapon_ambient_move_spd = 0.027;
weapon_ambient_move_size = 2;
weapon_holster_ambient_move_size = 2;

weapon_cursor_ambient_range = 72;
weapon_cursor_range_lerp_spd = 0.1;

// Limb Settings
limbs = 2;

limb_x[0] = -5;
limb_y[0] = -32;
limb_angle[0] = -10;

limb_x[1] = 2;
limb_y[1] = -32;
limb_angle[1] = 20;

limb_action_radius = 1.5;
limb_ambient_anim_spd = 0.017;

limb_ambient_idle_rotate_radius = 1;
limb_ambient_idle_length_offset = 0.2;

limb_ambient_move_width = 4;
limb_ambient_move_height = 4;
limb_ambient_move_angle_offset = 0;
limb_ambient_move_length_offset = 0.2;

limb_aim_move_offset_x = -1;
limb_aim_offset_y = 2;

limb_melee_arm_length_mult = 0.6;
limb_melee_arm_swing_length_mult = 2;

// Knockout Settings
can_die = true;

knockout = false;
knockout_active = false;
knockout_timer = 0.6;

// Weapon Variables
weapon_x = 0;
weapon_y = 0;

weapon_ambient_move_val = 0;

aim_ambient_x = 0;
aim_ambient_y = 0;

old_target_angle = 0;

reload = false;
bolt_action_load = false;
bolt_action_reload = false;

weapon_cursor_range = 50;

// Limb Variables
limb_ambient_anim_val = 0;

limb[0] = instance_create_layer(x, y, layers[4], oArm);
limb[1] = instance_create_layer(x, y, layers[1], oArm);

limb_sprite[0] = sWilliam_Arms;  // Right Arm
limb_sprite[1] = sWilliamDS_Arms;  // Left Arm

limb_normal_sprite[0] = sWolf_Arms_NormalMap;  // Right Arm
limb_normal_sprite[1] = sWolf_Arms_NormalMap;  // Left Arm