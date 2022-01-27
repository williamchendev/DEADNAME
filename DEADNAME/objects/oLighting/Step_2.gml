/// @description Lighting Step Event
// Caches the oSolid Vertices for use in the Shadow Shader

// Stick to Camera Position
if (instance_exists(oCamera)) {
	var temp_camera = instance_find(oCamera, 0);
	x = floor(temp_camera.x);
	y = floor(temp_camera.y);
}

// Find Shadow Vertices
vertex_begin(shadows_vertex_buffer, shadows_vertex_format);
with (oSolid) {
	// Shadows Enabled
	if (shadows_enabled) {
		// Find Vertex Positions
		var temp_sprite_index = sprite_index;

		var temp_bbox_left = sprite_get_bbox_left(temp_sprite_index) * image_xscale;
		var temp_bbox_right = (sprite_get_bbox_right(temp_sprite_index) + 1) * image_xscale;
		var temp_bbox_top = sprite_get_bbox_top(temp_sprite_index) * image_yscale;
		var temp_bbox_bottom = sprite_get_bbox_bottom(temp_sprite_index) * image_yscale;
	
		temp_bbox_left -= sprite_get_xoffset(temp_sprite_index) * image_xscale;
		temp_bbox_bottom -= sprite_get_yoffset(temp_sprite_index) * image_yscale;
		temp_bbox_right -= sprite_get_xoffset(temp_sprite_index) * image_xscale;
		temp_bbox_top -= sprite_get_yoffset(temp_sprite_index) * image_yscale;
	
		var temp_point1_dis = point_distance(0, 0, temp_bbox_left, temp_bbox_top);
		var temp_point1_angle = point_direction(0, 0, temp_bbox_left, temp_bbox_top);
		var temp_point2_dis = point_distance(0, 0, temp_bbox_right, temp_bbox_top);
		var temp_point2_angle = point_direction(0, 0, temp_bbox_right, temp_bbox_top);
		var temp_point3_dis = point_distance(0, 0, temp_bbox_right, temp_bbox_bottom);
		var temp_point3_angle = point_direction(0, 0, temp_bbox_right, temp_bbox_bottom);
		var temp_point4_dis = point_distance(0, 0, temp_bbox_left, temp_bbox_bottom);
		var temp_point4_angle = point_direction(0, 0, temp_bbox_left, temp_bbox_bottom);
	
		var temp_left_top_x_offset = lengthdir_x(temp_point1_dis, temp_point1_angle + image_angle);
		var temp_left_top_y_offset = lengthdir_y(temp_point1_dis, temp_point1_angle + image_angle);
		var temp_right_top_x_offset = lengthdir_x(temp_point2_dis, temp_point2_angle + image_angle);
		var temp_right_top_y_offset = lengthdir_y(temp_point2_dis, temp_point2_angle + image_angle);
		var temp_right_bottom_x_offset = lengthdir_x(temp_point3_dis, temp_point3_angle + image_angle);
		var temp_right_bottom_y_offset = lengthdir_y(temp_point3_dis, temp_point3_angle + image_angle);
		var temp_left_bottom_x_offset = lengthdir_x(temp_point4_dis, temp_point4_angle + image_angle);
		var temp_left_bottom_y_offset = lengthdir_y(temp_point4_dis, temp_point4_angle + image_angle);
	
		// Create Shadow Quads from Vertice Triangles
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_left_top_x_offset - other.x, y + temp_left_top_y_offset - other.y, 0);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_left_top_x_offset - other.x, y + temp_left_top_y_offset - other.y, 1);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_right_bottom_x_offset - other.x, y + temp_right_bottom_y_offset - other.y, 0);
		
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_left_top_x_offset - other.x, y + temp_left_top_y_offset - other.y, 1);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_right_bottom_x_offset - other.x, y + temp_right_bottom_y_offset - other.y, 0);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_right_bottom_x_offset - other.x, y + temp_right_bottom_y_offset - other.y, 1);
	
		// Create Shadow Quads from Vertice Triangles (again...)
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_right_top_x_offset - other.x, y + temp_right_top_y_offset - other.y, 0);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_right_top_x_offset - other.x, y + temp_right_top_y_offset - other.y, 1);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_left_bottom_x_offset - other.x, y + temp_left_bottom_y_offset - other.y, 0);
		
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_right_top_x_offset - other.x, y + temp_right_top_y_offset - other.y, 1);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_left_bottom_x_offset - other.x, y + temp_left_bottom_y_offset - other.y, 0);
		vertex_position_3d(other.shadows_vertex_buffer, x + temp_left_bottom_x_offset - other.x, y + temp_left_bottom_y_offset - other.y, 1);
	}
}
vertex_end(shadows_vertex_buffer);