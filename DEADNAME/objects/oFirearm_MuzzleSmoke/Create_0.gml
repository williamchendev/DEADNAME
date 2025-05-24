/// @description Muzzle Smoke Cloud Init Event
// Instantiates the Muzzle Smoke Cloud

// Lighting Engine Dynamic Object Initialization
event_inherited();

// Smoke Cloud Random Sprite Settings
image_index = irandom_range(0, sprite_get_number(sprite_index) - 1);

// Smoke Cloud Transparency & Alpha Decay Settings
image_alpha = alpha;

// Smoke Cloud Muzzle Position Offset Behaviour
var temp_muzzle_position_offset = random_range(spawn_offset_min, spawn_offset_max);
x += dcos(image_angle) * temp_muzzle_position_offset;
y += -dsin(image_angle) * temp_muzzle_position_offset;

// Smoke Cloud Rotation Speed Settings
movement_angle = image_angle + random_range(-random_movement_direction, random_movement_direction);

// Smoke Cloud Rotation and Image Angle Settings
image_angle = random(360);
rotation_spd = random_range(-random_rotation_spd, random_rotation_spd);

// Smoke Cloud Size & Size Decay Settings
size = random_range(size_min, size_max);
size_decay = random_range(size_decay_min, size_decay_max);

// Smoke Cloud Movement Speed Settings
movement_spd = movement_spd - size;
movement_spd_decay = random_range(movement_decay_min, movement_decay_max);

// Smoke Cloud Movement Direction Settings
movement_direction_h = dcos(movement_angle);
movement_direction_v = -dsin(movement_angle);

movement_direction_h += random_range(-random_movement_offset, random_movement_offset);
movement_direction_v += random_range(-random_movement_offset, random_movement_offset);
