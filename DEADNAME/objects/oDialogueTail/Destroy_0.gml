/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

//
ds_list_destroy(path_x_coordinate_list);
path_x_coordinate_list = -1;

ds_list_destroy(path_y_coordinate_list);
path_y_coordinate_list = -1;
	
ds_list_destroy(path_h_vector_list);
path_h_vector_list = -1;

ds_list_destroy(path_v_vector_list);
path_v_vector_list = -1;

ds_list_destroy(path_thickness_list);
path_thickness_list = -1;
