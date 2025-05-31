/// @description Unlit Impact Hitmarker Init Event
// Instantiates the Unlit Object Hitmarker Effect

// Set Unlit Object Type for Unlit Object Initialization in the Lighting Engine
object_type = LightingEngineUnlitObjectType.Hitmarker;

// Default Unlit Object Initialization Behaviour
event_inherited();

// Set Random Hitmarker Sprite Index
image_index = irandom(sprite_get_number(sprite_index));

// Set Random Hitmarker Rotation
image_angle = irandom(360);

// Set Random Hitmarker Drop Shadow Offset
hitmarker_dropshadow_horizontal_offset = random_range(-3, 3);
hitmarker_dropshadow_vertical_offset = random_range(-3, 3);

// Set Hitmarker Destroy Timer
hitmarker_destroy_timer = 8;
