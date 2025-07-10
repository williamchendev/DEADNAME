/// @description Bezier Curve Destroy Event
// Destroys all the Bezier Curve's Data Structures managing its Path

// Destroy all Path Data Structure DS Lists
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
