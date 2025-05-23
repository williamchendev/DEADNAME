/// @description Explosion Init Event
// Creates the Explosion Effect and all of the Object Instances necessary for it

// Lighting Engine Default Dynamic Object Initialization
event_inherited();

//
image_angle = random(360);

//
instance_create_depth(x, y, 0, oExplosion_Flare_PointLight);

//
instance_create_depth(x, y, 0, oExplosion_Shockwave);

//
var temp_back_explosion_clouds_num = irandom_range(12, 18);

for (var i = 0; i < temp_back_explosion_clouds_num; i++)
{
	instance_create_depth(x, y, 0, oExplosion_SmokeCloud, { image_angle: random(360), sub_layer_index: 0 });
}

var temp_front_explosion_clouds_num = irandom_range(12, 18);

for (var i = 0; i < temp_front_explosion_clouds_num; i++)
{
	instance_create_depth(x, y, 0, oExplosion_SmokeCloud, { image_angle: random(360), sub_layer_index: -1 });
}
