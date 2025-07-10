/// @function bezier_curve_draw(bezier_curve_object, draw_offset_x, draw_offset_y);
/// @description Draws a Bezier Curve with the given Bezier Curve Object
/// @param {oBezierCurve} bezier_curve_object The Bezier Curve Object to draw
/// @param {real} draw_offset_x Optional parameter to set the horizontal offset of the drawn Bezier Curve, but by default this is the negative offset of the Lighting Engine's horizontal render position
/// @param {real} draw_offset_y Optional parameter to set the vertical offset of the drawn Bezier Curve, but by default this is the negative offset of the Lighting Engine's vertical render position
function bezier_curve_draw(bezier_curve_object, draw_offset_x = -LightingEngine.render_x, draw_offset_y = -LightingEngine.render_y) 
{
	// Check if Bezier Curve Path contains at least 2 points
	if (bezier_curve_object.path_count < 2)
	{
		// Bezier Curve Path is invalid
		return;
	}
	
	// Draw Bezier Curve as Triangle Strip Primitive
	draw_primitive_begin(pr_trianglestrip);
	
	// Draw First Position
	var temp_start_x = ds_list_find_value(bezier_curve_object.path_x_coordinate_list, 0);
	var temp_start_y = ds_list_find_value(bezier_curve_object.path_y_coordinate_list, 0);
	
	var temp_start_h = ds_list_find_value(bezier_curve_object.path_h_vector_list, 0);
	var temp_start_v = ds_list_find_value(bezier_curve_object.path_v_vector_list, 0);
	
	var temp_vector_dis = max(sqrt(sqr(temp_start_h) + sqr(temp_start_v)), 0.0001);
	
	temp_start_h = temp_start_h / temp_vector_dis;
	temp_start_v = temp_start_v / temp_vector_dis;
	
	var temp_start_thickness = ds_list_find_value(bezier_curve_object.path_thickness_list, 0) * bezier_curve_object.path_thickness;

	draw_vertex_color(temp_start_x + (-temp_start_thickness * temp_start_v) + draw_offset_x, temp_start_y + (temp_start_thickness * temp_start_h) + draw_offset_y, bezier_curve_object.image_blend, bezier_curve_object.image_alpha);
	draw_vertex_color(temp_start_x + (temp_start_thickness * temp_start_v) + draw_offset_x, temp_start_y + (-temp_start_thickness * temp_start_h) + draw_offset_y, bezier_curve_object.image_blend, bezier_curve_object.image_alpha);
	
	// Iterate through Bezier Curve Path
	var temp_path_index = 0;
	
	repeat (bezier_curve_object.path_count - 1)
	{
		// Find Path Segment Start and End Positions
		var temp_path_segment_start_x_coordinate = ds_list_find_value(bezier_curve_object.path_x_coordinate_list, temp_path_index);
		var temp_path_segment_start_y_coordinate = ds_list_find_value(bezier_curve_object.path_y_coordinate_list, temp_path_index);
		
		var temp_path_segment_end_x_coordinate = ds_list_find_value(bezier_curve_object.path_x_coordinate_list, temp_path_index + 1);
		var temp_path_segment_end_y_coordinate = ds_list_find_value(bezier_curve_object.path_y_coordinate_list, temp_path_index + 1);
		
		// Find Path Segment Start and End Vectors
		var temp_path_segment_start_h_vector = ds_list_find_value(bezier_curve_object.path_h_vector_list, temp_path_index);
		var temp_path_segment_start_v_vector = ds_list_find_value(bezier_curve_object.path_v_vector_list, temp_path_index);
		
		var temp_path_segment_end_h_vector = ds_list_find_value(bezier_curve_object.path_h_vector_list, temp_path_index + 1);
		var temp_path_segment_end_v_vector = ds_list_find_value(bezier_curve_object.path_v_vector_list, temp_path_index + 1);
		
		// Find Path Segment Start and End Line Thicknesses
		var temp_path_segment_start_thickness = ds_list_find_value(bezier_curve_object.path_thickness_list, temp_path_index);
		var temp_path_segment_end_thickness = ds_list_find_value(bezier_curve_object.path_thickness_list, temp_path_index + 1);
		
		// Create Temporary Path Position
		var temp_path_x = temp_path_segment_start_x_coordinate;
		var temp_path_y = temp_path_segment_start_y_coordinate;
		
		// Draw Bezier Curve
		var temp_division_index = 1;
		
		repeat (bezier_curve_object.path_segment_divisions - 1)
		{
			// Find Percentage Progress 
			var temp_path_segment_percent = temp_division_index / bezier_curve_object.path_segment_divisions;
			
			// Cubic Bezier Curve Lerp Calculation for Horizontal Position
			var temp_path_pah = lerp(temp_path_segment_start_x_coordinate, temp_path_segment_start_x_coordinate + temp_path_segment_start_h_vector, temp_path_segment_percent);
			var temp_path_pbh = lerp(temp_path_segment_start_x_coordinate, temp_path_segment_end_x_coordinate, temp_path_segment_percent);
			var temp_path_pch = lerp(temp_path_segment_end_x_coordinate + temp_path_segment_end_h_vector, temp_path_segment_end_x_coordinate, temp_path_segment_percent);
			var temp_path_pdh = lerp(temp_path_pah, temp_path_pbh, temp_path_segment_percent);
			var temp_path_peh = lerp(temp_path_pbh, temp_path_pch, temp_path_segment_percent);
			var temp_path_ph = lerp(temp_path_pdh, temp_path_peh, temp_path_segment_percent);
			
			// Cubic Bezier Curve Lerp Calculation for Vertical Position
			var temp_path_pav = lerp(temp_path_segment_start_y_coordinate, temp_path_segment_start_y_coordinate + temp_path_segment_start_v_vector, temp_path_segment_percent);
			var temp_path_pbv = lerp(temp_path_segment_start_y_coordinate, temp_path_segment_end_y_coordinate, temp_path_segment_percent);
			var temp_path_pcv = lerp(temp_path_segment_end_y_coordinate + temp_path_segment_end_v_vector, temp_path_segment_end_y_coordinate, temp_path_segment_percent);
			var temp_path_pdv = lerp(temp_path_pav, temp_path_pbv, temp_path_segment_percent);
			var temp_path_pev = lerp(temp_path_pbv, temp_path_pcv, temp_path_segment_percent);
			var temp_path_pv = lerp(temp_path_pdv, temp_path_pev, temp_path_segment_percent);
			
			// Find Raw Vector at point on Bezier Curve Segment
			var temp_path_h = temp_path_ph - temp_path_x;
			var temp_path_v = temp_path_pv - temp_path_y;
			
			// Find Normalized Vector at point on Bezier Curve Segment
			var temp_path_vector_dis = max(sqrt(sqr(temp_path_h) + sqr(temp_path_v)), 0.0001);
			
			temp_path_h = temp_path_h / temp_path_vector_dis;
			temp_path_v = temp_path_v / temp_path_vector_dis;
			
			// Find Thickness at point on Bezier Curve Segment
			var temp_thickness = lerp(temp_path_segment_start_thickness, temp_path_segment_end_thickness, temp_path_segment_percent) * bezier_curve_object.path_thickness;
			
			// Draw points on Bezier Curve Triangle Strip
			draw_vertex_color(temp_path_ph + (-temp_thickness * temp_path_v) + draw_offset_x, temp_path_pv + (temp_thickness * temp_path_h) + draw_offset_y, bezier_curve_object.image_blend, bezier_curve_object.image_alpha);
			draw_vertex_color(temp_path_ph + (temp_thickness * temp_path_v) + draw_offset_x, temp_path_pv + (-temp_thickness * temp_path_h) + draw_offset_y, bezier_curve_object.image_blend, bezier_curve_object.image_alpha);
			
			// Update Temporary Path Positions
			temp_path_x = temp_path_ph;
			temp_path_y = temp_path_pv;
			
			// Increment Division Index
			temp_division_index++;
		}
		
		// Increment Path Index
		temp_path_index++;
	}
	
	// End Vertex Creation and Draw Traingle Strip Primitive
	draw_primitive_end();
}

