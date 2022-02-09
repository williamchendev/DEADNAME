/// @description Clean Up DS Lists
// Destroys DS Lists

// Destroy Surfaces
event_inherited();

// Destroy DS Lists
ds_list_destroy(interact_inventory_obj_mask_list);
interact_inventory_obj_mask_list = -1;

ds_list_destroy(interact_inventory_obj_outline_list);
interact_inventory_obj_outline_list = -1;