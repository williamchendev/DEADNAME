/// @description Init Point Light Source
// Creates the DS List and Variables for Point Light Solid Box Shadow Collisions

// Point Light Solid Collisions List
point_light_collisions_list = ds_list_create();

// Point Light Movement Detection Variables
old_point_light_radius = undefined;
old_point_light_position_x = undefined;
old_point_light_position_y = undefined;

// Remove Unnecessary Rendering Behaviour
visible = false;
sprite_index = -1;