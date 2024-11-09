/// @description Unit Clean Up Event
// Cleans up the variables and DS Structures of the Unit on the Unit's Destroy Event

// Clean Up Unit's Platform DS List
ds_list_destroy(platform_list);
platform_list = -1;