/// @function		device_mouse_check_region(device, x, y, rot, width, [height], [halign, valign]);
/// @param			{integer}	device
/// @param			{real}		x
/// @param			{real}		y
/// @param			{real}		rot
/// @param			{real}		width
/// @param			{real}		[height]
/// @param			{constant}	[halign
/// @param			{constant}	valign]
/// @requires		rot_prefetch, rot_vec_x, rot_vec_y
/// @description	Checks whether the mouse is currently within a certain region relative to room
///					coordinates and returns true or false. If only a region width is specified, it
///					will be interpreted as a radius and the region to check will be circular. For
///					other shapes, a rotated rectangle can be used to cover most areas.
///				
///					By default, the region to check will be aligned to the center, but this can be 
///					changed by specifying optional halign and valign values using font alignment 
///					constants such as `fa_left` and `fa_top`. Alignment **must** be input as a pair.
///
/// @example		//Rectangular region
///					if (device_mouse_check_region(0, 640, 480, 0, 512, 384)) {
///					    //Action
///					}
///				
///					//Diamond region
///					if (device_mouse_check_region(0, 640, 480, 45, 256, 256)) {
///						//Action
///					}
///				
///					//Circular region with custom alignment
///					if (device_mouse_check_region(0, 256, 128, 0, 512, fa_left, fa_top)) {
///						//Action
///					}		
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function device_mouse_check_region() {
	// Initialize temporary variables for checking mouse region
	var reg_xorig, reg_yorig,
		reg_dev = argument[0],
		reg_x = argument[1],
		reg_y = argument[2],
		reg_rot = argument[3],
		reg_width = argument[4],
		reg_shape_rectangle = 0.5,
		reg_shape_circle = 1,
		reg_debug = false;

	// Get region shape and dimensions
	if (argument_count == 6) or (argument_count == 8) {
		var reg_shape = reg_shape_rectangle;
		var reg_height = argument[5];
		reg_xorig = reg_width*0.5;
		reg_yorig = reg_height*0.5;
	} else {
		var reg_shape = reg_shape_circle;
		var reg_height = argument[4];
		reg_xorig = 0;
		reg_yorig = 0;
	}

	// Get custom alignment, if specified
	if (argument_count > 6) {
		// Horizontal alignment
		switch (argument[argument_count - 2]) {
			case fa_left:	reg_xorig -= (reg_width*reg_shape); break;
			case fa_right:	reg_xorig += (reg_width*reg_shape); break;
		}
	
		// Vertical alignment
		switch (argument[argument_count - 1]) {
			case fa_top:	reg_yorig -= (reg_height*reg_shape); break;
			case fa_bottom:	reg_yorig += (reg_height*reg_shape); break;
		}
	}

	// Check if mouse is within region
	if (reg_shape == reg_shape_rectangle) {
		if (reg_rot == 0) or (abs(reg_rot) == 180) {
			// Get rectangular region origin
			reg_x -= reg_xorig;
			reg_y -= reg_yorig;
		
			// Draw debug region, if enabled
			if (reg_debug) {
				draw_rectangle_color(reg_x, reg_y, reg_x + reg_width, reg_y + reg_height, c_lime, c_lime, c_lime, c_lime, true);
				draw_line_color(reg_x, reg_y + reg_height, reg_x + reg_width, reg_y, c_lime, c_lime);
			}
		
			// Detect mouse in rectangular region
			return point_in_rectangle(device_mouse_x(reg_dev), device_mouse_y(reg_dev), reg_x, reg_y, reg_x + reg_width, reg_y + reg_height);
		} else {
			// Get rectangle rotation, if any
			rot_prefetch(reg_rot);
	
			// Get rotated rectangular region origin
			reg_width -= reg_xorig;
			reg_height -= reg_yorig;
	
			// Get rectangular region coordinates as triangles to support rotation
			var reg_x0 = rot_vec_x(reg_x, reg_y, -reg_xorig, -reg_yorig),
				reg_y0 = rot_vec_y(reg_x, reg_y, -reg_xorig, -reg_yorig),
				reg_x1 = rot_vec_x(reg_x, reg_y, reg_width, -reg_yorig),
				reg_y1 = rot_vec_y(reg_x, reg_y, reg_width, -reg_yorig),
				reg_x2 = rot_vec_x(reg_x, reg_y, -reg_xorig, reg_height),
				reg_y2 = rot_vec_y(reg_x, reg_y, -reg_xorig, reg_height),
				reg_x3 = rot_vec_x(reg_x, reg_y, reg_width, reg_height),
				reg_y3 = rot_vec_y(reg_x, reg_y, reg_width, reg_height);
	
			// Draw debug region, if enabled
			if (reg_debug) {
				draw_triangle_color(reg_x0, reg_y0, reg_x1, reg_y1, reg_x2, reg_y2, c_lime, c_lime, c_lime, true);
				draw_triangle_color(reg_x3, reg_y3, reg_x1, reg_y1, reg_x2, reg_y2, c_lime, c_lime, c_lime, true);
			}
	
			// Detect mouse in rectangular region
			if (point_in_triangle(device_mouse_x(reg_dev), device_mouse_y(reg_dev), reg_x0, reg_y0, reg_x1, reg_y1, reg_x2, reg_y2)) 
			or (point_in_triangle(device_mouse_x(reg_dev), device_mouse_y(reg_dev), reg_x3, reg_y3, reg_x1, reg_y1, reg_x2, reg_y2)) {
				return true;
			} else {
				return false;
			}
		}
	} else {
		// Get circular region origin
		reg_x -= reg_xorig;
		reg_y -= reg_yorig;
	
		// Draw debug region
		if (reg_debug) {
			draw_circle_color(reg_x, reg_y, reg_width, c_lime, c_lime, true);
		}
	
		// Detect mouse in circular region
		return point_in_circle(device_mouse_x(reg_dev), device_mouse_y(reg_dev), reg_x, reg_y, reg_width);
	}
}


