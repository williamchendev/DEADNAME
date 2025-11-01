/// @description Explosion Hitmarker Init
// Initializes the Explosion Hitmarker Unlit Object

// Set Unlit Object Type for Unlit Object Initialization in the Lighting Engine
object_type = LightingEngineUnlitObjectType.Default;

// Set the Depth of the Explosion Hitmarker 
// Explosion Hitmarker must be Behind the Front Explosion Clouds and in Front of the Back Explosion Clouds
object_depth = -0.01;

// Lighting Engine Default Dynamic Object Initialization
event_inherited();

// Set Explosion Impact Sprites
if (hitmarker_collision)
{
	// Set Explosion Impact Sprite as Collision Sprite
	sprite_index = collision_sprite;
}
else
{
	// Set Explosion Impact Sprite as Collisionless Sprite
	sprite_index = collisionless_sprite;
}

// Set Explosion Impact Hitmarker Image Index to random value
image_index = irandom_range(0, sprite_get_number(sprite_index) - 1);

// Set Explosion Impact Inital Size
image_xscale *= size;
image_yscale *= size;