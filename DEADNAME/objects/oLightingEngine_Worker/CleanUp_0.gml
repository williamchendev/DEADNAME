/// @description Worker Cleanup
// Destroys any unnecessary Data Structures used by the Worker previously

// Destroy Bulk Static DS Lists
ds_list_destroy(bulk_static_layers_list);
bulk_static_layers_list = -1;

ds_list_destroy(bulk_static_regions_list);
bulk_static_regions_list = -1;

// Destroy Dynamic Object DS Lists
ds_list_destroy(dynamic_object_list);
dynamic_object_list = -1;

ds_list_destroy(dynamic_type_list);
dynamic_type_list = -1;

// Destroy Unlit Object DS Lists
ds_list_destroy(unlit_object_list);
unlit_object_list = -1;

ds_list_destroy(unlit_type_list);
unlit_type_list = -1;

ds_list_destroy(unlit_depth_list);
unlit_depth_list = -1;

// Destroy Unlit Object DS Lists
ds_list_destroy(ui_object_list);
unlit_object_list = -1;

ds_list_destroy(ui_type_list);
ui_type_list = -1;

ds_list_destroy(ui_depth_list);
ui_depth_list = -1;
