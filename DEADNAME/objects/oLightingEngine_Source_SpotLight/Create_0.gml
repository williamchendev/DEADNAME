/// @description Init Spot Light Source
// Creates the DS List and Variables for Spot Light Solid Box Shadow Collisions

// Spot Light Solid Collisions List
spot_light_collisions_list = ds_list_create();

// Spot Light Movement Detection Variables
old_spot_light_radius = undefined;
old_spot_light_position_x = undefined;
old_spot_light_position_y = undefined;
old_spot_light_angle = undefined;
old_spot_light_fov = undefined;

// Remove Unnecessary Rendering Behaviour
visible = false;
sprite_index = -1;