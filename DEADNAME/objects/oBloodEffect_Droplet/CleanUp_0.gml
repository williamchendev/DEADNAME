/// @description Blood Clean Up Event
// Cleans up the variables and DS Structures of the Blood on the Blood Droplet's Destroy Event

// Clear Platform Indexing List
ds_list_destroy(platform_list);
platform_list = -1;