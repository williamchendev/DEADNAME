/// @description Insert description here
// You can write your code in this editor

//
if (!mouse_check_button_pressed(mb_left)) {
	return;
}

//var temp_explosion_x = x;
//var temp_explosion_y = y;
var temp_explosion_x = mouse_room_x();
var temp_explosion_y = mouse_room_y();
	
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
	
//
var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, -3999, oSmokePuff_Occlusion);
temp_smoke_inst.velocity_spd = 1;
temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
temp_smoke_inst.colors_sprite_index = sSmokePuff_Large_Sprite9;
temp_smoke_inst.normals_sprite_index = sSmokePuff_Large_NormalMap7;
	
//
var temp_smoke_num = 15;
for (var i = 0; i < temp_smoke_num; i++) {
	var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, 1, oSmokePuff);
	temp_smoke_inst.velocity_spd = 5 + ((i / temp_smoke_num) * 5) + temp_smoke_power;
	temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
	temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
	temp_smoke_inst.colors_sprite_index = sSmokePuff_Large_Sprite9;
	temp_smoke_inst.normals_sprite_index = sSmokePuff_Large_NormalMap7;
}
temp_smoke_num = 5;
for (var i = 0; i < temp_smoke_num; i++) {
	var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, -3999, oSmokePuff_Occlusion);
	temp_smoke_inst.velocity_spd = i + temp_smoke_power;
	temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
	temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
	temp_smoke_inst.colors_sprite_index = sSmokePuff_Large_Sprite9;
	temp_smoke_inst.normals_sprite_index = sSmokePuff_Large_NormalMap7;
}

/*
temp_smoke_num = 20;
for (var i = 0; i < temp_smoke_num; i++) {
	var temp_smoke_inst = instance_create_depth(temp_explosion_x, temp_explosion_y, -3999, oSmokePuff);
	temp_smoke_inst.velocity_spd = 4 + ((i / temp_smoke_num) * 12) + temp_smoke_power;
	temp_smoke_inst.velocity_direction = temp_smoke_angle + random_range(-temp_smoke_random_angle, temp_smoke_random_angle);
	temp_smoke_inst.velocity_wall_slowdown = temp_smoke_wall_slowdown;
}

//
//instance_destroy();