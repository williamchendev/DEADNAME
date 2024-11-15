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

// Animation Settings
unit_animation_state = UnitAnimationState.Idle;
unit_equipment_animation_state = UnitEquipmentAnimationState.None;
unit_sprite_pack = UnitSpritePacks.MoralistWilliam;

jump_peak_threshold = 0.8;
squash_stretch_jump_intensity = 0.5;

squash_stretch_reset_spd = 0.15;

// Unit Behaviour Variables
for (var s = 0; s < array_length(global.unit_sprite_packs); s++)
{
	// Auto Assign Unit Sprite Pack from Unit Object's Idle Sprite Index
	if (global.unit_sprite_packs[s].idle_sprite == sprite_index)
	{
		unit_sprite_pack = s;
		break;
	}
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

// Limbs
limb_left_arm = NEW(LimbArmClass);
limb_left_arm.init_arm(LimbType.LeftArm, unit_sprite_pack);

limb_right_arm = NEW(LimbArmClass);
limb_right_arm.init_arm(LimbType.RightArm, unit_sprite_pack);
limb_right_arm.limb_animation_value_offset = 0.5;

limb_animation_double_cycle = false;

// Input Action Variables
move_left = false;
move_right = false;

move_drop_down = false;

move_jump_hold = false;
move_double_jump = false;

// Unit Methods
unit_ground_contact_behaviour = function()
{
	// Ground Contact Behaviour
	if (ds_list_find_index(platform_list, collision_point(x, y + 1, oPlatform, false, true)) != -1)
	{
		// Contact with Platform
		ground_contact_vertical_offset = 0;
		draw_angle = 0;
	}
	else
	{
		// Raycast to Solid Collider
		for (var i = 0; i < slope_raycast_distance; i++)
		{
			var temp_solid_rot_inst = collision_point(x, y + i, oSolid, false, true);
			
			if (temp_solid_rot_inst != noone)
			{
				ground_contact_vertical_offset = i;
				draw_angle = point_check_solid_surface_angle(x, y, temp_solid_rot_inst);
				return;
			}
		}
	}
}