/// @description Spot Light Cleanup Event
// Destroy DS List upon Object Deletion

// Destroy Spot Light Shadow Collisions DS List
ds_list_destroy(spot_light_collisions_list);
spot_light_collisions_list = -1;
