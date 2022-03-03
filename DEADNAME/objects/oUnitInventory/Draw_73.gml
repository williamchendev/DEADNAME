/// @description Inventory GUI Draw Event
// draws the GUI Inventory Menu to the screen

// Skips drawing inventory unless GUI mode is active
if (!draw_inventory) {
	exit;
}

// Camera GUI Layer
var temp_camera_x = 0;
var temp_camera_y = 0;
var temp_camera_exists = instance_exists(oCamera);
if (temp_camera_exists) {
	var temp_camera_inst = instance_find(oCamera, 0);
	temp_camera_x = temp_camera_inst.x;
	temp_camera_y = temp_camera_inst.y;
	surface_set_target(temp_camera_inst.gui_surface);
}

// Draw Inventory Background
var temp_x = draw_inventory_x + inventory_offset_size + inventory_outline_size - temp_camera_x;
var temp_y = draw_inventory_y + inventory_offset_size + inventory_outline_size - temp_camera_y;
if (draw_sprite_index == noone) {
	// Draw blank inventory without sprite
	draw_set_color(c_black);
	draw_roundrect(temp_x - draw_inventory_outline_size, temp_y - draw_inventory_outline_size, temp_x + (inventory_width * inventory_grid_size) + draw_inventory_outline_size, temp_y + (inventory_height * inventory_grid_size) + draw_inventory_outline_size, false);
}

// Reset Camera GUI Layer
if (temp_camera_exists) {
	surface_reset_target();
}