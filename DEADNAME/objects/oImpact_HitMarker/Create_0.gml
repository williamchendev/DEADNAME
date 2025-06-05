/// @description Unlit Impact Hitmarker Init Event
// Instantiates the Unlit Object Hitmarker Effect

// Set Unlit Object Type for Unlit Object Initialization in the Lighting Engine
object_type = LightingEngineUnlitObjectType.Hitmarker;

// Set Unlit Object Depth based on if the Hitmarker Impact made contact with Collider
object_depth = hitmarker_contact ? 0 : -0.08;

// Default Unlit Object Initialization Behaviour
event_inherited();

// Set Random Hitmarker & Trail Sprite Index
hitmarker_image_index = irandom(sprite_get_number(hitmarker_sprite));
trail_image_index = irandom(sprite_get_number(trail_sprite));

// Set Random Hitmarker Rotation
hitmarker_image_angle = irandom(360);

// Set Random Hitmarker Drop Shadow Offset
hitmarker_dropshadow_horizontal_offset = random_range(-3, 3);
hitmarker_dropshadow_vertical_offset = random_range(-3, 3);

// Set Trail Multiplier
trail_multiplier = 1;

// Set Hitmarker Destroy Timer
hitmarker_destroy_timer = hitmarker_life;
