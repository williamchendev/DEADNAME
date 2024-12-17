/// @description DO NOT RENAME
//  SELF-CREATING GML+ MANAGER OBJECT

/*
MOUSE
*/

#region Get starting mouse coordinates
if (gmlp.mouse.xstart == -1) {
	if (mouse_x != gmlp.mouse.xprevious) or (mouse_y != gmlp.mouse.yprevious) {
		gmlp.mouse.xstart = mouse_x;
		gmlp.mouse.ystart = mouse_y;
	}
}
#endregion

#region Update mouse coordinates for next Step
gmlp.mouse.xprevious = mouse_x;
gmlp.mouse.yprevious = mouse_y;
#endregion

#region Update mouse cursor state
event_perform(ev_other, ev_user0);
#endregion


/*
OBJECTS
*/

#region Update instance properties for next Step
if (gmlp.instance.variable.expanded_image_previous) {
	with (all) {
		image_angle_previous  = image_angle;
		image_xscale_previous = image_xscale;
		image_yscale_previous = image_yscale;
	}
}
#endregion