/// @description Insert description here
// You can write your code in this editor

// Delete all Windows
ds_list_destroy(windows_ds_list);
windows_ds_list = -1;

//
if (!is_undefined(debug_path))
{
	ds_list_destroy(debug_path);
	debug_path = -1;
}
