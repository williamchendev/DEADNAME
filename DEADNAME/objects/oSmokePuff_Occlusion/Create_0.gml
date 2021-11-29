/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Variables
unit_collision_num = 0;
unit_collision_list = ds_list_create();

// Surfaces
smoke_surface = noone;
occlusion_surface = noone;
occlusion_remove_surface = noone;
smoke_final_surface = noone;

occlusion_map = shader_get_sampler_index(shd_basicocclusion, "occlusionTex");
occlusion_remove_map = shader_get_sampler_index(shd_basicocclusion, "noOcclusionTex");