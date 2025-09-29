/// @description Solid Collision Behaviour
// Performs Dynamic Weapon Item's Physics Collision Behaviour

// Inherited Physics Collision Behaviour
event_inherited();

// Ground Contact Collision Behaviour
if (!ground_contact)
{
	// Ground Contact Collision has been made
	ground_contact = true;
	
	// Enable Normal Physics Rotation now that Ground Contact Collision has occurred
	phy_angular_damping = item_angular_dampening;
}
