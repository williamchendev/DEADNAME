/// @description Default Dynamic Cloud Cleanup Event
// Removes and Destroys the Default Dynamic Cloud's DS Lists

// Destroy all Cloud DS Lists
ds_list_destroy(clouds_image_index_list);
clouds_image_index_list = -1;

ds_list_destroy(clouds_rotation_list);
clouds_rotation_list = -1;

ds_list_destroy(clouds_horizontal_offset_list);
clouds_horizontal_offset_list = -1;
ds_list_destroy(clouds_vertical_offset_list);
clouds_vertical_offset_list = -1;

ds_list_destroy(clouds_horizontal_scale_list);
clouds_horizontal_scale_list = -1;
ds_list_destroy(clouds_vertical_scale_list);
clouds_vertical_scale_list = -1;

ds_list_destroy(clouds_alpha_list);
clouds_alpha_list = -1;
ds_list_destroy(clouds_alpha_filter_list);
clouds_alpha_filter_list = -1;

ds_list_destroy(clouds_color_list);
clouds_color_list = -1;