/// @function		device_mouse_check_region_gui(device, x, y, rot, width, [height], [halign, valign]);
/// @param			{integer}	device
/// @param			{real}		x
/// @param			{real}		y
/// @param			{real}		rot
/// @param			{real}		width
/// @param			{real}		[height]
/// @param			{constant}	[halign
/// @param			{constant}	valign]
/// @requires		rot_prefetch, rot_vec_x, rot_vec_y
/// @description	Checks whether the mouse is currently within a certain region relative to GUI
///					coordinates and returns true or false. If only a region width is specified, it
///					will be interpreted as a radius and the region to check will be circular. For
///					other shapes, a rotated rectangle can be used to cover most areas.
///				
///					By default, the region to check will be aligned to the center, but this can be 
///					changed by specifying optional halign and valign values using font alignment 
///					constants such as `fa_left` and `fa_top`. Alignment **must** be input as a pair.
///
/// @example		//Rectangular region
///					if (device_mouse_check_region_gui(0, 640, 480, 0, 512, 384)) {
///					    //Action
///					}
///				
///					//Diamond region
///					if (device_mouse_check_region_gui(0, 640, 480, 45, 256, 256)) {
///						//Action
///					}
///				
///					//Circular region with custom alignment
///					if (device_mouse_check_region_gui(0, 256, 128, 0, 512, fa_left, fa_top)) {
///						//Action
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function device_mouse_check_region_gui() {
	// Initialize temporary variables for checking mouse region
	var reg_xorig, reg_yorig,
		reg_dev = argument[0],
		reg_x = argument[1],
		reg_y = argument[2],
		reg_rot = argument[3],
		reg_width = argument[4],
		reg_shape_rectangle = 0.5,
		reg_shape_circle = 1,
		reg_debug = false;

	// Get region shape and dimensions
	if (argument_count == 6) or (argument_count == 8) {
		var reg_shape = reg_shape_rectangle;
		var reg_height = argument[5];
		reg_xorig = reg_width*0.5;
		reg_yorig = reg_height*0.5;
	} else {
		var reg_shape = reg_shape_circle;
		var reg_height = argument[4];
		reg_xorig = 0;
		reg_yorig = 0;
	}

	// Get custom alignment, if specified
	if (argument_count > 6) {
		// Horizontal alignment
		switch (argument[argument_count - 2]) {
			case fa_left:	reg_xorig -= (reg_width*reg_shape); break;
			case fa_right:	reg_xorig += (reg_width*reg_shape); break;
		}
	
		// Vertical alignment
		switch (argument[argument_count - 1]) {
			case fa_top:	reg_yorig -= (reg_height*reg_shape); break;
			case fa_bottom:	reg_yorig += (reg_height*reg_shape); break;
		}
	}

	// Check if mouse is within region
	if (reg_shape == reg_shape_rectangle) {
		if (reg_rot == 0) or (abs(reg_rot) == 180) {
			// Get rectangular region origin
			reg_x -= reg_xorig;
			reg_y -= reg_yorig;
		
			// Draw debug region, if enabled
			if (reg_debug) {
				draw_rectangle_color(reg_x, reg_y, reg_x + reg_width, reg_y + reg_height, c_lime, c_lime, c_lime, c_lime, true);
				draw_line_color(reg_x, reg_y + reg_height, reg_x + reg_width, reg_y, c_lime, c_lime);
			}
		
			// Detect mouse in rectangular region
			return point_in_rectangle(device_mouse_x_to_gui(reg_dev), device_mouse_y_to_gui(reg_dev), reg_x, reg_y, reg_x + reg_width, reg_y + reg_height);
		} else {
			// Get rectangle rotation, if any
			rot_prefetch(reg_rot);
	
			// Get rotated rectangular region origin
			reg_width -= reg_xorig;
			reg_height -= reg_yorig;
	
			// Get rectangular region coordinates as triangles to support rotation
			var reg_x0 = rot_vec_x(reg_x, reg_y, -reg_xorig, -reg_yorig),
				reg_y0 = rot_vec_y(reg_x, reg_y, -reg_xorig, -reg_yorig),
				reg_x1 = rot_vec_x(reg_x, reg_y, reg_width, -reg_yorig),
				reg_y1 = rot_vec_y(reg_x, reg_y, reg_width, -reg_yorig),
				reg_x2 = rot_vec_x(reg_x, reg_y, -reg_xorig, reg_height),
				reg_y2 = rot_vec_y(reg_x, reg_y, -reg_xorig, reg_height),
				reg_x3 = rot_vec_x(reg_x, reg_y, reg_width, reg_height),
				reg_y3 = rot_vec_y(reg_x, reg_y, reg_width, reg_height);
	
			// Draw debug region, if enabled
			if (reg_debug) {
				draw_triangle_color(reg_x0, reg_y0, reg_x1, reg_y1, reg_x2, reg_y2, c_lime, c_lime, c_lime, true);
				draw_triangle_color(reg_x3, reg_y3, reg_x1, reg_y1, reg_x2, reg_y2, c_lime, c_lime, c_lime, true);
			}
	
			// Detect mouse in rectangular region
			if (point_in_triangle(device_mouse_x_to_gui(reg_dev), device_mouse_y_to_gui(reg_dev), reg_x0, reg_y0, reg_x1, reg_y1, reg_x2, reg_y2)) 
			or (point_in_triangle(device_mouse_x_to_gui(reg_dev), device_mouse_y_to_gui(reg_dev), reg_x3, reg_y3, reg_x1, reg_y1, reg_x2, reg_y2)) {
				return true;
			} else {
				return false;
			}
		}
	} else {
		// Get circular region origin
		reg_x -= reg_xorig;
		reg_y -= reg_yorig;
	
		// Draw debug region
		if (reg_debug) {
			draw_circle_color(reg_x, reg_y, reg_width, c_lime, c_lime, true);
		}
	
		// Detect mouse in circular region
		return point_in_circle(device_mouse_x_to_gui(reg_dev), device_mouse_y_to_gui(reg_dev), reg_x, reg_y, reg_width);
	}
}
