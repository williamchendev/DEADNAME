/// @description Point Light Cleanup Event
// Destroy DS List upon Object Deletion

// Destroy Point Light Shadow Collisions DS List
ds_list_destroy(point_light_collisions_list);
point_light_collisions_list = -1;
