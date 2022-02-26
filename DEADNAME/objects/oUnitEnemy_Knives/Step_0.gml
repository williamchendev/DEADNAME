/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Ragdoll Hair Behaviour
if (ragdoll_hair_inst != noone) {
	if (instance_exists(ragdoll_hair_inst)) {
		var temp_ragdoll_hair_distance = point_distance(0, 0, ragdoll_hair_x * sign(image_xscale * draw_xscale), ragdoll_hair_y);
		var temp_ragdoll_hair_direction = point_direction(0, 0, ragdoll_hair_x * sign(image_xscale * draw_xscale), ragdoll_hair_y);
		var temp_ragdoll_hair_x = x + lengthdir_x(temp_ragdoll_hair_distance, temp_ragdoll_hair_direction + draw_angle);
		var temp_ragdoll_hair_y = y + lengthdir_y(temp_ragdoll_hair_distance, temp_ragdoll_hair_direction + draw_angle);

		ragdoll_hair_inst.phy_speed_x = temp_ragdoll_hair_x - ragdoll_hair_inst.phy_position_x;
		ragdoll_hair_inst.phy_speed_y = temp_ragdoll_hair_y - ragdoll_hair_inst.phy_position_y;

		for (var i = 0; i < array_length_1d(ragdoll_hair_list); i++) {
			ragdoll_hair_list[i].image_xscale = image_xscale;
		}
	}
}