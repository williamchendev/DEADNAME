/// @description Arm Initialization
// Creates the variables necessary for the Arm Effect Object

// Basic Lighting Inheritance
event_inherited();

// Arm Settings
limb_anchor_x = x;
limb_anchor_y = y;

limb_target_x = x;
limb_target_y = y;

limb_sprite = sWilliam_Arms;
limb_normal_sprite = sWolf_Arms_NormalMap;

limb_direction = 1;

limb_length = 0;
limb_compress = 0.3;

// Arm Variables
point1_x = 0;
point1_y = 0;

point2_x = 0;
point2_y = 0;

angle_1 = 0;
angle_2 = 0;

// Surface Variables
surface_x_offset = 0;
surface_y_offset = 0;

// Shader Variables
vectortransform_shader_angle = shader_get_uniform(shd_vectortransform, "vectorAngle");
vectortransform_shader_scale = shader_get_uniform(shd_vectortransform, "vectorScale");