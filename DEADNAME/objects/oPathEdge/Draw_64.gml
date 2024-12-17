/// @description Debug Edge Draw Event
// Draws Debug info on the Edge Object

if (!global.debug) {
	return;
}

// Draw Path Edge
if (nodes[0] != noone and nodes[1] != noone) {
	// Camera GUI Layer
	var temp_camera_x = 0;
	var temp_camera_y = 0;
	var temp_camera_width = 640;
	var temp_camera_height = 360;
	var temp_camera_exists = instance_exists(oCamera);
	if (temp_camera_exists) {
		var temp_camera_inst = instance_find(oCamera, 0);
		temp_camera_x = temp_camera_inst.x;
		temp_camera_y = temp_camera_inst.y;
		temp_camera_width = temp_camera_inst.camera_width;
		temp_camera_height = temp_camera_inst.camera_height;
		display_set_gui_size(temp_camera_width, temp_camera_height);
	}
	
	// Find Node Position
	var temp_nodea_x = nodes[0].x;
	var temp_nodea_y = nodes[0].y;
	var temp_nodeb_x = nodes[1].x;
	var temp_nodeb_y = nodes[1].y;
	nodes[0].x = (nodes[0].x - temp_camera_x);
	nodes[0].y = (nodes[0].y - temp_camera_y);
	nodes[1].x = (nodes[1].x - temp_camera_x);
	nodes[1].y = (nodes[1].y - temp_camera_y);
	x -= temp_camera_x;
	y -= temp_camera_y;
	
	// Draw Edges between Nodes
	draw_line(nodes[0].x, nodes[0].y, nodes[1].x, nodes[1].y);
	draw_text_outline(x, y, c_white, c_black, string(distance));
	if (jump) {
		draw_text_outline(x, y + 11, c_white, c_black, "[Jump]");
		draw_rectangle(nodes[0].x - 5, nodes[0].y - 5, nodes[0].x + 5, nodes[0].y + 5, false);
		draw_rectangle(nodes[1].x - 5, nodes[1].y - 5, nodes[1].x + 5, nodes[1].y + 5, false);
	}
	if (teleport) {
		draw_text_outline(x, y + 11, c_white, c_black, "[Teleport]");
		draw_rectangle(nodes[0].x - 5, nodes[0].y - 5, nodes[0].x + 5, nodes[0].y + 5, false);
		draw_rectangle(nodes[1].x - 5, nodes[1].y - 5, nodes[1].x + 5, nodes[1].y + 5, false);
	}
	
	// Reset Node Positions
	nodes[0].x = temp_nodea_x;
	nodes[0].y = temp_nodea_y;
	nodes[1].x = temp_nodeb_x;
	nodes[1].y = temp_nodeb_y;
	x += temp_camera_x;
	y += temp_camera_y;
}