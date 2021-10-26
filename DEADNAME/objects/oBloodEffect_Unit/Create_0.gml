/// @description Blood Init Event
// Creates the variables and settings of the Blood Effect for oUnit Objects

// Settings
unit_inst = noone;
corpse_inst = noone;

blood_sprite = sBloodEffect_UnitSplatter_Blur;
blood_color = c_white;
blood_alpha = 0.9;

// Variables
blood_x = 0;
blood_y = 0;

corpse_occlusion_list = noone;

// Surface Variables
blood_surface = noone;
occlusion_surface = noone;
occlusion_remove_surface = noone;

// Shader Textures
occlusion_map = shader_get_sampler_index(shd_basicocclusion, "occlusionTex");
occlusion_remove_map = shader_get_sampler_index(shd_basicocclusion, "noOcclusionTex");

// Draw Variables
image_index = irandom(sprite_get_number(blood_sprite) - 1);

image_angle = 90 * irandom_range(0, 3);