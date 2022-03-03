/// @description Blood Init Event
// Creates the variables and settings of the Blood Effect for the Droplets

// Basic Lighting Inheritance
event_inherited();

// Settings
unit_inst = noone;
corpse_inst = noone;

// Variables
blood_size = 1;
blood_y = -5;

image_index = irandom(sprite_get_number(sprite_index) - 1);

// Case Behaviour
var temp_case_rotation_sign = 1;
if (random(1) < 0.5) {
	temp_case_rotation_sign = -1;
}
case_rotation = temp_case_rotation_sign * random_range(8, 18);
case_direction = random_range(45, 15) + 90;
case_spd = random_range(1.5, 4.5);
gravity_spd = 0.25;
spd = 0;

// Platform Behaviour
platform_list = ds_list_create();
for (var i = 0; i < instance_number(oPlatform); i++) {
	var temp_platform_inst = instance_find(oPlatform, i);
	if (temp_platform_inst.y > y) {
		ds_list_add(platform_list, temp_platform_inst);
	}
}