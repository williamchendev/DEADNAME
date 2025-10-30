/// @description Explosion Init Event
// Creates the Explosion Effect and all of the Object Instances necessary for it

//
var temp_back_hitmarker = instance_create_depth(x, y, 0, oExplosion_Hitmarker);
var temp_front_hitmarker = instance_create_depth(x, y, 0, oExplosion_Hitmarker);

//
var temp_solid_collision = collision_circle(x, y, 12, oSolid, true, true);

if (temp_solid_collision != noone and instance_exists(temp_solid_collision))
{
	//
	temp_front_hitmarker.image_angle = point_check_solid_surface_angle(x, y, temp_solid_collision);
	
	//
	temp_front_hitmarker.sprite_index = sImpact_Explosion_Collision;
	
	//
	temp_front_hitmarker.image_xscale = random(1) > 0.5 ? 1 : -1;
	temp_front_hitmarker.image_yscale = 1;
}
else
{
	//
	temp_front_hitmarker.image_angle = random(360);
	
	//
	temp_front_hitmarker.sprite_index = sImpact_Explosion_Collisionless;
	
	//
	temp_front_hitmarker.image_xscale = random(1) > 0.5 ? 1 : -1;
	temp_front_hitmarker.image_yscale = random(1) > 0.5 ? 1 : -1;
}

//
temp_front_hitmarker.image_index = irandom_range(0, sprite_get_number(sprite_index) - 1);

//
temp_back_hitmarker.sprite_index = temp_front_hitmarker.sprite_index;
temp_back_hitmarker.image_index = temp_front_hitmarker.image_index;

temp_back_hitmarker.image_xscale = temp_front_hitmarker.image_xscale;
temp_back_hitmarker.image_yscale = temp_front_hitmarker.image_yscale;

temp_back_hitmarker.image_angle = temp_front_hitmarker.image_angle;

//
temp_back_hitmarker.image_blend = c_black;

//
temp_back_hitmarker.x += (random(1) > 0.5 ? 1 : -1) * random_range(1, 3);
temp_back_hitmarker.y += (random(1) > 0.5 ? 1 : -1) * random_range(1, 3);

//
instance_create_depth(x, y, 0, oExplosion_Flare_PointLight);

//
instance_create_depth(x, y, 0, oExplosion_Shockwave);

//
instance_create_depth(x, y, 0, oExplosion_Cloud, { sub_layer_index: 0 });
instance_create_depth(x, y, 0, oExplosion_Cloud, { sub_layer_index: -1 });

//
instance_destroy();
