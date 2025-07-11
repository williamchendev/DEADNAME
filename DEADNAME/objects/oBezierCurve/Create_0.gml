/// @description Bezier Curve Initialization Event
// Creates the Bezier Curve Object's Data Structures to manage its Path

// Disable Rendering & Visibility
visible = false;
sprite_index = -1;

// Path Variables
path_count = 0;

// Path Data Structure DS Lists
path_x_coordinate_list = ds_list_create();
path_y_coordinate_list = ds_list_create();

path_h_vector_list = ds_list_create();
path_v_vector_list = ds_list_create();

path_thickness_list = ds_list_create();