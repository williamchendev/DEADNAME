/// @description Unit Initialization Event
// Creates all the variables necessary for the Unit character

// Lighting Engine
lighting_engine_add_unit(id);

// Unit Behaviour Settings
canmove = true;

// Health Settings
health = 3;

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

slope_tolerance = 5; // Tolerance for walking up slopes in pixels
slope_raycast_distance = 8; // Distance to raycast to solids beneath the unit to calculate slope angle
slope_angle_lerp_spd = 0.15; // Speed to lerp the angle to the slope the player is standing on

max_velocity = 10;

// Animation Settings
unit_animation_state = UnitAnimationState.Idle;
unit_equipment_animation_state = UnitEquipmentAnimationState.None;
unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;

animation_asymptotic_tolerance = 0.1;

jump_peak_threshold = 0.8;
jump_pathfinding_behaviour_target_padding = -3;
squash_stretch_jump_intensity = 0.5;

squash_stretch_reset_spd = 0.15;

hand_default_movement_spd = 0.1;
hand_fast_movement_spd = 0.33;

hand_fumble_animation_travel_size = 1.6;
hand_fumble_animation_travel_spd = 0.5;
hand_fumble_animation_delay_min = 2;
hand_fumble_animation_delay_max = 12;

weapon_vertical_bobbing_height = 1;
weapon_bobbing_animation_percent_offset = 0.18;

firearm_aiming_aim_transition_spd = 0.2;
firearm_aiming_hip_transition_spd = 0.1;
firearm_aiming_angle_transition_spd = 0.17;

firearm_recoil_recovery_spd = 0.2;
firearm_recoil_angle_recovery_spd = 0.1;

firearm_idle_safety_angle = -15;
firearm_moving_safety_angle = -45;
firearm_reload_safety_angle = 15;

// Physics Variables
platform_list = ds_list_create();

grounded = false;
double_jump = false;

grav_velocity = 0;
jump_velocity = 0;

x_velocity = 0;
y_velocity = 0;

// Animation Variables
normalmap_spritepack = noone;
metallicroughnessmap_spritepack = noone;
emissivemap_spritepack = noone;

image_speed = 0;

animation_speed = 0.18;
animation_speed_direction = 1;

draw_image_index = 0;
draw_image_index_length = 0;

draw_xscale = 1;
draw_yscale = 1;

draw_angle = 0;
draw_angle_value = 0;

ground_contact_vertical_offset = 0;

hand_fumble_animation_timer = 0;
hand_fumble_animation_cycle_timer = 0;
hand_fumble_animation_transition_value = 1;

hand_fumble_animation_offset_ax = 0;
hand_fumble_animation_offset_ay = 0;
hand_fumble_animation_offset_bx = 0;
hand_fumble_animation_offset_by = 0;

hand_fumble_animation_offset_x = 0;
hand_fumble_animation_offset_y = 0;

unit_equipment_inventory_position_x = 0;
unit_equipment_inventory_position_y = 0;

firearm_weapon_primary_hand_pivot_offset_ax = 0;
firearm_weapon_primary_hand_pivot_offset_ay = 0;
firearm_weapon_primary_hand_pivot_offset_bx = 0;
firearm_weapon_primary_hand_pivot_offset_by = 0;
firearm_weapon_primary_hand_pivot_transition_value = 0;

firearm_weapon_hip_pivot_to_aim_pivot_transition_value = 0;
firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;

// Weapons
weapon_active = false;
weapon_reload = false;
weapon_aim = false;

weapon_aim_x = 0;
weapon_aim_y = 0;

weapon_equipped = noone;

// Weapons DEBUG
weapon_active = true;
weapon_equipped = create_weapon_from_weapon_pack(WeaponPack.Corso);
weapon_equipped.init_weapon_physics();
unit_equipment_animation_state = UnitEquipmentAnimationState.Firearm; // DEBUG

// Unit Limb Arms
limb_primary_arm = NEW(LimbArmClass);
limb_primary_arm.init_arm(LimbType.LeftArm, unit_pack);

limb_secondary_arm = NEW(LimbArmClass);
limb_secondary_arm.init_arm(LimbType.RightArm, unit_pack);

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

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = 0;
pathfinding_path_ended = false;

pathfinding_recalculate = false;

pathfinding_path_start_x = 0;
pathfinding_path_start_y = 0;
pathfinding_path_end_x = 0;
pathfinding_path_end_y = 0;

pathfinding_jump = false;

// Trig Variables
trig_sine = 0;
trig_cosine = 1;

// PBR Variables
normal_strength = 1;
metallic = global.unit_packs[unit_pack].metallic;
roughness = global.unit_packs[unit_pack].roughness;
emissive = global.unit_packs[unit_pack].emissive;
emissive_multiplier = 1;

// Generate UVs
unit_spritepack_idle_normalmap = global.unit_packs[unit_pack].idle_normalmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].idle_sprite, global.unit_packs[unit_pack].idle_normalmap);
unit_spritepack_walk_normalmap = global.unit_packs[unit_pack].walk_normalmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].walk_sprite, global.unit_packs[unit_pack].walk_normalmap);
unit_spritepack_jump_normalmap = global.unit_packs[unit_pack].jump_normalmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].jump_sprite, global.unit_packs[unit_pack].jump_normalmap);
unit_spritepack_aim_normalmap = global.unit_packs[unit_pack].aim_normalmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].aim_sprite, global.unit_packs[unit_pack].aim_normalmap);
unit_spritepack_aim_walk_normalmap = global.unit_packs[unit_pack].aim_walk_normalmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].aim_walk_sprite, global.unit_packs[unit_pack].aim_walk_normalmap);

unit_spritepack_idle_metallicroughnessmap = global.unit_packs[unit_pack].idle_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].idle_sprite, global.unit_packs[unit_pack].idle_metallicroughnessmap);
unit_spritepack_walk_metallicroughnessmap = global.unit_packs[unit_pack].walk_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].walk_sprite, global.unit_packs[unit_pack].walk_metallicroughnessmap);
unit_spritepack_jump_metallicroughnessmap = global.unit_packs[unit_pack].jump_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].jump_sprite, global.unit_packs[unit_pack].jump_metallicroughnessmap);
unit_spritepack_aim_metallicroughnessmap = global.unit_packs[unit_pack].aim_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].aim_sprite, global.unit_packs[unit_pack].aim_metallicroughnessmap);
unit_spritepack_aim_walk_metallicroughnessmap = global.unit_packs[unit_pack].aim_walk_metallicroughnessmap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].aim_walk_sprite, global.unit_packs[unit_pack].aim_walk_metallicroughnessmap);

unit_spritepack_idle_emissivemap = global.unit_packs[unit_pack].idle_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].idle_sprite, global.unit_packs[unit_pack].idle_emissivemap);
unit_spritepack_walk_emissivemap = global.unit_packs[unit_pack].walk_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].walk_sprite, global.unit_packs[unit_pack].walk_emissivemap);
unit_spritepack_jump_emissivemap = global.unit_packs[unit_pack].jump_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].jump_sprite, global.unit_packs[unit_pack].jump_emissivemap);
unit_spritepack_aim_emissivemap = global.unit_packs[unit_pack].aim_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].aim_sprite, global.unit_packs[unit_pack].aim_emissivemap);
unit_spritepack_aim_walk_emissivemap = global.unit_packs[unit_pack].aim_walk_emissivemap == noone ? undefined : spritepack_get_uvs_transformed(global.unit_packs[unit_pack].aim_walk_sprite, global.unit_packs[unit_pack].aim_walk_emissivemap);