/// @function bezier_curve_add_path_point(bezier_curve_object, point_position_x, point_position_y, point_vector_x, point_vector_y, point_thickness);
/// @description Adds a new point to a Bezier Curve Object's Bezier Curve Path
/// @param {oBezierCurve} bezier_curve_object The Bezier Curve Object to add a point to
/// @param {real} point_position_x The horizontal position of the new point to add to the Bezier Curve
/// @param {real} point_position_y The vertical position of the new point to add to the Bezier Curve
/// @param {real} point_vector_x The horizontal vector of the new point to add to the Bezier Curve
/// @param {real} point_vector_y The vertical vector of the new point to add to the Bezier Curve
/// @param {real} point_thickness The thickness of the new point being added to the Bezier Curve
function bezier_curve_add_path_point(bezier_curve_object, point_position_x, point_position_y, point_vector_x, point_vector_y, point_thickness = 1)
{
	// Add Point's Position to Bezier Curve
	ds_list_add(bezier_curve_object.path_x_coordinate_list, point_position_x);
	ds_list_add(bezier_curve_object.path_y_coordinate_list, point_position_y);
	
	// Add Point's Vector to Bezier Curve
	ds_list_add(bezier_curve_object.path_h_vector_list, point_vector_x);
	ds_list_add(bezier_curve_object.path_v_vector_list, point_vector_y);
	
	// Add Point's Thickness to Bezier Curve
	ds_list_add(bezier_curve_object.path_thickness_list, point_thickness);
	
	// Increment Path Count
	bezier_curve_object.path_count += 1;
}

