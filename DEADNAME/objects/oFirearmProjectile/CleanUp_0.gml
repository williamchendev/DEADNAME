/// @description Firearm Projectile CleanUp Event
// Cleans up any unused Data Structures upon the Firearm Projectile's uninstantiation

// Clear Indexing Lists
ds_list_destroy(platform_list);
ds_list_destroy(bullet_trail_list);
platform_list = -1;
bullet_trail_list = -1;