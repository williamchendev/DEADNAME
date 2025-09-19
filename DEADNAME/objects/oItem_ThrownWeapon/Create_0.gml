/// @description Dynamic Weapon Item Initialization
// Initialized Dynamic Weapon Item for Lighting Engine Rendering

// Lighting Engine Dynamic Object Initialization
event_inherited();

// Ground Contact Check Variable
ground_contact = false;

// Enable Normal Physics Rotation now that Ground Contact Collision has occurred
phy_angular_damping = item_angular_dampening;
