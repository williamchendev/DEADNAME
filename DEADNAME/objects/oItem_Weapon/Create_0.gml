/// @description Dynamic Weapon Item Initialization
// Initialized Dynamic Weapon Item for Lighting Engine Rendering

// Lighting Engine Dynamic Object Initialization
event_inherited();

// Ground Contact Check Variable
ground_contact = false;

// Reduce Weapon Angular Movement when dropped mid-air
item_angular_dampening = phy_angular_damping;
phy_angular_damping = 50;
