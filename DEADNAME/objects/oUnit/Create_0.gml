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

slope_tolerance = 3; // Tolerance for walking up slopes in pixels
slope_raycast_distance = 8;
slope_angle_lerp_spd = 0.1; // Speed to lerp the angle to the slope the player is standing on

max_velocity = 10;

// Animation Settings
unit_animation_state = UnitAnimationState.Idle;
unit_pack = UnitPack.MoralistWilliam;

jump_peak_threshold = 0.8;
squash_stretch_jump_intensity = 0.5;

squash_stretch_reset_spd = 0.15;

hand_fumble_animation_travel_size = 1.8;
hand_fumble_animation_travel_spd = 0.4;
hand_fumble_animation_delay_min = 2;
hand_fumble_animation_delay_max = 16;

weapon_vertical_bobbing_height = 1;
weapon_bobbing_animation_percent_offset = 0.18;

firearm_aiming_aim_transition_spd = 0.2;
firearm_aiming_hip_transition_spd = 0.1;
firearm_aiming_angle_transition_spd = 0.17;

firearm_recoil_recovery_spd = 0.2;
firearm_recoil_angle_recovery_spd = 0.1;

firearm_idle_safety_angle = -15;
firearm_moving_safety_angle = -45;
firearm_reload_safety_angle = -45;

// Unit Behaviour Variables
var s = 0;
repeat (array_length(global.unit_packs))
{
	// Auto Assign Unit Sprite Pack from Unit Object's Idle Sprite Index
	if (global.unit_packs[s].idle_sprite == sprite_index)
	{
		unit_pack = s;
		break;
	}
	s++;
}

ground_contact_vertical_offset = 0;

// Physics Variables
platform_list = ds_list_create();

grounded = false;
double_jump = false;

grav_velocity = 0;
jump_velocity = 0;

x_velocity = 0;
y_velocity = 0;

// Animation Variables
image_speed = 0;

animation_speed = 0.18;
animation_speed_direction = 1;

draw_image_index = 0;
draw_image_index_length = 0;

draw_xscale = 1;
draw_yscale = 1;

draw_angle = 0;
draw_angle_value = 0;

normalmap_index = noone;

hand_fumble_animation_timer = 0;
hand_fumble_animation_transition_value = 1;

hand_fumble_animation_offset_ax = 0;
hand_fumble_animation_offset_ay = 0;
hand_fumble_animation_offset_bx = 0;
hand_fumble_animation_offset_by = 0;

hand_fumble_animation_offset_x = 0;
hand_fumble_animation_offset_y = 0;

unit_equipment_animation_state = UnitEquipmentAnimationState.None;
unit_equipment_animation_state = UnitEquipmentAnimationState.Firearm; // DEBUG
unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;

firearm_aim_transition_value = 0;
firearm_reload_hand_primary_animation_value = 0; // EXPLAIN

// Weapons
weapon_active = false;
weapon_reload = false;
weapon_aim = false;

weapon_equipped = noone;

// Weapons DEBUG
weapon_active = true;
weapon_equipped = create_weapon_from_weapon_pack(WeaponPack.Default);
weapon_equipped.init_weapon_physics();

weapon_aim_x = 0;
weapon_aim_y = 0;

// Unit Limb Arms
limb_left_arm = NEW(LimbArmClass);
limb_left_arm.init_arm(LimbType.LeftArm, unit_pack);

limb_right_arm = NEW(LimbArmClass);
limb_right_arm.init_arm(LimbType.RightArm, unit_pack);

limb_animation_double_cycle = false;

// Input Action Variables
input_left = false;
input_right = false;

input_drop_down = false;

input_jump_hold = false;
input_double_jump = false;

input_attack = false;
input_aim = false;

input_reload = false;

input_cursor_x = 0;
input_cursor_y = 0;
