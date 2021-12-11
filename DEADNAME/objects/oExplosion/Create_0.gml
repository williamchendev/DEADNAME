/// @description Insert description here
// You can write your code in this editor

// Singleton
game_manager = instance_find(oGameManager, 0);

// Explosion Settings
explosion_damage = 8;
explosion_radius = 72;
explosion_force = 40;

smoke_sprite_small = sSmokePuff_Small_Sprite1;
smoke_normalmap_small = sSmokePuff_Small_NormalMap1;

smoke_sprite_large = sSmokePuff_Large_Sprite1;
smoke_normalmap_large = sSmokePuff_Large_NormalMap1;

// Explosion Variables
explosion_objects_empty = false;
explosion_objects = ds_list_create();

// Explosion Creation Behaviour
var temp_explosion_x = x;
var temp_explosion_y = y;

// Explosion Damage Calculation
var temp_unit_list = ds_list_create();
var temp_unit_num = collision_circle_list(temp_explosion_x, temp_explosion_y, explosion_radius, oUnit, false, true, temp_unit_list, false);
if (temp_unit_num > 0) {
	for (var i = 0; i < temp_unit_num; i++) {
		// Unit Calculation
		var temp_unit = ds_list_find_value(temp_unit_list, i);
		
		// Damage Position
		var temp_hit_x = random_range(temp_unit.bbox_left, temp_unit.bbox_right);
		var temp_hit_y = random_range(temp_unit.bbox_top, temp_unit.bbox_bottom);
		var temp_hit_direction = point_direction(x, y, temp_hit_x, temp_hit_y);
		
		// Skip Unit if Hit not Viable
		if (collision_line(x, y, temp_hit_x, temp_hit_y, oSolid, false, true)) {
			continue;
		}
		
		// Damage Calculation
		temp_unit.health_points -= explosion_damage;
		temp_unit.health_points = clamp(temp_unit.health_points, 0, temp_unit.max_health_points);
					
		// Blood Effect
		create_unit_blood(temp_unit, temp_hit_x, temp_hit_y, temp_hit_direction);
					
		// Ragdoll Effect
		if (temp_unit.health_points == 0) {
			temp_unit.force_applied = true;
			temp_unit.force_x = temp_unit.x;
			temp_unit.force_y = temp_hit_y;
			temp_hit_direction = point_direction(x, y, temp_unit.x, temp_hit_y);
			temp_unit.force_xvector = cos(degtorad(temp_hit_direction)) * explosion_force;
			temp_unit.force_yvector = sin(degtorad(temp_hit_direction)) * explosion_force;
		}
    }
}
ds_list_destroy(temp_unit_list);

// Explosion Depth Calculation
var temp_explosion_back_depth = 1;
var temp_explosion_front_depth = -3999;

var temp_highest_unit_layer_id = -1;
for (var i = 0; i < instance_number(oUnit); i++) {
	var temp_unit = instance_find(oUnit, i);
	if (ds_list_find_index(game_manager.instantiated_units, temp_unit) != -1) {
		if (temp_highest_unit_layer_id < temp_unit.layer_id) {
			temp_highest_unit_layer_id = temp_unit.layer_id;
		}
	}
}

var temp_highest_explosion_layer_id = -1;
for (var i = 0; i < instance_number(oExplosion); i++) {
	var temp_explosion = instance_find(oExplosion, i);
	if (temp_highest_explosion_layer_id < temp_explosion.layer_id) {
		temp_highest_explosion_layer_id = temp_explosion.layer_id;
	}
}
if (temp_highest_explosion_layer_id == -1) {
	layer_id = 1;
}
else {
	layer_id = temp_highest_explosion_layer_id + 1;
}
temp_explosion_front_depth = ((temp_highest_explosion_layer_id + 1) + (temp_highest_unit_layer_id + 1)) * -5;

//
var temp_smoke_power = 1;
var temp_smoke_angle = 0;
var temp_smoke_random_angle = 180;
var temp_smoke_wall_slowdown = true;
	
//
var temp_solid_inst = collision_point(temp_explosion_x, temp_explosion_y, oSolid, false, true);
if (temp_solid_inst != noone) {
	temp_smoke_power = 4;
	temp_smoke_random_angle = 65;
	temp_smoke_angle = point_check_solid_surface_angle(temp_explosion_x, temp_explosion_y, temp_solid_inst) + 90;
	temp_smoke_wall_slowdown = false;
}
	
// Instantiate Explosion Center Smoke Puff
var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, temp_explosion_front_depth, oSmokePuff_Occlusion);
temp_smoke_inst.velocity_spd = 0;
temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
temp_smoke_inst.colors_sprite_index = smoke_sprite_large;
temp_smoke_inst.normals_sprite_index = smoke_normalmap_large;
temp_smoke_inst.image_index = irandom(sprite_get_number(temp_smoke_inst.colors_sprite_index) - 1);

ds_list_add(explosion_objects, temp_smoke_inst.id);
	
//
var temp_smoke_num = 25;
for (var i = 0; i < temp_smoke_num; i++) {
	var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, temp_explosion_back_depth, oSmokePuff);
	temp_smoke_inst.velocity_spd = 4 + ((i / temp_smoke_num) * 5) + temp_smoke_power;
	temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
	temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
	temp_smoke_inst.color_transition_start = random_range(10, 25);
	temp_smoke_inst.colors_sprite_index = smoke_sprite_large;
	temp_smoke_inst.normals_sprite_index = smoke_normalmap_large;
	temp_smoke_inst.image_index = irandom(sprite_get_number(temp_smoke_inst.colors_sprite_index) - 1);
	
	ds_list_add(explosion_objects, temp_smoke_inst.id);
}
temp_smoke_num = 5;
for (var i = 0; i < temp_smoke_num; i++) {
	var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, temp_explosion_front_depth, oSmokePuff_Occlusion);
	temp_smoke_inst.velocity_spd = i + temp_smoke_power;
	temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
	temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
	temp_smoke_inst.color_transition_start = random_range(35, 50);
	temp_smoke_inst.colors_sprite_index = smoke_sprite_large;
	temp_smoke_inst.normals_sprite_index = smoke_normalmap_large;
	temp_smoke_inst.image_index = irandom(sprite_get_number(temp_smoke_inst.colors_sprite_index) - 1);
	
	ds_list_add(explosion_objects, temp_smoke_inst.id);
}

//
var temp_explosionimpact_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, temp_explosion_front_depth, oExplosionImpact);
temp_explosionimpact_inst.image_blend = c_white;
ds_list_add(explosion_objects, temp_explosionimpact_inst.id);

//
temp_smoke_num = 25;
for (var i = 0; i < temp_smoke_num; i++) {
	var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, temp_explosion_front_depth, oSmokePuff);
	temp_smoke_inst.velocity_spd = 4 + ((i / temp_smoke_num) * 8) + temp_smoke_power;
	temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
	temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
	temp_smoke_inst.colors_sprite_index = smoke_sprite_small;
	temp_smoke_inst.normals_sprite_index = smoke_normalmap_small;
	temp_smoke_inst.image_index = irandom(sprite_get_number(temp_smoke_inst.colors_sprite_index) - 1);
	
	ds_list_add(explosion_objects, temp_smoke_inst.id);
}