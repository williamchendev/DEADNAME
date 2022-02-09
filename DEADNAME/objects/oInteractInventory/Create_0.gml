/// @description Interact Inventory Init
// Creates the variables and settings of the Inventory Interaction

// Interact Initialization
event_inherited();

// Interact Settings
interact_description = "Scavenge Items";

interact_icon_index = 4;
interact_select_outline_color = make_color_rgb(75, 105, 57);
interact_select_second_outline_color = c_white;

// Inventory Settings
interact_inventory_obj = noone;

// Animation Settings
interact_mirror_select_obj = true;
interact_inventory_obj_select_mask_padding_size = 30;

// Inventory Settings
interact_inventory_player_action = false;

// Animation Variables
interact_inventory_obj_sprite = sDebugSystem;
interact_inventory_obj_bbox_left = bbox_left;
interact_inventory_obj_bbox_right = bbox_right;
interact_inventory_obj_bbox_top = bbox_top;
interact_inventory_obj_bbox_bottom = bbox_bottom;

interact_inventory_obj_mask_list = ds_list_create();
interact_inventory_obj_outline_list = ds_list_create();