/// @function bezier_curve_insert_path_point(bezier_curve_object, point_index, point_position_x, point_position_y, point_vector_x, point_vector_y, point_thickness);
/// @description Inserts a new point to a Bezier Curve Object's Bezier Curve Path at the given index
/// @param {oBezierCurve} bezier_curve_object The Bezier Curve Object to add a point to
/// @param {real} point_index The index of the point to insert into the Bezier Curve's Path
/// @param {real} point_position_x The horizontal position of the new point to add to the Bezier Curve
/// @param {real} point_position_y The vertical position of the new point to add to the Bezier Curve
/// @param {real} point_vector_x The horizontal vector of the new point to add to the Bezier Curve
/// @param {real} point_vector_y The vertical vector of the new point to add to the Bezier Curve
/// @param {real} point_thickness The thickness of the new point being added to the Bezier Curve
function bezier_curve_insert_path_point(bezier_curve_object, point_index, point_position_x, point_position_y, point_vector_x, point_vector_y, point_thickness = 1)
{
	// Insert Point's Position to Bezier Curve
	ds_list_insert(bezier_curve_object.path_x_coordinate_list, point_index, point_position_x);
	ds_list_insert(bezier_curve_object.path_y_coordinate_list, point_index, point_position_y);
	
	// Insert Point's Vector to Bezier Curve
	ds_list_insert(bezier_curve_object.path_h_vector_list, point_index, point_vector_x);
	ds_list_insert(bezier_curve_object.path_v_vector_list, point_index, point_vector_y);
	
	// Insert Point's Thickness to Bezier Curve
	ds_list_insert(bezier_curve_object.path_thickness_list, point_index, point_thickness);
	
	// Increment Path Count
	bezier_curve_object.path_count += 1;
}

/// @function bezier_curve_delete_path_point(bezier_curve_object, point_index);
/// @description Deletes a point from a Bezier Curve Object's Bezier Curve Path at the given index
/// @param {oBezierCurve} bezier_curve_object The Bezier Curve Object to remove a point from
/// @param {real} point_index The index of the point to remove from the Bezier Curve's Path
function bezier_curve_delete_path_point(bezier_curve_object, point_index)
{
	// Delete Point's Position to Bezier Curve
	ds_list_delete(bezier_curve_object.path_x_coordinate_list, point_index);
	ds_list_delete(bezier_curve_object.path_y_coordinate_list, point_index);
	
	// Delete Point's Vector to Bezier Curve
	ds_list_delete(bezier_curve_object.path_h_vector_list, point_index);
	ds_list_delete(bezier_curve_object.path_v_vector_list, point_index);
	
	// Delete Point's Thickness to Bezier Curve
	ds_list_delete(bezier_curve_object.path_thickness_list, point_index);
	
	// Increment Path Count
	bezier_curve_object.path_count -= 1;
}

/// @function bezier_curve_clear_all_points(bezier_curve_object);
/// @description Deletes all points from a Bezier Curve Object's Bezier Curve Path
/// @param {oBezierCurve} bezier_curve_object The Bezier Curve Object to clear all points from
function bezier_curve_clear_all_points(bezier_curve_object)
{
	// Clear all Points on Bezier Curve
	ds_list_clear(bezier_curve_object.path_x_coordinate_list);
	ds_list_clear(bezier_curve_object.path_y_coordinate_list);
	
	ds_list_clear(bezier_curve_object.path_h_vector_list);
	ds_list_clear(bezier_curve_object.path_v_vector_list);
	
	ds_list_clear(bezier_curve_object.path_thickness_list);
	
	// Reset Path Count
	bezier_curve_object.path_count = 0;
}
