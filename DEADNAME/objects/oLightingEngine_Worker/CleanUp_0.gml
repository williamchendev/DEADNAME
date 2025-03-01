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
