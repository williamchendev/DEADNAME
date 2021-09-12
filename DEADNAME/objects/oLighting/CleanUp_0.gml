/// @description Lighting Clean Up Event
// Destroys unused variables and cleans up memory

// Destroy oBasic Depth List
ds_list_destroy(basic_object_depth_list);
basic_object_depth_list = -1;