/// @description Worker Initialization
// Initializes the DS Lists for logging object and behaviours to organize for the Lighting Engine

// Bulk Static DS Lists
bulk_static_layers_list = ds_list_create();
bulk_static_regions_list = ds_list_create();

// Dynamic Object DS List
dynamic_object_list = ds_list_create();
dynamic_type_list = ds_list_create();

// Unlit Object DS List
unlit_object_list = ds_list_create();
unlit_type_list = ds_list_create();
unlit_depth_list = ds_list_create();

// UI Object DS List
ui_object_list = ds_list_create();
ui_type_list = ds_list_create();
ui_depth_list = ds_list_create();
