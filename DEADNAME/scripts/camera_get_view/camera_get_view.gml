/// @function		camera_get_view(camera);
/// @param			{camera} camera
/// @description	Checks if a camera is currently assigned to a view, and if so, returns
///					the view number (0-7). If the camera is not currently assigned to a view,
///					-1 will be returned instead.
/// 
/// @example		var view = camera_get_view(my_cam);
///
///					if (view > -1) {
///						camera_set_view_pos(view_camera[view], x, y);
///					}
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function camera_get_view(_camera) {
	// Identify view from camera
	switch (_camera) {
		case view_camera[0]: return 0;
		case view_camera[1]: return 1;
		case view_camera[2]: return 2;
		case view_camera[3]: return 3;
		case view_camera[4]: return 4;
		case view_camera[5]: return 5;
		case view_camera[6]: return 6;
		case view_camera[7]: return 7;
		
		// Return -1 if camera is not assigned to a view
		default: return -1;
	}
	
	#region Alternate method
	/*
	// Identify view from camera
	var _view = -1;
	for (var v = 0; v <= 7; v++) {
		// If view is found...
		if (_camera == view_camera[v]) {
			// Use this view
			_view = v;
			break;
		}
	}
	
	// Return the view number
	return _view;
	*/
	#endregion
}