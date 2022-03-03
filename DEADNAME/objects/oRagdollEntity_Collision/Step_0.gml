/// @description Ragdoll Entity Update Event
// Performs calculations for the Ragdoll Entity Object

/*
if (held) {
	var px = (mouse_get_x() - x);
	var py = (mouse_get_y() - y);
	phy_speed_x = px;
	phy_speed_y = py;
	
	if (!mouse_check_button(mb_left)) {
		held = false;
	}
}
else {
	if (mouse_check_button_pressed(mb_left)) {
		if (position_meeting(mouse_get_x(), mouse_get_y(), self)) {
			with (oRagdollEntity_Collision) {
				held = false;
			}
			held = true;
		}
	}
}
*/

// Deltatime Physics
event_inherited();