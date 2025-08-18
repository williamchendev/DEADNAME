/// @description Unit Initialization Event
// Creates all the variables necessary for the Unit character

// Lighting Engine
lighting_engine_add_unit(id);

// Unit Behaviour Settings
canmove = true;

// Health Settings
unit_health = 3;
unit_luck = max(random_range(-2.0, 1.0), 0);

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

max_velocity = 10; // Unit's Maximum Horizontal or Vertical Velocity

// Animation Settings
unit_animation_state = UnitAnimationState.Idle;
unit_equipment_animation_state = UnitEquipmentAnimationState.None;
unit_firearm_reload_animation_state = UnitFirearmReloadAnimationState.Reload_End;

animation_asymptotic_tolerance = 0.1;

jump_peak_threshold = 0.8;
jump_pathfinding_behaviour_target_padding = -3;
squash_stretch_jump_intensity = 0.5;

squash_stretch_reset_spd = 0.15;
bobbing_animation_percent_offset = 0.18;

hand_default_movement_spd = 0.1;
hand_fast_movement_spd = 0.33;

hand_fumble_animation_travel_size = 1.6;
hand_fumble_animation_travel_spd = 0.5;
hand_fumble_animation_delay_min = 2;
hand_fumble_animation_delay_max = 12;

inventory_item_rotate_spd = 0.1;
inventory_vertical_bobbing_height = 1;

item_take_lerp_movement_spd = 0.1;

weapon_vertical_bobbing_height = 1;

firearm_aiming_aim_transition_spd = 0.2;
firearm_aiming_hip_transition_spd = 0.1;
firearm_aiming_angle_transition_spd = 0.17;

firearm_recoil_recovery_spd = 0.2;
firearm_recoil_angle_recovery_spd = 0.1;

// Combat Settings
sight_ignore_radius = 820;

combat_target_aim_recovery_spd = 0.1;

combat_target_vertical_interpolation_min = 0.4;
combat_target_vertical_interpolation_max = 0.85;

combat_attack_delay_min = 2;
combat_attack_delay_max = 22;

// Inventory Settings
item_drop_base_horizontal_power = 8;
item_drop_random_horizontal_power = 3;
item_drop_movement_horizontal_power = 14;

item_drop_base_vertical_power = -16;
item_drop_random_vertical_power = 4;
item_drop_movement_vertical_power = 8;

player_inventory_ui_fade_delay = 160;
player_inventory_ui_alpha_decay = 0.95;

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

draw_xscale = sign(image_xscale) != 0 ? sign(image_xscale) : 1;
draw_yscale = 1;

draw_angle = 0;
draw_angle_value = 0;

draw_angle_trig_sine = 0;
draw_angle_trig_cosine = 1;

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

bobbing_animation_value = 0;

unit_equipment_inventory_position_x = 0;
unit_equipment_inventory_position_y = 0;

firearm_weapon_primary_hand_pivot_offset_ax = 0;
firearm_weapon_primary_hand_pivot_offset_ay = 0;
firearm_weapon_primary_hand_pivot_offset_bx = 0;
firearm_weapon_primary_hand_pivot_offset_by = 0;
firearm_weapon_primary_hand_pivot_transition_value = 0;

firearm_weapon_hip_pivot_to_aim_pivot_transition_value = 0;
firearm_weapon_primary_hand_pivot_to_unit_inventory_pivot_transition_value = 0;

// Combat Variables
combat_target = undefined;
combat_strategy = UnitCombatStrategy.NullStrategy;
combat_priority_rank = UnitCombatPriorityRank.NullPriorityCombat;

combat_target_aim_value = 0;
combat_target_vertical_interpolation = 0.5;

combat_attack_delay = random_range(combat_attack_delay_min, combat_attack_delay_max);

combat_sight_calculation_delay = irandom_range(0, GameManager.sight_collision_calculation_frame_delay);

combat_attack_impulse_power = -1;
combat_attack_impulse_position_x = 0;
combat_attack_impulse_position_y = 0;
combat_attack_impulse_horizontal_vector = 0;
combat_attack_impulse_vertical_vector = 0;

// Weapon Variables
weapon_active = false;
weapon_reload = false;
weapon_aim = false;

weapon_aim_x = 0;
weapon_aim_y = 0;

weapon_equipped = noone;

// Inventory Variables
inventory_index = -1;
inventory_slots = array_create(0);
unit_lift_strength = 0;

player_inventory_ui_fade_timer = 0;
player_inventory_ui_alpha = 0;

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
input_drop = false;

input_cursor_x = 0;
input_cursor_y = 0;

// Pathfinding Variables
pathfinding_path = undefined;
pathfinding_path_index = 0;
pathfinding_path_ended = true;

pathfinding_recalculate = false;

pathfinding_path_start_x = 0;
pathfinding_path_start_y = 0;
pathfinding_path_end_x = 0;
pathfinding_path_end_y = 0;

pathfinding_jump = true;

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

// Instantiate Unit Inventory Slots
global.unit_packs[unit_pack].inventory_slot_init(id);

// Weapons DEBUG
if (true)
{
	unit_inventory_add_item(id, InventoryItemPack.Ammo, 5);
	instance_create_item(InventoryItemPack.Ammo, x, y - 48, 5);
	
	var temp_weapon_equip_slot_index = unit_inventory_add_item(id, InventoryItemPack.CorsoRifle);
	unit_inventory_add_item(id, InventoryItemPack.CorsoRifle);
	show_debug_message(temp_weapon_equip_slot_index);
	unit_inventory_change_slot(id, temp_weapon_equip_slot_index);
}
else
{
	instance_create_item(InventoryItemPack.CorsoRifle, x, y - 48);
	unit_inventory_add_item(id, InventoryItemPack.Ammo);
}
