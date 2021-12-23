/// @description Melee Weapon DS Cleanup
// Clears the Melee Weapon Data Structures on the destroy event

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