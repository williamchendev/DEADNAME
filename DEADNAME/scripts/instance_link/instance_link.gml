/// @function		instance_link(parent, child, pos, rot, scale);
/// @param			{instance}				parent
/// @param			{instance|object|array}	child
/// @param			{boolean}				pos
/// @param			{boolean}				rot
/// @param			{boolean}				scale
/// @requires		rot_prefetch, rot_vec_x, rot_vec_y
/// @description	Links an object, instance, or array of them to the parent instance so that all
///					child objects match the parent's position, rotation, and/or scale. Links are
///					relative, meaning child objects can still have their own independent position,
///					rotation, and scale as well.
///
///					Unlike the child, the parent must be a specific instance. Use `self` or `id` to 
///					indicate the running instance. If an object is input as the parent, the first 
///					randomly detected active instance of the object will be used.
///
///					Must be run in the Step event for changes to position, rotation, and scale to 
///					apply continuously.
///
/// @example		instance_link(obj_grid, obj_cell, true, true, true);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function instance_link(_parent, _child, _pos, _rot, _scale) {
	
	/*
	IDENTIFICATION
	*/
	
	// Interpret `self` keyword as instance ID
	if (_child == self) {
		_child = id;
	}
	if (_parent == self) {
		_parent = id;
	} else {
		// If parent is input as object, get first instance
		if (object_exists(_parent)) {
			_parent = instance_find(_parent, 0);
			
			// Exit if parent doesn't exist
			if (_parent == noone) {
				exit;
			}
		}
	}
	
	// Interpret child as object/instance array
	if (!is_array(_child)) {
		_child = array_create(1, _child);
	}
	
	
	/*
	INITIALIZATION
	*/
	
	with (_parent) {
		// Initialize expanded image previous variables
		var	uid = string(debug_get_callstack(2)[1]),
			str_img_angle_previous  = "img_angle_previous_"  + uid,
			str_img_xscale_previous = "img_xscale_previous_" + uid,
			str_img_yscale_previous = "img_yscale_previous_" + uid;
		if (!variable_instance_exists(id, str_img_angle_previous)) {
			variable_instance_set(id, str_img_angle_previous, image_angle);
		}
		if (!variable_instance_exists(id, str_img_xscale_previous)) {
			variable_instance_set(id, str_img_xscale_previous, image_xscale);
		}
		if (!variable_instance_exists(id, str_img_yscale_previous)) {
			variable_instance_set(id, str_img_yscale_previous, image_yscale);
		}
		
		// Initialize temporary variables
		var roffset, xoffset, yoffset, scale_xoffset, scale_yoffset,
			img_angle_previous  = variable_instance_get(id, str_img_angle_previous),
			img_xscale_previous = variable_instance_get(id, str_img_xscale_previous),
			img_yscale_previous = variable_instance_get(id, str_img_yscale_previous);


		/*
		LINKING
		*/
	
		// Link objects
		for (var c = 0; c < array_length(_child); c++) {

			/*
			SCALE LINKING
			*/

			// Link scale, if enabled
			if (_scale == true) {
				// If parent has scaled...
				if (image_xscale != img_xscale_previous) or (image_yscale != img_yscale_previous) {				
					// Limit scale to prevent positional data loss
					if (image_xscale == 0) {
						image_xscale = (0.01*sign(img_xscale_previous));
					}
					if (image_yscale == 0) {
						image_yscale = (0.01*sign(img_yscale_previous));
					}
				
					// Get difference in scale
					scale_xoffset = (image_xscale - img_xscale_previous);
					scale_yoffset = (image_yscale - img_yscale_previous);
   
					// Update child scale
					with (_child[c]) {
					    image_xscale += scale_xoffset;
					    image_yscale += scale_yoffset;
					}
				}
			}
		
	
			/*
			ROTATION LINKING
			*/
	
			// Link rotation, if enabled
			if (_rot == true) {
				// If parent has rotated...
				if (image_angle != img_angle_previous) {
					// Get difference in rotation
					roffset = (image_angle - img_angle_previous);
			
					// Update child rotation
					with (_child[c]) {
						image_angle += roffset;
					}
				}
			}
		
		
			/*
			POSITION LINKING
			*/

			// Link position, if enabled
			if (_pos == true) {
				// If parent has moved...
				if (x != xprevious) or (y != yprevious) {
				    // Get difference in position
				    xoffset = (x - xprevious);
				    yoffset = (y - yprevious);

				    // Update child position
				    with (_child[c]) {
						x += xoffset;
						y += yoffset;
				    }
				}
			
				// if parent has scaled...
				if (image_xscale != img_xscale_previous) or (image_yscale != img_yscale_previous) {	
					// Get difference in scale
					scale_xoffset = (image_xscale/img_xscale_previous);
					scale_yoffset = (image_yscale/img_yscale_previous);   
				
					// Update child position based on parent scale
					with (_child[c]) {
					    x = (other.x + ((x - other.x)*scale_xoffset));
					    y = (other.y + ((y - other.y)*scale_yoffset));
					}
				}
			
				// If parent has rotated...
				if (image_angle != img_angle_previous) {
					// Get difference in rotation
					roffset = (image_angle - img_angle_previous);
				
					// Update child position based on parent rotation
					with (_child[c]) {
						rot_prefetch(roffset);
						xoffset = rot_vec_x(other.x, other.y, (x - other.x), (y - other.y));
					    yoffset = rot_vec_y(other.x, other.y, (x - other.x), (y - other.y));
						x = xoffset;
						y = yoffset;
					}
				}
			}
		}
	
	
		/*
		FINALIZATION
		*/
	
		// Update instance properties for next step
		variable_instance_set(id, str_img_angle_previous,  image_angle);
		variable_instance_set(id, str_img_xscale_previous, image_xscale);
		variable_instance_set(id, str_img_yscale_previous, image_yscale);
	}
	
	// Clear child object/instance array from memory
	_child = 0;
}
