/// @description Default Planet Clean Up
// Cleans up the Planet's Data Structures and Buffers used for calculating the Planet's Behaviour

// Perform Inherited Celestial Body Cleanup Behaviour
event_inherited();

// Destroy Clouds Depth Sorted Rendering DS List
ds_list_destroy(clouds_render_list);
clouds_render_list = -1;
