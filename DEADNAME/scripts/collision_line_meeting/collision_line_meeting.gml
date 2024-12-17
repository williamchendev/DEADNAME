/// @function		collision_line_meeting(x1, y1, x2, y2, obj, prec, notme);
/// @param			{real}				x1
/// @param			{real}				y1
/// @param			{real}				x2
/// @param			{real}				y2
/// @param			{object|instance}	obj
/// @param			{bool}			prec
/// @param			{bool}			notme
/// @description	Finds the exact point of collision between two sets of coordinates and an
///					input object. Results are returned as a struct containing three keys: the
///					nearest colliding instance `id`, plus the `x` and `y` values of the exact
///					point of collision. If no collision is found, the instance ID will be 
///					considered `noone` and the position unchanged from `x2` and `y2`.
///
///					The object to check for collisions can be an object ID (in which case all
///					instances of the object will be considered), a single instance ID, or the
///					keyword `all` for all active instances. Set `notme` to `true` to exclude 
///					instances of the running object from consideration.
///
///					Collisions can be evaluated precisely (per-pixel, with a collision mask) 
///					or by bounding box, depending on whether `prec` is `true` or `false`. This
///					setting also depends on the type of collision mask defined in the Sprite
///					Editor (i.e. a precise mask must be created for enabling precise collisions
///					to have any effect).
///
/// @example		var coll = collision_line_meeting(x, y, x + mov_speed, y, obj_wall, false, true);
///
///					if (coll.id != noone) {
///						// Limit movement to point of collision, if any
///						x = coll.x;
///						y = coll.y;
///					} else {
///						// Otherwise move forward freely
///						x += mov_speed;
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

function collision_line_meeting(_x1, _y1, _x2, _y2, _obj, _prec, _notme) {
	// Find nearest colliding instance
	var ds_inst = ds_list_create();
	var collisions_num = collision_line_list(_x1, _y1, _x2, _y2, _obj, _prec, _notme, ds_inst, true);
	
	// Return target coord if not found
	if (collisions_num == 0) {
		ds_list_destroy(ds_inst);
		return {
			id: noone,
			x: _x2, 
			y: _y2
		}
	}
	
	// Otherwise get colliding instance
	var inst = ds_inst[| 0];
	ds_list_destroy(ds_inst);
	
	// Initialize checking segments of collision line for collision coord
	var chk_start = 0,
		chk_end = 1,
		coll_x = _x2,
		coll_y = _y2;
	
	// Iterate segments to find collision coord
	var rep_num = (ceil(log2(point_distance(_x1, _y1, _x2, _y2))) + 1); // Newton-Raphson iterations
	repeat (rep_num) {
	    var chk = (chk_start + ((chk_end - chk_start)*0.5)),
			chk_x = (_x1 + ((_x2 - _x1)*chk)),
			chk_y = (_y1 + ((_y2 - _y1)*chk)),
			chk_xprevious = (_x1 + ((_x2 - _x1)*chk_start)),
			chk_yprevious = (_y1 + ((_y2 - _y1)*chk_start)),
			chk_inst = collision_line(chk_xprevious, chk_yprevious, chk_x, chk_y, inst, _prec, _notme);
		
		// Trim line down to checked segment if collision was found
	    if (chk_inst != noone) {
	        inst = chk_inst;
	        coll_x = chk_x;
	        coll_y = chk_y;
	        chk_end = chk;
	    } else {
			// Otherwise eliminate segment and try again
			chk_start = chk;
		}
	}
	
	// Return collision coord
	return {
		id: inst,
		x:  coll_x, 
		y:  coll_y
	}
}