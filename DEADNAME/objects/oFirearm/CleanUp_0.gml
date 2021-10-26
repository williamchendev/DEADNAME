/// @description Firearm DS Cleanup
// Clears the Firearm Data Structures on the destroy event

// Clear Flash Effect DS List Data
ds_list_destroy(flash_timer);
ds_list_destroy(flash_length);
ds_list_destroy(flash_direction);
ds_list_destroy(flash_xposition);
ds_list_destroy(flash_yposition);
ds_list_destroy(flash_imageindex);
flash_timer = -1;
flash_length = -1;
flash_direction = -1;
flash_xposition = -1;
flash_yposition = -1;
flash_imageindex = -1;

// Clear Hit Effect DS List Data
ds_list_destroy(hit_effect_timer);
ds_list_destroy(hit_effect_index);
ds_list_destroy(hit_effect_sign);
ds_list_destroy(hit_effect_xpos);
ds_list_destroy(hit_effect_ypos);
ds_list_destroy(hit_effect_xscale);
ds_list_destroy(hit_effect_yscale);
ds_list_destroy(hit_effect_rotation);
hit_effect_timer = -1;
hit_effect_index = -1;
hit_effect_sign = -1;
hit_effect_xpos = -1;
hit_effect_ypos = -1;
hit_effect_xscale = -1;
hit_effect_yscale = -1;
hit_effect_rotation = -1;