/// @description GML+ MANAGER OBJECT
//  SELF-CREATING GML+ MANAGER OBJECT

/*
INITIALIZATION
*/

/// @description	Initializes GML+ and automatically adds `obj_server_gmlp` to all rooms
///
/// @example		/* Internal system object - Not for manual instantiation! */
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2021, All Rights Reserved

#region gmlp_init()

// GML+ properties
#macro gmlp_version "1.1.4 build 121621"
#macro gmlp global.ds_gmlp

// Frame-time constants and variables
#macro frame_target		gmlp.frame.target
#macro frame_time		gmlp.frame.time
#macro frame_delta		gmlp.frame.delta

// Mouse variables
#macro mouse_xstart		gmlp.mouse.xstart
#macro mouse_ystart		gmlp.mouse.ystart
#macro mouse_xprevious	gmlp.mouse.xprevious
#macro mouse_yprevious	gmlp.mouse.yprevious
#macro mouse_hspeed		gmlp.mouse.hspeed
#macro mouse_vspeed		gmlp.mouse.vspeed
#macro mouse_speed		gmlp.mouse.speed
#macro mouse_direction	gmlp.mouse.direction
#macro mouse_visible	gmlp.mouse.visible

// Configure GML+
gml_pragma("global", @"
	// Auto-create object at launch
	room_instance_add(room_first, 0, 0, obj_server_gmlp);
	
	// Initialize global constants and variables
	global.ds_gmlp = {
		frame: {
			target: (1/60),
			time: (1/60),
			delta: 1
		},
		
		instance: {
			variable: {
				expanded_image_previous: false
			}
		},
		
		mouse: {
			xstart: -1,
			ystart: -1,
			xprevious: 0,
			yprevious: 0,
			hspeed: 0,
			vspeed: 0,
			speed: 0,
			direction: 0,
			visible: true,
			cursor: {
				wprevious: 0,
				sprevious: -1
			}
		},
		
		time: {
			step: 0,
			loss: 0
		}
	}
");
#endregion

#region Initialize object properties

// Disallow multiple instances of this object from existing
if (instance_number(object_index) > 1) {
	instance_destroy(id, false);
	exit;
}

// Force object visible and persistent
persistent = true;
visible = true;
#endregion