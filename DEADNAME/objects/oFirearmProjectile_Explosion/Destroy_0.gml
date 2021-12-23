/// @description Explosive Projectile Destroy Event
// Spawns an Explosion Object to manage the visual effects and behaviour of the Explosion

// Inherit the parent event
event_inherited();

// Instantiate the Explosion Manager Object
instance_create_layer(x, y, layer_get_id("Instances"), oExplosion);