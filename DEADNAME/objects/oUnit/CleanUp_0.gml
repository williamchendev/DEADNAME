/// @description Unit Clean Up Event
// Cleans up the variables and DS Structures of the Unit on the Unit's Destroy Event

// Destroy Unit Limbs
DELETE(limb_left_arm);
DELETE(limb_right_arm);

// Clean Up Unit's Platform DS List
ds_list_destroy(platform_list);
platform_list = -1;